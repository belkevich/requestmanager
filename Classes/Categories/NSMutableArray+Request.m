//
//  NSMutableArray+Request.m
//  Request Manager
//
//  Created by Alexey Belkevich on 6/4/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//


#import "NSMutableArray+Request.h"
#import "ABRequestWrapper.h"

@implementation NSMutableArray (Request)

- (void)removeWrapper:(ABRequestWrapper *)wrapper isFirst:(BOOL *)isFirst
{
    NSUInteger index = [self indexOfObject:wrapper];
    [self removeObject:wrapper];
    if (isFirst != NULL)
    {
        *isFirst = (index == 0);
    }
}

- (void)removeRequest:(NSURLRequest *)request isFirst:(BOOL *)isFirst
{
    NSIndexSet *indexSet = [self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx,
                                                                   BOOL *stop)
    {
        ABRequestWrapper *wrapper = obj;
        return ([wrapper.request isEqual:request]);
    }];
    [self removeObjectsAtIndexes:indexSet];
    if (isFirst != NULL)
    {
        *isFirst = ([indexSet containsIndex:0]);
    }
}


@end