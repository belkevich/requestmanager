//
//  NSURL+Host.h
//  NetworkTest
//
//  Created by Alexey Belkevich on 12/31/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Host)

+ (id)URLWithFullPath:(NSString *)path;
+ (id)URLWithHost:(NSString *)host path:(NSString *)path;

@end
