//
//  ABRequestManager+Spec.h
//  RequestManagerSpec
//
//  Created by Alexey Belkevich on 1/26/13.
//  Copyright (c) 2013 Okolodev. All rights reserved.
//

#import "ABRequestManager.h"
#import "SCNetworkReachability.h"

@interface ABRequestManager (Spec) <SCNetworkReachabilityDelegate>

@property (nonatomic, readonly) NSMutableArray *queue;
@property (nonatomic, retain) ABConnectionHelper *connection;
@property (nonatomic, retain) SCNetworkReachability *reachability;

@end
