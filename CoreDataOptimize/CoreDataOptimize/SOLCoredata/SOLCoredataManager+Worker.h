//
//  SOLCoredataManager+Worker.h
//  CoreDataOptimize
//
//  Created by wangtao on 14-5-26.
//  Copyright (c) 2014年 wangtao. All rights reserved.
//

#import "SOLCoredataManager.h"

@interface SOLCoredataManager (Worker)
- (void)saveToPersistence;

//add object
- (NSManagedObject *)addRecordObjectByName:(NSString *)name;

//delete object
- (void)deleteObject:(NSManagedObject *)object;
- (void)deleteObjectsByClass:(NSString *)name predicate:(NSPredicate *)predicate;

//query object
- (NSInteger)countOfObjectByClass:(NSString *)name;
- (NSInteger)countOfObjectByClass:(NSString *)name predicate:(NSPredicate *)predicate;

- (NSArray *)objectsOfClass:(NSString *)name;
- (NSManagedObject *)objectByClass:(NSString *)name predicate:(NSPredicate *)predicate;
- (NSArray *)objectsByClass:(NSString *)name predicate:(NSPredicate *)predicate;

- (NSArray *)objectsByClass:(NSString *)name sortBy:(NSString *)property ascending:(BOOL)ascend predicate:(NSPredicate *)predicate;
- (NSArray *)objectsByClass:(NSString *)name predicate:(NSPredicate *)searchTerm page:(NSInteger)page pageSize:(NSInteger)pageSize sortBy:(NSString *)sortTerm ascending:(BOOL)ascending;

- (NSArray *)objectsByClass:(NSString *)name predicate:(NSPredicate *)searchTerm page:(NSInteger)page pageSize:(NSInteger)pageSize sortBy:(NSString *)sortTerm ascendings:(NSString *)ascendings;
- (NSArray *)lastObjectsByClass:(NSString *)name predicate:(NSPredicate *)searchTerm count:(NSInteger)count sortBy:(NSString *)sortTerm ascendings:(NSString *)ascendings;
@end
