//
//  PMRPartyMakerNotification.h
//  PartyMaker
//
//  Created by 2 on 2/21/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMRParty;

@interface PMRPartyMakerNotification : UILocalNotification

+ (void)createNewLocalNotificationForParty:(PMRParty *)party;
+ (void)createNewLocalNotificationsForParties:(NSArray *)parties;
+ (void)deleteAllLocalNotifications;

@end
