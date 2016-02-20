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
    //self.errorLabel.text = @"";
    
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
    [PMRUser user].name = self.loginTextField.text;
    [PMRUser user].password = self.passwordTextField.text;
    
    [[PMRApiController apiController] loginUser:[PMRUser user] withCallback:^(NSDictionary *response, NSError *error) {
        if ([response[@"statusCode"] integerValue] == kStatusCodeUserExist) {
            self.errorLabel.text = @"Invalid login or password";
        } else {
            //self.errorLabel.text = @"";
            [PMRUser user].userId = @([response[@"response"][@"id"] integerValue]);
            [self performSegueWithIdentifier:@"toTabControllerSegue" sender:self];
            NSLog(@"[User sign in] --- %@", response);
        }
    }];
}

- (IBAction)onRegisterButtonTouchUpInside:(id)sender {
    [PMRUser user].name = self.loginTextField.text;
    [PMRUser user].password = self.passwordTextField.text;
    [PMRUser user].email = @"lololo1456789";
    
    [[PMRApiController apiController] registerUser:[PMRUser user] withCallback:^(NSDictionary *response, NSError *error) {
        if ([response[@"statusCode"] integerValue] == kStatusCodeUserExist) {
            self.errorLabel.text = @"User exists or data is wrong";
        } else {
            self.errorLabel.text = @"";
            // have to write smth to notificate user that he was registered successfully.
            NSLog(@"[User registered] --- %@", response);
        }
    }];
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
