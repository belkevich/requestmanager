//
//  ABRequestManager+Spec.h
//  RequestManagerSpec
//
//  Created by Alexey Belkevich on 1/26/13.
//  Copyright (c) 2013 Okolodev. All rights reserved.
//

#import "ABRequestManager_Spec.h"
#import "SCNetworkReachability.h"

@interface ABRequestManager (Spec)

@property (nonatomic, readonly) NSMutableArray *queue;
@property (nonatomic, retain) ABConnectionHelper *connection;

@end
