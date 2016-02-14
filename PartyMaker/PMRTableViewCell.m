//
//  PMRTableViewCell.m
//  PartyMaker
//
//  Created by 2 on 2/11/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRTableViewCell.h"

@interface PMRTableViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *logoImageView;
@property (nonatomic, weak) IBOutlet UILabel *eventNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *eventTimeStartLabel;

@end

@implementation PMRTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

+ (NSString *)reuseIdentifier {
    return @"PMRTableViewCellIdentifier";
}

- (void)configureWithName:(NSString *)eventName timeStart:(NSString *)eventTimeStart logo:(UIImage *)logo {
    self.logoImageView.image = logo;
    self.eventNameLabel.text = eventName;
    self.eventTimeStartLabel.text = eventTimeStart;
}

@end
