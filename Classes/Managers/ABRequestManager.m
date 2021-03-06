//
//  ABRequestManager.m
//  Request Manager
//
//  Created by Alexey Belkevich on 12/30/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import "ABRequestManager.h"
#import "ABMultiton.h"
#import "ABConnectionHelper.h"
#import "SCNetworkReachability.h"
#import "NSMutableArray+Queue.h"
#import "NSMutableArray+Request.h"
#import "ABRequestWrapper_RequestManager.h"

NSString * const kABDefaultReachabilityHost = @"google.com";


@interface ABRequestManager () <SCNetworkReachabilityDelegate>

@property (nonatomic, strong) SCNetworkReachability *reachability;

@end


@implementation ABRequestManager

#pragma mark -
#pragma mark main routine

- (id)init
{
    self = [super init];
    if (self)
    {
        queue = [[NSMutableArray alloc] init];
        [self setReachabilityCheckHost:kABDefaultReachabilityHost];
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
    [queue addObject:wrapper];
    if (queue.count == 1)
    {
        [self runHeadRequest];
    }
}

- (void)addRequestWrapperFirst:(ABRequestWrapper *)wrapper
{
    queue.count > 1 ? [queue insertObject:wrapper atIndex:1] : [self addRequestWrapper:wrapper];
}

- (void)removeRequestWrapper:(ABRequestWrapper *)wrapper
{
    BOOL isFirst = NO;
    [queue removeWrapper:wrapper isFirst:&isFirst];
    if (isFirst)
    {
        [self runHeadRequest];
    }
}

- (void)removeAllRequestWrappers
{
    [connection stop];
    connection = nil;
    [queue removeAllObjects];
}

- (void)removeRequest:(NSURLRequest *)request
{
    BOOL isFirst = NO;
    [queue removeRequest:request isFirst:&isFirst];
    if (isFirst)
    {
        [self runHeadRequest];
    }
}

- (void)setReachabilityCheckHost:(NSString *)checkHost
{
    self.reachability = [[SCNetworkReachability alloc] initWithHostName:checkHost];
    self.reachability.delegate = self;
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
    [self runHeadRequestWithNetworkStatus:self.reachability.status];
}

- (void)runHeadRequestWithNetworkStatus:(SCNetworkStatus)status
{
    ABRequestWrapper *wrapper = nil;
    if (queue.count > 0)
    {
        [connection stop];
        switch (status)
        {
#if TARGET_OS_IPHONE
            case SCNetworkStatusReachableViaCellular:
            case SCNetworkStatusReachableViaWiFi:
#else
            case SCNetworkStatusReachable:
#endif
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
