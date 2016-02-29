//
//  PMRTableViewCell.h
//  PartyMaker
//
//  Created by 2 on 2/11/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMRParty;

@interface PMRPartyTableViewCell : UITableViewCell

@property (nonatomic) NSInteger partyId;

- (void)configureWithParty:(PMRParty *)partyDictionary;
+ (NSString *)reuseIdentifier;

@end
