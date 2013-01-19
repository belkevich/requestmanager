//
//  NSMutableArray+Queue.h
//  Request Manager
//
//  Created by Alexey Belkevich on 12/30/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Queue)

- (id)head;
- (id)headPop;
- (void)headRemove;

@end
