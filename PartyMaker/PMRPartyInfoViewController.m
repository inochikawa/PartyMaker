//
//  PMRPartyInfoViewController.m
//  PartyMaker
//
//  Created by 2 on 2/12/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRPartyInfoViewController.h"

@interface PMRPartyInfoViewController()

@property (nonatomic, weak) IBOutlet UIImageView *logoImageView;

@property (nonatomic, weak) IBOutlet UILabel *eventNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *eventDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventStartTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventEndTimeLabel;


@property (weak, nonatomic) IBOutlet UIView *imageHolderView;

@end

@implementation PMRPartyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageHolderView.layer.borderColor = [UIColor colorWithRed:31/255. green:34/255. blue:39/255. alpha:1].CGColor;
    self.imageHolderView.layer.borderWidth = 3.0f;
    self.imageHolderView.layer.cornerRadius = self.imageHolderView.frame.size.width / 2.;
    
    [self configurePartyInfoView];
}

#pragma mark - IBActions

- (IBAction)onLocationButtonTouchUpInside:(id)sender {
}

- (IBAction)onEditButtonTouchUpInside:(id)sender {
}

- (IBAction)onDeleteButtonTouchUpInside:(id)sender {
}

#pragma mark - Helpers

- (void)configurePartyInfoView {
    self.logoImageView.image = [UIImage imageNamed:self.party.imagePath];
    self.eventNameLabel.text = self.party.eventName;
    self.eventDescriptionLabel.text = [self roundQuatesText:self.party.eventDescription];
}

- (NSString *)roundQuatesText:(NSString *)text {
    NSMutableString *resultText = [[NSMutableString alloc] initWithString:@"\""];
    [resultText appendString:text];
    [resultText appendString:@"\""];
    return resultText;
}

@end
