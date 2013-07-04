//
//  NSURLRequest+RequestManager.h
//  Request Manager
//
//  Created by Alexey Belkevich on 3/30/13.
//  Copyright (c) 2013 Okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABRequestDelegate.h"

typedef void (^ABRequestCompletedBlock)(NSHTTPURLResponse *response, id result);
typedef void (^ABRequestFailedBlock)(NSError *error);
typedef id (^ABRequestDataParsingBlock)(NSData *data);


@interface NSURLRequest (RequestManager)

- (void)startWithDelegate:(NSObject <ABRequestDelegate> *)delegate;
- (void)startWithDelegate:(NSObject <ABRequestDelegate> *)delegate
             parsingBlock:(ABRequestDataParsingBlock)parsingBlock;
- (void)startWithCompletedBlock:(ABRequestCompletedBlock)completedBlock
                    failedBlock:(ABRequestFailedBlock)failedBlock;
- (void)startWithCompletedBlock:(ABRequestCompletedBlock)completedBlock
                    failedBlock:(ABRequestFailedBlock)failedBlock
                   parsingBlock:(ABRequestDataParsingBlock)parsingBlock;
- (void)cancelRequest;

@end