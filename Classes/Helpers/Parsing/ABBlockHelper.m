//
//  ABBlockHelper.m
//  RequestManagerSpec
//
//  Created by Alexey Belkevich on 3/11/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "ABBlockHelper.h"

@interface ABBlockHelper ()

@property (nonatomic, assign, readwrite) dispatch_queue_t lockQueue;

@end

@implementation ABBlockHelper

#pragma mark -
#pragma mark main routine

@synthesize completeBlock, failBlock, parsingBlock;

@synthesize lockQueue;

- (id)init
{
    self = [super init];
    if (self)
    {
        NSString *name = [NSString stringWithFormat:@"lock queue %d", self.hash];
        lockQueue = dispatch_queue_create([name UTF8String], NULL);
    }
    return self;
}

- (void)dealloc
{
    self.completeBlock = nil;
    self.failBlock = nil;
    self.parsingBlock = nil;
    dispatch_release(lockQueue);
    [super dealloc];
}

#pragma mark -
#pragma mark actions

- (void)runCompleteBlockWithData:(id)data response:(NSHTTPURLResponse *)response
{
    if (self.completeBlock)
    {
        self.completeBlock(data, response);
    }
}

- (void)runFailBlockWithError:(NSError *)error unreachable:(BOOL)isUnreachable
{
    if (self.failBlock)
    {
        self.failBlock(error, isUnreachable);
    }
}

- (void)runParsingBlockWithData:(NSData *)data
                completionBlock:(ABParsingCompleteBlock)completionBlock
{
    if (self.parsingBlock)
    {
        dispatch_async(self.lockQueue, ^
        {
            id result = self.parsingBlock(data);
            dispatch_async(dispatch_get_main_queue(), ^
            {
                completionBlock(result);
            });
        });
    }
}

@end
