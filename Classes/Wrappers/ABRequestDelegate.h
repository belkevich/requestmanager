//
//  ABRequestDelegate.h
//  Request Manager
//
//  Created by Alexey Belkevich on 12/31/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ABRequestWrapper;

@protocol ABRequestDelegate <NSObject>

@required
- (void)wrapper:(ABRequestWrapper *)wrapper didReceiveResponse:(id)response;

@optional
- (void)wrapper:(ABRequestWrapper *)wrapper didReceiveError:(NSError *)error;
- (void)wrapperDidBecomeUnreachable:(ABRequestWrapper *)wrapper;

@end
