//
//  PMRAddEventViewController.m
//  PartyMaker
//
//  Created by 2 on 2/8/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRAddEventViewController.h"
#import "PMRParty.h"

#define kTimeDifference     30

@interface PMRAddEventViewController ()<UITextFieldDelegate,
                                        UIScrollViewDelegate,
                                        UITextViewDelegate>

@property (nonatomic) NSMutableString* lastTextViewEditText;

@property (nonatomic, weak) IBOutlet UIButton *chooseDateButton;

@property (nonatomic, weak) IBOutlet UIButton *saveButton;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

@property (nonatomic, weak) IBOutlet UITextField *eventNameTextField;

@property (nonatomic, weak) IBOutlet UIView *dynamicBall;
@property (nonatomic, weak) IBOutlet UIView *datePickerView;

@property (nonatomic, weak) IBOutlet UILabel *startTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *endTimeLabel;

@property (nonatomic, weak) IBOutlet UISlider *startTimeSlider;
@property (nonatomic, weak) IBOutlet UISlider *endTimeSlider;

@property (nonatomic, weak) IBOutlet UIScrollView *imageScrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *imagePageControl;

@property (nonatomic, weak) IBOutlet UITextView *descriptionTextView;

@property (nonatomic, weak) IBOutlet UIDatePicker *datePickerControl;

@property (nonatomic, weak) IBOutlet UIToolbar *datePickerToolBar;
@property (nonatomic, weak) IBOutlet UIToolbar *keyboardToolBar;

@end

@implementation PMRAddEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:46/255. green:49/255. blue:56/255. alpha:1];
    self.title = @"CREATE PARTY";
    
    if ([self.navigationController isViewLoaded]) {
        self.navigationController.navigationBar.userInteractionEnabled = NO;
        self.navigationController.navigationBar.tintColor = self.navigationController.navigationBar.barTintColor;
        self.navigationItem.hidesBackButton = YES;
    }
    else {
        NSLog(@"Error - navigation controller view is not loaded");
    }
    self.lastTextViewEditText = [[NSMutableString alloc] initWithString:@""];
    
    [self configureButtons];
    [self configureDescriptionTextView];
    [self configureEventNameTextField];
    [self configureImagePageControl];
    [self configureImageScrollView];
    [self configureDatePickerView];
    [self configureKeyboardToolBar];
    [self configureDynamicBall];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureButtons {
    self.chooseDateButton.layer.cornerRadius = 5.;
    self.saveButton.layer.cornerRadius = 5.;
    self.cancelButton.layer.cornerRadius = 5.;
}

- (void)configureEventNameTextField {
    self.eventNameTextField.backgroundColor = [UIColor colorWithRed:35/255. green:37/255. blue:43/255. alpha:1];
    self.eventNameTextField.layer.cornerRadius = 5.;
    self.eventNameTextField.returnKeyType = UIReturnKeyDone;
    self.eventNameTextField.delegate = self;
    if ([self.eventNameTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor colorWithRed:76/255. green:82/255. blue:92/255. alpha:1];
        self.eventNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Your party Name"
                                                                                   attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
    }
}

- (void)configureImageScrollView {
    self.imageScrollView.layer.cornerRadius = 4.;
    self.imageScrollView.delegate = self;
    self.imageScrollView.contentSize = CGSizeMake(190 * 6, 63);
    
    for (int i = 0; i < 6 ; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"PartyLogo_Small_%d", i]]];
        float xOffset = (self.imageScrollView.frame.size.width / 2 - imageView.frame.size.width / 2) + i * 190;
        imageView.frame =CGRectMake(xOffset, 9.5, imageView.frame.size.width, imageView.frame.size.height);
        [self.imageScrollView addSubview:imageView];
    }
}

- (void)configureImagePageControl {
    self.imagePageControl.pageIndicatorTintColor = [UIColor colorWithRed:29/255. green:30/255. blue:36/255. alpha:1];
    self.imagePageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
}

- (void)configureDescriptionTextView {
    self.descriptionTextView.layer.cornerRadius = 4.;
    self.descriptionTextView.delegate = self;
}

- (void)configureDatePickerView {
    self.datePickerToolBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 36);
    [self.datePickerToolBar sizeToFit];
    
    self.datePickerControl.frame = CGRectMake(0, self.datePickerToolBar.frame.size.height, self.view.frame.size.width, 219);
    [self.datePickerControl setMinimumDate:[NSDate date]];
    self.datePickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.datePickerControl.frame.size.height + self.datePickerToolBar.frame.size.height);
}

- (void)configureKeyboardToolBar {
        self.keyboardToolBar.frame = CGRectMake(0, 200, self.view.frame.size.width, 36);
        [self.keyboardToolBar sizeToFit];        
        self.descriptionTextView.inputAccessoryView = self.keyboardToolBar;
}

- (void)configureDynamicBall {
    self.dynamicBall.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.5];
    self.dynamicBall.layer.cornerRadius = self.dynamicBall.frame.size.height / 2.;
}

#pragma mark - Keyboard notifications

- (void)keyboardWillShow:(NSNotification*)notification {
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    float duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    __block __weak PMRAddEventViewController *weakSelf = self;
    
    [UIView animateWithDuration:duration animations:^{
        CGRect viewFrame = weakSelf.view.frame;
        viewFrame.origin.y -= keyboardRect.size.height - 100;
        weakSelf.view.frame = viewFrame;
    }];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    __block __weak PMRAddEventViewController *weakSelf = self;
    
    [UIView animateWithDuration:duration animations:^{
        CGRect viewFrame = weakSelf.view.frame;
        viewFrame.origin.y += keyboardRect.size.height - 100;
        weakSelf.view.frame = viewFrame;
    }];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - IBActions

- (IBAction)onSaveButtonTouchUpInside {
    __block __weak PMRAddEventViewController *weakSelf = self;
    [UIView transitionWithView:weakSelf.saveButton duration:.2
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [weakSelf.saveButton setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
                    }
                    completion:nil];
    
    if ([self.chooseDateButton.titleLabel.text  isEqual: @"CHOOSE DATE"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"You did not choose date." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if ([self.eventNameTextField.text isEqual:@""]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"You did not input event name." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    [self saveParty];
    
    if ([self.navigationController isViewLoaded]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        NSLog(@"Error - navigation controller is not loaded");
    }
}

- (IBAction)onCancelButtonTouchUpInside {
    if ([self.navigationController isViewLoaded]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        NSLog(@"Error - navigation controller is not loaded");
    }
}

- (IBAction)onChooseDateButtonTouchUpInside {
    [self.eventNameTextField setUserInteractionEnabled:NO];
    __block __weak PMRAddEventViewController *weakSelf = self;
    [UIView animateWithDuration:.3 delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         weakSelf.datePickerView.frame = CGRectMake(0, weakSelf.view.frame.size.height - weakSelf.datePickerView.frame.size.height, weakSelf.datePickerView.frame.size.width, weakSelf.datePickerView.frame.size.height);
                     }
                     completion:nil];
}

- (IBAction)onStartTimeSliderValueChanged:(UISlider *)sender {
    self.startTimeLabel.text = [self timeFromMinutes:(int)sender.value];
    
    if (sender.value > self.endTimeSlider.value - kTimeDifference) {
        self.endTimeSlider.value = sender.value + kTimeDifference;
        self.endTimeLabel.text = [self timeFromMinutes:(int)self.endTimeSlider.value];
    }
}

- (IBAction)onEndTimeSliderValueChanged:(UISlider *)sender {
    self.endTimeLabel.text = [self timeFromMinutes:(int)sender.value];
    
    if (sender.value < self.startTimeSlider.value + kTimeDifference) {
        self.startTimeSlider.value = sender.value - kTimeDifference;
        self.startTimeLabel.text = [self timeFromMinutes:(int)self.startTimeSlider.value];
    }
}

- (IBAction)onCancelDatePickerViewBarButtonTouch {
    [self.eventNameTextField setUserInteractionEnabled:YES];
    
    __block __weak PMRAddEventViewController *weakSelf = self;
    [UIView animateWithDuration:.3 delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         weakSelf.datePickerView.frame = CGRectMake(0, weakSelf.view.frame.size.height, weakSelf.datePickerView.frame.size.width, weakSelf.datePickerView.frame.size.height);
                     }
                     completion:nil];
}

- (IBAction)onDoneDatePickerViewBarButtonTouch {
    [self.eventNameTextField setUserInteractionEnabled:YES];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    
    [self.chooseDateButton setTitle:[dateFormatter stringFromDate:self.datePickerControl.date]
                           forState:UIControlStateNormal];
    
    [UIView animateWithDuration:.3 delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         self.datePickerView.frame = CGRectMake(0, self.view.frame.size.height, self.datePickerView.frame.size.width, self.datePickerView.frame.size.height);
                     }
                     completion:nil];
}

- (IBAction)onCancelKeyboardBarButtonTouch {
    [self.descriptionTextView resignFirstResponder];
    self.descriptionTextView.text = self.lastTextViewEditText;
}

- (IBAction)onDoneKeyboardBarButtonTouch {
    [self.descriptionTextView resignFirstResponder];
    [self.lastTextViewEditText setString:@""];
    [self.lastTextViewEditText appendString:self.descriptionTextView.text];
}

- (IBAction)onEventNameTextFieldTouchDown {
    [self.chooseDateButton setUserInteractionEnabled:NO];
}

- (IBAction)moveBallToElement:(id)sender {
    CGRect elementFrame = CGRectMake(((UIControl *)sender).frame.origin.x, ((UIControl *)sender).frame.origin.y, ((UIControl *)sender).frame.size.width, ((UIControl *)sender).frame.size.height);
    float yCoordinate = elementFrame.origin.y + elementFrame.size.height / 2 - self.dynamicBall.frame.size.height / 2;
    __block __weak PMRAddEventViewController *weakSelf = self;
    [UIView animateWithDuration:.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         weakSelf.dynamicBall.frame = CGRectMake(weakSelf.dynamicBall.frame.origin.x, yCoordinate, weakSelf.dynamicBall.frame.size.width, weakSelf.dynamicBall.frame.size.height);
                     }
                     completion:nil];
}

#pragma mark - Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.chooseDateButton setUserInteractionEnabled:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length > 20) {
        return NO;
    }
    else {
        return YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self moveBallToYCoordinate:235];
    NSInteger currentPage = scrollView.contentOffset.x / self.imageScrollView.frame.size.width;
    [self.imagePageControl setCurrentPage:currentPage];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self moveBallToYCoordinate:354];
    [self.imageScrollView setUserInteractionEnabled:NO];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillShow:)
                                                name:UIKeyboardWillShowNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [self.imageScrollView setUserInteractionEnabled:YES];
    [self.descriptionTextView resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.text.length > 100) {
        return NO;
    }
    return YES;
}

#pragma mark - Helpers

- (NSString *)timeFromMinutes:(int)totalMinutes {
    int minutes = totalMinutes % 60;
    int hours = totalMinutes / 60;
    return [NSString stringWithFormat:@"%02d:%02d",hours, minutes];
}

- (void)saveParty {
    PMRParty *party = [PMRParty new];
    party.eventName = self.eventNameTextField.text;
    party.eventDescription = self.descriptionTextView.text;
    party.startDate = [self selectedDateWithTime:self.startTimeLabel.text];
    party.endDate = [self selectedDateWithTime:self.endTimeLabel.text];
    party.imagePath = [self selectedImagePath];
    [party save];
}

- (NSDate *)selectedDateWithTime:(NSString *)time {
    NSDate *date = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date];
    NSArray *timeArray = [time componentsSeparatedByString:@":"];
    [components setHour: (NSInteger)timeArray[0]];
    [components setMinute: (NSInteger)timeArray[1]];
    [components setSecond: 00];
    
    return [gregorian dateFromComponents: components];
}

- (NSString *)selectedImagePath {
    NSInteger selectedImageIndex = self.imageScrollView.contentOffset.x / self.imageScrollView.frame.size.width;
    return [NSString stringWithFormat:@"PartyLogo_Small_%ld", (long)selectedImageIndex ];
}

- (void)moveBallToYCoordinate:(float)yCoordinate {
    __block __weak PMRAddEventViewController *weakSelf = self;
    [UIView animateWithDuration:.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         weakSelf.dynamicBall.frame = CGRectMake(weakSelf.dynamicBall.frame.origin.x, yCoordinate, weakSelf.dynamicBall.frame.size.width, weakSelf.dynamicBall.frame.size.height);
                     }
                     completion:nil];
}

-(UIView *)createBallWithFrame:(CGRect)frame {
    UIView *ball = [[UIView alloc] initWithFrame:frame];
    ball.backgroundColor = [UIColor whiteColor];
    ball.layer.cornerRadius = frame.size.height / 2.;
    return ball;
}

- (UILabel *)createLabelWithText:(NSString *)text withFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12];
    return label;
}

@end
