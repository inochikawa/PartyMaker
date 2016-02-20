//
//  PMRParty+CoreDataProperties.m
//  PartyMaker
//
//  Created by 2 on 2/19/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PMRParty+CoreDataProperties.h"

@implementation PMRParty (CoreDataProperties)

@dynamic endTime;
@dynamic startTime;
@dynamic imageIndex;
@dynamic eventDescription;
@dynamic eventName;
@dynamic creatorId;
@dynamic eventId;
@dynamic isPartyDeleted;
@dynamic isPartyChanged;
@dynamic partyToUser;

@end
