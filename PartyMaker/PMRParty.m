//
//  PMRParty.m
//  PartyMaker
//
//  Created by 2 on 2/17/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRParty.h"

@implementation PMRParty

- (BOOL)isEqual:(id)object {
    PMRParty *party = (PMRParty *)object;
    if ([party.eventId integerValue] == [self.eventId integerValue]) {
        return YES;
    }
    return NO;
}

@end
