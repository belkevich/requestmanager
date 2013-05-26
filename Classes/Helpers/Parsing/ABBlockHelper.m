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
                     callbackBlock:(ABParsingCompleteBlock)callbackBlock
{
    if (self.parsingBlock)
    {
        NSOperationQueue *callbackQueue = [NSOperationQueue mainQueue];
        [self.backgroundQueue addOperationWithBlock:^
        {
            id result = self.parsingBlock(wrapper);
            [callbackQueue addOperationWithBlock:^
            {
                callbackBlock(result);
            }];
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
    }
    return _backgroundQueue;
}

@end
