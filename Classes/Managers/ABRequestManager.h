//
//  ABRequestManager
//  Request Manager
//
//  Created by Alexey Belkevich on 12/30/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABMultitonProtocol.h"
#import "ABConnectionDelegate.h"
#import "SCNetworkReachabilityDelegate.h"

@class ABConnectionHelper;
@class ABRequestWrapper;
@class SCNetworkReachability;

@interface ABRequestManager : NSObject
<ABMultitonProtocol, ABConnectionDelegate, SCNetworkReachabilityDelegate>
{
    NSMutableArray *queue;
    ABConnectionHelper *connection;
    SCNetworkReachability *reachability;
}

// actions
- (void)addRequestWrapper:(ABRequestWrapper *)wrapper;
- (void)removeRequestWrapper:(ABRequestWrapper *)wrapper;
- (void)removeAllRequestWrappers;
- (void)removeRequest:(NSURLRequest *)request;

@end
