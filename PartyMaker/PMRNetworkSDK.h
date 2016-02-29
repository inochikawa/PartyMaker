//
//  PMRPartyMakerSDK.h
//  PartyMaker
//
//  Created by 2 on 2/16/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PMRParty;

@interface PMRNetworkSDK : NSObject
- (void)loginWithUserName:(NSString *) userName withPassword:(NSString *) password callback:(void (^) (NSDictionary *response, NSError *error))block;
- (void)loadAllPartiesByUserId:(NSInteger)userId callback:(void (^) (NSArray *parties, NSError *error))block;
- (void)deletePartyWithPartyId:(NSInteger)partyId withCreatorId:(NSInteger)creatorId callback:(void (^) (NSDictionary *response, NSError *error))block;
- (void)allUsersWithcallback:(void (^) (NSArray *users))block;
- (void)registerUserWithName:(NSString *)userName witEmail:(NSString *)email withPassword:(NSString *)password callback:(void (^) (NSDictionary *response, NSError *error))block;
- (void)addPaty:(PMRParty *)party callback:(void (^) (NSInteger partyId, NSError *error))block;
@end
