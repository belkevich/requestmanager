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
#import "ABReachabilityDelegate.h"

@class ABConnectionHelper;
@class ABRequestWrapper;
@class ABReachabilityHelper;

@interface ABRequestManager : NSObject
<ABMultitonProtocol, ABConnectionDelegate, ABReachabilityDelegate>
{
    NSMutableArray *queue;
    ABConnectionHelper *connection;
    ABReachabilityHelper *reachability;
}

// actions
- (void)sendRequestWrapper:(ABRequestWrapper *)wrapper;
- (void)removeRequestWrapper:(ABRequestWrapper *)wrapper;
- (void)removeAllRequestWrappers;
- (void)removeRequest:(NSURLRequest *)request;

@end
