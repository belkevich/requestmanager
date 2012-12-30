//
//  NSURL+Host.m
//  NetworkTest
//
//  Created by Alexey Belkevich on 12/31/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import "NSURL+Host.h"

@implementation NSURL (Host)

+ (id)URLWithFullPath:(NSString *)path
{
    NSString *string = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [self URLWithString:string];
}

+ (id)URLWithHost:(NSString *)host path:(NSString *)path
{
    NSString *string = [host stringByAppendingPathComponent:path];
    return [self URLWithFullPath:string];
}

@end
