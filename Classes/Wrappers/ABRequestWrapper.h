//
//  RequestWrapper.h
//  Request Manager
//
//  Created by Alexey Belkevich on 12/31/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABRequestDelegate.h"
#import "ABBlockHelper.h"

@interface ABRequestWrapper : NSObject
{
    NSObject <ABRequestDelegate> *delegate;
    ABBlockHelper *blockHelper;
}

@property (nonatomic, retain, readonly) NSURLRequest *request;
@property (nonatomic, retain, readonly) NSHTTPURLResponse *response;
@property (nonatomic, retain, readonly) id data;
@property (nonatomic, retain, readonly) NSError *error;

// initialization
- (id)initWithURLRequest:(NSURLRequest *)aRequest;
- (id)initWithURLRequest:(NSURLRequest *)aRequest
                delegate:(NSObject <ABRequestDelegate> *)aDelegate;
// blocks
- (void)setCompleteBlock:(ABRequestCompletedBlock)completeBlock
               failBlock:(ABRequestFailedBlock)failBlock;
- (void)setParsingBlock:(ABParsingDataBlock)parsingBlock;
// actions
- (void)setReceivedData:(NSData *)aData response:(NSHTTPURLResponse *)aResponse;
- (void)setReceivedError:(NSError *)anError;
- (void)setUnreachable;

@end
