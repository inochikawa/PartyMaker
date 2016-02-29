//
//  PMRUserTableViewCell.h
//  PartyMaker
//
//  Created by 2 on 2/26/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMRUser;

@interface PMRUserTableViewCell : UITableViewCell

@property (nonatomic) NSInteger userId;

- (void)configureWithUser:(PMRUser *)user;
+ (NSString *)reuseIdentifier;

@end
