//
//  NSURLRequest+RequestManager.mm
//  RequestManagerSpec
//
//  Created by Alexey Belkevich on 1/26/13.
//  Copyright (c) 2013 Okolodev. All rights reserved.
//

#import "CedarAsync.h"
#import "NSURLRequest+RequestManager.h"
#import "ABRequestManager+Spec.h"
#import "ABRequestWrapper.h"
#import "ABMultiton.h"
#import "OCFuntime.h"
#import "SCNetworkReachability.h"

@interface NSURLRequest ()

- (ABRequestWrapper *)wrapperWithRequestDelegate:(NSObject <ABRequestDelegate> *)delegate;
- (ABRequestWrapper *)wrapperWithCompletedBlock:(ABRequestCompletedBlock)completedBlock
                                    failedBlock:(ABRequestFailedBlock)failedBlock;
- (void)setParsingBlock:(ABRequestDataParsingBlock)block toWrapper:(ABRequestWrapper *)theWrapper;

@end


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(NSURLRequestCategory)


describe(@"Request category", ^
{
    __block NSURL *url = nil;
    __block NSMutableURLRequest *request = nil;

    beforeEach(^
               {
                   url = [[NSURL alloc] initWithString:@"http://test.com"];
                   request = [[NSMutableURLRequest alloc] initWithURL:url];
                   ABRequestManager *manager = [ABRequestManager sharedInstance];
                   manager.reachability = fake_for([SCNetworkReachability class]);
                   manager.reachability stub_method(@selector(status)).
                   and_return(SCNetworkStatusReachableViaWiFi);
               });

    afterEach(^
              {
                  [url release];
                  [request release];
                  [ABMultiton removeInstanceOfClass:[ABRequestManager class]];
              });

    it(@"should be able to run with delegate", ^
    {
        [request startWithDelegate:nil];
        NSArray *queue = [[ABRequestManager sharedInstance] queue];
        queue.count should equal(1);
        ABRequestWrapper *wrapper = [queue objectAtIndex:0];
        wrapper.request should equal(request);
    });

    it(@"should be able to run with delegate and parsing block", ^
    {
        [request startWithDelegate:nil parsingBlock:nil];
        NSArray *queue = [[ABRequestManager sharedInstance] queue];
        queue.count should equal(1);
        ABRequestWrapper *wrapper = [queue objectAtIndex:0];
        wrapper.request should equal(request);
    });

    it(@"should be able to run with complete and fail blocks", ^
    {
        [request startWithCompletedBlock:nil failedBlock:nil];
        NSArray *queue = [[ABRequestManager sharedInstance] queue];
        queue.count should equal(1);
        ABRequestWrapper *wrapper = [queue objectAtIndex:0];
        wrapper.request should equal(request);
    });

    it(@"should should be able to run with complete, fail and parsing blocks", ^
    {
        [request startWithCompletedBlock:nil failedBlock:nil parsingBlock:nil];
        NSArray *queue = [[ABRequestManager sharedInstance] queue];
        queue.count should equal(1);
        ABRequestWrapper *wrapper = [queue objectAtIndex:0];
        wrapper.request should equal(request);
    });

    it(@"should should be able to remove from requests queue", ^
    {
        [request startWithCompletedBlock:nil failedBlock:nil parsingBlock:nil];
        NSArray *queue = [[ABRequestManager sharedInstance] queue];
        queue.count should equal(1);
        [request cancelRequest];
        queue.count should equal(0);
    });
});

describe(@"Delegate", ^
{
    __block NSMutableURLRequest *request = nil;
    __block ABRequestWrapper *wrapper = nil;
    __block NSObject <ABRequestDelegate, CedarDouble> *delegateMock = nil;

    beforeEach(^
               {
                   NSURL *url = [NSURL URLWithString:@"http://test.com"];
                   request = [[NSMutableURLRequest alloc] initWithURL:url];
                   delegateMock = fake_for(@protocol(ABRequestDelegate));
                   wrapper = [request wrapperWithRequestDelegate:delegateMock];
               });

    afterEach(^
              {
                  [request release];
                  [delegateMock reset_sent_messages];
              });

    it(@"should send parsed data and response to delegate after parsing", ^
    {
        NSData *data = [NSData data];
        delegateMock stub_method(@selector(request:didReceiveResponse:));
        [wrapper setReceivedData:data response:nil];
        delegateMock should have_received(@selector(request:didReceiveResponse:)).
        with(request).and_with(data);
    });

    it(@"should send received error to delegate on connection error", ^
    {
        NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:nil];
        delegateMock stub_method(@selector(request:didReceiveError:));
        [wrapper setReceivedError:error];
        delegateMock should have_received(@selector(request:didReceiveError:)).
        with(request).and_with(error);
    });

    it(@"should send error to delegate on reachability lost", ^
    {
        delegateMock stub_method(@selector(request:didReceiveError:));
        [wrapper setUnreachable];
        delegateMock should have_received(@selector(request:didReceiveError:)).with(request).
        and_with(Arguments::any([NSError class]));
    });
});

describe(@"Blocks", ^
{
    __block NSMutableURLRequest *request = nil;
    __block ABRequestWrapper *wrapper = nil;

    beforeEach(^
               {
                   NSURL *url = [NSURL URLWithString:@"http://test.com"];
                   request = [[NSMutableURLRequest alloc] initWithURL:url];
               });

    afterEach(^
              {
                  [request release];
              });

    it(@"should receive HTTP-response and data in 'complete'-block", ^
    {
        NSData *checkData = [NSData data];
        __block NSData *receivedData = nil;
        NSHTTPURLResponse *checkResponse = [[[NSHTTPURLResponse alloc] init] autorelease];
        __block NSHTTPURLResponse *receivedResponse = nil;
        wrapper = [request wrapperWithCompletedBlock:^(NSHTTPURLResponse *response, id result)
        {
            receivedResponse = response;
            receivedData = result;
        }
                                         failedBlock:nil];
        [wrapper setReceivedData:checkData response:checkResponse];
        receivedData should equal(checkData);
        receivedResponse should equal(checkResponse);
    });

    it(@"should receive error in 'error'-block", ^
    {
        NSError *checkError = [NSError errorWithDomain:@"" code:0 userInfo:nil];
        __block NSError *receivedError = nil;
        wrapper = [request wrapperWithCompletedBlock:nil failedBlock:^(NSError *error)
        {
            receivedError = error;
        }];
        [wrapper setReceivedError:checkError];
        receivedError should equal(checkError);
    });

    it(@"should receive reachability error in 'error'-block", ^
    {
        __block NSError *theError = nil;
        wrapper = [request wrapperWithCompletedBlock:nil failedBlock:^(NSError *error)
        {
            theError = error;
        }];
        [wrapper setUnreachable];
        theError.code should equal(101);
    });
});

describe(@"Parsing", ^
{
    __block NSMutableURLRequest *request = nil;
    __block ABRequestWrapper *wrapper = nil;
    __block NSData *incomingData = nil;
    __block id parsedData = nil;

    beforeEach(^
               {
                   NSURL *url = [NSURL URLWithString:@"http://test.com"];
                   request = [[NSMutableURLRequest alloc] initWithURL:url];
                   incomingData = [[NSData alloc] initWithBytes:"abc" length:3];
                   wrapper = [request wrapperWithCompletedBlock:^(NSHTTPURLResponse *response,
                                                                  id result)
                   {
                        parsedData = [result retain];
                   }
                                                    failedBlock:nil];
                   [wrapper retain];
               });

    afterEach(^
              {
                  [request release];
                  [wrapper release];
                  [incomingData release];
                  [parsedData release];
                  parsedData = nil;
              });

    it(@"should receive raw data if no parsing-block set", ^
    {
        [wrapper setReceivedData:incomingData response:nil];
        parsedData should equal(incomingData);
    });

    it(@"should receive parsed data (asynchronously with parse-block)", ^
    {
        [request setParsingBlock:^id(NSData *data)
        {
            NSString *string = [[NSString alloc] initWithBytes:wrapper.data.bytes
                                                        length:wrapper.data.length
                                                      encoding:NSASCIIStringEncoding];
            return [string autorelease];
        }
                       toWrapper:wrapper];
        [wrapper setReceivedData:incomingData response:nil];
        parsedData should be_nil;
        in_time(parsedData) should equal(@"abc");
    });
});

SPEC_END

