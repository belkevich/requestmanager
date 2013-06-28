//
//  ABRequestFactory.m
//  Request Manager
//
//  Created by Alexey Belkevich on 12/31/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import "ABRequestFactory.h"
#import "ABMultiton.h"
#import "ABRequestOptions.h"


@implementation ABRequestFactory

+ (id)requestFactory
{
    return [[self alloc] init];
}

#pragma mark -
#pragma mark multiton protocol implementation

+ (instancetype)sharedInstance
{
    return [ABMultiton sharedInstanceOfClass:[self class]];
}

#pragma mark -
#pragma mark actions

- (NSMutableURLRequest *)createGETRequest:(NSString *)path
{
    return [self createRequest:path method:@"GET" data:nil];
}

- (NSMutableURLRequest *)createPOSTRequest:(NSString *)path body:(NSData *)body
{
    return [self createRequest:path method:@"POST" data:body];
}

- (NSMutableURLRequest *)createPUTRequest:(NSString *)path body:(NSData *)body
{
    return [self createRequest:path method:@"PUT" data:body];
}

- (NSMutableURLRequest *)createDELETERequest:(NSString *)path
{
    return [self createRequest:path method:@"DELETE" data:nil];
}

- (NSMutableURLRequest *)createRequest:(NSString *)path method:(NSString *)method
                                  data:(NSData *)data
{
    NSURL *pathURL = [self requestURLWithPath:path];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:pathURL];
    [request setHTTPMethod:method];
    if (data)
    {
        [request setHTTPBody:data];
    }
    [self applyOptionsToRequest:request];
    return request;
}

#pragma mark -
#pragma mark private

- (NSURL *)requestURLWithPath:(NSString *)path
{
    path = [self requestFullPathWithPath:path];
    NSURL *url = [NSURL URLWithString:path];
    if (!url)
    {
        NSString *reason = [NSString stringWithFormat:@"Can't create URL with path\n%@", path];
        @throw [NSException exceptionWithName:@"Invalid URL" reason:reason userInfo:nil];
    }
    return url;
}

- (NSString *)requestFullPathWithPath:(NSString *)path
{
    if (self.options.basePath)
    {
        path = [self.options.basePath stringByAppendingString:path];
    }
    return [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)applyOptionsToRequest:(NSMutableURLRequest *)request
{
    if (self.options)
    {
        [request setHTTPShouldHandleCookies:self.options.cookies];
        request.timeoutInterval = self.options.timeout;
        request.cachePolicy = self.options.cache;
        if (self.options.headers)
        {
            [request setAllHTTPHeaderFields:self.options.headers];
        }
    }
}

@end
