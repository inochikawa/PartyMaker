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
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = [NSString stringWithFormat:@"\"%@\" party is about to begin!", party.eventName];
    localNotification.alertAction = @"open party!";
    localNotification.fireDate = [NSDate date];
    localNotification.userInfo = @{ @"eventId" : party.eventId};
    localNotification.repeatInterval = 0;
    localNotification.category = @"LocalNotificationDefaultCategory";
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    UIMutableUserNotificationAction *doneAction = [[UIMutableUserNotificationAction alloc] init];
    doneAction.identifier = @"doneActionIdentifier";
    doneAction.destructive = NO;
    doneAction.title = @"Mark done";
    doneAction.activationMode = UIUserNotificationActivationModeBackground; // UIUserNotificationActivationModeForeground
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

@end
