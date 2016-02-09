//
//  ViewController.m
//  PartyMaker
//
//  Created by 2 on 2/3/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRTabBarController.h"
#import "PMRMainViewController.h"
#import "PMRParty.h"

@interface PMRTabBarController ()

@property (nonatomic, weak) IBOutlet UITabBarItem *partiesTabBarItem;
@property (nonatomic, weak) IBOutlet UITabBarItem *settingsTabBarItem;

@end

@implementation PMRTabBarController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
