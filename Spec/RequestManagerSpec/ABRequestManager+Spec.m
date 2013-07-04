//
//  ABRequestManager+Spec.m
//  RequestManagerSpec
//
//  Created by Alexey Belkevich on 1/26/13.
//  Copyright (c) 2013 Okolodev. All rights reserved.
//

#import "ABRequestManager+Spec.h"

@implementation ABRequestManager (Spec)

- (NSMutableArray *)queue
{
    return queue;
}

- (ABConnectionHelper *)connection
{
    return connection;
}

- (void)setConnection:(ABConnectionHelper *)aConnection
{
    [connection release];
    connection = [aConnection retain];
}

@end
