//
//  PMRApiController.h
//  PartyMaker
//
//  Created by 2 on 2/18/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PMRParty;
@class PMRUser;

@interface PMRApiController : NSObject

@property (nonatomic) PMRUser *user;

- (void)registerUser:(PMRUser *)user withCallback:(void (^) (NSDictionary *response, NSError *error))completion;
- (void)loginUser:(PMRUser *)user withCallback:(void (^) (NSDictionary *response, NSError *error))completion;

- (void)saveOrUpdateParty:(PMRParty *)partyDictionary withCallback:(void (^) ())completion;
- (void)deletePartyWithPartyId:(NSNumber *)partyId withCreatorId:(NSNumber *)creatorId withCallback:(void (^) ())completion;
- (void)loadAllPartiesByUserId:(NSNumber *)userId withCallback:(void (^) (NSArray *parties))completion;

+ (instancetype)apiController;

@end
