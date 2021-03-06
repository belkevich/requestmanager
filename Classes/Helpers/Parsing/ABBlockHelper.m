//
//  ABBlockHelper.m
//  Request Manager
//
//  Created by Alexey Belkevich on 3/11/13.
//  Copyright (c) 2013 Okolodev. All rights reserved.
//

#import "ABBlockHelper.h"
#import "ABRequestWrapper.h"
#import "NSThread+Block.h"

@implementation ABBlockHelper

#pragma mark -
#pragma mark main routine

- (id)init
{
    self = [super init];
    if (self)
    {
        unsigned long hash = (unsigned long)self.hash;
        NSString *name = [NSString stringWithFormat:@"%ld.org.okolodev.parsing", hash];
        queue = dispatch_queue_create([name cStringUsingEncoding:NSASCIIStringEncoding], NULL);
    }
    return self;
}

- (void)dealloc
{
#if !OS_OBJECT_USE_OBJC
    if (queue)
    {
        dispatch_release(queue);
    }
#endif
}

#pragma mark -
#pragma mark actions

- (void)runCompletedBlockWithWrapper:(ABRequestWrapper *)wrapper result:(id)result
{
    if (self.completedBlock)
    {
        self.completedBlock(wrapper, result);
    }
}

- (void)runFailedBlockWithWrapper:(ABRequestWrapper *)wrapper
{
    if (self.failedBlock)
    {
        self.failedBlock(wrapper);
    }
}

- (void)runParsingBlockWithWrapper:(ABRequestWrapper *)wrapper
                     callbackBlock:(ABParsingCompletedBlock)callbackBlock
{
    if (self.parsingBlock)
    {
        __weak NSThread *callbackThread = [NSThread currentThread];
        dispatch_async(queue, ^
        {
            id result = self.parsingBlock(wrapper);
            id block = ^{callbackBlock(result);};
            [NSThread performBlock:block onThread:callbackThread];
        });
    }
}

@end
