//
//  ABReachabilityHelper.m
//  Request Manager
//
//  Created by Alexey Belkevich on 1/20/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "ABReachabilityHelper.h"
#import "SCNetworkReachability.h"

#define AB_DEFAULT_REACHABILITY             @"google.com"

@interface ABReachabilityHelper ()
@property (nonatomic, strong, readonly) SCNetworkReachability *reachability;
@end


@implementation ABReachabilityHelper

#pragma mark -
#pragma mark main routine

- (id)initWithReachabilityDelegate:(NSObject <ABReachabilityDelegate> *)aDelegate
{
    self = [super init];
    if (self)
    {
        delegate = aDelegate;
    }
    return self;
}


#pragma mark -
#pragma mark public properties

@dynamic isReachable;

- (BOOL)isReachable
{
    SCNetworkStatus status = [self.reachability status];
    return (status != SCNetworkStatusNotReachable);
}

#pragma mark -
#pragma mark network reachability delegate implementation

- (void)reachabilityDidChange:(SCNetworkStatus)status
{
    [delegate reachabilityDidChange:self.isReachable];
}

#pragma mark -
#pragma mark private methods

@dynamic reachability;

- (SCNetworkReachability *)reachability
{
    if (!reachability)
    {
        reachability = [[SCNetworkReachability alloc] initWithHostName:AB_DEFAULT_REACHABILITY];
        reachability.delegate = self;
    }
    return reachability;
}

@end
