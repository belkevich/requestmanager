//
//  RequestWrapper.m
//  NetworkTest
//
//  Created by Alexey Belkevich on 12/31/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import "ABRequestWrapper.h"

@implementation ABRequestWrapper

@synthesize request, delegate;

#pragma mark -
#pragma mark main routine

- (id)initWithURLRequest:(NSURLRequest *)aRequest
                delegate:(NSObject <ABRequestDelegate> *)aDelegate
{
    self = [super init];
    if (self)
    {
        request = [aRequest retain];
        delegate = aDelegate;
    }
    return self;
}

- (void)dealloc
{
    [request release];
    [response release];
    [error release];
    [super dealloc];
}

#pragma mark -
#pragma mark dynamic properties

@dynamic response, error;

- (id)response
{
    return response;
}

- (NSError *)error
{
    return error;
}

- (void)setResponse:(id)aResponse
{
    [response release];
    response = [aResponse retain];
    [delegate wrapper:self didReceiveResponse:response];
}

- (void)setError:(NSError *)anError
{
    [error release];
    error = [anError retain];
    if ([delegate respondsToSelector:@selector(wrapper:didReceiveError:)])
    {
        [delegate wrapper:self didReceiveError:error];
    }
}


@end
