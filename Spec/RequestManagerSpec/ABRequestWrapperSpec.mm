//
//  ABRequestWrapper.mm
//  RequestManagerSpec
//
//  Created by Alexey Belkevich on 2/18/13.
//  Copyright (c) 2013 Okolodev. All rights reserved.
//

#import "CedarAsync.h"
#import "OCFuntime.h"
#import "ABRequestWrapper_RequestManager.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(RequestWrapper)

__block ABRequestWrapper *wrapper = nil;

describe(@"Main routine", ^
{
    __block NSURLRequest *request = nil;

    beforeEach(^
               {
                   request = [[NSMutableURLRequest alloc] init];
                   wrapper = [[ABRequestWrapper alloc] initWithURLRequest:request];
               });

    afterEach(^
              {
                  [wrapper release];
                  [request release];
              });

    it(@"should contain NSMutableURLRequest", ^
    {
        wrapper = [[ABRequestWrapper alloc] initWithURLRequest:request];
        wrapper.request should equal(request);
    });
});

describe(@"Delegate", ^
{
    __block NSObject <ABWrapperDelegate, CedarDouble> *delegateMock = nil;

    beforeEach(^
               {
                   delegateMock = fake_for(@protocol(ABWrapperDelegate));
                   NSURLRequest *request = [[NSMutableURLRequest alloc] init];
                   wrapper = [[ABRequestWrapper alloc] initWithURLRequest:request
                                                                 delegate:delegateMock];
                   [request release];
               });

    afterEach(^
              {
                  [wrapper release];
                  [delegateMock reset_sent_messages];
              });

    it(@"should send parsed data and response to delegate after parsing", ^
    {
        NSData *data = [NSData data];
        delegateMock stub_method(@selector(requestWrapper:didFinish:));
        [wrapper setReceivedData:data response:nil];
        delegateMock should have_received(@selector(requestWrapper:didFinish:)).
        with(wrapper).and_with(data);
    });

    it(@"should send received error to delegate on connection error", ^
    {
        NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:nil];
        delegateMock stub_method(@selector(requestWrapper:didFail:));
        [wrapper setReceivedError:error];
        delegateMock should have_received(@selector(requestWrapper:didFail:)).
        with(wrapper).and_with(error);
    });

    it(@"should send unreachable to delegate on reachability lost", ^
    {
        delegateMock stub_method(@selector(requestWrapperDidBecomeUnreachable:));
        [wrapper setUnreachable];
        delegateMock should have_received(@selector(requestWrapperDidBecomeUnreachable:)).
        with(wrapper);
    });

    it(@"should send error to delegate on reachability lost if method not implemented", ^
    {
        delegateMock stub_method(@selector(requestWrapper:didFail:));
        // workaround for optional delegate method remove when it will be fixed in Cedar
        OCFuntime *funtime = [[OCFuntime alloc] init];
        [funtime changeClass:[CDRProtocolFake class] instanceMethod:@selector(respondsToSelector:)
              implementation:^
              {
                  return NO;
              }];
        // end
        [wrapper setUnreachable];
        // remove workaround
        [funtime revertClass:[CDRProtocolFake class]];
        [funtime release];
        // end
        delegateMock should have_received(@selector(requestWrapper:didFail:)).with(wrapper).
        and_with(Arguments::any([NSError class]));
    });

    it(@"should call 'finish' delegate method in creation thread", ^
    {
        NSThread *currentThread = [NSThread currentThread];
        __block NSThread *blockThread = nil;
        delegateMock stub_method(@selector(requestWrapper:didFinish:)).and_do(
        ^(NSInvocation *invocation)
        {
            blockThread = [NSThread currentThread];
        });
        [wrapper setReceivedData:nil response:nil];
        blockThread should equal(currentThread);
    });

    it(@"should call 'error' delegate method in creation thread", ^
    {
        NSThread *currentThread = [NSThread currentThread];
        __block NSThread *blockThread = nil;
        delegateMock stub_method(@selector(requestWrapper:didFail:)).and_do(
        ^(NSInvocation *invocation)
        {
            blockThread = [NSThread currentThread];
        });
        [wrapper setReceivedError:nil];
        blockThread should equal(currentThread);
    });

    it(@"should call 'unreachable' delegate method in creation thread", ^
    {
        NSThread *currentThread = [NSThread currentThread];
        __block NSThread *blockThread = nil;
        delegateMock stub_method(@selector(requestWrapperDidBecomeUnreachable:)).and_do(
        ^(NSInvocation *invocation)
        {
            blockThread = [NSThread currentThread];
        });
        [wrapper setUnreachable];
        blockThread should equal(currentThread);
    });
});

describe(@"Blocks", ^
{
    beforeEach(^
               {
                   NSURLRequest *request = [[NSMutableURLRequest alloc] init];
                   wrapper = [[ABRequestWrapper alloc] initWithURLRequest:request];
                   [request release];
               });

    afterEach(^
              {
                  [wrapper release];
              });

    it(@"should run 'complete'-block after complete", ^
    {
        NSData *checkData = [NSData data];
        __block NSData *receivedData = nil;
        [wrapper setCompletedBlock:^(ABRequestWrapper *wrapper, id result)
        {
            receivedData = result;
        }              failedBlock:nil];
        [wrapper setReceivedData:checkData response:nil];
        receivedData should equal(checkData);
    });

    it(@"should run 'error'-block on connection error", ^
    {
        NSError *checkError = [NSError errorWithDomain:@"" code:0 userInfo:nil];
        __block NSError *receivedError = nil;
        [wrapper setCompletedBlock:nil failedBlock:^(ABRequestWrapper *wrapper)
        {
            receivedError = wrapper.error;
        }];
        [wrapper setReceivedError:checkError];
        receivedError should equal(checkError);
    });

    it(@"should run 'error'-block on unreachable", ^
    {
        __block NSError *error = nil;
        __block ABRequestWrapper *theWrapper = nil;
        [wrapper setCompletedBlock:nil failedBlock:^(ABRequestWrapper *wrapper)
        {
            theWrapper = wrapper;
            error = wrapper.error;
        }];
        [wrapper setUnreachable];
        theWrapper should equal(wrapper);
        error.code should equal(101);
    });

    it(@"should run 'complete'-block in the creation thread", ^
    {
        NSThread *currentThread = [NSThread currentThread];
        __block NSThread *blockThread = nil;
        [wrapper setCompletedBlock:^(ABRequestWrapper *wrapper, id result)
        {
            blockThread = [NSThread currentThread];
        }              failedBlock:nil];
        [wrapper setReceivedData:nil response:nil];
        blockThread should equal(currentThread);
    });

    it(@"should run 'error'-block in the creation thread", ^
    {
        NSThread *currentThread = [NSThread currentThread];
        __block NSThread *blockThread = nil;
        [wrapper setCompletedBlock:nil
                       failedBlock:^(ABRequestWrapper *wrapper)
        {
            blockThread = [NSThread currentThread];
        }];
        [wrapper setReceivedError:nil];
        blockThread should equal(currentThread);
    });
});

describe(@"Parsing", ^
{
    __block id delegateMock = nice_fake_for(@protocol(ABWrapperDelegate));
    __block NSData *data = nil;

    beforeEach(^
               {
                   NSURLRequest *request = [[NSMutableURLRequest alloc] init];
                   wrapper = [[ABRequestWrapper alloc] initWithURLRequest:request
                                                                 delegate:delegateMock];
                   data = [[NSData alloc] initWithBytes:"abc" length:3];
                   [request release];
               });

    afterEach(^
              {
                  [wrapper release];
                  [data release];
                  [delegateMock reset_sent_messages];
              });

    it(@"should continue with raw data if no parsing-block set", ^
    {
        [wrapper setReceivedData:data response:nil];
        delegateMock should have_received(@selector(requestWrapper:didFinish:)).with(wrapper).
        and_with(data);
    });

    it(@"should parse received data asynchronously with parse-block", ^
    {
        [wrapper setParsingBlock:^id(ABRequestWrapper *wrapper)
        {
            NSString *string = [[NSString alloc] initWithBytes:wrapper.data.bytes
                                                        length:wrapper.data.length
                                                      encoding:NSASCIIStringEncoding];
            return [string autorelease];
        }];
        [wrapper setReceivedData:data response:nil];
        delegateMock should_not have_received(@selector(requestWrapper:didFinish:));
        in_time(delegateMock) should have_received(@selector(requestWrapper:didFinish:)).
        with(wrapper).and_with(@"abc");
    });

    it(@"should call delegate method on creation thread", ^
    {
        NSThread *currentThread = [NSThread currentThread];
        __block NSThread *blockThread = nil;
        delegateMock stub_method(@selector(requestWrapper:didFinish:)).and_do(
        ^(NSInvocation *invocation)
        {
            blockThread = [NSThread currentThread];
        });
        [wrapper setParsingBlock:^id(ABRequestWrapper *wrapper)
        {
            NSString *string = [[NSString alloc] initWithBytes:wrapper.data.bytes
                                                        length:wrapper.data.length
                                                      encoding:NSASCIIStringEncoding];
            return [string autorelease];
        }];
        [wrapper setReceivedData:data response:nil];
        blockThread should be_nil;
        in_time(blockThread) should equal(currentThread);
    });

    it(@"should call completed block on creation thread", ^
    {
        [wrapper release];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        wrapper = [[ABRequestWrapper alloc] initWithURLRequest:request];
        [request release];
        NSThread *currentThread = [NSThread currentThread];
        __block NSThread *blockThread = nil;
        [wrapper setCompletedBlock:^(ABRequestWrapper *wrapper, id result)
        {
            blockThread = [NSThread currentThread];
        }
                       failedBlock:nil];
        [wrapper setParsingBlock:^id(ABRequestWrapper *wrapper)
        {
            NSString *string = [[NSString alloc] initWithBytes:wrapper.data.bytes
                                                        length:wrapper.data.length
                                                      encoding:NSASCIIStringEncoding];
            return [string autorelease];
        }];
        [wrapper setReceivedData:data response:nil];
        blockThread should be_nil;
        in_time(blockThread) should equal(currentThread);
    });

});

describe(@"Exceptions", ^
{
    __block id delegateMock = nice_fake_for(@protocol(ABWrapperDelegate));

    beforeEach(^
               {
                   NSURLRequest *request = [[NSMutableURLRequest alloc] init];
                   wrapper = [[ABRequestWrapper alloc] initWithURLRequest:request
                                                                 delegate:delegateMock];
                   [request release];
               });

    afterEach(^
              {
                  [wrapper release];
                  [delegateMock reset_sent_messages];
              });

    it(@"should throw exception when complete or fail block set if delegate set before", ^
    {
        ^{[wrapper setCompletedBlock:nil failedBlock:nil];} should raise_exception;
    });
});

SPEC_END
