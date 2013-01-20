//
//  ABReachabilityHelper.m
//  Request Manager
//
//  Created by Alexey Belkevich on 1/20/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "ABReachabilityHelper.h"
#import "ABRequestOptions.h"
#import "SCNetworkReachability.h"

#define AB_DEFAULT_REACHABILITY             @"http://google.com"

@interface ABReachabilityHelper ()
@property (nonatomic, readonly) SCNetworkReachability *reachability;
- (NSString *)reachabilityHost;
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

- (void)dealloc
{
    [reachability release];
    [super dealloc];
}

#pragma mark -
#pragma mark public properties

@dynamic isReachable;

- (BOOL)isReachable
{
    SCNetworkStatus status = [reachability status];
    BOOL reachable = NO;
    if (status != SCNetworkStatusNotReachable)
    {
        reachable = ![ABRequestOptions sharedInstance].isWiFiOnly ? YES :
        (status == SCNetworkStatusReachableViaWiFi);
    }
    return reachable;
}

#pragma mark -
#pragma mark network reachability delegate implementation

- (void)reachabilityDidChange:(SCNetworkReachability *)aReachability
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
        NSString *host = [self reachabilityHost];
        reachability = [[SCNetworkReachability alloc] initWithHostName:host];
        reachability.delegate = self;
    }
    return reachability;
}

- (NSString *)reachabilityHost
{
    ABRequestOptions *options = [ABRequestOptions sharedInstance];
    return options.baseHost ? options.baseHost : AB_DEFAULT_REACHABILITY;
}

@end
