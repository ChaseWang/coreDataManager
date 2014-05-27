//
//  SOLCoredataManager.m
//  CoreDataOptimize
//
//  Created by wangtao on 14-5-26.
//  Copyright (c) 2014年 wangtao. All rights reserved.
//

#import "SOLCoredataManager.h"

NSString * const kSOLDefaultStoreFileName = @"CoreDataStore.sqlite";

@interface SOLCoredataManager ()
@property (nonatomic, strong)SOLCoredataConfiguration *configuration;
@property (nonatomic, strong)NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong)NSManagedObjectModel *managedObjectModel;
@end

@implementation SOLCoredataManager
@synthesize queryManagedObjectContext = _queryManagedObjectContext;
@synthesize modifyManagedObjectContext = _modifyManagedObjectContext;

- (id)initWithConfiguration:(SOLCoredataConfiguration *)config
{
    self = [super init];
    if (self) {
        self.configuration = config;
    }
    return self;
}

- (id)initWithDefault
{
    self = [super init];
    if (self) {
        self.configuration = nil;
    }
    return self;
}

- (NSManagedObjectContext *)queryManagedObjectContext
{
    @synchronized(self){
        if (_queryManagedObjectContext) {
            return _queryManagedObjectContext;
        }

        NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
        if (coordinator) {
            _queryManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            [_queryManagedObjectContext setPersistentStoreCoordinator: coordinator];
        }
    }

    return _queryManagedObjectContext;
}

- (NSManagedObjectContext *)modifyManagedObjectContext
{
    @synchronized(self){
        if (_modifyManagedObjectContext) {
            return _modifyManagedObjectContext;
        }

        NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
        if (coordinator) {
            _modifyManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            [_modifyManagedObjectContext setPersistentStoreCoordinator: coordinator];
        }
    }
    return _modifyManagedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {

    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }

    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent:[self storeName]]];
	NSError *error;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];

    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:[self autoMigrationOptions] error:&error]) {
		NSLog(@"PersistentStoreCoordinator SetUp Error %@, %@", error, [error userInfo]);
		exit(-1);
    }

    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel {

    if (_managedObjectModel) {
        return _managedObjectModel;
    }

    if (self.configuration.modelName) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[self.configuration.modelName stringByDeletingPathExtension]
                                                         ofType:[self.configuration.modelName pathExtension]];
        NSURL *momURL = [NSURL fileURLWithPath:path];

        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
    }else{
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    
    return _managedObjectModel;
}

- (NSDictionary *)autoMigrationOptions;
{
    if (!self.configuration.isMigrating) {
        return nil;
    }

    NSMutableDictionary *sqliteOptions = [NSMutableDictionary dictionary];
    [sqliteOptions setObject:@"WAL" forKey:@"journal_mode"];

    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             sqliteOptions, NSSQLitePragmasOption,
                             nil];
    return options;
}

- (NSString *)storeName;
{
    if (self.configuration.storageName) {
        return self.configuration.storageName;
    }

    NSString *defaultName = [[[NSBundle mainBundle] infoDictionary] valueForKey:(id)kCFBundleNameKey];
    if (!defaultName){
        defaultName = kSOLDefaultStoreFileName;
    }
    if (![defaultName hasSuffix:@"sqlite"]){
        defaultName = [defaultName stringByAppendingPathExtension:@"sqlite"];
    }

    return defaultName;
}

- (NSString *)applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

@end
