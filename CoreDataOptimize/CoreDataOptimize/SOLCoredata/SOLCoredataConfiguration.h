//
//  SOLCoredataSetupConfiguration.h
//  CoreDataOptimize
//
//  Created by wangtao on 14-5-26.
//  Copyright (c) 2014年 wangtao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOLCoredataConfiguration : NSObject
@property (nonatomic, assign)BOOL isMigrating;
@property (nonatomic, copy)NSString *storageName;
@property (nonatomic, copy)NSString *modelName;
@end
