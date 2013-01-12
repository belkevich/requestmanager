//
//  ABConnectionDelegate.h
//  NetworkTest
//
//  Created by Alexey Belkevich on 12/31/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ABConnectionDelegate <NSObject>

- (void)connectionDidFail:(NSError *)error;
- (void)connectionDidReceiveData:(NSData *)receivedData;

@end
