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

- (void)configureWithUserName:(NSString *)userName;
+ (NSString *)reuseIdentifier;

@end
