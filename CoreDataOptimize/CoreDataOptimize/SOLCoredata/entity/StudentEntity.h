//
//  StudentEntity.h
//  CoreDataOptimize
//
//  Created by wangtao on 14-5-27.
//  Copyright (c) 2014年 wangtao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SubjectEntity;

@interface StudentEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * sid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSOrderedSet *subjects;
@end

@interface StudentEntity (CoreDataGeneratedAccessors)

- (void)insertObject:(SubjectEntity *)value inSubjectsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSubjectsAtIndex:(NSUInteger)idx;
- (void)insertSubjects:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSubjectsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSubjectsAtIndex:(NSUInteger)idx withObject:(SubjectEntity *)value;
- (void)replaceSubjectsAtIndexes:(NSIndexSet *)indexes withSubjects:(NSArray *)values;
- (void)addSubjectsObject:(SubjectEntity *)value;
- (void)removeSubjectsObject:(SubjectEntity *)value;
- (void)addSubjects:(NSOrderedSet *)values;
- (void)removeSubjects:(NSOrderedSet *)values;
@end
