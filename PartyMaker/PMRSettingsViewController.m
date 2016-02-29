//
//  PMRSettingsViewController.m
//  PartyMaker
//
//  Created by 2 on 2/24/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRSettingsViewController.h"

@interface PMRSettingsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *developedInformationLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutDeveloperLabel;
@property (weak, nonatomic) IBOutlet UIView *informationBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *signOutButton;

@end

@implementation PMRSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.informationBackgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.informationBackgroundView.layer.borderWidth = 2.0f;
    
    [self.signOutButton setTitle:NSLocalizedStringFromTable(@"SIGN OUT", @"Language", nil) forState:UIControlStateNormal];
    self.versionLabel.text = [NSString stringWithFormat:@"Party Maker 2016 (c) %@: 1.0(1)", NSLocalizedStringFromTable(@"Version", @"Language", nil)];
    self.developedInformationLabel.text = [NSString stringWithFormat:@"%@ Softheme iOS Intership 2016", NSLocalizedStringFromTable(@"Developed for", @"Language", nil)];
    self.aboutDeveloperLabel.text = NSLocalizedStringFromTable(@"Developer: Maksim Stecenko", @"Language", nil);
    
    self.navigationItem.title = NSLocalizedStringFromTable(@"SETTINGS", @"Language", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSignOutButtonTouchUpInside:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}

@end
