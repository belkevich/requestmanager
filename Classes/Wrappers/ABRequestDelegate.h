//
//  ABRequestDelegate.h
//  Request Manager
//
//  Created by Alexey Belkevich on 12/31/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ABRequestDelegate <NSObject>

@required
- (void)request:(NSURLRequest *)request didReceiveResponse:(id)response;
- (void)request:(NSURLRequest *)request didReceiveError:(NSError *)error;

@end
