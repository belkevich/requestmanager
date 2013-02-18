//
//  RequestWrapper.h
//  Request Manager
//
//  Created by Alexey Belkevich on 12/31/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABRequestDelegate.h"

@interface ABRequestWrapper : NSObject
{
    NSURLRequest *request;
    NSObject <ABRequestDelegate> *delegate;
    NSHTTPURLResponse *httpResponse;
    id receivedResponse;
    NSError *error;
}

@property (nonatomic, readonly) NSURLRequest *request;
@property (nonatomic, readonly) NSHTTPURLResponse *httpResponse;
@property (nonatomic, readonly) id receivedResponse;
@property (nonatomic, readonly) NSError *error;

// initialization
- (id)initWithURLRequest:(NSURLRequest *)aRequest
                delegate:(NSObject <ABRequestDelegate> *)aDelegate;
// actions
- (void)setReceivedResponse:(id)aReceivedResponse httpResponse:(NSHTTPURLResponse *)aHTTPResponse;
- (void)setReceivedError:(NSError *)anError;
- (void)resetDelegate;

@end
