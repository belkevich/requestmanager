//
//  NSError+Reachability.m
//  RequestManagerApp
//
//  Created by Alexey Belkevich on 1/21/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "NSError+Reachability.h"

@implementation NSError (Reachability)

+ (id)errorReachabilityLost
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Connection lost"
                                                         forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:@"SCNetworkReachability" code:101 userInfo:userInfo];
}

@end
