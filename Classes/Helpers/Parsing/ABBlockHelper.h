//
//  ABBlockHelper.h
//  RequestManagerSpec
//
//  Created by Alexey Belkevich on 3/11/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ABRequestCompletedBlock)(NSHTTPURLResponse *response, id data);
typedef void (^ABRequestFailedBlock)(NSError *error, BOOL isUnreachable);
typedef id (^ABParsingDataBlock)(NSData *data);
typedef void (^ABParsingCompleteBlock)(id parsedResult);

@interface ABBlockHelper : NSObject

@property (nonatomic, copy, readwrite) ABRequestCompletedBlock completeBlock;
@property (nonatomic, copy, readwrite) ABRequestFailedBlock failBlock;
@property (nonatomic, copy, readwrite) ABParsingDataBlock parsingBlock;

// actions
- (void)runCompleteBlockWithData:(id)data response:(NSHTTPURLResponse *)response;
- (void)runFailBlockWithError:(NSError *)error unreachable:(BOOL)isUnreachable;
- (void)runParsingBlockWithData:(NSData *)data
                completionBlock:(ABParsingCompleteBlock)completionBlock;

@end
