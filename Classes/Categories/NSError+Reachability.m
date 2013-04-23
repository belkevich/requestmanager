//
//  NSError+Reachability.m
//  Request Manager
//
//  Created by Alexey Belkevich on 4/23/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//


#import "NSError+Reachability.h"

@implementation NSError (Reachability)

+ (NSError *)errorReachability
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Host is not reachable"
                                                         forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:@"Internet reachability" code:101 userInfo:userInfo];
}


@end