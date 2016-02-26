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
@class PMRCoreData;
@class PMRNetworkSDK;

@interface PMRApiController : NSObject

@property (nonatomic) PMRUser *user;
@property (nonatomic) PMRCoreData *coreData;
@property (nonatomic) PMRNetworkSDK *networkSDK;

- (void)pmr_performCompletionBlock:(void (^) ())block;
+ (instancetype)apiController;

@end

#import "PMRApiController+UserApi.h"
#import "PMRApiController+PartyApi.h"