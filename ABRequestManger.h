//
//  ABRequestManager
//  Request Manager
//
//  Created by Alexey Belkevich on 12/30/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABConnectionDelegate.h"

@class ABConnectionHelper;
@class ABRequestWrapper;

@interface ABRequestManager : NSObject <ABConnectionDelegate>
{
    NSMutableArray *queue;
    ABConnectionHelper *helper;
}

// actions
- (void)sendRequest:(ABRequestWrapper *)request;

@end
