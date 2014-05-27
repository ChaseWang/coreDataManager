//
//  SOLCoredataManager+Worker.m
//  CoreDataOptimize
//
//  Created by wangtao on 14-5-26.
//  Copyright (c) 2014年 wangtao. All rights reserved.
//

#import "SOLCoredataManager+Worker.h"

@implementation SOLCoredataManager (Worker)
- (void)saveToPersistence
{
    NSError *error = nil;
    [self.modifyManagedObjectContext save:&error];
    NSAssert(error == nil, @"save context error:%@",error);
}

- (NSManagedObject *)addRecordObjectByName:(NSString *)name;
{
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self.modifyManagedObjectContext];
}

- (void)deleteObject:(NSManagedObject *)object
{
    [self.modifyManagedObjectContext deleteObject:object];
}

- (void)deleteObjectsByClass:(NSString *)name predicate:(NSPredicate *)predicate
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setReturnsObjectsAsFaults:YES];
	[request setIncludesPropertyValues:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:self.modifyManagedObjectContext];
    [request setEntity:entity];

    __block NSArray *objectsToTruncate = nil;
    [self.modifyManagedObjectContext performBlockAndWait:^{
        objectsToTruncate = [self.modifyManagedObjectContext executeFetchRequest:request error:nil];
    }];
    for (id objectToTuncate in objectsToTruncate) {
        [self.modifyManagedObjectContext deleteObject:objectToTuncate];
    }
}

- (NSInteger)countOfObjectByClass:(NSString *)name
{
    NSError *error = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:name inManagedObjectContext:self.queryManagedObjectContext]];
    NSInteger count = [self.queryManagedObjectContext countForFetchRequest:request error:&error];
    NSAssert(error == nil, @"query error %@",error);
    return count;
}

- (NSInteger)countOfObjectByClass:(NSString *)name predicate:(NSPredicate *)predicate
{
    NSError *error = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:name inManagedObjectContext:self.queryManagedObjectContext]];
    [request setPredicate:predicate];
    NSInteger count = [self.queryManagedObjectContext countForFetchRequest:request error:&error];
    NSAssert(error == nil, @"query error %@",error);
    return count;
}

- (NSArray *)objectsOfClass:(NSString *)name
{
    return [self findAllObjectsByClass:name WithPredicate:nil pageSize:0 page:0
                         sortBy:nil ascendings:nil inContext:self.queryManagedObjectContext];
}

- (NSManagedObject *)objectByClass:(NSString *)name predicate:(NSPredicate *)predicate
{
    return [self findAllObjectsByClass:name WithPredicate:predicate pageSize:0 page:0
                                sortBy:nil ascendings:nil inContext:self.queryManagedObjectContext].firstObject;
}

- (NSArray *)objectsByClass:(NSString *)name predicate:(NSPredicate *)predicate
{
    return [self findAllObjectsByClass:name WithPredicate:predicate pageSize:0 page:0
                                sortBy:nil ascendings:nil inContext:self.queryManagedObjectContext];
}

- (NSArray *)objectsByClass:(NSString *)name sortBy:(NSString *)property
                  ascending:(BOOL)ascend predicate:(NSPredicate *)predicate
{
    NSString *ascendStr = ascend ? @"YES" : @"NO";
    return [self findAllObjectsByClass:name WithPredicate:predicate pageSize:0 page:0
                                sortBy:property ascendings:ascendStr inContext:self.queryManagedObjectContext];
}

- (NSArray *)objectsByClass:(NSString *)name predicate:(NSPredicate *)predicate
                       page:(NSInteger)page pageSize:(NSInteger)pageSize
                     sortBy:(NSString *)property ascending:(BOOL)ascending
{
    NSString *ascendStr = ascending ? @"YES" : @"NO";
    return [self findAllObjectsByClass:name WithPredicate:predicate pageSize:pageSize page:page
                                sortBy:property ascendings:ascendStr inContext:self.queryManagedObjectContext];
}

- (NSArray *)objectsByClass:(NSString *)name predicate:(NSPredicate *)predicate
                       page:(NSInteger)page pageSize:(NSInteger)pageSize
                     sortBy:(NSString *)property ascendings:(NSString *)ascendings
{
    return [self findAllObjectsByClass:name WithPredicate:predicate pageSize:pageSize page:page
                                sortBy:property ascendings:ascendings inContext:self.queryManagedObjectContext];
}

- (NSArray *)lastObjectsByClass:(NSString *)name predicate:(NSPredicate *)predicate
                      count:(NSInteger)count sortBy:(NSString *)sortTerm ascendings:(NSString *)ascendings
{
    return nil;
}


- (NSArray *)findAllObjectsByClass:(NSString *)name
                     WithPredicate:(NSPredicate *)predicate
                            pageSize:(NSInteger)pageSize page:(NSInteger)page
                           sortBy:(NSString *)sortTerm
                       ascendings:(NSString *)ascendings
                        inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:name inManagedObjectContext:self.queryManagedObjectContext]];
	[request setPredicate:predicate];
    [request setFetchLimit:pageSize];
    [request setFetchOffset:pageSize *(page - 1)];

    NSMutableArray* sortDescriptors = [[NSMutableArray alloc] init];
    NSArray* sortKeys = [sortTerm componentsSeparatedByString:@","];
    NSArray* sortAscedings = [ascendings componentsSeparatedByString:@","];

    [sortKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BOOL asced = NO;
        if ([[sortAscedings objectAtIndex:idx] isEqual:@"YES"] || [[sortAscedings objectAtIndex:idx] isEqual:@"yes"] ||
            [[sortAscedings objectAtIndex:idx] isEqual:@"Yes"]) {
            asced = YES;
        }
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:obj ascending:asced];
        [sortDescriptors addObject:sortDescriptor];
    }];

    [request setSortDescriptors:sortDescriptors];

	return [self executeFetchRequest:request
                              inContext:context];
}

- (NSArray *)executeFetchRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context
{
    __block NSArray *results = nil;
    [context performBlockAndWait:^{

        NSError *error = nil;

        results = [context executeFetchRequest:request error:&error];

        if (results == nil){
            NSAssert(results != nil, @"results is nil");
        }
    }];
	return results;
}
@end
