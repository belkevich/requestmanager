//
//  ABRequestWrapper.m
//  Request Manager
//
//  Created by Alexey Belkevich on 12/31/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import "ABRequestWrapper.h"
#import "ABBlockHelper.h"
#import "NSError+Reachability.h"

@interface ABRequestWrapper ()

@property (nonatomic, strong, readwrite) NSURLRequest *request;
@property (nonatomic, strong, readwrite) NSHTTPURLResponse *response;
@property (nonatomic, strong, readwrite) NSData *data;
@property (nonatomic, strong, readwrite) NSError *error;

@property (nonatomic, strong) ABBlockHelper *blockHelper;

@end

@implementation ABRequestWrapper


#pragma mark -
#pragma mark main routine

- (id)initWithURLRequest:(NSURLRequest *)request
{
    self = [super init];
    if (self)
    {
        self.request = request;
        self.blockHelper = [[ABBlockHelper alloc] init];
    }
    return self;
}

- (id)initWithURLRequest:(NSURLRequest *)request
                delegate:(NSObject <ABWrapperDelegate> *)aDelegate
{
    self = [self initWithURLRequest:request];
    if (self)
    {
        delegate = aDelegate;
    }
    return self;
}


#pragma mark -
#pragma mark blocks

- (void)setCompletedBlock:(ABWrapperCompletedBlock)completedBlock
              failedBlock:(ABWrapperFailedBlock)failedBlock
{
    if (!delegate)
    {
        self.blockHelper.completedBlock = completedBlock;
        self.blockHelper.failedBlock = failedBlock;
    }
    else
    {
        @throw [NSException exceptionWithName:@"Setted block and delegate"
                                       reason:@"Block can't be setted if delegate setted"
                                     userInfo:nil];
    }
}

- (void)setParsingBlock:(ABWrapperDataParsingBlock)parsingBlock
{
    self.blockHelper.parsingBlock = parsingBlock;
}

#pragma mark -
#pragma mark actions

- (void)setReceivedData:(NSData *)data
               response:(NSHTTPURLResponse *)response
{
    self.data = data;
    self.response = response;
    self.blockHelper.parsingBlock ? [self parseReceivedData] : [self returnReceivedResult:data];
}

- (void)setReceivedError:(NSError *)anError
{
    self.error = anError;
    delegate ? [delegate requestWrapper:self didFail:self.error] :
    [self.blockHelper runFailedBlockWithWrapper:self unreachable:NO];
}

- (void)setUnreachable
{
    if (delegate)
    {
        if ([delegate respondsToSelector:@selector(requestWrapperDidBecomeUnreachable:)])
        {
            [delegate requestWrapperDidBecomeUnreachable:self];
        }
        else
        {
            NSError *error = [NSError errorReachability];
            [delegate requestWrapper:self didFail:error];
        }
    }
    else
    {
        [self.blockHelper runFailedBlockWithWrapper:self unreachable:YES];
    }
}

#pragma mark -
#pragma mark private

- (void)parseReceivedData
{
    id completionBlock = ^(id parsedResult)
    {
        if (parsedResult)
        {
            [self returnReceivedResult:parsedResult];
        }
    };
    [self.blockHelper runParsingBlockWithWrapper:self callbackBlock:completionBlock];
}

- (void)returnReceivedResult:(id)result
{
    if (delegate)
    {
        [delegate requestWrapper:self didFinish:result];
    }
    else if (self.blockHelper)
    {
        [self.blockHelper runCompletedBlockWithWrapper:self result:result];
    }
}

@end
