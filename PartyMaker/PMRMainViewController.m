//
//  PMRMainViewController.m
//  PartyMaker
//
//  Created by 2 on 2/3/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRMainViewController.h"
#import "PMRAddEventViewController.h"

@implementation PMRMainViewController

- (void)createEventViewController {
    if (![self.navigationController isViewLoaded]) {
        NSLog(@"Error - navigation controller view is not loaded");
        return;
    }
    
    PMRAddEventViewController *addEventViewController = [PMRAddEventViewController new];
    [self.navigationController pushViewController:addEventViewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Main view";
    self.view.backgroundColor = [UIColor grayColor];
    self.view = [[UIView alloc] initWithFrame:self.view.frame];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createEventViewController)];
    rightButton.tintColor = [UIColor grayColor];
    
    self.navigationItem.rightBarButtonItem = rightButton;
}

@end
