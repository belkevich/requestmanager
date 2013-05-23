//
//  ABWrapperBlocks.h
//  Request Manager
//
//  Created by Alexey Belkevich on 5/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ABRequestWrapper;

typedef void (^ABWrapperCompletedBlock)(ABRequestWrapper *wrapper, id result);
typedef void (^ABWrapperFailedBlock)(ABRequestWrapper *wrapper, BOOL isUnreachable);
typedef id (^ABWrapperDataParsingBlock)(ABRequestWrapper *wrapper);
