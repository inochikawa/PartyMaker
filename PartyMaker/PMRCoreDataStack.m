//
//  PMRCoreDataStack.m
//  PartyMaker
//
//  Created by 2 on 2/28/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRCoreDataStack.h"
#import "PMRPartyManagedObject.h"

@interface PMRCoreDataStack()

@property (nonatomic) NSManagedObjectContext *mainThreadContext;
@property (nonatomic) NSManagedObjectContext *backgroundThreadContext;
@property (nonatomic) NSManagedObjectModel *coreDataManagedObjectModel;
@property (nonatomic) NSPersistentStoreCoordinator *coreDataPersistentStoreCoordinator;

@end

@implementation PMRCoreDataStack

#pragma mark - Core Data stack

- (NSManagedObjectContext *)mainManagedObjectContext {
    if (self.mainThreadContext) {
        return self.mainThreadContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
        self.mainThreadContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [self.mainThreadContext setPersistentStoreCoordinator:coordinator];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applyMainContextChanges:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:self.mainThreadContext];
    
    return self.mainThreadContext;
}

- (NSManagedObjectContext *)backgroundManagedObjectContext {
    if (self.backgroundThreadContext) {
        return self.backgroundThreadContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
        self.backgroundThreadContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [self.backgroundThreadContext setPersistentStoreCoordinator:coordinator];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applyBackgroundContextChanges:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:self.backgroundThreadContext];
    }
    return self.backgroundThreadContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (self.coreDataManagedObjectModel != nil) {
        return self.coreDataManagedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PMRDataModel" withExtension:@"momd"];
    self.coreDataManagedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return self.coreDataManagedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (self.coreDataPersistentStoreCoordinator != nil) {
        return self.coreDataPersistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PMRDataModel.sqlite"];
    NSLog(@"%@", storeURL);
    NSError *error = nil;
    self.coreDataPersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![self.coreDataPersistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error -  [Error] - %@, [User info] - %@", error, [error userInfo]);
        abort();
    }
    
    return self.coreDataPersistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Notification changes

- (void)applyBackgroundContextChanges:(NSNotification *)notification {
    @synchronized (self) {
        [[self mainManagedObjectContext] performBlock:^{
            [[self mainManagedObjectContext] mergeChangesFromContextDidSaveNotification:notification];
        }];
    }
}

- (void)applyMainContextChanges:(NSNotification *)notification {
    @synchronized (self) {
        [[self backgroundManagedObjectContext] performBlock:^{
            [[self backgroundManagedObjectContext] mergeChangesFromContextDidSaveNotification:notification];
        }];
    }
}

@end
