//
//  ABAsyncQueue.m
//  Request Manager
//
//  Created by Alexey Belkevich on 5/30/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//


#import "ABAsyncQueue.h"

@interface ABAsyncQueue ()

- (void)getHeadObjectAsync:(ABAsyncGetBlock)block remove:(BOOL)remove;

@end

@implementation ABAsyncQueue

#pragma mark -
#pragma mark main routine

- (id)init
{
    self = [super init];
    if (self)
    {
        array = [[NSMutableArray alloc] init];
        NSString *name = [NSString stringWithFormat:@"%d.org.okolodev.asyncqueue", self.hash];
        queue = dispatch_queue_create([name cStringUsingEncoding:NSASCIIStringEncoding], NULL);
    }
    return self;
}

- (void)dealloc
{
#if !OS_OBJECT_USE_OBJC
    dispatch_release(queue);
#endif
}

#pragma mark -
#pragma mark actions

- (void)getHeadAsync:(ABAsyncGetBlock)block
{
    [self getHeadObjectAsync:block remove:NO];
}

- (void)popHeadAsync:(ABAsyncGetBlock)block
{
    [self getHeadObjectAsync:block remove:YES];
}

- (void)putObject:(id)object async:(ABAsyncPutBlock)block
{
    dispatch_async(queue, ^
    {
        [array addObject:object];
        if (block)
        {
            block(array.count);
        }
    });
}

- (void)removeObject:(id)object async:(ABAsyncRemoveBlock)block
{
    dispatch_async(queue, ^
    {
        NSUInteger index = [array indexOfObject:object];
        if (index != NSNotFound)
        {
            [array removeObject:object];
            if (block)
            {
                block(array.count);
            }
        }
    });
}

- (void)removeObjectPassingTest:(ABAsyncPassBlock)test async:(ABAsyncRemoveBlock)block
{
    dispatch_async(queue, ^
    {
        if (test)
        {
            NSIndexSet *indexSet = [array indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx,
                                                                            BOOL *stop)
            {
                return test(obj);
            }];
            if (block)
        }
    });
}

- (void)removeAllObjects
{
    dispatch_async(queue, ^
    {
        [array removeAllObjects];
    });
}

#pragma mark -
#pragma mark private

- (void)getHeadObjectAsync:(ABAsyncGetBlock)block remove:(BOOL)remove
{
    dispatch_async(queue, ^
    {
        id object = nil;
        if (array.count > 0)
        {
            object = [array objectAtIndex:0];
            if (remove)
            {
                [array removeObject:object];
            }
        }
        if (block)
        {
            block(object, array.count);
        }
    });
}

@end