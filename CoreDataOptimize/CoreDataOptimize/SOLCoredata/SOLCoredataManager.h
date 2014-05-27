//
//  SOLCoredataManager.h
//  CoreDataOptimize
//
//  Created by wangtao on 14-5-26.
//  Copyright (c) 2014年 wangtao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SOLCoredataConfiguration.h"

@interface SOLCoredataManager : NSObject
- (id)initWithConfiguration:(SOLCoredataConfiguration *)config;
- (id)initWithDefault;

@property (nonatomic, readonly)NSManagedObjectContext *queryManagedObjectContext;
@property (nonatomic, readonly)NSManagedObjectContext *modifyManagedObjectContext;
@end
