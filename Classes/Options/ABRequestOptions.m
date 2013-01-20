//
//  ABRequestOptions.m
//  RequestManagerApp
//
//  Created by Alexey Belkevich on 1/20/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "ABRequestOptions.h"
#import "ABMultiton.h"

@implementation ABRequestOptions

@synthesize baseHost, isWiFiOnly, connectionLostAction;

#pragma mark -
#pragma mark main routine

- (id)init
{
    self = [super init];
    if (self)
    {
        isWiFiOnly = NO;
        connectionLostAction = ABConnectionLostActionWait;
    }
    return self;
}

- (void)dealloc
{
    [baseHost release];
    [super dealloc];
}

#pragma mark -
#pragma mark singleton protocol implementation

+ (instancetype)sharedInstance
{
    return [ABMultiton sharedInstanceOfClass:[self class]];
}

@end
