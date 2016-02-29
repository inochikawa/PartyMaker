//
//  PMRLoginViewController.m
//  PartyMaker
//
//  Created by 2 on 2/15/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRLoginViewController.h"
#import "PMRApiController.h"
#import "PMRUser.h"
#import <MBProgressHUD/MBProgressHUD.h>

#define kStatusCodeSuccess 200

@interface PMRLoginViewController()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *loginBackgroundView;

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UILabel *helloLabel;

@end

@implementation PMRLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginBackgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.loginBackgroundView.layer.borderWidth = 2.0f;
    self.informationLabel.text = @"";
    
    self.helloLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"HELLO", @"Language", nil)];
    [self.signInButton setTitle:[NSString stringWithFormat:NSLocalizedStringFromTable(@"SIGN IN", @"Language", nil)] forState:UIControlStateNormal];
    [self.registerButton setTitle:[NSString stringWithFormat:NSLocalizedStringFromTable(@"REGISTER", @"Language", nil)] forState:UIControlStateNormal];
    
    [self configureTextFields];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSInteger userId = [[[NSUserDefaults standardUserDefaults]
                         stringForKey:@"userId"] integerValue];
    
    if (userId) {
        [PMRApiController apiController].user.userId = userId;
        [self performSegueWithIdentifier:@"toTabControllerSegue" sender:self];
    }
}

#pragma mark - IBActions

- (IBAction)onSignInButtonTouchUpInside:(id)sender {    
    __block __weak PMRLoginViewController *weakSelf = self;
    __block PMRUser *user = [PMRUser new];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Loading...", @"Language", nil)];
    
    dispatch_async(dispatch_get_main_queue(), ^{        
        user.name = weakSelf.loginTextField.text;
        user.password = weakSelf.passwordTextField.text;
        
        [[PMRApiController apiController] loginUser:user withCallback:^(NSDictionary *response, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
            });
            

            if ([response[@"response"] isEqual:[NSNull null]]) {
                    weakSelf.informationLabel.text = NSLocalizedStringFromTable(@"The request is timeout", @"Language", nil);
            }
            else if ([response[@"response"][@"status"] isEqualToString:@"Failed"]) {
                weakSelf.informationLabel.text = NSLocalizedStringFromTable(response[@"response"][@"msg"], @"Language", nil);
            }
            else {
                weakSelf.informationLabel.text = @"";
                user.userId = [response[@"response"][@"id"] integerValue];
                
                [self writeUserIdToUserDefaults:user.userId];
                
                [weakSelf performSegueWithIdentifier:@"toTabControllerSegue" sender:weakSelf];
                NSLog(@"[User sign in] --- %@", response);
            }
        }];
    });
}

- (IBAction)onLoginTextFieldDidEndOnExit:(id)sender {
    [self.passwordTextField becomeFirstResponder];
}

#pragma mark - Text field delegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length > 20) {
        textField.text = [textField.text substringWithRange:NSMakeRange(0, 20)];
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.passwordTextField resignFirstResponder];
    return YES;
}

#pragma mark - Configure methods

- (void)configureTextFields {
    UIColor *color = [UIColor colorWithRed:76/255. green:82/255. blue:92/255. alpha:1];
    NSString *loginPlaceholder = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Login", @"Language", nil)];
    NSString *passwordPlaceholder = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Password", @"Language", nil)];
    
    self.loginTextField.returnKeyType = UIReturnKeyNext;
    self.loginTextField.delegate = self;
    self.loginTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:loginPlaceholder
                                                                                attributes:@{NSForegroundColorAttributeName: color}];


    
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    self.passwordTextField.delegate = self;
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:passwordPlaceholder
                                                                                attributes:@{NSForegroundColorAttributeName: color}];
}

- (void)writeUserIdToUserDefaults:(NSInteger)userId {
    NSString *userIdStringValue = [NSString stringWithFormat:@"%ld", (long)userId];
    [[NSUserDefaults standardUserDefaults] setObject:userIdStringValue forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
