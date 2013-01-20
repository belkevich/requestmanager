//
//  ABReachabilityDelegate.h
//  Request Manager
//
//  Created by Alexey Belkevich on 1/20/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ABReachabilityDelegate <NSObject>

- (void)reachabilityDidChange:(BOOL)reachable;

@end
