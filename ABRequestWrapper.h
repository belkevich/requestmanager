//
//  RequestWrapper.h
//  NetworkTest
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
    id response;
    NSError *error;
}

@property (nonatomic, readonly) NSURLRequest *request;
@property (nonatomic, assign) NSObject <ABRequestDelegate> *delegate;
@property (nonatomic, retain) id response;
@property (nonatomic, retain) NSError *error;

// initialization
- (id)initWithURLRequest:(NSURLRequest *)aRequest
                delegate:(NSObject <ABRequestDelegate> *)aDelegate;

@end
