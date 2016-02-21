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

- (PMRUser *)createInstanseForUser {
    NSManagedObjectContext *context = [self.coreData mainManagedObjectContext];
    return [[PMRUser alloc] initWithEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
}

- (PMRParty *)createInstanseForParty {
    NSManagedObjectContext *context = [self.coreData mainManagedObjectContext];
    return [[PMRParty alloc] initWithEntity:[NSEntityDescription entityForName:@"Party" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
}

#pragma mark - Configure API controller

- (void)configureApiController {
    self.coreData = [PMRCoreData new];
    self.networkSDK = [PMRNetworkSDK new];
}

#pragma mark - API user methods

- (void)registerUser:(PMRUser *)user withCallback:(void (^) (NSDictionary *response, NSError *error))completion{
    [self.networkSDK registerUserWithName:user.name witEmail:user.email withPassword:user.password callback:^(NSDictionary *response, NSError *error) {
        if (completion) {
            completion(response, error);
        }
    }];
}

- (void)loginUser:(PMRUser *)user withCallback:(void (^) (NSDictionary *response, NSError *error))completion{
    self.user = user;
    [self.networkSDK loginWithUserName:user.name withPassword:user.password callback:^(NSDictionary *response, NSError *error) {
        self.user.userId = @([response[@"response"][@"id"] integerValue]);
        if (completion) {
            completion(response, error);
        }
    }];
}

#pragma mark - API party methods

- (void)saveOrUpdateParty:(PMRParty *)party withCallback:(void (^) ())completion{
    __block __weak PMRApiController *weakSelf = self;
    party.creatorId = self.user.userId;
    
    [self.networkSDK addPaty:party callback:^(NSDictionary *response, NSError *error) {
        NSUInteger statusRequest = [response[@"statusCode"] integerValue];
        NSError *networkError = error;
        
        if (statusRequest == 200) {
            party.eventId = [NSNumber numberWithInteger:[response[@"partyId"] integerValue]];
        }
        else {
            NSLog(@"%s --- [Network error] - %@, user info - %@", __PRETTY_FUNCTION__, networkError, networkError.userInfo);
            party.isPartyChanged = @1;
        }
        
        // upload data to database
        NSManagedObjectContext *context = [weakSelf.coreData mainManagedObjectContext];
        PMRParty *partyObject = [weakSelf.coreData fetchObjectFromEntity:@"Party" forKey:@"eventId" withValue:party.eventId inContext:context];
        if (partyObject) {
            [weakSelf.coreData updateParty:party withCallback:^(NSError * _Nullable completionError) {
                if (!completionError) {
                    NSLog(@"%s --- Party [%@] was upadated in data base", __PRETTY_FUNCTION__, party.eventName);
                } else {
                    NSLog(@"%s [Core data error] --- Party [%@] was not upadated in data base --- [Error - %@, user info - %@", __PRETTY_FUNCTION__, party.eventName, completionError, completionError.userInfo);
                }
                [weakSelf pmr_performCompletionBlock:completion];
            }];
        }
        else {
            [weakSelf.coreData saveParty:party withCallback:^(NSError * _Nullable completionError) {
                if (!completionError) {
                    NSLog(@"%s --- Party [%@] was upadated in data base", __PRETTY_FUNCTION__, party.eventName);
                } else {
                    NSLog(@"%s [Core data error] --- Party [%@] was not saved to data base --- [Error - %@, user info - %@", __PRETTY_FUNCTION__, party.eventName, completionError, completionError.userInfo);
                }
                [weakSelf pmr_performCompletionBlock:completion];
            }];
        }
    }];
}

- (void)deleteParty:(PMRParty *)party  withCallback:(void (^) ())completion{
    __block __weak PMRApiController *weakSelf = self;
    [self.networkSDK deleteParty:party callback:^(NSDictionary *response, NSError *error) {
        NSInteger statusRequest = [response[@"statusCode"] integerValue];
        NSError *networkError = error;
        
        if (statusRequest == 200) {
            [weakSelf.coreData deleteParty:party.eventId withCallback:^(NSError * _Nullable completionError) {
                if (!completionError) {
                    NSLog(@"%s --- Party [%@] was upadated in data base", __PRETTY_FUNCTION__, party.eventName);
                } else {
                    NSLog(@"%s [Core data error] --- Party [%@] was not deleted from data base --- [Error - %@, user info - %@", __PRETTY_FUNCTION__, party.eventName, completionError, completionError.userInfo);
                }
                
                [weakSelf pmr_performCompletionBlock:completion];
            }];
        } else {
            NSLog(@"%s --- [Network error] - %@, user info - %@", __PRETTY_FUNCTION__, networkError, networkError.userInfo);
            party.isPartyDeleted = @1;
            [weakSelf pmr_performCompletionBlock:completion];
        }
    }];
}

- (void)loadAllPartiesByUserId:(NSNumber *)userId withCallback:(void (^) (NSArray *parties))completion {
    __block __weak PMRApiController *weakSelf = self;
    
    // loading parties from server
    [self.networkSDK loadAllPartiesByUserId:userId callback:^(NSDictionary *response, NSError *error) {
        if (!error) {
            NSMutableArray *partiesFromServer = [NSMutableArray new];
            NSMutableArray *arrayOfPartyDictionaries = [[NSMutableArray alloc]init];
            
            if (![response[@"response"] isEqual:[NSNull null]]) {
                [arrayOfPartyDictionaries addObjectsFromArray:response[@"response"]];
            }
            
            for (NSDictionary *partyDictionary in arrayOfPartyDictionaries) {
                PMRParty *party = [self createInstanseForParty];
                party.eventName = partyDictionary[@"name"];
                party.eventId = @([partyDictionary[@"id"] integerValue]);
                party.eventDescription = partyDictionary[@"comment"];
                party.startTime = @([partyDictionary[@"start_time"] integerValue]);
                party.endTime = @([partyDictionary[@"end_time"] integerValue]);
                party.imageIndex = @([partyDictionary[@"logo_id"] integerValue]);
                party.creatorId = @([partyDictionary[@"creator_id"] integerValue]);
                [partiesFromServer addObject:party];
            }
            ///////////////////////////////////////////////////////////////////////////////////
            // loading parties from database
            [weakSelf.coreData loadAllPartiesByUserId:userId withCallback:^(NSArray * _Nullable partiesFromDatabase, NSError * _Nullable completionError) {
                if (!completionError) {
                    NSLog(@"%s --- Party array was loaded from data base", __PRETTY_FUNCTION__);
                    
                    NSMutableArray *resultArrayOfParties = [[NSMutableArray  alloc] init];
                    
                    BOOL isDatabasePartyExist = NO;
                    
                    for (PMRParty *databaseParty in partiesFromDatabase) {
                        isDatabasePartyExist = NO;
                        for (PMRParty *serverParty in partiesFromServer) {
                            // if party exist in server we must check was party changed in offline mode?
                            if ([databaseParty.eventId integerValue] == [serverParty.eventId integerValue]) {
                                isDatabasePartyExist = YES;
                                if (databaseParty.isPartyChanged) {
                                    serverParty.eventName = databaseParty.eventName;
                                    serverParty.eventDescription = databaseParty.eventDescription;
                                    serverParty.imageIndex = databaseParty.imageIndex;
                                    serverParty.startTime = databaseParty.startTime;
                                    serverParty.endTime = databaseParty.endTime;
                                    //need add latitude and longtitude
                                    break;
                                }
                            }
                        }
                        // if party doesn't exist in server we must check party Id. If Id = 0 - party was added to database in offline mode and we must add this party to server. If Id != 0 - party was deleted from server but it was not deleted from database => we mark this party as FOR DELETED.
                        if (!isDatabasePartyExist) {
                            if ([databaseParty.eventId intValue] != 0) {
                                databaseParty.isPartyDeleted = @1;
                            }
                            else if (!databaseParty.isPartyDeleted) {
                                [resultArrayOfParties addObject:databaseParty];
                            }
                        }
                    }
                    
                    [resultArrayOfParties addObjectsFromArray:partiesFromServer];
                    
                    // And now we delete all parties from "Party" table. And then we add new info to "Party" table.
                    [weakSelf.coreData deleteAllUserPartiesByUserId:userId withCallback:^(NSError * _Nullable completionError) {
                        if (!completionError) {
                            [weakSelf.coreData savePartiesFromArray:resultArrayOfParties withCallback:^(NSError * _Nullable completionError) {
                                // upload parties to server after storing their to database
                                for (PMRParty *serverParty in resultArrayOfParties) {
                                    [weakSelf.networkSDK addPaty:serverParty callback:^(NSDictionary *response, NSError *error) {
                                        if (error) {
                                            NSLog(@"%s --- [Error] - %@, user info - %@", __PRETTY_FUNCTION__, completionError, completionError.userInfo);
                                        }
                                        else {
                                            NSLog(@"%s --- party [%@] was added to server", __PRETTY_FUNCTION__, serverParty.eventName);
                                        }
                                    }];
                                }
                                
                                if (completion) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        NSLog(@"\n\n%s", __PRETTY_FUNCTION__);
                                        completion(partiesFromServer);
                                    });
                                }
                            }];
                        }
                    }];                    
                } else {
                    NSLog(@"%s [Core data error] --- Party array was not loaded from data base --- [Error - %@, user info - %@", __PRETTY_FUNCTION__, completionError, completionError.userInfo);
                }
            }];
            
            ///////////////////////////////////////////////////////////////////////////////////
            
        }
        else {
            NSLog(@"%s [Core data error] --- Party array was not loaded from data base --- [Error - %@, user info - %@", __PRETTY_FUNCTION__, error, error.userInfo);
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
