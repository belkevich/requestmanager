//
//  ABRequestFactory.h
//  Request Manager
//
//  Created by Alexey Belkevich on 12/31/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ABRequestFactory : NSObject

// initialization
+ (id)requestFactory;
// actions
- (NSMutableURLRequest *)createGETRequest:(NSURL *)requestURL;
- (NSMutableURLRequest *)createPOSTRequest:(NSURL *)requestURL data:(NSData *)data;
- (NSMutableURLRequest *)createPUTRequest:(NSURL *)requestURL data:(NSData *)data;
- (NSMutableURLRequest *)createDELETERequest:(NSURL *)requestURL;
- (NSMutableURLRequest *)createRequest:(NSURL *)requestURL method:(NSString *)method
                                  data:(NSData *)data;


@end
