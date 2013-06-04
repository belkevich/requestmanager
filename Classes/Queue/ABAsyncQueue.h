//
//  ABAsyncQueue.h
//  Request Manager
//
//  Created by Alexey Belkevich on 5/30/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef void (^ABAsyncGetBlock)(id object, NSUInteger count);
typedef void (^ABAsyncPutBlock)(NSUInteger count);
typedef void (^ABAsyncRemoveBlock)(NSUInteger index);
typedef BOOL (^ABAsyncPassBlock)(id object);

@interface ABAsyncQueue : NSObject
{
    NSMutableArray *array;
    dispatch_queue_t queue;
}

// actions
- (void)getHeadAsync:(ABAsyncGetBlock)block;
- (void)popHeadAsync:(ABAsyncGetBlock)block;
- (void)putObject:(id)object async:(ABAsyncPutBlock)block;
- (void)removeObject:(id)object async:(ABAsyncRemoveBlock)block;
- (void)removeObjectPassingTest:(ABAsyncPassBlock)test async:(ABAsyncRemoveBlock)block;
- (void)removeAllObjects;

@end