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
- (void)deletePartyWithPartyId:(NSNumber *)partyId withCreatorId:(NSNumber *)creatorId withCallback:(void (^) ())completion;
- (void)loadAllPartiesByUserId:(NSNumber *)userId withCallback:(void (^) (NSArray *parties))completion;

@end
