//
//  SubjectEntity.h
//  CoreDataOptimize
//
//  Created by wangtao on 14-5-27.
//  Copyright (c) 2014年 wangtao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StudentEntity;

@interface SubjectEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * subid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *student;
@end

@interface SubjectEntity (CoreDataGeneratedAccessors)

- (void)addStudentObject:(StudentEntity *)value;
- (void)removeStudentObject:(StudentEntity *)value;
- (void)addStudent:(NSSet *)values;
- (void)removeStudent:(NSSet *)values;

@end
