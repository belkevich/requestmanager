//
//  NSError+Reachability.m
//  Request Manager
//
//  Created by Alexey Belkevich on 4/23/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//


#import "NSError+Reachability.h"

const NSString *kErrorReachabilityDomain = @"Internet reachability";
const NSString *kErrorReachabilityDescription = @"Host is not reachable";
const NSUInteger kErrorReachabilityCode = 101;

@implementation NSError (Reachability)

+ (NSError *)errorReachability
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:kErrorReachabilityDescription
                                                         forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:kErrorReachabilityDomain code:kErrorReachabilityCode
                           userInfo:userInfo];
}

- (BOOL)isReachabilityError
{
    return (self.code == kErrorReachabilityCode &&
            [self.domain isEqualToString:(NSString *)kErrorReachabilityDomain]);
}


@end