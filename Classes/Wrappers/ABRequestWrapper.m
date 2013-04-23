//
//  RequestWrapper.m
//  Request Manager
//
//  Created by Alexey Belkevich on 12/31/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import "ABRequestWrapper.h"
#import "NSError+Reachability.h"

@interface ABRequestWrapper ()

@property (nonatomic, retain, readwrite) NSURLRequest *request;
@property (nonatomic, retain, readwrite) NSHTTPURLResponse *response;
@property (nonatomic, retain, readwrite) id data;
@property (nonatomic, retain, readwrite) NSError *error;
@property (nonatomic, retain, readonly) ABBlockHelper *blockHelper;

- (void)parseReceivedData:(NSData *)aData;
- (void)returnReceivedData:(id)aData;
@end

@implementation ABRequestWrapper

@synthesize request, response, data, error;

#pragma mark -
#pragma mark main routine

- (id)initWithURLRequest:(NSURLRequest *)aRequest
{
    self = [super init];
    if (self)
    {
        self.request = aRequest;
    }
    return self;
}

- (id)initWithURLRequest:(NSURLRequest *)aRequest
                delegate:(NSObject <ABRequestDelegate> *)aDelegate
{
    self = [self initWithURLRequest:aRequest];
    if (self)
    {
        delegate = aDelegate;
    }
    return self;
}

- (void)dealloc
{
    self.request = nil;
    self.response = nil;
    self.data = nil;
    self.error = nil;
    [blockHelper release];
    [super dealloc];
}

#pragma mark -
#pragma mark blocks

- (void)setCompleteBlock:(ABRequestCompletedBlock)completeBlock
               failBlock:(ABRequestFailedBlock)failBlock
{
    if (!delegate)
    {
        self.blockHelper.completeBlock = completeBlock;
        self.blockHelper.failBlock = failBlock;
    }
    else
    {
        @throw [NSException exceptionWithName:@"Setted block and delegate"
                                       reason:@"Block can't be setted if delegate setted"
                                     userInfo:nil];
    }
}

- (void)setParsingBlock:(ABParsingDataBlock)parsingBlock
{
    self.blockHelper.parsingBlock = parsingBlock;
}

#pragma mark -
#pragma mark actions

- (void)setReceivedData:(NSData *)aData
               response:(NSHTTPURLResponse *)aResponse
{
    self.response = aResponse;
    blockHelper.parsingBlock ? [self parseReceivedData:aData] : [self returnReceivedData:aData];
}

- (void)setReceivedError:(NSError *)anError
{
    self.error = anError;
    blockHelper ? [blockHelper runFailBlockWithError:self.error unreachable:NO]:
    [delegate request:self.request didReceiveError:self.error];
}

- (void)setUnreachable
{
    if (blockHelper)
    {
        [blockHelper runFailBlockWithError:nil unreachable:YES];
    }
    else if ([delegate respondsToSelector:@selector(requestDidBecomeUnreachable:)])
    {
        [delegate requestDidBecomeUnreachable:self.request];
    }
    else
    {
        NSError *error = [NSError errorReachability];
        [delegate request:self.request didReceiveError:error];
    }
}

#pragma mark -
#pragma mark properties

- (ABBlockHelper *)blockHelper
{
    if (!blockHelper)
    {
        blockHelper = [[ABBlockHelper alloc] init];
    }
    return blockHelper;
}

#pragma mark -
#pragma mark private

- (void)parseReceivedData:(NSData *)aData
{
    id completionBlock = ^(id parsedResult)
    {
        if (parsedResult)
        {
            [self returnReceivedData:parsedResult];
        }
    };
    [self.blockHelper runParsingBlockWithData:aData completionBlock:completionBlock];
}

- (void)returnReceivedData:(id)aData
{
    self.data = aData;
    if (delegate)
    {
        [delegate request:self.request didReceiveResponse:self.data];
    }
    else if (blockHelper.completeBlock)
    {
        [self.blockHelper runCompleteBlockWithData:self.response response:self.data];
    }
}

@end
