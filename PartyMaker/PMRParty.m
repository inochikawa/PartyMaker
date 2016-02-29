//
//  PMRParty.m
//  PartyMaker
//
//  Created by 2 on 2/24/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRParty.h"
#import "PMRPartyManagedObject.h"

@implementation PMRParty

- (instancetype)initUsingPartyObject:(PMRPartyManagedObject *)partyObject {
    self = [super init];
    
    if (!self) {
        NSLog(@"%s --- [Error] - Party doesn't created", __PRETTY_FUNCTION__);
        return nil;
    }
    
    self.eventId = partyObject.eventId;
    self.eventName = partyObject.eventName;
    self.eventDescription = partyObject.eventDescription;
    self.imageIndex = partyObject.imageIndex;
    self.startTime = partyObject.startTime;
    self.endTime = partyObject.endTime;
    self.creatorId = partyObject.creatorId;
    self.isPartyChanged = partyObject.isPartyChanged;
    self.isPartyDeleted = partyObject.isPartyDeleted;
    self.latitude = partyObject.latitude;
    self.longitude = partyObject.longitude;
    
    return self;
}

@end