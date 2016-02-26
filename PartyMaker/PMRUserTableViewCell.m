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
@property (weak, nonatomic) IBOutlet UILabel *userEmailLabel;

@end

@implementation PMRUserTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.userNameLabel.text = nil;
    self.userEmailLabel.text = nil;
}

- (void)configureWithUserName:(NSString *)userName {
    self.userNameLabel.text = userName;
}

+ (NSString *)reuseIdentifier {
    return @"PMRUserTableViewCellIdentifier";
}

@end
