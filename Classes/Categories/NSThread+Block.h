//
//  NSThread+Block.h
//  Request Manager
//
//  Created by Alexey Belkevich on 5/30/13.
//  Copyright (c) 2013 Okolodev. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSThread (Block)

+ (void)performBlock:(void(^)())block onThread:(NSThread *)thread;

@end