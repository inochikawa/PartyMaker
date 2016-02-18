//
//  PRMUser.m
//  PartyMaker
//
//  Created by 2 on 2/16/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRUser.h"

@implementation PMRUser

-(instancetype) initUniqueInstance {
    return [super init];
}

+ (instancetype) user {
    static dispatch_once_t pred;
    static id user = nil;
    dispatch_once(&pred, ^{
        user = [[super alloc] initUniqueInstance];
    });
    return user;
}

@end
