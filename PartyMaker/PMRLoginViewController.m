//
//  PMRLoginViewController.m
//  PartyMaker
//
//  Created by 2 on 2/15/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRLoginViewController.h"

@interface PMRLoginViewController()

@property (weak, nonatomic) IBOutlet UIView *loginBackgroundView;


@end

@implementation PMRLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginBackgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.loginBackgroundView.layer.borderWidth = 2.0f;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

@end
