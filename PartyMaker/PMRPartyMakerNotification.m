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
    NSDate *partyFireDate = [NSDate dateFromSeconds:party.startTime];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = [NSString stringWithFormat:@"\"%@\" party is about to begin!", party.eventName];
    localNotification.alertAction = @"open party!";
    localNotification.fireDate = [partyFireDate dateByAddingTimeInterval:-3600];
    localNotification.userInfo = @{ @"eventId" : party.eventId};
    localNotification.repeatInterval = 0;
    localNotification.category = @"LocalNotificationDefaultCategory";
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    UIMutableUserNotificationAction *doneAction = [[UIMutableUserNotificationAction alloc] init];
    doneAction.identifier = @"doneActionIdentifier";
    doneAction.destructive = NO;
    doneAction.title = @"Done";
    doneAction.activationMode = UIUserNotificationActivationModeBackground;
    doneAction.authenticationRequired = NO;
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
    category.identifier = @"LocalNotificationDefaultCategory";
    [category setActions:@[doneAction] forContext:UIUserNotificationActionContextMinimal];
    [category setActions:@[doneAction] forContext:UIUserNotificationActionContextDefault];
    
    NSSet *categories = [[NSSet alloc] initWithArray:@[category]];
    
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings
                                                        settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
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
