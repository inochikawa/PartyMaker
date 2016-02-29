//
//  PMRPartyInfoViewController.m
//  PartyMaker
//
//  Created by 2 on 2/12/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRPartyInfoViewController.h"
#import "PMRAddEventViewController.h"
#import "PMRLocationViewController.h"
#import "NSDate+Utility.h"
#import "PMRApiController.h"
#import "PMRParty.h"

@interface PMRPartyInfoViewController()

@property (nonatomic, weak) IBOutlet UIImageView *logoImageView;

@property (nonatomic, weak) IBOutlet UILabel *eventNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *eventDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventStartTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventEndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;

@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;

@property (weak, nonatomic) IBOutlet UIView *imageHolderView;

@end

@implementation PMRPartyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBackBarButton];
    [self configurePartyInfoView];
    
    if (self.needHideButtons) {
        [self.locationButton removeFromSuperview];
        [self.editButton removeFromSuperview];
        [self.deleteButton removeFromSuperview];
    }
    else {
        [self.locationButton setTitle:NSLocalizedStringFromTable(@"LOCATION", @"Language", nil) forState:UIControlStateNormal];
        [self.editButton setTitle:NSLocalizedStringFromTable(@"EDIT", @"Language", nil) forState:UIControlStateNormal];
        [self.deleteButton setTitle:NSLocalizedStringFromTable(@"DELETE", @"Language", nil) forState:UIControlStateNormal];
    }
    
    self.imageHolderView.layer.borderColor = [UIColor colorWithRed:31/255. green:34/255. blue:39/255. alpha:1].CGColor;
    self.imageHolderView.layer.borderWidth = 3.0f;
    self.imageHolderView.layer.cornerRadius = self.imageHolderView.frame.size.width / 2.;
    
    self.navigationItem.title = NSLocalizedStringFromTable(@"PARTY INFO", @"Language", nil);
    self.dateLabel.text = NSLocalizedStringFromTable(@"DATE", @"Language", nil);
    self.startLabel.text = NSLocalizedStringFromTable(@"START", @"Language", nil);
    self.endLabel.text = NSLocalizedStringFromTable(@"END", @"Language", nil);
}

- (void)configureBackBarButton {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedStringFromTable(@"Back", @"Language", nil)]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
    [backButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor colorWithRed:29/255. green:31/255. blue:36/255. alpha:1], NSForegroundColorAttributeName, [UIFont fontWithName:@"MyriadPro-Regular" size:16], NSFontAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.backBarButtonItem = backButton;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PartyInfoViewControllerToAddEventViewController"]) {
        PMRAddEventViewController *addEventViewController = segue.destinationViewController;
        addEventViewController.party = self.party;
    }
    if ([segue.identifier isEqualToString:@"partyInfoViewControllerToLocationViewController"]) {
        PMRLocationViewController *locationViewController = segue.destinationViewController;
        locationViewController.party = self.party;
        locationViewController.editingMode = NO;
    }
}

#pragma mark - IBActions

- (IBAction)onDeleteButtonTouchUpInside:(id)sender {
    __block __weak PMRPartyInfoViewController *weakSelf = self;
    [[PMRApiController apiController] deletePartyWithPartyId:self.party.eventId withCreatorId:self.party.creatorId withCallback:^{
        if ([weakSelf.navigationController isViewLoaded]) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else {
            NSLog(@"[Error] - Navigation controller isn't loaded");
        }
    }];
}

#pragma mark - Helpers

- (void)configurePartyInfoView {
    NSString *imageName = [NSString stringWithFormat:@"PartyLogo_Small_%d", self.party.imageIndex];
    self.logoImageView.image = [UIImage imageNamed:imageName];
    self.eventNameLabel.text = self.party.eventName;
    self.eventDescriptionLabel.text = [self roundQuatesText:self.party.eventDescription];
    self.eventDateLabel.text = [NSDate stringDateFromSeconds:self.party.startTime withDateFormat:@"dd.MM.yyyy"];
    self.eventStartTimeLabel.text = [NSDate stringDateFromSeconds:self.party.startTime withDateFormat:@"HH:mm"];
    self.eventEndTimeLabel.text = [NSDate stringDateFromSeconds:self.party.endTime withDateFormat:@"HH:mm"];
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
