//
//  RequestWrapper.m
//  Request Manager
//
//  Created by Alexey Belkevich on 12/31/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import "ABRequestWrapper.h"

@interface ABRequestWrapper ()
- (void)parseReceivedData:(NSData *)data;
@end

@implementation ABRequestWrapper

@synthesize request, httpResponse, receivedResponse, error;

#pragma mark -
#pragma mark main routine

- (id)initWithURLRequest:(NSURLRequest *)aRequest
{
    self = [super init];
    if (self)
    {
        request = [aRequest retain];
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
    [request release];
    [httpResponse release];
    [receivedResponse release];
    [error release];
    [parsingHelper release];
    [super dealloc];
}

#pragma mark -
#pragma mark parsing block

- (void)setParsingBlock:(ABParsingBlock)parsingBlock
{
    if (!parsingHelper)
    {
        parsingHelper = [[ABParsingHelper alloc] init];
    }
    parsingHelper.parsingBlock = parsingBlock;
}

#pragma mark -
#pragma mark actions

- (void)setReceivedResponse:(NSData *)aReceivedResponse
               httpResponse:(NSHTTPURLResponse *)aHTTPResponse
{
    [receivedResponse release];
    [httpResponse release];
    receivedResponse = [aReceivedResponse retain];
    httpResponse = [aHTTPResponse retain];
    parsingHelper ? [self parseReceivedData:aReceivedResponse]:
    [delegate wrapper:self didReceiveResponse:receivedResponse];
}

- (void)setReceivedError:(NSError *)anError
{
    [error release];
    error = [anError retain];
    [delegate wrapper:self didReceiveError:error];
}

- (void)setUnreachable
{
    [delegate wrapperDidBecomeUnreachable:self];
}

- (void)resetDelegate
{
    delegate = nil;
}

#pragma mark -
#pragma mark private

- (void)parseReceivedData:(NSData *)data
{
    id completionBlock = ^(id parsedResult) {
        if (parsedResult)
        {
            [receivedResponse release];
            receivedResponse = [parsedResult retain];
            [delegate wrapper:self didReceiveResponse:receivedResponse];
        }
    };
    [parsingHelper runParsingBlockWithData:data completionBlock:completionBlock];
}

@end
