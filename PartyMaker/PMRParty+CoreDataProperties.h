//
//  PMRParty+CoreDataProperties.h
//  PartyMaker
//
//  Created by 2 on 2/21/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PMRParty.h"

NS_ASSUME_NONNULL_BEGIN

@interface PMRParty (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *creatorId;
@property (nullable, nonatomic, retain) NSNumber *endTime;
@property (nullable, nonatomic, retain) NSString *eventDescription;
@property (nullable, nonatomic, retain) NSNumber *eventId;
@property (nullable, nonatomic, retain) NSString *eventName;
@property (nullable, nonatomic, retain) NSNumber *imageIndex;
@property (nullable, nonatomic, retain) NSNumber *isPartyChanged;
@property (nullable, nonatomic, retain) NSNumber *isPartyDeleted;
@property (nullable, nonatomic, retain) NSNumber *startTime;
@property (nullable, nonatomic, retain) NSString *latitude;
@property (nullable, nonatomic, retain) NSString *longitude;
@property (nullable, nonatomic, retain) PMRUser *partyToUser;

@end

NS_ASSUME_NONNULL_END
