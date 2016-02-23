//
//  PMRTableViewCell.h
//  PartyMaker
//
//  Created by 2 on 2/11/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMRParty;

@interface PMRTableViewCell : UITableViewCell

@property (nonatomic) NSNumber *partyId;

- (void)configureWithName:(NSString *)eventName timeStart:(NSString *)eventTimeStart logo:(UIImage *)logo;
- (void)configureWithPartyDictionary:(NSDictionary *)partyDictionary;
+ (NSString *)reuseIdentifier;

@end
