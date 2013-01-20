//
//  ABRequestOptions.h
//  RequestManagerApp
//
//  Created by Alexey Belkevich on 1/20/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABSingletonProtocol.h"

typedef enum
{
    ABConnectionLostActionWait = 0,
    ABConnectionLostActionClean = 1
}
ABConnectionLostAction;

@interface ABRequestOptions : NSObject <ABSingletonProtocol>
{
    NSString *baseHost;
    BOOL isWiFiOnly;
    ABConnectionLostAction connectionLostAction;
}

@property (nonatomic, retain) NSString *baseHost;
@property (nonatomic, assign) BOOL isWiFiOnly;
@property (nonatomic, assign) ABConnectionLostAction connectionLostAction;

@end
