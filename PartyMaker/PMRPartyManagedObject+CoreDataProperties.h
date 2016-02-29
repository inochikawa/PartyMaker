//
//  PMRPartyManagedObject+CoreDataProperties.h
//  PartyMaker
//
//  Created by 2 on 2/28/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PMRPartyManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface PMRPartyManagedObject (CoreDataProperties)

@property (nonatomic) int64_t creatorId;
@property (nonatomic) int64_t endTime;
@property (nullable, nonatomic, retain) NSString *eventDescription;
@property (nonatomic) int64_t eventId;
@property (nullable, nonatomic, retain) NSString *eventName;
@property (nonatomic) int16_t imageIndex;
@property (nonatomic) BOOL isPartyChanged;
@property (nonatomic) BOOL isPartyDeleted;
@property (nullable, nonatomic, retain) NSString *latitude;
@property (nullable, nonatomic, retain) NSString *longitude;
@property (nonatomic) int64_t startTime;

@end

NS_ASSUME_NONNULL_END
