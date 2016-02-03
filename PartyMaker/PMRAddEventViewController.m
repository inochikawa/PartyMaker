//
//  PMRAddEventViewController.m
//  PartyMaker
//
//  Created by 2 on 2/3/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRAddEventViewController.h"

@interface PMRAddEventViewController()
@property (nonatomic) UIButton *chooseDateButton;
@property (nonatomic) UIButton *saveButton;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UIView *dynamicBall;
@end

@implementation PMRAddEventViewController

- (void)initButtons {
    // init chooseButton
    self.chooseDateButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 10, 190, 36)];
    self.chooseDateButton.backgroundColor = [UIColor colorWithRed:239/255. green:177/255. blue:27/255. alpha:1];
    self.chooseDateButton.layer.cornerRadius = 5.;
    self.chooseDateButton.tintColor = [UIColor whiteColor];
    [self.chooseDateButton setTitle:@"Choose date" forState:UIControlStateNormal];
    
    // init saveButton
    self.saveButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 413.5, 190, 36)];
    self.saveButton.backgroundColor = [UIColor colorWithRed:140/255. green:186/255. blue:29/255. alpha:1];
    self.saveButton.layer.cornerRadius = 5.;
    self.saveButton.tintColor = [UIColor whiteColor];
    [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
    
    //init cancelButton
    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 460.5, 190, 36)];
    self.cancelButton.backgroundColor = [UIColor colorWithRed:236/255. green:71/255. blue:19/255. alpha:1];
    self.cancelButton.layer.cornerRadius = 5.;
    self.cancelButton.tintColor = [UIColor whiteColor];
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    
    [self.view addSubview:self.chooseDateButton];
    [self.view addSubview:self.saveButton];
    [self.view addSubview:self.cancelButton];
}

- (void)initBalls {
    NSArray *ballsFrames = @[[NSValue valueWithCGRect:CGRectMake(10.5, 23, 9, 9)],
                             [NSValue valueWithCGRect:CGRectMake(10.5, 72, 9, 9)],
                             [NSValue valueWithCGRect:CGRectMake(10.5, 119, 9, 9)],
                             [NSValue valueWithCGRect:CGRectMake(10.5, 161, 9, 9)],
                             [NSValue valueWithCGRect:CGRectMake(10.5, 237, 9, 9)],
                             [NSValue valueWithCGRect:CGRectMake(10.5, 356, 9, 9)],
                             [NSValue valueWithCGRect:CGRectMake(10.5, 474, 9, 9)]];
    
    for (int i = 0; i < 7; i++) {
        [self.view addSubview:[self createBallWithFrame:[[ballsFrames objectAtIndex:i] CGRectValue]]];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(14.5, 28.5, 1, 452)];
    line.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line];
    
    self.dynamicBall = [[UIView alloc] initWithFrame:CGRectMake(8.5, 21, 13, 13)];
    self.dynamicBall.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.5];
    self.dynamicBall.layer.cornerRadius = self.dynamicBall.frame.size.height / 2.;
    [self.view addSubview:self.dynamicBall];
}

-(UIView *)createBallWithFrame:(CGRect)frame {
    UIView *ball = [[UIView alloc] initWithFrame:frame];
    ball.backgroundColor = [UIColor whiteColor];
    ball.layer.cornerRadius = frame.size.height / 2.;
    return ball;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initButtons];
    [self initBalls];
    
    self.view.backgroundColor = [UIColor colorWithRed:46/255. green:49/255. blue:56/255. alpha:1];
    
    if ([self.navigationController isViewLoaded]) {
        self.navigationController.navigationBar.userInteractionEnabled = NO;
        self.navigationController.navigationBar.tintColor = self.navigationController.navigationBar.barTintColor;
        self.navigationController.navigationItem.leftBarButtonItem.enabled = NO;
    }
    else {
        NSLog(@"Error - navigation controller view is not loaded");
    }
    
    self.title = @"Create party";
    
}

@end
