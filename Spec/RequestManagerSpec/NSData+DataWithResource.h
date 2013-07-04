//
//  NSData+DataWithResource.h
//  RequestManagerSpec
//
//  Created by Alexey Belkevich on 2/10/13.
//  Copyright (c) 2013 Okolodev. All rights reserved.
//

@interface NSData (DataWithResource)

- (NSData *)initWithResource:(NSString *)resourceName;
+ (NSData *)dataWithResource:(NSString *)resourceName;

@end
