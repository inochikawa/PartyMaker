//
//  PMRUser.m
//  PartyMaker
//
//  Created by 2 on 2/19/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRUser.h"
#import "PMRParty.h"
#import "PMRApiController.h"

@implementation PMRUser

-(instancetype) initUniqueInstance {
    return [super init];
}

+ (instancetype)user {
    static dispatch_once_t pred;
    static id instance = nil;
    dispatch_once(&pred, ^{
        instance = [[PMRApiController apiController] createInstanseForUser];
    });
    return instance;
}

@end
