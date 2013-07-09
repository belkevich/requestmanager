//
//  ABRequestManagerSpec.mm
//  RequestManagerSpec
//
//  Created by Alexey Belkevich on 1/26/13.
//  Copyright (c) 2013 Okolodev. All rights reserved.
//

#import "ABRequestManager+Spec.h"
#import "ABConnectionHelper+Spec.h"
#import "SCNetworkReachability.h"
#import "ABRequestWrapper_RequestManager.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(RequestManager)

__block NSURL *url = nil;
__block NSMutableURLRequest *request1 = nil;
__block NSMutableURLRequest *request2 = nil;
__block ABRequestWrapper *wrapper1 = nil;
__block ABRequestWrapper *wrapper2 = nil;
__block ABRequestManager *manager = nil;

SCNetworkReachability <CedarDouble> *reachability = nice_fake_for([SCNetworkReachability class]);
reachability stub_method(@selector(status)).and_return(SCNetworkStatusReachableViaWiFi);

describe(@"Queue", ^
{
    beforeEach(^
    {
        url = [[NSURL alloc] initWithString:@"http://test.com"];
        request1 = [[NSMutableURLRequest alloc] initWithURL:url];
        request2 = [[NSMutableURLRequest alloc] initWithURL:url];
        wrapper1 = [[ABRequestWrapper alloc] initWithURLRequest:request1 delegate:nil];
        wrapper2 = [[ABRequestWrapper alloc] initWithURLRequest:request2 delegate:nil];
        manager = [[ABRequestManager alloc] init];
        manager.reachability = reachability;
        [manager addRequestWrapper:wrapper1];
        [manager addRequestWrapper:wrapper2];
    });

    afterEach(^
    {
        [manager release];
        [wrapper1 release];
        [wrapper2 release];
        [request1 release];
        [request2 release];
        [url release];
        [reachability reset_sent_messages];
    });

    it(@"should add requests to queue", ^
    {
        manager.queue.count should equal(2);
        [manager.queue objectAtIndex:0] should equal(wrapper1);
        [manager.queue objectAtIndex:1] should equal(wrapper2);
    });

    it(@"should add request first if no requests in queue", ^
    {
        [manager removeAllRequestWrappers];
        [manager addRequestWrapperFirst:wrapper1];
        manager.queue.count should equal(1);
        [manager.queue objectAtIndex:0] should equal(wrapper1);
    });

    it(@"should add request second if request already running", ^
    {
        ABRequestWrapper *wrapper3 = [[ABRequestWrapper alloc] initWithURLRequest:request1];
        [manager addRequestWrapperFirst:wrapper3];
        manager.queue.count should equal(3);
        [manager.queue objectAtIndex:0] should equal(wrapper1);
        [manager.queue objectAtIndex:1] should equal(wrapper3);
        [manager.queue objectAtIndex:2] should equal(wrapper2);
        [wrapper3 release];
    });

    it(@"should run first request in queue", ^
    {
        manager.connection.connection should_not be_nil;
        manager.connection.connection.currentRequest should equal(request1);
    });

    it(@"should remove request from queue after complete", ^
    {
        [manager connectionDidReceiveData:nil response:nil];
        manager.queue.count should equal(1);
        [manager.queue objectAtIndex:0] should equal(wrapper2);
    });

    it(@"should run second request in queue when first request is removed from queue", ^
    {
        [manager connectionDidReceiveData:nil response:nil];
        manager.connection.connection should_not be_nil;
        manager.connection.connection.currentRequest should equal(request2);
    });

    it(@"should be able to remove request from queue", ^
    {
        [manager removeRequestWrapper:wrapper1];
        manager.queue.count should equal(1);
        [manager.queue objectAtIndex:0] should equal(wrapper2);
    });

    it(@"should be able to remove all requests from queue", ^
    {
        [manager removeAllRequestWrappers];
        manager.queue.count should equal(0);
    });

    it(@"should start second request, if first request was removed", ^
    {
        [manager removeRequestWrapper:wrapper1];
        manager.connection should_not be_nil;
        manager.connection.connection.currentRequest should equal(request2);
    });

    it(@"should release connection if all requests were removed", ^
    {
        [manager removeAllRequestWrappers];
        manager.connection should be_nil;
    });
});

describe(@"Response", ^
{
    beforeEach(^
    {
        url = [[NSURL alloc] initWithString:@"http://test.com"];
        request1 = [[NSMutableURLRequest alloc] initWithURL:url];
        wrapper1 = [[ABRequestWrapper alloc] initWithURLRequest:request1 delegate:nil];
        manager = [[ABRequestManager alloc] init];
        manager.reachability = reachability;
        [manager addRequestWrapper:wrapper1];
    });

    afterEach(^
    {
        [manager release];
        [wrapper1 release];
        [request1 release];
        [url release];
        [reachability reset_sent_messages];
    });

    it(@"should fill request wrapper with HTTP-response", ^
    {
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:url statusCode:200
                                                                 HTTPVersion:@"1.1"
                                                                headerFields:nil];
        [response autorelease];
        [manager connectionDidReceiveData:nil response:response];
        wrapper1.response should equal(response);
    });

    it(@"should fill request wrapper with received data", ^
    {
        NSData *data = [NSData data];
        [manager connectionDidReceiveData:data response:nil];
        wrapper1.data should equal(data);
    });
});

describe(@"Reachability", ^
{
    beforeEach(^
    {
        request1 = [[NSMutableURLRequest alloc] init];
        wrapper1 = [[ABRequestWrapper alloc] initWithURLRequest:request1 delegate:nil];
        manager = [[ABRequestManager alloc] init];
        manager.reachability = reachability;
    });

    afterEach(^
    {
        [manager release];
        [wrapper1 release];
        [request1 release];
        [reachability reset_sent_messages];
    });

    it(@"should check internet reachability before run request", ^
    {
        [manager addRequestWrapper:wrapper1];
        manager.reachability should have_received(@selector(status));
    });

    it(@"should release connection and head request if reachability lost", ^
    {
        [manager addRequestWrapper:wrapper1];
        [manager reachabilityDidChange:SCNetworkStatusNotReachable];
        manager.connection should be_nil;
        manager.queue.count should equal(0);
    });

    it(@"should run first request in queue if internet becomes reachable", ^
    {
        request2 = [[request1 copy] autorelease];
        wrapper2 = [[[ABRequestWrapper alloc] initWithURLRequest:request2] autorelease];
        [manager addRequestWrapper:wrapper1];
        [manager addRequestWrapper:wrapper2];
        [manager reachabilityDidChange:SCNetworkStatusNotReachable];
        manager.connection should be_nil;
        manager.queue.count should equal(1);
        [manager.queue objectAtIndex:0] should equal(wrapper2);
        [manager reachabilityDidChange:SCNetworkStatusReachableViaWiFi];
        manager.connection should_not be_nil;
        manager.connection.connection.currentRequest should equal(request2);
    });
});

SPEC_END

