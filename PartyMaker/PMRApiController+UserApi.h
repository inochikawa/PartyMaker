//
//  PMRApiController+UserApi.h
//  PartyMaker
//
//  Created by 2 on 2/26/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRApiController.h"

@interface PMRApiController (UserApi)

- (void)registerUser:(PMRUser *)user withCallback:(void (^) (NSDictionary *response, NSError *error))completion;
- (void)loginUser:(PMRUser *)user withCallback:(void (^) (NSDictionary *response, NSError *error))completion;
- (void)loadAllUsersWithCallback:(void (^) (NSArray *users))callback;

@end
