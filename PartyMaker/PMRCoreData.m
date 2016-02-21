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

#define kPartyEventId            @"eventId"
#define kPartyEventName          @"eventName"
#define kPartyEventDescription   @"eventDescription"
#define kPartyCreatorId          @"creatorId"
#define kPartyStartTime          @"startTime"
#define kPartyEndTime            @"endTime"
#define kPartyImageIndex         @"imageIndex"

#define kUserId         @"userId"
#define kUserName       @"userName"
#define kUserPassword   @"userPassword"
#define kUserEmail      @"userEmail"

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

#pragma mark - Core data implementation

- (void)loadAllPartiesByUserId:(NSNumber *)userId withCallback:(void (^)(NSArray *parties, NSError *completionError))completion {
    __weak PMRCoreData *weakSelf = self;
    [self deleteDublicatesFromMainObjectContextFromEntity:@"Party" withCallback:^(NSError *completionError) {
        NSManagedObjectContext *context = [weakSelf mainManagedObjectContext];
        
        NSFetchRequest *fetch = [NSFetchRequest new];
        fetch.entity = [NSEntityDescription entityForName:@"Party" inManagedObjectContext:context];
        fetch.predicate = [NSPredicate predicateWithFormat:@"creatorId == %@", userId];
        [fetch setReturnsObjectsAsFaults:NO];
        
        NSError *error = nil;
        NSArray *fetchedObjects = [context executeFetchRequest:fetch error:&error];
        if ( error ) {
            NSLog(@"PMRPartyManagedObject pmr_fetchPartyWithName: failed with error %@", error);
        }
        
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(fetchedObjects, error);
            });
        }
    }];
}

- (void)saveParty:(PMRParty *)party withCallback:(void (^)(NSError *completionError))completion{
    NSManagedObjectContext *context = [self backgroundManagedObjectContext];
    NSLog(@"%s --- CALLED SAVED METHOD!!!", __PRETTY_FUNCTION__);
    NSDictionary *partyDictionary = [self pmr_dictionaryOfPartyPropertiesFromParty:party];
 
    [context performBlock:^{
        PMRParty *partyObject = [NSEntityDescription insertNewObjectForEntityForName:@"Party" inManagedObjectContext:context];
        partyObject.eventId = partyDictionary[kPartyEventId];
        partyObject.eventName = partyDictionary[kPartyEventName];
        partyObject.eventDescription = partyDictionary[kPartyEventDescription];
        partyObject.imageIndex = partyDictionary[kPartyImageIndex];
        partyObject.startTime = partyDictionary[kPartyStartTime];
        partyObject.endTime = partyDictionary[kPartyEndTime];
        partyObject.creatorId = partyDictionary[kPartyCreatorId];
        
        NSError *error = nil;
        [context save:&error];
        
        
        if (error) {
            NSLog(@"%s error saving context %@", __PRETTY_FUNCTION__, error);
        }
        
        NSLog(@"%s --- Party was saved", __PRETTY_FUNCTION__);
        
        [self pmr_performCompletionBlock:completion withError:error];
    }];
}

- (void)updateParty:(PMRParty *)party withCallback:(void (^)(NSError *completionError))completion {
    NSDictionary *partyDictionary = [self pmr_dictionaryOfPartyPropertiesFromParty:party];
    
    NSManagedObjectContext *context = [self backgroundManagedObjectContext];
    [context performBlock:^{
        PMRParty *partyObject = [self fetchObjectFromEntity:@"Party" forKey:@"eventId" withValue:partyDictionary[kPartyEventId] inContext:context];
        partyObject.eventName = partyDictionary[kPartyEventName];
        partyObject.eventDescription = partyDictionary[kPartyEventDescription];
        partyObject.imageIndex = partyDictionary[kPartyImageIndex];
        partyObject.startTime = partyDictionary[kPartyStartTime];
        partyObject.endTime = partyDictionary[kPartyEndTime];
        
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
    __weak PMRCoreData *weakSelf = self;
    NSManagedObjectContext *context = [self backgroundManagedObjectContext];
    [context performBlock:^{
        PMRParty *partyObject = [weakSelf fetchObjectFromEntity:@"Party" forKey:@"eventId" withValue:partyId inContext:context];
        
        NSError *error = nil;
        [context deleteObject:partyObject];
        [context save:&error];
        
        [self pmr_performCompletionBlock:completion withError:error];
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
            NSLog(@"%s --- Party was deleted", __PRETTY_FUNCTION__);
            if (error) {
                NSLog(@"%s --- [Error] - %@, user info - %@", __PRETTY_FUNCTION__, error, error.userInfo);
            }
        }
        
        [weakSelf pmr_performCompletionBlock:completion withError:error];
    }];
}

- (void)savePartiesFromArray:(NSArray *)parties withCallback:(void (^)(NSError *completionError))completion {
    __weak PMRCoreData *weakSelf = self;
    NSMutableArray *partyDictionaries = [NSMutableArray new];
    for (PMRParty *party in parties) {
        [partyDictionaries addObject:[self pmr_dictionaryOfPartyPropertiesFromParty:party]];
    }
    NSManagedObjectContext *context = [self backgroundManagedObjectContext];
    [context performBlock:^{
        for (NSDictionary *dictionary in partyDictionaries) {
            PMRParty *partyObject = [NSEntityDescription insertNewObjectForEntityForName:@"Party" inManagedObjectContext:context];
            partyObject.eventId = dictionary[kPartyEventId];
            partyObject.eventName = dictionary[kPartyEventName];
            partyObject.eventDescription = dictionary[kPartyEventDescription];
            partyObject.imageIndex = dictionary[kPartyImageIndex];
            partyObject.startTime = dictionary[kPartyStartTime];
            partyObject.endTime = dictionary[kPartyEndTime];
            partyObject.creatorId = dictionary[kPartyCreatorId];
            
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"%s --- [Error] - %@, user info - %@", __PRETTY_FUNCTION__, error, error.userInfo);
            }
            
            NSLog(@"%s --- Party was saved", __PRETTY_FUNCTION__);
        }
        
        [weakSelf pmr_performCompletionBlock:completion withError:nil];
    }];
}

#pragma mark - User core data implementation 

- (void)saveUser:(PMRUser *)user withCallback:(void (^)(NSError *completionError))completion {
    NSManagedObjectContext *context = [self backgroundManagedObjectContext];
    NSDictionary *userDictionary = [self pmr_dictionaryOfUserPropertiesFromUser:user];
    
    [context performBlock:^{
        PMRUser *userObject = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        userObject.userId = userDictionary[kUserId];
        userObject.name = userDictionary[kUserName];
        userObject.email = userDictionary[kUserEmail];
        
        NSError *error = nil;
        [context save:&error];
        
        
        if (error) {
            NSLog(@"%s error saving context %@", __PRETTY_FUNCTION__, error);
        }
        
        NSLog(@"%s --- Party was saved", __PRETTY_FUNCTION__);
        
        [self pmr_performCompletionBlock:completion withError:error];
    }];
}

- (void)updateUser:(PMRUser *)user withCallback:(void (^)(NSError *completionError))completion {
    NSDictionary *userDictionary = [self pmr_dictionaryOfUserPropertiesFromUser:user];
    
    NSManagedObjectContext *context = [self backgroundManagedObjectContext];
    [context performBlock:^{
        PMRUser *userObject = [self fetchObjectFromEntity:@"User" forKey:@"userId" withValue:userDictionary[kUserId] inContext:context];
        userObject.name = userDictionary[kUserName];
        userObject.email = userDictionary[kUserEmail];
        
        NSError *error = nil;
        if (userObject.hasChanges) {
            [context save:&error];
            if (error) {
                NSLog(@"%s error saving context %@", __PRETTY_FUNCTION__, error);
            }
        }
        
        [self pmr_performCompletionBlock:completion withError:error];
    }];
}

- (void)deleteUser:(NSNumber *)userId withCallback:(void (^)(NSError *completionError))completion {
    __weak PMRCoreData *weakSelf = self;
    NSManagedObjectContext *context = [self backgroundManagedObjectContext];
    [context performBlock:^{
        PMRUser *userObject = [weakSelf fetchObjectFromEntity:@"User" forKey:@"userId" withValue:userId inContext:context];
        
        NSError *error = nil;
        [context deleteObject:userObject];
        [context save:&error];
        
        [self pmr_performCompletionBlock:completion withError:error];
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

- (NSDictionary *)pmr_dictionaryOfPartyPropertiesFromParty:(PMRParty *)party {
    return @{kPartyEventName:[party.eventName copy],
             kPartyEventDescription:[party.eventDescription copy],
             kPartyEventId:[party.eventId copy],
             kPartyStartTime:[party.startTime copy],
             kPartyEndTime:[party.endTime copy],
             kPartyImageIndex:[party.imageIndex copy],
             kPartyCreatorId:[party.creatorId copy]};
}

- (NSDictionary *)pmr_dictionaryOfUserPropertiesFromUser:(PMRUser *)user {
    return @{kUserId:[user.userId copy],
             kUserName:[user.name copy],
             kUserEmail:[user.email copy]};
}

- (void)deleteDublicatesFromMainObjectContextFromEntity:(NSString *)entityName withCallback:(void (^)(NSError *completionError))completion {
    __weak PMRCoreData *weakSelf = self;
    NSManagedObjectContext *context = [self mainManagedObjectContext];
    [context performBlock:^{
        NSFetchRequest *fetch = [NSFetchRequest new];
        fetch.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
        [fetch setReturnsObjectsAsFaults:NO];
        
        NSError *error = nil;
        NSArray *fetchedObjects = [context executeFetchRequest:fetch error:&error];
        if (error) {
            NSLog(@"%s --- failed with error %@", __PRETTY_FUNCTION__, error);
        }
        
        NSMutableArray *arrayForCheckingOnDublicate = [NSMutableArray new];
        BOOL isPartyObjectDublicate = NO;

        for (PMRParty *partyObject in fetchedObjects) {
            isPartyObjectDublicate = NO;
            for (PMRParty *partyFromCheckingArray in arrayForCheckingOnDublicate) {
                if ([partyObject.eventId integerValue] == [partyFromCheckingArray.eventId integerValue]) {
                    isPartyObjectDublicate = YES;
                    break;
                }
            }
            if (isPartyObjectDublicate) {
                NSError *error = nil;
                [context deleteObject:partyObject];
                [context save:&error];
                NSLog(@"%s --- Dublicated %@ was deleted", __PRETTY_FUNCTION__, entityName);
                if (error) {
                    NSLog(@"%s --- [Error] - %@, user info - %@", __PRETTY_FUNCTION__, error, error.userInfo);
                }
            }
            else if (!isPartyObjectDublicate) {
                [arrayForCheckingOnDublicate addObject:partyObject];
            }
        }
        
        [weakSelf pmr_performCompletionBlock:completion withError:error];
    }];
}

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

@end
