//
//  ViewController.m
//  PartyMaker
//
//  Created by 2 on 2/3/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRViewController.h"
#import "PMRMainViewController.h"
#import "PMRParty.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    PMRMainViewController *mainViewController = [PMRMainViewController new];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    navigationController.view.backgroundColor = [UIColor colorWithRed:46/255. green:49/255. blue:56/255. alpha:1];
    navigationController.navigationBar.barTintColor = [UIColor colorWithRed:68/255. green:73/255. blue:83/255. alpha:1];
    navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [self presentViewController:navigationController animated:NO completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [PMRParty loadAllPatries];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
