//
//  PMRParty.m
//  PartyMaker
//
//  Created by Maksim Stecenko on 2/4/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRParty.h"

#define kEventNameKey           @"eventName"
#define kEventDescriptionKey    @"eventDescription"
#define kStartDateKey           @"startDate"
#define kEndDateKey             @"endDate"
#define kImagePathKey           @"imagePath"

@implementation PMRParty

- (instancetype)init {
    self = [super init];
    if (!self) {
        NSLog(@"%s - [Error] - PMRPArty doesn't init.", __PRETTY_FUNCTION__);
        return nil;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (!self) {
        NSLog(@"%s - [Error] - PMRPArty doesn't init.", __PRETTY_FUNCTION__);
        return nil;
    }
    
    self.eventName = [aDecoder decodeObjectForKey:kEventNameKey];
    self.eventDescription = [aDecoder decodeObjectForKey:kEventDescriptionKey];
    self.startDate = [aDecoder decodeObjectForKey:kStartDateKey];
    self.endDate = [aDecoder decodeObjectForKey:kEndDateKey];
    self.imagePath = [aDecoder decodeObjectForKey:kImagePathKey];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.eventName forKey:kEventNameKey];
    [aCoder encodeObject:self.eventDescription forKey:kEventDescriptionKey];
    [aCoder encodeObject:self.startDate forKey:kStartDateKey];
    [aCoder encodeObject:self.endDate forKey:kEndDateKey];
    [aCoder encodeObject:self.imagePath forKey:kImagePathKey];
}

@end
