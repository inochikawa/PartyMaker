//
//  PMRTableViewCell.m
//  PartyMaker
//
//  Created by 2 on 2/11/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRTableViewCell.h"
#import "PMRParty.h"
#import "NSDate+Utility.h"

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
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.logoImageView.image = nil;
    self.eventNameLabel.text = nil;
    self.eventTimeStartLabel.text = nil;
}

+ (NSString *)reuseIdentifier {
    return @"PMRTableViewCellIdentifier";
}

- (void)configureWithName:(NSString *)eventName timeStart:(NSString *)eventTimeStart logo:(UIImage *)logo {
    self.logoImageView.image = logo;
    self.eventNameLabel.text = eventName;
    self.eventTimeStartLabel.text = eventTimeStart;
}

- (void)configureWithParty:(PMRParty *)party {
    NSString *logoName = [NSString stringWithFormat:@"PartyLogo_Small_%d", [party.imageIndex integerValue]];
    
    self.logoImageView.image = [UIImage imageNamed:logoName];
    self.eventNameLabel.text = party.eventName;
    self.eventTimeStartLabel.text = [NSDate stringDateFromSeconds:party.startTime withDateFormat:@"HH:mm"];
    self.partyId = party.eventId;
}

@end
