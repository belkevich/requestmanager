//
//  ABReachabilityHelper.h
//  Request Manager
//
//  Created by Alexey Belkevich on 1/20/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABReachabilityDelegate.h"
#import "SCNetworkReachabilityDelegate.h"

@class SCNetworkReachability;

@interface ABReachabilityHelper : NSObject <SCNetworkReachabilityDelegate>
{
    NSObject <ABReachabilityDelegate> *delegate;
    SCNetworkReachability *reachability;
}

@property (nonatomic, readonly) BOOL isReachable;

// initialization
- (id)initWithReachabilityDelegate:(NSObject <ABReachabilityDelegate> *)aDelegate;

@end
