//
//  ABWrapperFactory.h
//  NetworkTest
//
//  Created by Alexey Belkevich on 12/31/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABRequestDelegate.h"

@class ABRequestWrapper;

@interface ABWrapperFactory : NSObject
{
    NSString *host;
}

@property (nonatomic, retain) NSString *host;

// actions
- (ABRequestWrapper *)wrapperWithPath:(NSString *)path
                             delegate:(NSObject <ABRequestDelegate> *)delegate;
- (ABRequestWrapper *)wrapperWithURL:(NSURL *)url
                            delegate:(NSObject <ABRequestDelegate> *)delegate;

@end
