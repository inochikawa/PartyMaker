//
//  PMRPartyInfoViewController.m
//  PartyMaker
//
//  Created by 2 on 2/12/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRPartyInfoViewController.h"
#import "PMRAddEventViewController.h"
#import "NSDate+Utility.h"
#import "PMRDataStorage.h"

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configurePartyInfoView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PartyInfoViewControllerToAddEventViewController"]) {
        PMRAddEventViewController *addEventViewController = segue.destinationViewController;
        addEventViewController.party = self.party;
    }
}

#pragma mark - IBActions

- (IBAction)onLocationButtonTouchUpInside:(id)sender {
}

- (IBAction)onEditButtonTouchUpInside:(id)sender {
}

- (IBAction)onDeleteButtonTouchUpInside:(id)sender {
    NSArray *parties = [PMRDataStorage dataStorage].parties;
    
    for (PMRParty *party in parties) {
        if ([party.Id isEqualToString:self.party.Id]) {
            [[PMRDataStorage dataStorage].parties removeObject:party];
            break;
        }
    }
    
    if ([self.navigationController isViewLoaded]) {
        [self.navigationController popViewControllerAnimated:YES];
        [[PMRDataStorage dataStorage] savePlistFile];
    }
    else {
        NSLog(@"[Error] - Navigation controller isn't loaded");
    }
}

#pragma mark - Helpers

- (void)configurePartyInfoView {
    self.logoImageView.image = [UIImage imageNamed:self.party.imagePath];
    self.eventNameLabel.text = self.party.eventName;
    self.eventDescriptionLabel.text = [self roundQuatesText:self.party.eventDescription];
    self.eventDateLabel.text = [self.party.startDate toStringWithDateFormat:@"dd.MM.yyyy"];
    self.eventStartTimeLabel.text = [self.party.startDate toStringWithDateFormat:@"HH:mm"];
    self.eventEndTimeLabel.text = [self.party.endDate toStringWithDateFormat:@"HH:mm"];
}

- (NSString *)roundQuatesText:(NSString *)text {
    if ([text isEqualToString:@""]) {
        return @"";
    }
    
    NSMutableString *resultText = [[NSMutableString alloc] initWithString:@"\""];
    [resultText appendString:text];
    [resultText appendString:@"\""];
    return resultText;
}

@end
