//
//  ABRequestOptions.m
//  RequestManager
//
//  Created by Alexey Belkevich on 6/28/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "ABRequestOptions.h"

@implementation ABRequestOptions

#pragma mark -
#pragma mark main routine

- (id)init
{
    self = [super init];
    if (self)
    {
        self.cookies = YES;
        self.cache = NSURLRequestUseProtocolCachePolicy;
        self.timeout = 60.f;
    }
    return self;
}

@end
