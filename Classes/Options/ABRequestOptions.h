//
//  ABRequestOptions.h
//  RequestManager
//
//  Created by Alexey Belkevich on 6/28/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABRequestOptions : NSObject

@property (nonatomic, strong) NSString *basePath;
@property (nonatomic, assign) BOOL cookies;
@property (nonatomic, assign) NSTimeInterval timeout;
@property (nonatomic, assign) NSURLRequestCachePolicy cache;
@property (nonatomic, strong) NSDictionary *headers;

@end