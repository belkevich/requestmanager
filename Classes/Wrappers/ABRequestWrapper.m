//
//  RequestWrapper.m
//  Request Manager
//
//  Created by Alexey Belkevich on 12/31/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import "ABRequestWrapper.h"

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
    [super dealloc];
}

#pragma mark -
#pragma mark actions

- (void)setReceivedResponse:(id)aReceivedResponse httpResponse:(NSHTTPURLResponse *)aHTTPResponse
{
    [receivedResponse release];
    [httpResponse release];
    receivedResponse = [aReceivedResponse retain];
    httpResponse = [aHTTPResponse retain];
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

@end
