//
//  PMRParty.h
//  PartyMaker
//
//  Created by 2 on 2/24/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PMRPartyManagedObject;

@interface PMRParty : NSObject

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

- (nullable instancetype)initUsingPartyObject:(PMRPartyManagedObject * _Nullable)partyObject;

@end