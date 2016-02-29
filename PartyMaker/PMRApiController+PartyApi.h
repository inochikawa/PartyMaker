//
//  PMRApiController+PartyApi.h
//  PartyMaker
//
//  Created by 2 on 2/26/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRApiController.h"

@interface PMRApiController (PartyApi)

- (void)saveOrUpdateParty:(PMRParty *)partyDictionary withCallback:(void (^) ())completion;
- (void)deletePartyWithPartyId:(NSInteger)partyId withCreatorId:(NSInteger)creatorId withCallback:(void (^) ())completion;
- (void)loadAllPartiesByUserId:(NSInteger)userId withCallback:(void (^) (NSArray *parties))completion;
- (void)loadAllPartiesFromNetworkByUserId:(NSInteger)userId withCallback:(void (^) (NSArray *parties))completion;
@end
