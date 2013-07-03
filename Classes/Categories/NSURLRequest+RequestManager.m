//
//  NSURLRequest+RequestManager.m
//  Request Manager
//
//  Created by Alexey Belkevich on 3/30/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "NSURLRequest+RequestManager.h"
#import "NSError+Reachability.h"
#import "ABRequestWrapper.h"
#import "ABRequestManager.h"


@implementation NSURLRequest (RequestManager)

#pragma mark -
#pragma mark public

- (void)startWithDelegate:(NSObject <ABRequestDelegate> *)delegate
{
    ABRequestWrapper *wrapper = [self wrapperWithRequestDelegate:delegate];
    [[ABRequestManager sharedInstance] addRequestWrapper:wrapper];
}

- (void)startWithDelegate:(NSObject <ABRequestDelegate> *)delegate
             parsingBlock:(ABRequestDataParsingBlock)parsingBlock
{
    ABRequestWrapper *wrapper = [self wrapperWithRequestDelegate:delegate];
    [self setParsingBlock:parsingBlock toWrapper:wrapper];
    [[ABRequestManager sharedInstance] addRequestWrapper:wrapper];
}

- (void)startWithCompletedBlock:(ABRequestCompletedBlock)completedBlock
                    failedBlock:(ABRequestFailedBlock)failedBlock
{
    ABRequestWrapper *wrapper = [self wrapperWithCompletedBlock:completedBlock
                                                    failedBlock:failedBlock];
    [[ABRequestManager sharedInstance] addRequestWrapper:wrapper];
}

- (void)startWithCompletedBlock:(ABRequestCompletedBlock)completedBlock
                    failedBlock:(ABRequestFailedBlock)failedBlock
                   parsingBlock:(ABRequestDataParsingBlock)parsingBlock
{
    ABRequestWrapper *wrapper = [self wrapperWithCompletedBlock:completedBlock
                                                    failedBlock:failedBlock];
    [self setParsingBlock:parsingBlock toWrapper:wrapper];
    [[ABRequestManager sharedInstance] addRequestWrapper:wrapper];
}

- (void)cancelRequest
{
    [[ABRequestManager sharedInstance] removeRequest:self];
}

#pragma mark -
#pragma mark private

- (ABRequestWrapper *)wrapperWithRequestDelegate:(NSObject <ABRequestDelegate> *)delegate
{
    __weak NSObject <ABRequestDelegate> *weakDelegate = delegate;
    ABRequestWrapper *theWrapper = [[ABRequestWrapper alloc] initWithURLRequest:self];
    [theWrapper setCompletedBlock:^(ABRequestWrapper *wrapper, id result)
    {
        [weakDelegate request:wrapper.request didReceiveResponse:result];
    }                 failedBlock:^(ABRequestWrapper *wrapper, BOOL isUnreachable)
    {
        if (isUnreachable)
        {
            if ([weakDelegate respondsToSelector:@selector(requestDidBecomeUnreachable:)])
            {
                [weakDelegate requestDidBecomeUnreachable:wrapper.request];
            }
            else
            {
                NSError *error = [NSError errorReachability];
                [weakDelegate request:wrapper.request didReceiveError:error];
            }
        }
        else
        {
            [weakDelegate request:wrapper.request didReceiveError:wrapper.error];
        }
    }];
    return theWrapper;
}

- (ABRequestWrapper *)wrapperWithCompletedBlock:(ABRequestCompletedBlock)completedBlock
                                    failedBlock:(ABRequestFailedBlock)failedBlock
{
    ABRequestWrapper *theWrapper = [[ABRequestWrapper alloc] initWithURLRequest:self];
    [theWrapper setCompletedBlock:^(ABRequestWrapper *wrapper, id result)
    {
        if (completedBlock)
        {
            completedBlock(wrapper.response, result);
        }
    }                 failedBlock:^(ABRequestWrapper *wrapper, BOOL isUnreachable)
    {
        if (failedBlock)
        {
            failedBlock(wrapper.error, isUnreachable);
        }
    }];
    return theWrapper;
}

- (void)setParsingBlock:(ABRequestDataParsingBlock)block toWrapper:(ABRequestWrapper *)theWrapper
{
    [theWrapper setParsingBlock:^id(ABRequestWrapper *wrapper)
    {
        return (block) ? block(wrapper.data) : nil;
    }];
}

@end