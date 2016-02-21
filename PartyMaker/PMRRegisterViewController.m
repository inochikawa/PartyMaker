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

#define kStatusCodeUserExist 400

@interface PMRRegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet PMRTextField *loginTextField;
@property (weak, nonatomic) IBOutlet PMRTextField *emailTextField;
@property (weak, nonatomic) IBOutlet PMRTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet PMRTextField *repeatPasswordTextField;

@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UIView *registerBackgroundView;

@property (nonatomic) BOOL isMainViewSwipedUp;

@end

@implementation PMRRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isMainViewSwipedUp = NO;
    
    self.registerBackgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.registerBackgroundView.layer.borderWidth = 2.0f;
    self.informationLabel.text = @"";
    
    [self configureTextFields];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onRegisterButtonTouchUpInside:(id)sender {
    __block __weak PMRRegisterViewController *weakSelf = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    
    dispatch_async(dispatch_get_main_queue(), ^{
        PMRUser *user = [[PMRApiController apiController] createInstanseForUser];
        user.name = weakSelf.loginTextField.text;
        user.password = weakSelf.passwordTextField.text;
        user.email = weakSelf.emailTextField.text;
        
        [[PMRApiController apiController] registerUser:user withCallback:^(NSDictionary *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
            });
            
            if ([response[@"statusCode"] integerValue] == kStatusCodeUserExist) {
                weakSelf.informationLabel.text = @"User exists or data is wrong";
            } else {
                weakSelf.informationLabel.text = @"";
                // have to write smth to notificate user that he was registered successfully.
                NSLog(@"[User registered] --- %@", response);
                [weakSelf performSegueWithIdentifier:@"toLoginViewControllerSegue" sender:weakSelf];
            }
        }];
    });
}

- (IBAction)onCancelButtonTouchUpInside:(id)sender {
    [self performSegueWithIdentifier:@"toLoginViewControllerSegue" sender:self];
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
    if (textField.text.length > 20) {
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
    
    self.loginTextField.delegate = self;
    self.loginTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Login"
                                                                                attributes:@{NSForegroundColorAttributeName: color}];
    
    
    
    self.passwordTextField.delegate = self;
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password"
                                                                                   attributes:@{NSForegroundColorAttributeName: color}];
    
    self.emailTextField.delegate = self;
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email"
                                                                                attributes:@{NSForegroundColorAttributeName: color}];
    
    
    
    self.repeatPasswordTextField.delegate = self;
    self.repeatPasswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Repeat password"
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

- (void)notificateAboutPasswords {
    if (![self isPaswordsIdentity]) {
        self.informationLabel.text = @"Passwords aren't equals.";
    }
    else {
        self.informationLabel.text = @"";
    }
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
