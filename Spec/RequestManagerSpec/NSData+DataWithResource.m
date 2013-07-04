//
//  NSData+DataWithResource.m
//  RequestManagerSpec
//
//  Created by Alexey Belkevich on 2/10/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "NSData+DataWithResource.h"

@implementation NSData (DataWithResource)

- (NSData *)initWithResource:(NSString *)resourceName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:resourceName ofType:nil
                                                inDirectory:nil];
    return [self initWithContentsOfFile:path];
}

+ (NSData *)dataWithResource:(NSString *)resourceName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:resourceName ofType:nil
                                                inDirectory:nil];
    return [NSData dataWithContentsOfFile:path];
}

@end
