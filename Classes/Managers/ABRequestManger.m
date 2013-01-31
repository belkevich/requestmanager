//
//  ABRequestManager
//  Request Manager
//
//  Created by Alexey Belkevich on 12/30/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import "ABRequestManger.h"
#import "ABMultiton.h"
#import "ABConnectionHelper.h"
#import "ABRequestWrapper.h"
#import "ABReachabilityHelper.h"
#import "NSMutableArray+Queue.h"
#import "NSError+Reachability.h"

@interface ABRequestManager ()
- (void)runHeadRequest;
- (void)parseData:(NSData *)data forWrapper:(ABRequestWrapper *)wrapper;
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

- (void)sendRequestWrapper:(ABRequestWrapper *)request
{
    [queue addObject:request];
    if (queue.count == 1)
    {
        [self runHeadRequest];
    }
}

- (void)removeRequestWrapper:(ABRequestWrapper *)request
{
    NSInteger index = [queue indexOfObject:request];
    if (index != NSNotFound)
    {
        [queue removeObject:request];
        if (index == 0)
        {
            [self connectionRelease];
        }
    }
}

- (void)removeAllRequestWrappers
{
    [queue removeAllObjects];
    [self connectionRelease];
}

#pragma mark -
#pragma mark connection delegate method

- (void)connectionDidFail:(NSError *)error
{
    [self connectionRelease];
    ABRequestWrapper *wrapper = [queue headPop];
    wrapper.error = error;
}

- (void)connectionDidReceiveData:(NSData *)receivedData
{
    [self connectionRelease];
    ABRequestWrapper *request = [queue headPop];
    [self parseData:receivedData forWrapper:request];
    if (queue.count > 0)
    {
        [self runHeadRequest];
    }
}

#pragma mark -
#pragma mark reachability delegate implementation

- (void)reachabilityDidChange:(BOOL)reachable
{
    reachable ? [self runHeadRequest] : [self connectionRelease];
}

#pragma mark -
#pragma mark private

- (void)runHeadRequest
{
    ABRequestWrapper *wrapper = [queue head];
    if (reachability.isReachable)
    {
        [self connectionRelease];
        connection = [[ABConnectionHelper alloc] initWithRequest:wrapper.request delegate:self];
        [connection start];
    }
    else
    {
        NSError *error = [NSError errorReachabilityLost];
        [wrapper.delegate wrapper:wrapper didReceiveError:error];
    }
}

- (void)parseData:(NSData *)data forWrapper:(ABRequestWrapper *)wrapper
{
    wrapper.response = data;
}

- (void)connectionRelease
{    
    [connection release];
    connection = nil;
}

@end
