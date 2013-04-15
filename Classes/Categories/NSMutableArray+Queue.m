//
//  NSMutableArray+Queue.m
//  Request Manager
//
//  Created by Alexey Belkevich on 12/30/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import "NSMutableArray+Queue.h"

@implementation NSMutableArray (Queue)

- (id)head
{
    return self.count > 0 ? [self objectAtIndex:0] : nil;
}

- (id)headPop
{
    NSObject *head = [self head];
    if (head)
    {
        [head retain];
        [head autorelease];
        [self removeObject:head];
    }
    return head;
}

@end
