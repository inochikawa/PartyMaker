//
//  PMRDataStorage.m
//  PartyMaker
//
//  Created by 2 on 2/9/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRCoreData.h"
#import "PMRParty.h"

@interface PMRCoreData()

@end

@implementation PMRCoreData

#pragma mark - Core Data stack

- (NSManagedObjectContext *)mainManagedObjectContext {
    if (self.mainManagedObjectContext) {
        return self.mainManagedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
        self.mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [self.mainManagedObjectContext setPersistentStoreCoordinator:coordinator];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applyMainContextChanges:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:self.mainManagedObjectContext];
    
    return self.mainManagedObjectContext;
}

- (NSManagedObjectContext *)backgroundManagedObjectContext {
    if (self.backgroundManagedObjectContext) {
        return self.backgroundManagedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
        self.backgroundManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [self.backgroundManagedObjectContext setPersistentStoreCoordinator:coordinator];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applyBackgroundContextChanges:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:self.backgroundManagedObjectContext];
    }
    return self.backgroundManagedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (self.managedObjectModel != nil) {
        return self.managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PMRDataModel" withExtension:@"momd"];
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return self.managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (self.persistentStoreCoordinator != nil) {
        return self.persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PMRDataModel.sqlite"];
    
    NSError *error = nil;
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error -  [Error] - %@, [User info] - %@", error, [error userInfo]);
        abort();
    }
    
    return self.persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Core data implementation

- (NSArray *)allPartiesInUser:(NSNumber *)userId {
    NSFetchRequest *fetch = [NSFetchRequest new];
    fetch.entity = [NSEntityDescription entityForName:@"Party" inManagedObjectContext:[self mainManagedObjectContext]];
    fetch.predicate = [NSPredicate predicateWithFormat:@"creatorId == %@", userId];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [[self mainManagedObjectContext] executeFetchRequest:fetch error:&error];
    if ( error ) {
        NSLog(@"PMRPartyManagedObject pmr_fetchPartyWithName: failed with error %@", error);
    }
    
    return fetchedObjects;
}

- (void)saveParty:(PMRParty *)party withCallback:(void (^)(NSError *completionError))completion{
    NSManagedObjectContext *context = [self backgroundManagedObjectContext];
    [context performBlock:^{
        PMRParty *partyObject = [NSEntityDescription insertNewObjectForEntityForName:@"Party" inManagedObjectContext:context];
        partyObject.eventId = party.eventId;
        partyObject.eventName = party.eventName;
        partyObject.eventDescription = party.eventDescription;
        partyObject.imageIndex = party.imageIndex;
        partyObject.startTime = party.startTime;
        partyObject.endTime = party.endTime;
        
        NSError *error = nil;
        [context save:&error];
        
        if (error) {
            NSLog(@"%s error saving context %@", __PRETTY_FUNCTION__, error);
        }
        
        [self pmr_performCompletionBlock:completion withError:error];
    }];
}

- (void)updateParty:(PMRParty *)party withCallback:(void (^)(NSError *completionError))completion{
    NSManagedObjectContext *context = [self backgroundManagedObjectContext];
    [context performBlock:^{
        PMRParty *partyObject = [self fetchPartyByPartyId:party.eventId inContext:[self backgroundManagedObjectContext]];
        partyObject.eventName = party.eventName;
        partyObject.eventDescription = party.eventDescription;
        partyObject.imageIndex = party.imageIndex;
        partyObject.startTime = party.startTime;
        partyObject.endTime = party.endTime;
        
        NSError *error = nil;
        if (partyObject.hasChanges) {
            [context save:&error];
            if (error) {
                NSLog(@"%s error saving context %@", __PRETTY_FUNCTION__, error);
            }
        }

        [self pmr_performCompletionBlock:completion withError:error];
    }];
}

- (void)deleteParty:(PMRParty *)party withCallback:(void (^)(NSError *completionError))completion{
    NSManagedObjectContext *context = [self backgroundManagedObjectContext];
    [context performBlock:^{
        PMRParty *partyObject = [self fetchPartyByPartyId:party.eventId inContext:[self backgroundManagedObjectContext]];
        
        NSError *error = nil;
        [context deleteObject:partyObject];
        [context save:&error];
        
        [self pmr_performCompletionBlock:completion withError:error];
    }];
}

- (PMRParty *)fetchPartyByPartyId:(NSNumber *)partyId inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetch = [NSFetchRequest new];
    fetch.entity = [NSEntityDescription entityForName:@"Party" inManagedObjectContext:context];
    fetch.predicate = [NSPredicate predicateWithFormat:@"eventId == %@", partyId];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [[self mainManagedObjectContext] executeFetchRequest:fetch error:&error];
    if ( error ) {
        NSLog(@"PMRPartyManagedObject pmr_fetchPartyWithName: failed with error %@", error);
    }
    return [fetchedObjects firstObject];
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

#pragma mark - Perform completion block

- (void)pmr_performCompletionBlock:(void (^) (NSError *completionError))block withError:(NSError *)error{
    if (block) {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(error);
        });
    }
}

@end
