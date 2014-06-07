//
//  DataManager.m
//  HousekeepingBook
//
//  Created by 川端伸彦 on 2014/06/05.
//  Copyright (c) 2014年 mikke. All rights reserved.
//

#import "DataManager.h"

@interface DataManager()
@property(readwrite, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(readwrite, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property(readwrite, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@end




@implementation DataManager

+ (instancetype)sharedManager
{
    static id manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if(!_managedObjectContext)
    {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if(!_managedObjectModel)
    {
        NSURL *modelURl = [[NSBundle mainBundle] URLForResource:@"HousekeepingBook" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURl];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if(!_persistentStoreCoordinator)
    {
        NSURL *directoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *storeURL = [directoryURL URLByAppendingPathComponent:@"coredata.sqlite"];
        
        NSError *erro = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    }
    return _persistentStoreCoordinator;
}





@end
