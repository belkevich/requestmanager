//
//  ABWrapperDelegate.h
//  Request Manager
//
//  Created by Alexey Belkevich on 5/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ABRequestWrapper;

@protocol ABWrapperDelegate <NSObject>

@required
- (void)requestWrapper:(ABRequestWrapper *)wrapper didFinish:(id)result;
- (void)requestWrapper:(ABRequestWrapper *)wrapper didFail:(NSError *)error;

@optional
- (void)requestWrapperDidBecomeUnreachable:(ABRequestWrapper *)wrapper;

@end