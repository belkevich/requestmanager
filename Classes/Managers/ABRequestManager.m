//
//  ABRequestManager
//  Request Manager
//
//  Created by Alexey Belkevich on 12/30/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import "ABRequestManager.h"
#import "ABMultiton.h"
#import "ABConnectionHelper.h"
#import "ABRequestWrapper.h"
#import "ABReachabilityHelper.h"
#import "NSMutableArray+Queue.h"

@interface ABRequestManager ()
- (void)runHeadRequest;
- (void)parseData:(NSData *)data response:(NSHTTPURLResponse *)response
       forWrapper:(ABRequestWrapper *)wrapper;
- (void)connectionRelease;
@end

@implementation ABRequestManager

#pragma mark -
#pragma mark main routine

- (id)init
{
    self = [super init];
    if (self)
    {
        queue = [NSMutableArray new];
        reachability = [[ABReachabilityHelper alloc] initWithReachabilityDelegate:self];
    }
    return self;
}

- (void)dealloc
{
    [self connectionRelease];
    [queue release];
    [reachability release];
    [super dealloc];
}

#pragma mark -
#pragma mark singleton protocol implementation

+ (instancetype)sharedInstance
{
    return [ABMultiton sharedInstanceOfClass:[self class]];
}

#pragma mark -
#pragma mark actions

- (void)sendRequestWrapper:(ABRequestWrapper *)wrapper
{
    [queue addObject:wrapper];
    if (queue.count == 1)
    {
        [self runHeadRequest];
    }
}

- (void)removeRequestWrapper:(ABRequestWrapper *)wrapper
{
    NSInteger index = [queue indexOfObject:wrapper];
    if (index != NSNotFound)
    {
        [queue removeObject:wrapper];
        if (index == 0)
        {
            [self connectionRelease];
            [self runHeadRequest];
        }
    }
}

- (void)removeAllRequestWrappers
{
    [queue removeAllObjects];
    [self connectionRelease];
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
        [self connectionRelease];
        [self runHeadRequest];
    }
}

#pragma mark -
#pragma mark connection delegate method

- (void)connectionDidFail:(NSError *)error
{
    [self connectionRelease];
    ABRequestWrapper *wrapper = [queue headPop];
    [wrapper setReceivedError:error];
}

- (void)connectionDidReceiveData:(NSData *)receivedData response:(NSHTTPURLResponse *)response
{
    [self connectionRelease];
    ABRequestWrapper *request = [queue headPop];
    [self parseData:receivedData response:response forWrapper:request];
    [self runHeadRequest];
}

#pragma mark -
#pragma mark reachability delegate implementation

- (void)reachabilityDidChange:(BOOL)reachable
{
    if (reachable)
    {
        [self runHeadRequest];
    }
    else
    {
        [self connectionRelease];
        ABRequestWrapper *wrapper = [queue head];
        [wrapper setUnreachable];
    }
}

#pragma mark -
#pragma mark private

- (void)runHeadRequest
{
    ABRequestWrapper *wrapper = [queue head];
    if (wrapper)
    {
        if (reachability.isReachable)
        {
            [self connectionRelease];
            connection = [[ABConnectionHelper alloc] initWithRequest:wrapper.request delegate:self];
            [connection start];
        }
        else
        {
            [wrapper setUnreachable];
        }
    }
}

- (void)parseData:(NSData *)data response:(NSHTTPURLResponse *)response
       forWrapper:(ABRequestWrapper *)wrapper
{
    [wrapper setReceivedData:data response:response];
}

- (void)connectionRelease
{
    [connection stop];
    [connection release];
    connection = nil;
}

@end
