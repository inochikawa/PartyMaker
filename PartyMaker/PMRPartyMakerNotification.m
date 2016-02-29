//
//  PMRPartyMakerNotification.m
//  PartyMaker
//
//  Created by 2 on 2/21/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRPartyMakerNotification.h"
#import "PMRParty.h"
#import "NSDate+Utility.h"

@implementation PMRPartyMakerNotification

+ (void)createNewLocalNotificationForParty:(PMRParty *)party {
    NSDate *partyFireDate = [NSDate dateFromSeconds:(NSInteger)party.startTime];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = [NSString stringWithFormat:@"\"%@\" party is about to begin!", party.eventName];
    localNotification.fireDate = [partyFireDate dateByAddingTimeInterval:-3600];
    localNotification.repeatInterval = 0;
    localNotification.category = @"LocalNotificationDefaultCategory";
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

+ (void)createNewLocalNotificationsForParties:(NSArray *)parties {
    for (PMRParty *party in parties) {
        [self createNewLocalNotificationForParty:party];
    }
}

+ (void)deleteAllLocalNotifications {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    for (int i=0; i<[eventArray count]; i++) {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        [app cancelLocalNotification:oneEvent];
    }
}

@end
