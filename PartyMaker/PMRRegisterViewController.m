//
//  PMRRegisterViewController.m
//  PartyMaker
//
//  Created by 2 on 2/20/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRRegisterViewController.h"
#import "PMRTextField.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "PMRUser.h"
#import "PMRApiController.h"

@interface PMRRegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet PMRTextField *loginTextField;
@property (weak, nonatomic) IBOutlet PMRTextField *emailTextField;
@property (weak, nonatomic) IBOutlet PMRTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet PMRTextField *repeatPasswordTextField;

@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UIView *registerBackgroundView;

@property (weak, nonatomic) IBOutlet UILabel *helloLabel;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic) BOOL isMainViewSwipedUp;

@end

@implementation PMRRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isMainViewSwipedUp = NO;
    
    self.registerBackgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.registerBackgroundView.layer.borderWidth = 2.0f;
    self.informationLabel.text = @"";
    
    self.helloLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"HELLO", @"Language", nil)];
    [self.cancelButton setTitle:[NSString stringWithFormat:NSLocalizedStringFromTable(@"CANCEL", @"Language", nil)] forState:UIControlStateNormal];
    [self.registerButton setTitle:[NSString stringWithFormat:NSLocalizedStringFromTable(@"REGISTER", @"Language", nil)] forState:UIControlStateNormal];
    
    [self configureTextFields];
}

- (IBAction)onRegisterButtonTouchUpInside:(id)sender {
    if ([self notificateAboutPasswords]) {
        __block __weak PMRRegisterViewController *weakSelf = self;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Loading...", @"Language", nil)];
        
        PMRUser *user = [PMRUser new];
        user.name = weakSelf.loginTextField.text;
        user.password = weakSelf.passwordTextField.text;
        user.email = weakSelf.emailTextField.text;
        
        [[PMRApiController apiController] registerUser:user withCallback:^(NSDictionary *response, NSError *error) {
            [hud hide:YES];
            
            if ([response[@"response"] isEqual:[NSNull null]]) {
                weakSelf.informationLabel.text = NSLocalizedStringFromTable(@"The request is timeout", @"Language", nil);
            }
            else if ([response[@"response"][@"status"] isEqualToString:@"Failed"]) {
                weakSelf.informationLabel.text = NSLocalizedStringFromTable(response[@"response"][@"msg"], @"Language", nil);
            }
            else {
                weakSelf.informationLabel.text = @"";
                user.userId = [response[@"response"][@"id"] integerValue];
                
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                
                NSLog(@"[User sign in] --- %@", response);
            }
        }];
    }
}

- (IBAction)onCancelButtonTouchUpInside:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onLoginTextFieldDidEndOnExit:(id)sender {
    [self.emailTextField becomeFirstResponder];
}

- (IBAction)onEmailTextFieldDidEndOnExit:(id)sender {
    [self.passwordTextField becomeFirstResponder];
}

- (IBAction)onPasswordTextFieldDidEndOnExit:(id)sender {
    [self.repeatPasswordTextField becomeFirstResponder];
}

- (IBAction)onRepeatPasswordEditingDidBegin:(id)sender {
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillShow:)
                                                name:UIKeyboardWillShowNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (IBAction)onRepeatPasswordTextFieldEditingDidEnd:(id)sender {
    [self notificateAboutPasswords];
    [self.repeatPasswordTextField resignFirstResponder];
}

- (IBAction)onPasswordTextFieldEditingDidEnd:(id)sender {
    [self notificateAboutPasswords];
}


#pragma mark - Text field delegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length > 30) {
        textField.text = [textField.text substringWithRange:NSMakeRange(0, 20)];
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.repeatPasswordTextField resignFirstResponder];
    return YES;
}

#pragma mark - Configure methods

- (void)configureTextFields {
    UIColor *color = [UIColor colorWithRed:76/255. green:82/255. blue:92/255. alpha:1];
    
    NSString *loginPlaceholder = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Login", @"Language", nil)];
    NSString *passwordPlaceholder = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Password", @"Language", nil)];
    NSString *emailPlaceholder = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Email", @"Language", nil)];
    NSString *repeatPasswordPlaceholder = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Repeat password", @"Language", nil)];
    
    self.loginTextField.delegate = self;
    self.loginTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:loginPlaceholder
                                                                                attributes:@{NSForegroundColorAttributeName: color}];
    
    self.passwordTextField.delegate = self;
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:passwordPlaceholder
                                                                                   attributes:@{NSForegroundColorAttributeName: color}];
    
    self.emailTextField.delegate = self;
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:emailPlaceholder
                                                                                attributes:@{NSForegroundColorAttributeName: color}];
    
    self.repeatPasswordTextField.delegate = self;
    self.repeatPasswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:repeatPasswordPlaceholder
                                                                                   attributes:@{NSForegroundColorAttributeName: color}];
}

- (BOOL)isPaswordsIdentity {
    NSString *firstPassword = self.passwordTextField.text;
    NSString *secondPassword = self.repeatPasswordTextField.text;
    
    if ([firstPassword isEqualToString:secondPassword]) {
        return YES;
    }
    return NO;
}

- (BOOL)notificateAboutPasswords {
    if (![self isPaswordsIdentity]) {
        self.informationLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Passwords aren't equals.", @"Language", nil)];
        return NO;
    }
    self.informationLabel.text = @"";
    return YES;
}

#pragma mark - Keyboard notifications

- (void)keyboardWillShow:(NSNotification*)notification {
    if (!self.isMainViewSwipedUp) {
        CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect textFieldRect = self.repeatPasswordTextField.frame;
        
        if (CGRectIntersectsRect(textFieldRect, keyboardRect)) {
            float duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
            __block __weak PMRRegisterViewController *weakSelf = self;
            
            [UIView animateWithDuration:duration animations:^{
                CGRect viewFrame = weakSelf.view.frame;
                viewFrame.origin.y -= 50;
                weakSelf.view.frame = viewFrame;
            }];
            self.isMainViewSwipedUp = YES;
        }
    }
}

- (void)keyboardWillHide:(NSNotification*)notification {
    if (self.isMainViewSwipedUp) {
        float duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        __block __weak PMRRegisterViewController *weakSelf = self;
        
        [UIView animateWithDuration:duration animations:^{
            CGRect viewFrame = weakSelf.view.frame;
            viewFrame.origin.y += 50;
            weakSelf.view.frame = viewFrame;
        }];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        self.isMainViewSwipedUp = NO;
    }
}

@end
