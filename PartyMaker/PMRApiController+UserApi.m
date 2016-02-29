//
//  PMRApiController+UserApi.m
//  PartyMaker
//
//  Created by 2 on 2/26/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRApiController+UserApi.h"
#import "PMRNetworkSDK.h"
#import "PMRUser.h"

@implementation PMRApiController (UserApi)

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
            self.user.userId = [response[@"response"][@"id"] integerValue];
        }
        else {
            NSLog(@"%s --- [Error] - %@, user info - %@", __PRETTY_FUNCTION__, error, error.userInfo);
        }
        if (completion) {
            completion(response, error);
        }
    }];
}

- (void)loadAllUsersWithCallback:(void (^) (NSArray *users))callback {
    [self.networkSDK allUsersWithcallback:^(NSArray *users) {
        if (callback) {
            callback(users);
        }
    }];
}

@end
