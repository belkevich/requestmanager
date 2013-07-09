//
//  ABRequestManager_Spec.h
//  RequestManagerSpec
//
//  Created by Alexey Belkevich on 7/9/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "ABRequestManager.h"
#import "SCNetworkReachability.h"

@interface ABRequestManager () <SCNetworkReachabilityDelegate>

@property (nonatomic, retain) SCNetworkReachability *reachability;

@end
