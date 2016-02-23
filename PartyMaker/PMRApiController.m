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
#import "PMRDictionaryHelper.h"

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

- (void)saveOrUpdateParty:(NSMutableDictionary *)partyDictionary withCallback:(void (^) ())completion{
    __block __weak PMRApiController *weakSelf = self;
    
    [partyDictionary addEntriesFromDictionary:@{kPartyCreatorId: self.user.userId}];
    
    [self.networkSDK addPaty:partyDictionary callback:^(NSNumber *partyId, NSError *error) {
        NSError *networkError = error;
        
        if (!networkError) {
            [partyDictionary addEntriesFromDictionary:@{kPartyEventId: partyId}];
        }
        else {
            NSLog(@"%s --- [Network error] - %@, user info - %@", __PRETTY_FUNCTION__, networkError, networkError.userInfo);
            [partyDictionary addEntriesFromDictionary:@{kPartyIsChanged: @1}];
        }
        
        // upload data to database
        NSManagedObjectContext *context = [weakSelf.coreData backgroundManagedObjectContext];
        [context performBlock:^{
            [weakSelf.coreData saveOrUpadatePartyFromPartyDictionary:partyDictionary inContext:context];
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
                    NSLog(@"%s --- Party [%@] was deleted in data base", __PRETTY_FUNCTION__, partyId);
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

- (void)loadAllPartiesByUserId:(NSNumber *)userId withCallback:(void (^) (NSArray *partyDictionaries))completion {
    __block __weak PMRApiController *weakSelf = self;

    [self.networkSDK loadAllPartiesByUserId:userId callback:^(NSDictionary *response, NSError *error) {
        if (!error) {
            
            NSMutableArray *resultPartyDicrionaries = [[NSMutableArray alloc] init];
            NSMutableArray *partiesFromServer = [[NSMutableArray alloc] init];
            
            if (![response[@"response"] isEqual:[NSNull null]]) {
                [partiesFromServer addObjectsFromArray:response[@"response"]];
            }
            
            [weakSelf.coreData saveOrUpadatePartiesFromArrayOfPartyDictionaries:partiesFromServer withCallback:^(NSError * _Nullable completionError) {
                
                BOOL isDatabasePartyExist = NO;
                
                NSArray *partiesFromDatabase = [weakSelf.coreData loadAllPartiesByUserId:userId];
                /**************************************************************************************/
                for (PMRParty *databaseParty in partiesFromDatabase) {
                    isDatabasePartyExist = NO;
                    /**********************************************************************************/
                    for (NSDictionary *serverPartyDictionary in partiesFromServer) {
                        // if party exist in server we must check was party changed in offline mode?
                        if ([databaseParty.eventId integerValue] == [serverPartyDictionary[@"id"] integerValue]) {
                            isDatabasePartyExist = YES;
                            if (databaseParty.isPartyChanged == NO) {
                                NSDictionary *partyDictionary = [PMRDictionaryHelper fullPartyDictionary:databaseParty];
                                [weakSelf.networkSDK addPaty:partyDictionary callback:^(NSNumber *partyId, NSError *error) {
                                    if (error) {
                                        NSLog(@"%s --- [Network error] - %@, user info - %@", __PRETTY_FUNCTION__, error, error.userInfo);
                                    }
                                }];
                                break;
                            }
                        }
                    }
                    /**********************************************************************************/
                    if (!isDatabasePartyExist) {
                        if ([databaseParty.eventId intValue] != 0 || databaseParty.isPartyDeleted != NO) {
                            [weakSelf deletePartyWithPartyId:databaseParty.eventId withCreatorId:databaseParty.creatorId withCallback:^{
                                
                            }];
                        }
                        else {
                            NSMutableDictionary *partyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[PMRDictionaryHelper fullPartyDictionary:databaseParty]];
                            [weakSelf.networkSDK addPaty:partyDictionary callback:^(NSNumber *partyId, NSError *error) {
                                if (!error) {
                                    [partyDictionary setValue:partyId forKey:kPartyEventId];
                                    [resultPartyDicrionaries addObject:partyDictionary];
                                    NSManagedObjectContext *context = [weakSelf.coreData backgroundManagedObjectContext];
                                    [context performBlock:^{
                                        [weakSelf.coreData saveOrUpadatePartyFromPartyDictionary:partyDictionary inContext:context];
                                    }];
                                }
                                else {
                                    NSLog(@"%s --- [Network error] - %@, user info - %@", __PRETTY_FUNCTION__, error, error.userInfo);
                                }
                            }];
                        }
                    }
                    else {
                        NSDictionary *resultPartyDictionary = [PMRDictionaryHelper fullPartyDictionary:databaseParty];
                        [resultPartyDicrionaries addObject:resultPartyDictionary];
                    }
                    /**********************************************************************************/

                }
                /**************************************************************************************/
                
                if (completion) {
                    completion(resultPartyDicrionaries);
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

@end
