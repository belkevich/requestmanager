//
//  ABRequestWrapper_RequestManager.h
//  RequestManagerSpec
//
//  Created by Alexey Belkevich on 7/9/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "ABRequestWrapper.h"

@interface ABRequestWrapper ()

- (void)setReceivedData:(NSData *)data response:(NSHTTPURLResponse *)response;
- (void)setReceivedError:(NSError *)anError;
- (void)setUnreachable;

@end
