//
//  PMRApiController.m
//  PartyMaker
//
//  Created by 2 on 2/18/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRApiController.h"
#import "PMRCoreData.h"
#import "PMRNetworkSDK.h"
#import "PMRParty.h"
#import "PMRUser.h"
#import <CoreData/CoreData.h>

@interface PMRApiController()

@property (nonatomic) PMRCoreData *coreData;
@property (nonatomic) PMRNetworkSDK *networkSDK;

@end

@implementation PMRApiController

-(instancetype) initUniqueInstance {
    return [super init];
}

+ (instancetype)apiController {
    static dispatch_once_t pred;
    static id instance = nil;
    dispatch_once(&pred, ^{
        instance = [[super alloc] initUniqueInstance];
        [instance configureApiController];
    });
    return instance;
}

#pragma mark - Configure API controller

- (void)configureApiController {
    self.coreData = [PMRCoreData new];
    self.networkSDK = [PMRNetworkSDK new];
}

#pragma mark - API user methods

- (void)registerUser:(PMRUser *)user withCallback:(void (^) (NSDictionary *response, NSError *error))completion{
    [self.networkSDK registerUserWithName:user.name witEmail:user.email withPassword:user.password callback:^(NSDictionary *response, NSError *error) {
        if (error) {
            NSLog(@"%s --- [Error] - %@, user info - %@", __PRETTY_FUNCTION__, error, error.userInfo);
        }
        
        if (completion) {
            completion(response, error);
        }
    }];
}

- (void)loginUser:(PMRUser *)user withCallback:(void (^) (NSDictionary *response, NSError *error))completion{
    self.user = user;
    [self.networkSDK loginWithUserName:user.name withPassword:user.password callback:^(NSDictionary *response, NSError *error) {
        if (!error) {
            self.user.userId = @([response[@"response"][@"id"] integerValue]);
        }
        else {
            NSLog(@"%s --- [Error] - %@, user info - %@", __PRETTY_FUNCTION__, error, error.userInfo);
        }
        if (completion) {
            completion(response, error);
        }
    }];
}

#pragma mark - API party methods

- (void)saveOrUpdateParty:(PMRParty *)party withCallback:(void (^) ())completion{
    __block __weak PMRApiController *weakSelf = self;
    
    party.creatorId = self.user.userId;
    
    [self.networkSDK addPaty:party callback:^(NSNumber *partyId, NSError *error) {
        NSError *networkError = error;
        
        if (!networkError) {
            party.eventId = partyId;
        }
        else {
            NSLog(@"%s --- [Network error] - %@, user info - %@", __PRETTY_FUNCTION__, networkError, networkError.userInfo);
            party.isPartyChanged = @1;
        }
        
        // upload data to database
        NSManagedObjectContext *context = [weakSelf.coreData backgroundManagedObjectContext];
        [context performBlock:^{
            [weakSelf.coreData saveOrUpdateParty:party inContext:context];
            [weakSelf pmr_performCompletionBlock:completion];
        }];
    }];
}

- (void)deletePartyWithPartyId:(NSNumber *)partyId withCreatorId:(NSNumber *)creatorId withCallback:(void (^) ())completion {
    __block __weak PMRApiController *weakSelf = self;
    [self.networkSDK deletePartyWithPartyId:partyId withCreatorId:creatorId callback:^(NSDictionary *response, NSError *error) {
        NSError *networkError = error;
        
        if (!networkError) {
            [weakSelf.coreData deleteParty:partyId withCallback:^(NSError * _Nullable completionError) {
                if (!completionError) {
                    NSLog(@"%s --- Party [%@] was deleted from data base", __PRETTY_FUNCTION__, partyId);
                } else {
                    NSLog(@"%s [Core data error] --- Party [%@] was not deleted from data base --- [Error - %@, user info - %@", __PRETTY_FUNCTION__, partyId, completionError, completionError.userInfo);
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

- (void)loadAllPartiesByUserId:(NSNumber *)userId withCallback:(void (^) (NSArray *parties))completion {
    __block __weak PMRApiController *weakSelf = self;

    [self.networkSDK loadAllPartiesByUserId:userId callback:^(NSArray *partiesFromServer, NSError *error) {
        if (!error) {
            [weakSelf.coreData saveOrUpdatePartiesFromArrayOfParties:partiesFromServer withCallback:^(NSError * _Nullable completionError) {
                NSArray *partiesFromDatabase = [weakSelf.coreData loadAllPartiesByUserId:userId];
                NSArray *resultArrayOfParties = [weakSelf produceResultArrayOfPartiesUsingPartiesFromServer:partiesFromServer
                                                                                     andPartiesFromDatabase:partiesFromDatabase];
                
                if (completion) {
                    completion(resultArrayOfParties);
                }
                
            }];
        }
    }];
}

- (void)pmr_performCompletionBlock:(void (^) ())block {
    if (block) {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

- (NSArray *)produceResultArrayOfPartiesUsingPartiesFromServer:(NSArray *)partiesFromServer andPartiesFromDatabase:(NSArray *)partiesFromDatabase {
    BOOL isDatabasePartyExist = NO;
    NSMutableArray *resultArrayOfParties = [[NSMutableArray alloc] init];
    __block __weak PMRApiController *weakSelf = self;
    
    for (PMRParty *databaseParty in partiesFromDatabase) {
        isDatabasePartyExist = NO;
        for (PMRParty *serverParty in partiesFromServer) {
            // if party exist in server we must check was party changed in offline mode?
            if ([databaseParty.eventId integerValue] == [serverParty.eventId integerValue]) {
                isDatabasePartyExist = YES;
                if (![databaseParty.isPartyChanged boolValue]) {
                    [self.networkSDK addPaty:databaseParty callback:^(NSNumber *partyId, NSError *error) {
                        if (error) {
                            NSLog(@"%s --- [Network error] - %@, user info - %@", __PRETTY_FUNCTION__, error, error.userInfo);
                        }
                    }];
                    break;
                }
            }
        }
        if (!isDatabasePartyExist) {
            if ([databaseParty.eventId intValue] != 0 || ![databaseParty.isPartyDeleted boolValue]) {
                [self deletePartyWithPartyId:databaseParty.eventId withCreatorId:databaseParty.creatorId withCallback:^{
                    
                }];
            }
            else {
                [self.networkSDK addPaty:databaseParty callback:^(NSNumber *partyId, NSError *error) {
                    if (!error) {
                        databaseParty.eventId = partyId;
                        [resultArrayOfParties addObject:databaseParty];
                        NSManagedObjectContext *context = [weakSelf.coreData backgroundManagedObjectContext];
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
