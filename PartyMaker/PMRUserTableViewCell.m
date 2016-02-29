//
//  PMRUserTableViewCell.m
//  PartyMaker
//
//  Created by 2 on 2/26/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRUserTableViewCell.h"
#import "PMRUser.h"

@interface PMRUserTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation PMRUserTableViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.userNameLabel.text = nil;
}

- (void)configureWithUser:(PMRUser *)user {
    self.userNameLabel.text = user.name;
    self.userId = user.userId;
}

+ (NSString *)reuseIdentifier {
    return @"PMRUserTableViewCellIdentifier";
}

@end
