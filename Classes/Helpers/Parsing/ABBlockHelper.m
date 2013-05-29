//
//  ABBlockHelper.m
//  RequestManagerSpec
//
//  Created by Alexey Belkevich on 3/11/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "ABBlockHelper.h"
#import "ABRequestWrapper.h"

@interface ABBlockHelper ()

@property (nonatomic, strong, readwrite) NSOperationQueue *backgroundQueue;

- (void)runParsingCompletedBlock:(void(^)())block;

@end

@implementation ABBlockHelper

#pragma mark -
#pragma mark main routine


#pragma mark -
#pragma mark actions

- (void)runCompletedBlockWithWrapper:(ABRequestWrapper *)wrapper result:(id)result
{
    if (self.completedBlock)
    {
        self.completedBlock(wrapper, result);
    }
}

- (void)runFailedBlockWithWrapper:(ABRequestWrapper *)wrapper unreachable:(BOOL)isUnreachable
{
    if (self.failedBlock)
    {
        self.failedBlock(wrapper, isUnreachable);
    }
}

- (void)runParsingBlockWithWrapper:(ABRequestWrapper *)wrapper
                     callbackBlock:(ABParsingCompletedBlock)callbackBlock
{
    if (self.parsingBlock)
    {
        NSThread *callbackThread = [NSThread currentThread];
        [self.backgroundQueue addOperationWithBlock:^
        {
            id result = self.parsingBlock(wrapper);
            id block = ^
            {
                callbackBlock(result);
            };
            [self performSelector:@selector(runParsingCompletedBlock:) onThread:callbackThread
                       withObject:block waitUntilDone:NO];
        }];
    }
}

#pragma mark -
#pragma mark properties

- (NSOperationQueue *)backgroundQueue
{
    if (!_backgroundQueue)
    {
        _backgroundQueue = [[NSOperationQueue alloc] init];
        _backgroundQueue.maxConcurrentOperationCount = 1;
    }
    return _backgroundQueue;
}

#pragma mark -
#pragma mark private

- (void)runParsingCompletedBlock:(void(^)())block
{
    block();
}

@end
