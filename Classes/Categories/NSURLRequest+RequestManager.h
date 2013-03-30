//
//  NSURLRequest+RequestManager.h
//  Request Manager
//
//  Created by Alexey Belkevich on 3/30/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABRequestWrapper.h"

@interface NSURLRequest (RequestManager)

- (void)startWithDelegate:(NSObject <ABRequestDelegate> *)delegate;
- (void)startWithDelegate:(NSObject <ABRequestDelegate> *)delegate
             parsingBlock:(ABParsingDataBlock)parsingBlock;
- (void)startWithCompleteBlock:(ABRequestCompletedBlock)completeBlock
                     failBlock:(ABRequestFailedBlock)failBlock;
- (void)startWithCompleteBlock:(ABRequestCompletedBlock)completeBlock
                     failBlock:(ABRequestFailedBlock)failBlock
                  parsingBlock:(ABParsingDataBlock)parsingBlock;

@end