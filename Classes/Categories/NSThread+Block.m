//
//  NSThread+Block.m
//  Request Manager
//
//  Created by Alexey Belkevich on 5/30/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//


#import "NSThread+Block.h"

@interface NSThread ()

+ (void)performBlock:(void(^)())block;

@end

@implementation NSThread (Block)

#pragma mark -
#pragma mark category methods

+ (void)performBlock:(void (^)())block onThread:(NSThread *)thread
{
    if (thread)
    {
        [self performSelector:@selector(performBlock:) onThread:thread withObject:block
                waitUntilDone:NO];
    }
    else if (block)
    {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

#pragma mark -
#pragma mark private

+ (void)performBlock:(void(^)())block
{
    if (block)
    {
        block();
    }
}

@end