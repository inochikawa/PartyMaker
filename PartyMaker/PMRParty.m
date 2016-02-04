//
//  PMRParty.m
//  PartyMaker
//
//  Created by Maksim Stecenko on 2/4/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRParty.h"

@implementation PMRParty

- (instancetype)initWithName:(NSString *)eventName {
    self = [super init];
    
    if (!self) return nil;
    
    self.eventName = eventName;
    return self;
}

- (void)saveParty {
    
}

@end
