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

- (void)registerUser:(PMRUser *)user withCallback:(void (^) (NSDictionary *response, NSError *error))completion;
- (void)loginUser:(PMRUser *)user withCallback:(void (^) (NSDictionary *response, NSError *error))completion;

- (void)saveOrUpdateParty:(PMRParty *)party withCallback:(void (^) ())completion;
- (void)deleteParty:(PMRParty *)party  withCallback:(void (^) ())completion;
- (void)loadAllPartiesByUserId:(NSNumber *)userId withCallback:(void (^) (NSArray *parties))completion;
- (PMRParty *)loadPartyById:(NSNumber *)partyId;

- (PMRUser *)createInstanseForUser;
- (PMRParty *)createInstanseForParty;

+ (instancetype)apiController;

@end
