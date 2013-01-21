//
//  ABWrapperFactory.m
//  Request Manager
//
//  Created by Alexey Belkevich on 12/31/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import "ABWrapperFactory.h"
#import "ABMultiton.h"
#import "ABRequestWrapper.h"
#import "NSURL+Host.h"


@implementation ABWrapperFactory

#pragma mark -
#pragma mark singleton protocol implementation

+ (instancetype)sharedInstance
{
    return [ABMultiton sharedInstanceOfClass:[self class]];
}

#pragma mark -
#pragma mark actions

- (ABRequestWrapper *)wrapperWithPath:(NSString *)path
                             delegate:(NSObject <ABRequestDelegate> *)delegate
{
    NSURL *pathURL = [NSURL URLWithString:path];
    return [self wrapperWithURL:pathURL delegate:delegate];
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

@end
