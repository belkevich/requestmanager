//
//  ABRequestFactory.m
//  Request Manager
//
//  Created by Alexey Belkevich on 12/31/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import "ABRequestFactory.h"


@implementation ABRequestFactory

+ (id)requestFactory
{
    return [[self alloc] init];
}

#pragma mark -
#pragma mark actions

- (NSMutableURLRequest *)createGETRequest:(NSURL *)requestURL
{
    return [self createRequest:requestURL method:@"GET" data:nil];
}

- (NSMutableURLRequest *)createPOSTRequest:(NSURL *)requestURL data:(NSData *)data
{
    return [self createRequest:requestURL method:@"POST" data:data];
}

- (NSMutableURLRequest *)createPUTRequest:(NSURL *)requestURL data:(NSData *)data
{
    return [self createRequest:requestURL method:@"PUT" data:data];
}

- (NSMutableURLRequest *)createDELETERequest:(NSURL *)requestURL
{
    return [self createRequest:requestURL method:@"DELETE" data:nil];
}

- (NSMutableURLRequest *)createRequest:(NSURL *)requestURL method:(NSString *)method
                                  data:(NSData *)data
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    [request setHTTPMethod:method];
    if (data)
    {
        [request setHTTPBody:data];
    }
    return request;
}

@end
