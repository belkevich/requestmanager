//
//  ABBlockHelper.h
//  RequestManagerSpec
//
//  Created by Alexey Belkevich on 3/11/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABWrapperBlocks.h"

typedef void (^ABParsingCompletedBlock)(id result);

@interface ABBlockHelper : NSObject
{
    dispatch_queue_t queue;
}

@property (nonatomic, copy) ABWrapperCompletedBlock completedBlock;
@property (nonatomic, copy) ABWrapperFailedBlock failedBlock;
@property (nonatomic, copy) ABWrapperDataParsingBlock parsingBlock;

// actions
- (void)runCompletedBlockWithWrapper:(ABRequestWrapper *)wrapper result:(id)result;
- (void)runFailedBlockWithWrapper:(ABRequestWrapper *)wrapper unreachable:(BOOL)isUnreachable;
- (void)runParsingBlockWithWrapper:(ABRequestWrapper *)wrapper
                     callbackBlock:(ABParsingCompletedBlock)callbackBlock;

@end
