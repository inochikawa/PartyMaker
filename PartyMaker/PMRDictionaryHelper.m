//
//  PMRPartyDictionaryHelper.m
//  PartyMaker
//
//  Created by 2 on 2/22/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRDictionaryHelper.h"
#import "PMRParty.h"

#define kPartyEventId            @"id"
#define kPartyEventName          @"name"
#define kPartyEventDescription   @"comment"
#define kPartyCreatorId          @"creator_id"
#define kPartyStartTime          @"start_time"
#define kPartyEndTime            @"end_time"
#define kPartyImageIndex         @"logo_id"
#define kPartyIsChanged          @"isPartyChahged"
#define kPartyIsDeleted          @"isPartyDeleted"
#define kPartyLatitude           @"latitude"
#define kPartyLongitude          @"longitude"

@implementation PMRDictionaryHelper

+ (NSDictionary *)basePartyDictionary:(PMRParty *)party {
    return @{kPartyEventName:[party.eventName copy],
             kPartyEventDescription:[party.eventDescription copy],
             kPartyStartTime:[party.startTime copy],
             kPartyEndTime:[party.endTime copy],
             kPartyImageIndex:[party.imageIndex copy]};
}

+ (NSDictionary *)fullPartyDictionary:(PMRParty *)party {
    return @{kPartyEventName:[party.eventName copy],
             kPartyEventDescription:[party.eventDescription copy],
             kPartyEventId:[party.eventId copy],
             kPartyStartTime:[party.startTime copy],
             kPartyEndTime:[party.endTime copy],
             kPartyImageIndex:[party.imageIndex copy],
             kPartyCreatorId:[party.creatorId copy],
             kPartyLatitude:@"",
             kPartyLongitude:@"",
             kPartyIsChanged:[party.isPartyChanged copy],
             kPartyIsDeleted:[party.isPartyDeleted copy]};
}

@end
