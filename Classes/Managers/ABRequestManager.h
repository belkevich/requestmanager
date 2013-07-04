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

@class ABConnectionHelper;
@class ABRequestWrapper;

@interface ABRequestManager : NSObject
<ABMultitonProtocol, ABConnectionDelegate>
{
    NSMutableArray *queue;
    ABConnectionHelper *connection;
}

// actions
- (void)addRequestWrapper:(ABRequestWrapper *)wrapper;
- (void)addRequestWrapperFirst:(ABRequestWrapper *)wrapper;
- (void)removeRequestWrapper:(ABRequestWrapper *)wrapper;
- (void)removeAllRequestWrappers;
- (void)removeRequest:(NSURLRequest *)request;
- (void)setReachabilityCheckHost:(NSString *)checkHost;

@end
