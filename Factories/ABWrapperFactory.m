//
//  ABWrapperFactory.m
//  NetworkTest
//
//  Created by Alexey Belkevich on 12/31/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import "ABWrapperFactory.h"
#import "ABRequestWrapper.h"
#import "NSURL+Host.h"

@interface ABWrapperFactory ()
- (NSURL *)fullURLWithPath:(NSString *)path;
@end

@implementation ABWrapperFactory

@synthesize host;

#pragma mark -
#pragma mark main routine

- (void)dealloc
{
    [host release];
    [super dealloc];
}

#pragma mark -
#pragma mark actions

- (ABRequestWrapper *)wrapperWithPath:(NSString *)path
                             delegate:(NSObject <ABRequestDelegate> *)delegate
{
    NSURL *fullURL = [self fullURLWithPath:path];
    return [self wrapperWithURL:fullURL delegate:delegate];
}

- (ABRequestWrapper *)wrapperWithURL:(NSURL *)url
                            delegate:(NSObject <ABRequestDelegate> *)delegate
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    ABRequestWrapper *wrapper = [[ABRequestWrapper alloc] initWithURLRequest:request
                                                                    delegate:delegate];
    [request release];
    return [wrapper autorelease];
}

#pragma mark -
#pragma mark private

- (NSURL *)fullURLWithPath:(NSString *)path
{
    return host ? [NSURL URLWithHost:host path:path] : [NSURL URLWithFullPath:path];
}

@end
