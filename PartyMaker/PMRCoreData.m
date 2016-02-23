//
//  PMRDataStorage.m
//  PartyMaker
//
//  Created by 2 on 2/9/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRCoreData.h"
#import "PMRParty.h"
#import "PMRUser.h"

#define kPartyEventId            @"id"
#define kPartyEventName          @"name"
#define kPartyEventDescription   @"comment"
#define kPartyCreatorId          @"creator_id"
#define kPartyStartTime          @"start_time"
#define kPartyEndTime            @"end_time"
#define kPartyImageIndex         @"logo_id"
#define kPartyIsChanged          @"isPartyChahged"
#define kPartyIsDeleted          @"isPartyDeleted"
#define kPartyLatitude           @"latitude"
#define kPartyLongitude          @"longitude"

@interface PMRCoreData()

@property (nonatomic) NSManagedObjectContext *mainThreadContext;
@property (nonatomic) NSManagedObjectContext *backgroundThreadContext;
@property (nonatomic) NSManagedObjectModel *coreDataManagedObjectModel;
@property (nonatomic) NSPersistentStoreCoordinator *coreDataPersistentStoreCoordinator;

@end

@implementation PMRCoreData

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

#pragma mark - Party core data implementation

- (NSArray *)loadAllPartiesByUserId:(NSNumber *)userId {    
    NSManagedObjectContext *context = [self mainManagedObjectContext];
    
    NSFetchRequest *fetch = [NSFetchRequest new];
    fetch.entity = [NSEntityDescription entityForName:@"Party" inManagedObjectContext:context];
    fetch.predicate = [NSPredicate predicateWithFormat:@"creatorId == %@", userId];
    [fetch setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetch error:&error];
    if ( error ) {
        NSLog(@"PMRPartyManagedObject pmr_fetchPartyWithName: failed with error %@", error);
    }
    
    return fetchedObjects;
}

- (void)saveParty:(NSDictionary *)partyDictionary withCallback:(void (^)(NSError *completionError))completion {
    NSManagedObjectContext *context = [self backgroundManagedObjectContext];
    [context performBlock:^{
        PMRParty *partyObject = [NSEntityDescription insertNewObjectForEntityForName:@"Party" inManagedObjectContext:context];
        [self performParty:partyObject FromDictionaty:partyDictionary];
        
        NSError *error = nil;
        [context save:&error];
        
        
        if (error) {
            NSLog(@"%s error saving context %@", __PRETTY_FUNCTION__, error);
        }
        
        NSLog(@"%s --- Party was saved", __PRETTY_FUNCTION__);
        
        [self pmr_performCompletionBlock:completion withError:error];
    }];
}

- (void)updateParty:(NSDictionary *)partyDictionary withCallback:(void (^)(NSError *completionError))completion {
    NSManagedObjectContext *context = [self backgroundManagedObjectContext];
    [context performBlock:^{
        PMRParty *partyObject = [self fetchObjectFromEntity:@"Party" forKey:@"eventId" withValue:partyDictionary[kPartyEventId] inContext:context];
        [self performParty:partyObject FromDictionaty:partyDictionary];
        
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

- (void)deleteParty:(NSNumber *)partyId withCallback:(void (^)(NSError *completionError))completion{
    __block __weak PMRCoreData *weakSelf = self;
    NSManagedObjectContext *context = [self backgroundManagedObjectContext];
    [context performBlock:^{
        
        NSFetchRequest *fetch = [NSFetchRequest new];
        fetch.entity = [NSEntityDescription entityForName:@"Party" inManagedObjectContext:context];
        fetch.predicate = [NSPredicate predicateWithFormat:@"eventId == %@", partyId];
        NSError *fetchError = nil;
        NSArray *fetchedObjects = [context executeFetchRequest:fetch error:&fetchError];
        PMRParty *partyObject = [fetchedObjects firstObject];
        
        NSError *error = nil;
        
        if (partyObject) {
            [context deleteObject:partyObject];
            [context save:&error];
        }
        
        NSLog(@"%s --- Party [%@] was deleted", __PRETTY_FUNCTION__, partyObject.eventName);
        [weakSelf pmr_performCompletionBlock:completion withError:error];
    }];
}

- (void)deleteAllUserPartiesByUserId:(NSNumber *)userId withCallback:(void (^)(NSError *completionError))completion {
    __weak PMRCoreData *weakSelf = self;
    NSManagedObjectContext *context = [self backgroundManagedObjectContext];
    [context performBlock:^{
        NSFetchRequest *fetch = [NSFetchRequest new];
        fetch.entity = [NSEntityDescription entityForName:@"Party" inManagedObjectContext:context];
        fetch.predicate = [NSPredicate predicateWithFormat:@"creatorId == %@", userId];
        
        NSError *error = nil;
        NSArray *fetchedObjects = [context executeFetchRequest:fetch error:&error];
        if (error) {
            NSLog(@"PMRPartyManagedObject pmr_fetchPartyWithName: failed with error %@", error);
        }
        
        for (PMRParty *partyObject in fetchedObjects) {
            NSError *error = nil;
            [context deleteObject:partyObject];
            [context save:&error];
            NSLog(@"%s --- Party [%@] was deleted", __PRETTY_FUNCTION__, partyObject.eventName);
            if (error) {
                NSLog(@"%s --- [Error] - %@, user info - %@", __PRETTY_FUNCTION__, error, error.userInfo);
            }
        }
        
        [weakSelf pmr_performCompletionBlock:completion withError:error];
    }];
}

- (void)saveOrUpadatePartyFromPartyDictionary:(NSDictionary *)partyDictionary inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetch = [NSFetchRequest new];
    fetch.entity = [NSEntityDescription entityForName:@"Party" inManagedObjectContext:context];
    fetch.predicate = [NSPredicate predicateWithFormat:@"eventId == %@", @([partyDictionary[kPartyEventId] integerValue])];
    
    NSError *fetchError = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetch error:&fetchError];
    
    if (fetchError) {
        NSLog(@"%s --- [Error] - %@, user info - %@", __PRETTY_FUNCTION__, fetchError, fetchError.userInfo);
    }
    
    PMRParty *partyObject = [fetchedObjects firstObject];
    
    if (!partyObject) {
        partyObject = [NSEntityDescription insertNewObjectForEntityForName:@"Party" inManagedObjectContext:context];
    }
    
    [self performParty:partyObject FromDictionaty:partyDictionary];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"%s --- [Error] - %@, user info - %@", __PRETTY_FUNCTION__, error, error.userInfo);
    }
    
    NSLog(@"%s --- Party [%@] was saved", __PRETTY_FUNCTION__, partyObject.eventName);
}

- (void)saveOrUpadatePartiesFromArrayOfPartyDictionaries:(NSArray *)partyDictionaries withCallback:(void (^)(NSError *completionError))completion {
    __block __weak PMRCoreData *weakSelf = self;
    NSManagedObjectContext *context = [self backgroundManagedObjectContext];
    [context performBlock:^{
        for (NSDictionary *dictionary in partyDictionaries) {
            [weakSelf saveOrUpadatePartyFromPartyDictionary:dictionary inContext:context];
        }
        [weakSelf pmr_performCompletionBlock:completion withError:nil];
    }];
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

#pragma mark - Helpers

- (id)fetchObjectFromEntity:(NSString *)entityName forKey:(NSString *)key withValue:(NSNumber *)value inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetch = [NSFetchRequest new];
    fetch.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    fetch.predicate = [NSPredicate predicateWithFormat:@"%@ == %@", key, value];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetch error:&error];
    if ( error ) {
        NSLog(@"Fetching failed with error %@", error);
    }
    return [fetchedObjects firstObject];
}

- (void)markPartyAsDeletedByPartyId:(NSNumber *)partyId {
    __block __weak PMRCoreData *weakSelf = self;
    NSManagedObjectContext *context = [self backgroundManagedObjectContext];
    
    [context performBlock:^{
        PMRParty *partyObject = [weakSelf fetchObjectFromEntity:@"Party" forKey:@"eventId" withValue:partyId inContext:context];
        partyObject.isPartyDeleted = @1;
        NSError *error;
        [context save:&error];
        if (error) {
            NSLog(@"%s --- [Core data error] - %@, user info - %@", __PRETTY_FUNCTION__, error, error.userInfo);
        }
    }];
}

- (void)performParty:(PMRParty *)partyObject FromDictionaty:(NSDictionary *)partyDictionary {
    partyObject.eventId = @([partyDictionary[kPartyEventId] integerValue]);
    partyObject.eventName = partyDictionary[kPartyEventName];
    partyObject.eventDescription = partyDictionary[kPartyEventDescription];
    partyObject.imageIndex = @([partyDictionary[kPartyImageIndex] integerValue]);
    partyObject.startTime = @([partyDictionary[kPartyStartTime] integerValue]);
    partyObject.endTime = @([partyDictionary[kPartyEndTime] integerValue]);
    partyObject.creatorId = @([partyDictionary[kPartyCreatorId] integerValue]);
    partyObject.isPartyChanged = @([partyDictionary[kPartyIsChanged] integerValue]);
    partyObject.isPartyDeleted = @([partyDictionary[kPartyIsDeleted] integerValue]);
    partyObject.latitude = partyDictionary[kPartyLatitude];
    partyObject.longitude = partyDictionary[kPartyLongitude];
}

@end
