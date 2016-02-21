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

#define kStatusCodeUserExist 400

@interface PMRLoginViewController()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *loginBackgroundView;

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end

@implementation PMRLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginBackgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.loginBackgroundView.layer.borderWidth = 2.0f;
    self.errorLabel.text = @"";
    
    [self configureTextFields];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - IBActions

- (IBAction)onSignInButtonTouchUpInside:(id)sender {
    __block __weak PMRLoginViewController *weakSelf = self;
    __block PMRUser *user = [[PMRApiController apiController] createInstanseForUser];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    
    dispatch_async(dispatch_get_main_queue(), ^{        
        user.name = weakSelf.loginTextField.text;
        user.password = weakSelf.passwordTextField.text;
        
        [[PMRApiController apiController] loginUser:user withCallback:^(NSDictionary *response, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
            });
            
            if ([response[@"statusCode"] integerValue] == kStatusCodeUserExist) {
                weakSelf.errorLabel.text = @"Invalid login or password";
            } else {
                weakSelf.errorLabel.text = @"";
                user.userId = @([response[@"response"][@"id"] integerValue]);
                [weakSelf performSegueWithIdentifier:@"toTabControllerSegue" sender:self];
                NSLog(@"[User sign in] --- %@", response);
            }
        }];
    });
}

- (IBAction)onRegisterButtonTouchUpInside:(id)sender {
    
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
    
    self.loginTextField.returnKeyType = UIReturnKeyNext;
    self.loginTextField.delegate = self;
    self.loginTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Login"
                                                                                attributes:@{NSForegroundColorAttributeName: color}];


    
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    self.passwordTextField.delegate = self;
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password"
                                                                                attributes:@{NSForegroundColorAttributeName: color}];
}

@end
