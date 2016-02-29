//
//  PMRPartyInfoViewController.h
//  PartyMaker
//
//  Created by 2 on 2/12/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMRParty;

@interface PMRPartyInfoViewController : UIViewController

@property (nonatomic, weak) PMRParty *party;
@property (nonatomic) BOOL needHideButtons;

@end
