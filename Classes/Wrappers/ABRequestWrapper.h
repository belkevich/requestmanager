//
//  ABRequestWrapper.h
//  Request Manager
//
//  Created by Alexey Belkevich on 12/31/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABWrapperDelegate.h"
#import "ABWrapperBlocks.h"

@interface ABRequestWrapper : NSObject
{
    NSObject <ABWrapperDelegate> *delegate;
}

@property (nonatomic, strong, readonly) NSURLRequest *request;
@property (nonatomic, strong, readonly) NSHTTPURLResponse *response;
@property (nonatomic, strong, readonly) NSData *data;
@property (nonatomic, strong, readonly) NSError *error;

// initialization
- (id)initWithURLRequest:(NSURLRequest *)request;
- (id)initWithURLRequest:(NSURLRequest *)request
                delegate:(NSObject <ABWrapperDelegate> *)delegate;
// blocks
- (void)setCompletedBlock:(ABWrapperCompletedBlock)completedBlock
              failedBlock:(ABWrapperFailedBlock)failedBlock;
- (void)setParsingBlock:(ABWrapperDataParsingBlock)parsingBlock;
// actions
- (void)setReceivedData:(NSData *)data response:(NSHTTPURLResponse *)response;
- (void)setReceivedError:(NSError *)anError;
- (void)setUnreachable;

@end
