//
//  PMRApiController+PartyApi.m
//  PartyMaker
//
//  Created by 2 on 2/26/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "PMRApiController+PartyApi.h"
#import "PMRNetworkSDK.h"
#import "PMRCoreData.h"
#import "PMRCoreDataStack.h"
#import "PMRParty.h"
#import "PMRUser.h"

@implementation PMRApiController (PartyApi)

- (void)saveOrUpdateParty:(PMRParty *)party withCallback:(void (^) ())completion{
    __block __weak PMRApiController *weakSelf = self;
    
    party.creatorId = self.user.userId;
    
    [self.networkSDK addPaty:party callback:^(NSInteger partyId, NSError *error) {
        NSError *networkError = error;
        
        if (!networkError) {
            party.eventId = partyId;
        }
        else {
            NSLog(@"%s --- [Network error] - %@, user info - %@", __PRETTY_FUNCTION__, networkError, networkError.userInfo);
            party.isPartyChanged = @1;
        }
        
        // upload data to database
        NSManagedObjectContext *context = [weakSelf.coreData.coreDataStack backgroundManagedObjectContext];
        [context performBlock:^{
            [weakSelf.coreData saveOrUpdateParty:party inContext:context];
            [weakSelf pmr_performCompletionBlock:completion];
        }];
    }];
}

- (void)deletePartyWithPartyId:(NSInteger)partyId withCreatorId:(NSInteger)creatorId withCallback:(void (^) ())completion {
    __block __weak PMRApiController *weakSelf = self;
    [self.networkSDK deletePartyWithPartyId:partyId withCreatorId:creatorId callback:^(NSDictionary *response, NSError *error) {
        NSError *networkError = error;
        
        if (!networkError) {
            [weakSelf.coreData deleteParty:partyId withCallback:^(NSError * _Nullable completionError) {
                if (!completionError) {
                    NSLog(@"%s --- Party [%ld] was deleted from data base", __PRETTY_FUNCTION__, (long)partyId);
                } else {
                    NSLog(@"%s [Core data error] --- Party [%ld] was not deleted from data base --- [Error - %@, user info - %@", __PRETTY_FUNCTION__, (long)partyId, completionError, completionError.userInfo);
                }
                
                [weakSelf pmr_performCompletionBlock:completion];
            }];
        } else {
            NSLog(@"%s --- [Network error] - %@, user info - %@", __PRETTY_FUNCTION__, networkError, networkError.userInfo);
            [weakSelf.coreData markPartyAsDeletedByPartyId:partyId];
            [weakSelf pmr_performCompletionBlock:completion];
        }
    }];
}

- (void)loadAllPartiesFromNetworkByUserId:(NSInteger)userId withCallback:(void (^) (NSArray *parties))completion {
    [self.networkSDK loadAllPartiesByUserId:userId callback:^(NSArray *parties, NSError *error) {
        if (error) {
            NSLog(@"%s --- [Error] - %@, user info - %@", __PRETTY_FUNCTION__, error, error.userInfo);
        }
        if (completion) {
            completion(parties);
        }
    }];
}

- (void)loadAllPartiesByUserId:(NSInteger)userId withCallback:(void (^) (NSArray *parties))completion {
    __block __weak PMRApiController *weakSelf = self;
    
    [self.networkSDK loadAllPartiesByUserId:userId callback:^(NSArray *partiesFromServer, NSError *error) {
        NSMutableArray *partiesFromDatabase = [[NSMutableArray alloc] initWithArray:[weakSelf.coreData loadAllPartiesByUserId:userId]];
        NSMutableArray *resultArrayOfParties = [NSMutableArray new];
        
        if (error) {
            NSLog(@"%s --- [Network error] - %@, user info - %@", __PRETTY_FUNCTION__, error, error.userInfo);
            
            for (PMRParty *databaseParty in partiesFromDatabase) {
                if (!databaseParty.isPartyDeleted) {
                    [resultArrayOfParties addObject:databaseParty];
                }
            }
        }
        else {
            // delete all parties marked DELETED
            for (PMRParty *databaseParty in partiesFromDatabase) {
                if (databaseParty.isPartyDeleted) {
                    [weakSelf deletePartyWithPartyId:databaseParty.eventId withCreatorId:databaseParty.creatorId withCallback:^{
                        NSLog(@"Party deleted");
                    }];
                    [partiesFromDatabase removeObject:databaseParty];
                }
            }
            
            [resultArrayOfParties addObjectsFromArray:[weakSelf produceResultArrayOfPartiesUsingPartiesFromServer:partiesFromServer andPartiesFromDatabase:partiesFromDatabase]];
        }
        
        if (completion) {
            completion(resultArrayOfParties);
        }
    }];
}

- (NSArray *)produceResultArrayOfPartiesUsingPartiesFromServer:(NSArray *)partiesFromServer andPartiesFromDatabase:(NSArray *)partiesFromDatabase {
    BOOL isDatabasePartyExist = NO;
    NSMutableArray *resultArrayOfParties = [[NSMutableArray alloc] init];
    __block __weak PMRApiController *weakSelf = self;
    
    for (PMRParty *databaseParty in partiesFromDatabase) {
        isDatabasePartyExist = NO;
        for (PMRParty *serverParty in partiesFromServer) {
            // if party exist in server we must check was party changed in offline mode?
            if (databaseParty.eventId == serverParty.eventId) {
                isDatabasePartyExist = YES;
                if (!databaseParty.isPartyChanged) {
                    [self.networkSDK addPaty:databaseParty callback:^(NSInteger partyId, NSError *error) {
                        if (error) {
                            NSLog(@"%s --- [Network error] - %@, user info - %@", __PRETTY_FUNCTION__, error, error.userInfo);
                        }
                    }];
                    break;
                }
            }
        }
        if (!isDatabasePartyExist) {
            if (databaseParty.eventId != 0) {
                [self deletePartyWithPartyId:databaseParty.eventId withCreatorId:databaseParty.creatorId withCallback:^{
                    
                }];
            }
            else {
                [self.networkSDK addPaty:databaseParty callback:^(NSInteger partyId, NSError *error) {
                    if (!error) {
                        databaseParty.eventId = partyId;
                        [resultArrayOfParties addObject:databaseParty];
                        NSManagedObjectContext *context = [weakSelf.coreData.coreDataStack backgroundManagedObjectContext];
                        [context performBlock:^{
                            [weakSelf.coreData saveOrUpdateParty:databaseParty inContext:context];
                        }];
                    }
                    else {
                        NSLog(@"%s --- [Network error] - %@, user info - %@", __PRETTY_FUNCTION__, error, error.userInfo);
                    }
                }];
            }
        }
        else {
            [resultArrayOfParties addObject:databaseParty];
        }
    }
    
    return resultArrayOfParties;
}


@end
