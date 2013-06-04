//
//  ABRequestManager.m
//  Request Manager
//
//  Created by Alexey Belkevich on 12/30/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import "ABRequestManager.h"
#import "ABMultiton.h"
#import "ABAsyncQueue.h"
#import "ABConnectionHelper.h"
#import "ABRequestWrapper.h"
#import "SCNetworkReachability.h"

NSString * const kABDefaultReachabilityHost = @"google.com";

@interface ABRequestManager ()

- (void)runHeadRequest;
- (void)runHeadRequestWithNetworkStatus:(SCNetworkStatus)status;
- (void)runConnectionWithRequest:(NSURLRequest *)request;

@end

@implementation ABRequestManager

#pragma mark -
#pragma mark main routine

- (id)init
{
    self = [super init];
    if (self)
    {
        queue = [[ABAsyncQueue alloc] init];
        reachability = [[SCNetworkReachability alloc] initWithHostName:kABDefaultReachabilityHost];
        reachability.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    [connection stop];
}

#pragma mark -
#pragma mark singleton protocol implementation

+ (instancetype)sharedInstance
{
    return [ABMultiton sharedInstanceOfClass:[self class]];
}

#pragma mark -
#pragma mark actions

- (void)addRequestWrapper:(ABRequestWrapper *)wrapper
{
    [queue putObject:wrapper async:^(NSUInteger count)
    {
        if (count == 1)
        {
            [self runHeadRequest];
        }
    }];
}

- (void)removeRequestWrapper:(ABRequestWrapper *)wrapper
{
    [queue removeObject:wrapper async:^(NSUInteger index)
    {
        if (index == 0)
        {
            [self runHeadRequest];
        }
    }];
}

- (void)removeAllRequestWrappers
{
    [connection stop];
    connection = nil;
    [queue removeAllObjects];
}

- (void)removeRequest:(NSURLRequest *)request
{
    NSIndexSet *indexSet = [queue indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx,
                                                                    BOOL *stop)
    {
        ABRequestWrapper *wrapper = obj;
        return (wrapper.request == request);
    }];
    [queue removeObjectsAtIndexes:indexSet];
    if ([indexSet containsIndex:0])
    {
        [self runHeadRequest];
    }
}

#pragma mark -
#pragma mark connection delegate method

- (void)connectionDidFail:(NSError *)error
{
    [connection stop];
    ABRequestWrapper *wrapper = [queue headPop];
    [wrapper setReceivedError:error];
}

- (void)connectionDidReceiveData:(NSData *)data response:(NSHTTPURLResponse *)response
{
    [connection stop];
    ABRequestWrapper *wrapper = [queue headPop];
    [wrapper setReceivedData:data response:response];
    [self runHeadRequest];
}

#pragma mark -
#pragma mark network reachability delegate implementation

- (void)reachabilityDidChange:(SCNetworkStatus)status
{
    [self runHeadRequestWithNetworkStatus:status];
}

#pragma mark -
#pragma mark private

- (void)runHeadRequest
{
    [self runHeadRequestWithNetworkStatus:reachability.status];
}

- (void)runHeadRequestWithNetworkStatus:(SCNetworkStatus)status
{
    ABRequestWrapper *wrapper = nil;
    if (queue.count > 0)
    {
        [connection stop];
        switch (status)
        {
            case SCNetworkStatusReachableViaCellular:
            case SCNetworkStatusReachableViaWiFi:
                wrapper = [queue head];
                [self runConnectionWithRequest:wrapper.request];
                break;

            case SCNetworkStatusNotReachable:
                connection = nil;
                wrapper = [queue headPop];
                [wrapper setUnreachable];
                break;

            default:
                break;
        }
    }
}

- (void)runConnectionWithRequest:(NSURLRequest *)request
{
    connection = [[ABConnectionHelper alloc] initWithRequest:request delegate:self];
    [connection start];    
}

@end
