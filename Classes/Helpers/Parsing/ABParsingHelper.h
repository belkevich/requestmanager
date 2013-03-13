//
//  ABParsingHelper.h
//  RequestManagerSpec
//
//  Created by Alexey Belkevich on 3/11/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^ ABParsingBlock)(NSData *responseData);
typedef void (^ ABCompleteBlock)(id parsedResult);

@interface ABParsingHelper : NSObject
{
    dispatch_queue_t lockQueue;
    ABParsingBlock parsingBlock;
}

@property (nonatomic, copy) ABParsingBlock parsingBlock;

// actions
- (void)runParsingBlockWithData:(NSData *)data completionBlock:(ABCompleteBlock)completionBlock;

@end
