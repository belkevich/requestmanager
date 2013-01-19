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
#import "NSMutableArray+Queue.h"

@interface ABRequestManager ()
- (void)runHeadRequest;
- (void)parseData:(NSData *)data forWrapper:(ABRequestWrapper *)wrapper;
- (void)helperRelease;
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
    }
    return self;
}

- (void)dealloc
{
    [queue release];
    [helper release];
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

- (void)sendRequest:(ABRequestWrapper *)request
{
    [queue addObject:request];
    if (queue.count == 1)
    {
        [self runHeadRequest];
    }
}

#pragma mark -
#pragma mark connection delegate method

- (void)connectionDidFail:(NSError *)error
{
    [self helperRelease];
    ABRequestWrapper *wrapper = [queue headPop];
    wrapper.error = error;
}

- (void)connectionDidReceiveData:(NSData *)receivedData
{
    [self helperRelease];
    ABRequestWrapper *request = [queue headPop];
    [self parseData:receivedData forWrapper:request];
    if (queue.count > 0)
    {
        [self runHeadRequest];
    }
}

#pragma mark -
#pragma mark private

- (void)runHeadRequest
{
    ABRequestWrapper *wrapper = [queue head];
    if (wrapper)
    {
#warning add reachability check
        [helper release];
        helper = [[ABConnectionHelper alloc] initWithRequest:wrapper.request delegate:self];
        [helper start];
    }
}

- (void)parseData:(NSData *)data forWrapper:(ABRequestWrapper *)wrapper
{
    wrapper.response = data;
}

- (void)helperRelease
{
    [helper autorelease];
    helper = nil;
}

@end
