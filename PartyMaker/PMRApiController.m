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
    [self.networkSDK loginWithUserName:user.name withPassword:user.password callback:^(NSDictionary *response, NSError *error) {
        if (completion) {
            completion(response, error);
        }
    }];
}

#pragma mark - API party methods

- (void)saveOrUpdateParty:(PMRParty *)party {
    __block __weak PMRApiController *weakSekf = self;
    
    [self.networkSDK addPaty:party callback:^(NSDictionary *response, NSError *error) {
        NSUInteger statusRequest = [response[@"statusCode"] integerValue];
        NSError *networkError = error;
        
        if (statusRequest == 200) {
            NSManagedObjectContext *context = [weakSekf.coreData mainManagedObjectContext];
            PMRParty *partyObject = [weakSekf.coreData fetchPartyByPartyId:party.eventId inContext:context];
            if (partyObject) {
                [weakSekf.coreData updateParty:party withCallback:^(NSError * _Nullable completionError) {
                    if (!completionError) {
                        NSLog(@"%s --- Party [%@] was upadated in data base", __PRETTY_FUNCTION__, party.eventName);
                    } else {
                        NSLog(@"%s [Core data error] --- Party [%@] was not upadated in data base --- [Error - %@, user info - %@", __PRETTY_FUNCTION__, party.eventName, completionError, completionError.userInfo);
                    }
                }];
            } else {
                [weakSekf.coreData saveParty:party withCallback:^(NSError * _Nullable completionError) {
                    if (!completionError) {
                        NSLog(@"%s --- Party [%@] was upadated in data base", __PRETTY_FUNCTION__, party.eventName);
                    } else {
                        NSLog(@"%s [Core data error] --- Party [%@] was not saved to data base --- [Error - %@, user info - %@", __PRETTY_FUNCTION__, party.eventName, completionError, completionError.userInfo);
                    }
                }];
            }
        } else {
            NSLog(@"%s --- [Network error] - %@, user info - %@", __PRETTY_FUNCTION__, networkError, networkError.userInfo);
        }

    }];
}

- (void)deleteParty:(PMRParty *)party {
    [self.networkSDK deleteParty:party callback:^(NSDictionary *response, NSError *error) {
        NSInteger statusRequest = [response[@"statusCode"] integerValue];
        NSError *networkError = error;
        
        if (statusRequest == 200) {
            [self.coreData deleteParty:party withCallback:^(NSError * _Nullable completionError) {
                if (!completionError) {
                    NSLog(@"%s --- Party [%@] was upadated in data base", __PRETTY_FUNCTION__, party.eventName);
                } else {
                    NSLog(@"%s [Core data error] --- Party [%@] was not deleted from data base --- [Error - %@, user info - %@", __PRETTY_FUNCTION__, party.eventName, completionError, completionError.userInfo);
                }
                
            }];
        } else {
            NSLog(@"%s --- [Network error] - %@, user info - %@", __PRETTY_FUNCTION__, networkError, networkError.userInfo);
        }
    }];
}

- (void)loadAllPartiesByUserId:(NSNumber *)userId withCallback:(void (^) (NSArray *parties))completion {
    [self.networkSDK loadAllPartiesByUserId:userId callback:^(NSDictionary *response, NSError *error) {
        NSLog(@"%@", response);
        
        NSMutableArray *parties = [NSMutableArray new];
        
        for (PMRParty *party in parties) {
            [self saveOrUpdateParty:party];
        }
        
        if (completion) {
            completion(parties);
        }
    }];
}

- (PMRParty *)loadPartyById:(NSNumber *)partyId {
    NSManagedObjectContext *context = [self.coreData mainManagedObjectContext];
    return [self.coreData fetchPartyByPartyId:partyId inContext:context];
}

@end
