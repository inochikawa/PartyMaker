//
//  PMRAddEventViewController.m
//  PartyMaker
//
//  Created by 2 on 2/3/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRAddEventViewController.h"

@interface PMRAddEventViewController()<UITextFieldDelegate,
                                       UIScrollViewDelegate,
                                       UITextViewDelegate>
@property (nonatomic) UIButton *chooseDateButton;
@property (nonatomic) UIButton *saveButton;
@property (nonatomic) UIButton *cancelButton;

@property (nonatomic) UITextField *eventNameTextField;

@property (nonatomic) UIView *dynamicBall;
@property (nonatomic) UIView *datePickerView;

@property (nonatomic) UILabel *startTimeLabel;
@property (nonatomic) UILabel *endTimeLabel;

@property (nonatomic) UISlider *startTimeSlider;
@property (nonatomic) UISlider *endTimeSlider;

@property (nonatomic) UIScrollView *pageScrollView;
@property (nonatomic) UIPageControl *pageControl;

@property (nonatomic) UITextView *descriptionTextView;
@end

@implementation PMRAddEventViewController

#pragma mark Creating methods

- (void)creareButtons {
    // init chooseButton
    self.chooseDateButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 10, 190, 36)];
    self.chooseDateButton.backgroundColor = [UIColor colorWithRed:239/255. green:177/255. blue:27/255. alpha:1];
    self.chooseDateButton.layer.cornerRadius = 5.;
    self.chooseDateButton.tintColor = [UIColor whiteColor];
    self.chooseDateButton.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Bold" size:16];
    [self.chooseDateButton setTitle:@"CHOOSE DATE" forState:UIControlStateNormal];
    [self.chooseDateButton addTarget:self action:@selector(onChooseDateButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.chooseDateButton addTarget:self action:@selector(onChooseDateButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    
    // init saveButton
    self.saveButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 413.5, 190, 36)];
    self.saveButton.backgroundColor = [UIColor colorWithRed:140/255. green:186/255. blue:29/255. alpha:1];
    self.saveButton.layer.cornerRadius = 5.;
    self.saveButton.tintColor = [UIColor whiteColor];
    self.saveButton.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Bold" size:16];
    [self.saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(onSaveButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    //[self.saveButton addTarget:self action:@selector(onSaveButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    
    //init cancelButton
    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 460.5, 190, 36)];
    self.cancelButton.backgroundColor = [UIColor colorWithRed:236/255. green:71/255. blue:19/255. alpha:1];
    self.cancelButton.layer.cornerRadius = 5.;
    self.cancelButton.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Bold" size:16];
    self.cancelButton.tintColor = [UIColor whiteColor];
    [self.cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(onCancelButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.chooseDateButton];
    [self.view addSubview:self.saveButton];
    [self.view addSubview:self.cancelButton];
}

- (void)createBalls {
    NSArray *ballsFrames = @[[NSValue valueWithCGRect:CGRectMake(10.5, 23,  9, 9)],
                             [NSValue valueWithCGRect:CGRectMake(10.5, 72,  9, 9)],
                             [NSValue valueWithCGRect:CGRectMake(10.5, 119, 9, 9)],
                             [NSValue valueWithCGRect:CGRectMake(10.5, 161, 9, 9)],
                             [NSValue valueWithCGRect:CGRectMake(10.5, 237, 9, 9)],
                             [NSValue valueWithCGRect:CGRectMake(10.5, 356, 9, 9)],
                             [NSValue valueWithCGRect:CGRectMake(10.5, 474, 9, 9)]];
    
    NSArray *logosFrames = @[[NSValue valueWithCGRect:CGRectMake(27, 21,  100, 13)],
                             [NSValue valueWithCGRect:CGRectMake(27, 70,  100, 13)],
                             [NSValue valueWithCGRect:CGRectMake(27, 117, 100, 13)],
                             [NSValue valueWithCGRect:CGRectMake(27, 159, 100, 13)],
                             [NSValue valueWithCGRect:CGRectMake(27, 235, 100, 13)],
                             [NSValue valueWithCGRect:CGRectMake(27, 354, 100, 13)],
                             [NSValue valueWithCGRect:CGRectMake(27, 472, 100, 13)]];
    
    NSArray *logosTexts = @[@"CHOOSE DATE",
                            @"PARTY NAME",
                            @"START",
                            @"END",
                            @"LOGO",
                            @"DESCRIPTION",
                            @"FINAL"];
    
    for (int i = 0; i < 7; i++) {
        [self.view addSubview:[self createBallWithFrame:[[ballsFrames objectAtIndex:i] CGRectValue]]];
    }
    
    for (int i = 0; i < 7; i++) {
        [self.view addSubview:[self createLabelWithText:logosTexts[i] withFrame:[[logosFrames objectAtIndex:i] CGRectValue]]];
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

- (UILabel *)createLabelWithText:(NSString *)text withFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12];
    return label;
}

- (void)createTextField {
    self.eventNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 56.5, 190, 36)];
    self.eventNameTextField.placeholder = @"Your party Name";
    self.eventNameTextField.backgroundColor = [UIColor colorWithRed:35/255. green:37/255. blue:43/255. alpha:1];
    self.eventNameTextField.textColor = [UIColor whiteColor];
    self.eventNameTextField.textAlignment = NSTextAlignmentCenter;
    self.eventNameTextField.layer.cornerRadius = 5.;
    self.eventNameTextField.returnKeyType = UIReturnKeyDone;
    self.eventNameTextField.delegate = self;
    [self.eventNameTextField addTarget:self action:@selector(onEventNameTextFieldTouchDown) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:self.eventNameTextField];
}

- (void)createDatePickerView {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 36)];
    toolbar.barTintColor = [UIColor colorWithRed:68/255. green:73/255. blue:83/255. alpha:1];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(onCancelDatePickerViewBarButtonTouch)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(onDoneDatePickerViewBarButtonTouch)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil];
    cancelButton.tintColor = doneButton.tintColor = [UIColor whiteColor];
    toolbar.items = @[cancelButton, flexibleSpace, doneButton];
    [toolbar sizeToFit];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, toolbar.frame.size.height, self.view.frame.size.width, 200)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.backgroundColor = [UIColor whiteColor];
    [datePicker setMinimumDate:[NSDate date]];
    
    self.datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, datePicker.frame.size.height + toolbar.frame.size.height)];
    
    [self.datePickerView addSubview:toolbar];
    [self.datePickerView addSubview:datePicker];
    
    [self.view addSubview:self.datePickerView];
}

- (void)createKeyboardToolBar {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 36)];
    toolbar.barTintColor = [UIColor colorWithRed:68/255. green:73/255. blue:83/255. alpha:1];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(onCancelKeyboardBarButtonTouch)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(onDoneKeyboardBarButtonTouch)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil];
    cancelButton.tintColor = doneButton.tintColor = [UIColor whiteColor];
    toolbar.items = @[cancelButton, flexibleSpace, doneButton];
    [toolbar sizeToFit];
    
    self.descriptionTextView.inputAccessoryView = toolbar;
}

- (void)createSliders {
    self.startTimeSlider = [[UISlider alloc] initWithFrame:CGRectMake(120, 107, 190, 30)];
    self.startTimeSlider.tintColor = [UIColor colorWithRed:238/255. green:178/255. blue:30/255. alpha:1];
    [self.startTimeSlider addTarget:self action:@selector(onStartTimeSliderTouchDown) forControlEvents:UIControlEventTouchDown];
    // set minimum and maximum time in minutes
    self.startTimeSlider.minimumValue = 0;    // minimum time = 0:00
    self.startTimeSlider.maximumValue = 1409; // maximum time = 23:29
    
    self.endTimeSlider = [[UISlider alloc] initWithFrame:CGRectMake(120, 149.5, 190, 30)];
    self.endTimeSlider.tintColor = [UIColor colorWithRed:238/255. green:178/255. blue:30/255. alpha:1];
    [self.endTimeSlider addTarget:self action:@selector(onEndTimeSliderTouchDown) forControlEvents:UIControlEventTouchDown];
    // set minimum and maximum time in minutes
    self.endTimeSlider.minimumValue = 30;   // minimum time = 0:30
    self.endTimeSlider.maximumValue = 1439; // maximum time = 23:59
    
    self.startTimeSlider.minimumValueImage = [UIImage imageNamed:@"TimePopup"];
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"TimePopup"]];
    self.endTimeSlider.maximumValueImage = [[UIImage alloc] initWithCIImage:ciImage scale:2 orientation:UIImageOrientationUpMirrored];
    
    [self.view addSubview:self.startTimeSlider];
    [self.view addSubview:self.endTimeSlider];
    
    [self.startTimeSlider addTarget:self
                             action:@selector(onStartTimeSliderValueChanged:)
                   forControlEvents:UIControlEventValueChanged];
    
    [self.endTimeSlider addTarget:self
                           action:@selector(onEndTimeSliderValueChanged:)
                 forControlEvents:UIControlEventValueChanged];
    
    [self.startTimeSlider setValue:.3 animated:YES];
    
    self.startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 113, 32.5, 19)];
    self.startTimeLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:10.6];
    self.startTimeLabel.textColor = [UIColor whiteColor];
    self.startTimeLabel.text = @"00:00";
    self.startTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.startTimeLabel];
    
    self.endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(278, 148, 32.5, 32.5)];
    self.endTimeLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:10.6];
    self.endTimeLabel.textColor = [UIColor whiteColor];
    self.endTimeLabel.text = @"00:30";
    self.endTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.endTimeLabel];
}

- (void)createPageControl {
    self.pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(120, 192, 190, 100)];
    self.pageScrollView.pagingEnabled = YES;
    self.pageScrollView.backgroundColor = [UIColor colorWithRed:68/255. green:73/255. blue:83/255. alpha:1];
    self.pageScrollView.layer.cornerRadius = 4.;
    [self.pageScrollView setShowsHorizontalScrollIndicator:NO];
    self.pageScrollView.delegate = self;
    
    for (int i = 0; i < 6 ; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"PartyLogo_Small_%d", i]]];
        float xOffset = (self.pageScrollView.frame.size.width / 2 - imageView.frame.size.width / 2) + i * 190;
        imageView.frame =CGRectMake(xOffset, 9.5, imageView.frame.size.width, imageView.frame.size.height);
        [self.pageScrollView addSubview:imageView];
    }
    
    self.pageScrollView.contentSize = CGSizeMake(190 * 6, 63);
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(120, 272, 190, 20)];
    self.pageControl.numberOfPages = 6;
    self.pageControl.currentPage = 0;
    self.pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.pageControl.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:29/255. green:30/255. blue:36/255. alpha:1];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    
    [self.pageControl addTarget:self
                         action:@selector(onPageChanged:)
               forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.pageScrollView];
    [self.view addSubview:self.pageControl];
}

- (void)createDescriptionTextView {
    UIView *blueLine = [[UIView alloc] initWithFrame:CGRectMake(120, 302.5, 184.5, 5)];
    blueLine.backgroundColor = [UIColor colorWithRed:40/255. green:132/255. blue:175/255. alpha:1];
    
    self.descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(120, 302.5, 184.5, 99.5)];
    self.descriptionTextView.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12];
    self.descriptionTextView.textColor = [UIColor whiteColor];
    self.descriptionTextView.backgroundColor = [UIColor colorWithRed:35/255. green:37/255. blue:43/255. alpha:1];
    self.descriptionTextView.layer.cornerRadius = 4.;
    self.descriptionTextView.delegate = self;
    
    [self.view addSubview:self.descriptionTextView];
    [self.view addSubview:blueLine];
}

#pragma mark ---

#pragma mark Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
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
    NSInteger currentPage = scrollView.contentOffset.x / self.pageScrollView.frame.size.width;
    [self.pageControl setCurrentPage:currentPage];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self moveBallToYCoordinate:354];
    
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
    [self.descriptionTextView resignFirstResponder];
    return YES;
}

#pragma mark ---

#pragma mark OnEvent methods

- (void)onStartTimeSliderValueChanged:(UISlider *)sender {
    self.startTimeLabel.text = [self timeFromMinutes:(int)sender.value];
    
    if (sender.value > self.endTimeSlider.value - 30) {
        self.endTimeSlider.value = sender.value + 30;
        self.endTimeLabel.text = [self timeFromMinutes:(int)self.endTimeSlider.value];
    }
}

- (void)onEndTimeSliderValueChanged:(UISlider *)sender {
    self.endTimeLabel.text = [self timeFromMinutes:(int)sender.value];
    
    if (sender.value < self.startTimeSlider.value + 30) {
        self.startTimeSlider.value = sender.value - 30;
        self.startTimeLabel.text = [self timeFromMinutes:(int)self.startTimeSlider.value];
    }
}

- (void)onChooseDateButtonTouchUpInside {
    __block __weak PMRAddEventViewController *weakSelf = self;
    [UIView animateWithDuration:.3 delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         weakSelf.datePickerView.frame = CGRectMake(0, weakSelf.view.frame.size.height - weakSelf.datePickerView.frame.size.height, weakSelf.datePickerView.frame.size.width, weakSelf.datePickerView.frame.size.height);
                     }
                     completion:nil];
}

- (void)onCancelDatePickerViewBarButtonTouch {
    __block __weak PMRAddEventViewController *weakSelf = self;
    [UIView animateWithDuration:.3 delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         weakSelf.datePickerView.frame = CGRectMake(0, weakSelf.view.frame.size.height, weakSelf.datePickerView.frame.size.width, weakSelf.datePickerView.frame.size.height);
                     }
                     completion:nil];
}

- (void)onDoneDatePickerViewBarButtonTouch {
    UIDatePicker *datePicker = (UIDatePicker *)self.datePickerView.subviews[1];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    
    [self.chooseDateButton setTitle:[dateFormatter stringFromDate:datePicker.date]
                           forState:UIControlStateNormal];
    
    [UIView animateWithDuration:.3 delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         self.datePickerView.frame = CGRectMake(0, self.view.frame.size.height, self.datePickerView.frame.size.width, self.datePickerView.frame.size.height);
                     }
                     completion:nil];
}

- (void)onCancelButtonTouchUpInside {
    if ([self.navigationController isViewLoaded]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        NSLog(@"Error - navigation controller is not loaded");
    }
}

- (void)onCancelKeyboardBarButtonTouch {
    [self.descriptionTextView resignFirstResponder];
}

- (void)onDoneKeyboardBarButtonTouch {
    [self.descriptionTextView resignFirstResponder];
}

- (void)onPageChanged:(UIPageControl *)sender {
    [self moveBallToYCoordinate:235];
    CGPoint contentOffset = CGPointMake(sender.currentPage * self.pageScrollView.frame.size.width, 0);
    [self.pageScrollView setContentOffset:contentOffset animated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.text.length > 100) {
        return NO;
    }
    return YES;
}

- (void)onChooseDateButtonTouchDown {
    [self moveBallToYCoordinate:21];
}

- (void)onSaveButtonTouchDown {
    [self moveBallToYCoordinate:472];
    
    if ([self.chooseDateButton.titleLabel.text  isEqual: @"CHOOSE DATE"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"You aren't select event date!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if ([self.eventNameTextField.text isEqual:@""]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"You aren't input event name!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
}

- (void)onEventNameTextFieldTouchDown {
    [self moveBallToYCoordinate:70];
}

- (void)onStartTimeSliderTouchDown {
    [self moveBallToYCoordinate:117];
}

- (void)onEndTimeSliderTouchDown {
    [self moveBallToYCoordinate:159];
}

#pragma mark ---

#pragma mark Keyboard notifications

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

-(void)keyboardWillHide:(NSNotification*)notification {
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

#pragma mark ---

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

- (NSString *)timeFromMinutes:(int)totalMinutes {
    int minutes = totalMinutes % 60;
    int hours = totalMinutes / 60;
    return [NSString stringWithFormat:@"%02d:%02d",hours, minutes];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    [self creareButtons];
    [self createBalls];
    [self createTextField];
    [self createSliders];
    [self createPageControl];
    [self createDescriptionTextView];
    [self createKeyboardToolBar];
    [self createDatePickerView];
}

@end
