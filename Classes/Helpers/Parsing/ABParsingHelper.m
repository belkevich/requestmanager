//
//  ABParsingHelper.m
//  RequestManagerSpec
//
//  Created by Alexey Belkevich on 3/11/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "ABParsingHelper.h"

@implementation ABParsingHelper

#pragma mark -
#pragma mark main routine

@synthesize parsingBlock;

- (id)init
{
    self = [super init];
    if (self)
    {
        NSString *name = [NSString stringWithFormat:@"lock queue %d", self.hash];
        lockQueue = dispatch_queue_create([name UTF8String], NULL);
        parsingBlock = NULL;
    }
    return self;
}

- (void)dealloc
{
    dispatch_release(lockQueue);
    [super dealloc];
}

#pragma mark -
#pragma mark actions

- (void)runParsingBlockWithData:(NSData *)data completionBlock:(ABCompleteBlock)completionBlock
{
    if (parsingBlock)
    {
        dispatch_async(lockQueue, ^{
            id result = parsingBlock(data);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(result);
            });
        });
    }
}

@end
