//
//  PMRDataStorage.m
//  PartyMaker
//
//  Created by 2 on 2/9/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRCoreData.h"
#import "PMRParty.h"
#import "PMRCoreDataStack.h"
#import "PMRPartyManagedObject.h"

@interface PMRCoreData()

@end

@implementation PMRCoreData

#pragma mark - Party core data implementation

- (NSArray *)loadAllPartiesByUserId:(NSInteger)userId {
    NSManagedObjectContext *context = [self.coreDataStack mainManagedObjectContext];
    NSArray *fetchedObjects = [self fetchAllPartiesByUserId:userId fromContext:context];
    NSMutableArray *parties = [NSMutableArray new];
    
    for (PMRPartyManagedObject *partyObject in fetchedObjects) {
        PMRParty *party = [[PMRParty alloc] initUsingPartyObject:partyObject];
        [parties addObject:party];
    }
    
    return parties;
}

- (void)deleteParty:(NSInteger)partyId withCallback:(void (^)(NSError *completionError))completion{
    __block __weak PMRCoreData *weakSelf = self;
    NSManagedObjectContext *context = [self.coreDataStack backgroundManagedObjectContext];
    [context performBlock:^{
        PMRPartyManagedObject *partyObject = [PMRPartyManagedObject fetchFromContext:context withPartyId:partyId];
        
        NSError *error = nil;
        
        if (partyObject) {
            [context deleteObject:partyObject];
            [context save:&error];
        }
        
        NSLog(@"%s --- Party [%@] was deleted", __PRETTY_FUNCTION__, partyObject.eventName);
        [weakSelf performCompletionBlock:completion withError:error];
    }];
}

- (void)deleteAllUserPartiesByUserId:(NSInteger)userId withCallback:(void (^)(NSError *completionError))completion {
    __weak PMRCoreData *weakSelf = self;
    NSManagedObjectContext *context = [self.coreDataStack backgroundManagedObjectContext];
    [context performBlock:^{
        NSArray *fetchedObjects = [self fetchAllPartiesByUserId:userId fromContext:context];
        
        for (PMRPartyManagedObject *partyObject in fetchedObjects) {
            NSError *error = nil;
            [context deleteObject:partyObject];
            [context save:&error];
            NSLog(@"%s --- Party [%@] was deleted", __PRETTY_FUNCTION__, partyObject.eventName);
            if (error) {
                NSLog(@"%s --- [Error] - %@, user info - %@", __PRETTY_FUNCTION__, error, error.userInfo);
            }
        }
        
        [weakSelf performCompletionBlock:completion withError:nil];
    }];
}

- (void)saveOrUpdateParty:(PMRParty *)party {
    NSManagedObjectContext *context = [self.coreDataStack backgroundManagedObjectContext];
    [context performBlock:^{
        [self saveOrUpdateParty:party inContext:context];
    }];
}

- (void)saveOrUpdateParty:(PMRParty *)party inContext:(NSManagedObjectContext *)context {
    PMRPartyManagedObject *partyObject = [PMRPartyManagedObject fetchFromContext:context withPartyId:party.eventId];
    
    if (!partyObject) {
        partyObject = [NSEntityDescription insertNewObjectForEntityForName:@"Party" inManagedObjectContext:context];
    }
    
    partyObject = [partyObject produceUsingParty:party];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"%s --- [Error] - %@, user info - %@", __PRETTY_FUNCTION__, error, error.userInfo);
    }
    
    NSLog(@"%s --- Party [%@] was saved", __PRETTY_FUNCTION__, partyObject.eventName);
}

- (void)saveOrUpdatePartiesFromArrayOfParties:(NSArray *)parties withCallback:(void (^)(NSError *completionError))completion {
    __block __weak PMRCoreData *weakSelf = self;
    NSManagedObjectContext *context = [self.coreDataStack backgroundManagedObjectContext];
    [context performBlock:^{
        for (PMRParty *party in parties) {
            [weakSelf saveOrUpdateParty:party inContext:context];
        }
        [weakSelf performCompletionBlock:completion withError:nil];
    }];
}

- (void)markPartyAsDeletedByPartyId:(NSInteger)partyId {
    NSManagedObjectContext *context = [self.coreDataStack backgroundManagedObjectContext];
    
    [context performBlock:^{
        PMRPartyManagedObject *partyObject = [PMRPartyManagedObject fetchFromContext:context withPartyId:partyId];
        partyObject.isPartyDeleted = @1;
        NSError *error;
        [context save:&error];
        if (error) {
            NSLog(@"%s --- [Core data error] - %@, user info - %@", __PRETTY_FUNCTION__, error, error.userInfo);
        }
    }];
}

#pragma mark - Perform completion block

- (void)performCompletionBlock:(void (^) (NSError *completionError))block withError:(NSError *)error{
    if (block) {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(error);
        });
    }
}

#pragma mark - User core data implementation.

- (NSArray *)fetchAllPartiesByUserId:(NSInteger)userId fromContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetch = [NSFetchRequest new];
    fetch.entity = [NSEntityDescription entityForName:@"Party" inManagedObjectContext:context];
    fetch.predicate = [NSPredicate predicateWithFormat:@"creatorId == %@", @(userId)];
    fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"startTime" ascending:YES]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetch error:&error];
    
    if (error) {
        NSLog(@"%s --- [Fetch error] %@", __PRETTY_FUNCTION__, error);
    }
    
    return fetchedObjects;
}

@end
