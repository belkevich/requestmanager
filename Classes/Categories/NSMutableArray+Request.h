//
//  NSMutableArray+Request.h
//  Request Manager
//
//  Created by Alexey Belkevich on 6/4/13.
//  Copyright (c) 2013 Okolodev. All rights reserved.
//


#import <Foundation/Foundation.h>

@class ABRequestWrapper;

@interface NSMutableArray (Request)

- (void)removeWrapper:(ABRequestWrapper *)wrapper isFirst:(BOOL *)isFirst;
- (void)removeRequest:(NSURLRequest *)request isFirst:(BOOL *)isFirst;

@end