//
//  ABConnectionHelperSpec.mm
//  RequestManagerSpec
//
//  Created by Alexey Belkevich on 2/10/13.
//  Copyright (c) 2013 Okolodev. All rights reserved.
//

#import "CedarAsync.h"
#import "Nocilla.h"
#import "ABConnectionHelper+Spec.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(ConnectionHelper)

describe(@"Connection helper", ^
{

    __block NSURL *url = nil;
    __block NSMutableURLRequest *request = nil;
    __block ABConnectionHelper *helper = nil;
    __block NSData *responseData = nil;
    __block NSDictionary *responseHeaders = nil;
    __block id delegateMock = nil;

    beforeEach(^
    {
        url = [[NSURL alloc] initWithString:@"http://test.com"];
        request = [[NSMutableURLRequest alloc] initWithURL:url];
        delegateMock = nice_fake_for(@protocol(ABConnectionDelegate));
        helper = [[ABConnectionHelper alloc] initWithRequest:request delegate:delegateMock];
        responseData = [[NSData alloc] init];
        responseHeaders = [[NSDictionary alloc] initWithObjectsAndKeys:@"application/json",
                                                                       @"Content-Type", nil];
        stubRequest(@"GET", url.absoluteString).andReturnRawResponse(responseData).
        withHeaders(responseHeaders);
        [[LSNocilla sharedInstance] start];
    });

    afterEach(^
    {
        [helper stop];
        [helper release];
        [request release];
        [url release];
        [responseData release];
        [responseHeaders release];
        [[LSNocilla sharedInstance] clearStubs];
        [[LSNocilla sharedInstance] stop];
        [delegateMock reset_sent_messages];
    });

    it(@"should establish connection with request", ^
    {
        [helper start];
        helper.connection should_not be_nil;
        helper.connection.currentRequest should equal(request);
    });

    it(@"should received HTTP-response", ^
    {
        delegateMock stub_method(@selector(connectionDidReceiveData:response:)).
        and_do(^(NSInvocation *invocation)
        {
            NSHTTPURLResponse *response = nil;
            [invocation getArgument:&response atIndex:3];
            [response allHeaderFields] should equal(responseHeaders);
        });
        [helper start];
        in_time(delegateMock) should have_received(@selector(connectionDidReceiveData:response:)).
        with(Arguments::anything).and_with(Arguments::any([NSHTTPURLResponse class]));
    });

    it(@"should download data", ^
    {
        [helper start];
        in_time(delegateMock) should have_received(@selector(connectionDidReceiveData:response:)).
        with(responseData).and_with(Arguments::any([NSHTTPURLResponse class]));
        in_time(YES) should be_truthy;
    });
});

SPEC_END

