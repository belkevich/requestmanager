//
//  ABConnectionHelper.h
//  Request Manager
//
//  Created by Alexey Belkevich on 12/30/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABConnectionDelegate.h"

@interface ABConnectionHelper : NSObject <NSURLConnectionDelegate>
{
    NSObject <ABConnectionDelegate> *delegate;
    NSURLRequest *request;
    NSURLConnection *connection;
    NSHTTPURLResponse *receivedResponse;
    NSMutableData *receivedData;
}

// initialization
- (id)initWithRequest:(NSURLRequest *)aRequest
             delegate:(NSObject <ABConnectionDelegate> *)aDelegate;
// actions
- (void)start;
- (void)stop;

@end
