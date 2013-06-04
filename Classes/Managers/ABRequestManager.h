//
//  ABRequestManager.h
//  Request Manager
//
//  Created by Alexey Belkevich on 12/30/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABMultitonProtocol.h"
#import "ABConnectionDelegate.h"
#import "SCNetworkReachabilityDelegate.h"

@class ABAsyncQueue;
@class ABConnectionHelper;
@class ABRequestWrapper;
@class SCNetworkReachability;

@interface ABRequestManager : NSObject
<ABMultitonProtocol, ABConnectionDelegate, SCNetworkReachabilityDelegate>
{
    ABAsyncQueue *queue;
    ABConnectionHelper *connection;
    SCNetworkReachability *reachability;
}

// actions
- (void)addRequestWrapper:(ABRequestWrapper *)wrapper;
- (void)removeRequestWrapper:(ABRequestWrapper *)wrapper;
- (void)removeAllRequestWrappers;
- (void)removeRequest:(NSURLRequest *)request;

@end
