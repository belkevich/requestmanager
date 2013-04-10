//
//  NSURLRequest+RequestManager.m
//  Request Manager
//
//  Created by Alexey Belkevich on 3/30/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "NSURLRequest+RequestManager.h"
#import "ABRequestManager.h"

@implementation NSURLRequest (RequestManager)

- (void)startWithDelegate:(NSObject <ABRequestDelegate> *)delegate
{
    ABRequestWrapper *wrapper = [[ABRequestWrapper alloc] initWithURLRequest:self
                                                                    delegate:delegate];
    [[ABRequestManager sharedInstance] sendRequestWrapper:wrapper];
    [wrapper release];
}

- (void)startWithDelegate:(NSObject <ABRequestDelegate> *)delegate
             parsingBlock:(ABParsingDataBlock)parsingBlock
{
    ABRequestWrapper *wrapper = [[ABRequestWrapper alloc] initWithURLRequest:self
                                                                    delegate:delegate];
    [wrapper setParsingBlock:parsingBlock];
    [[ABRequestManager sharedInstance] sendRequestWrapper:wrapper];
    [wrapper release];
}

- (void)startWithCompleteBlock:(ABRequestCompletedBlock)completeBlock
                     failBlock:(ABRequestFailedBlock)failBlock
{
    ABRequestWrapper *wrapper = [[ABRequestWrapper alloc] initWithURLRequest:self];
    [wrapper setCompleteBlock:completeBlock failBlock:failBlock];
    [[ABRequestManager sharedInstance] sendRequestWrapper:wrapper];
    [wrapper release];
}

- (void)startWithCompleteBlock:(ABRequestCompletedBlock)completeBlock
                     failBlock:(ABRequestFailedBlock)failBlock
                  parsingBlock:(ABParsingDataBlock)parsingBlock
{
    ABRequestWrapper *wrapper = [[ABRequestWrapper alloc] initWithURLRequest:self];
    [wrapper setCompleteBlock:completeBlock failBlock:failBlock];
    [wrapper setParsingBlock:parsingBlock];
    [[ABRequestManager sharedInstance] sendRequestWrapper:wrapper];
    [wrapper release];
}

- (void)cancelRequest
{
    [[ABRequestManager sharedInstance] removeRequest:self];
}


@end