//
//  PMRSettingsViewController.m
//  PartyMaker
//
//  Created by 2 on 2/24/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRSettingsViewController.h"

@interface PMRSettingsViewController ()

@end

@implementation PMRSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedStringFromTable(@"SETTINGS", @"Language", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
