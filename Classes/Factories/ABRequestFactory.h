//
//  ABRequestFactory.h
//  Request Manager
//
//  Created by Alexey Belkevich on 12/31/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABMultitonProtocol.h"

@class ABRequestOptions;

@interface ABRequestFactory : NSObject <ABMultitonProtocol>

@property (nonatomic, retain) ABRequestOptions *options;

// initialization
+ (id)requestFactory;
// actions
- (NSMutableURLRequest *)createGETRequest:(NSString *)path;
- (NSMutableURLRequest *)createPOSTRequest:(NSString *)path body:(NSData *)body;
- (NSMutableURLRequest *)createPUTRequest:(NSString *)path body:(NSData *)body;
- (NSMutableURLRequest *)createDELETERequest:(NSString *)path;
- (NSMutableURLRequest *)createRequest:(NSString *)path method:(NSString *)method
                                  data:(NSData *)data;

@end
