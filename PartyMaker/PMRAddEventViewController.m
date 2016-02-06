//
//  PMRAddEventViewController.m
//  PartyMaker
//
//  Created by 2 on 2/3/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRAddEventViewController.h"
#import "PMRParty.h"

#define kTimeDifference     30
#define fMyriadProRegular   @"MyriadPro-Regular"
#define fMyriadProBold      @"MyriadPro-Bold"

@interface PMRAddEventViewController()<UITextFieldDelegate,
                                       UIScrollViewDelegate,
                                       UITextViewDelegate>

@property (nonatomic, weak) UIButton *chooseDateButton;
@property (nonatomic, weak) UIButton *saveButton;
@property (nonatomic, weak) UIButton *cancelButton;

@property (nonatomic, weak) UITextField *eventNameTextField;

@property (nonatomic, weak) UIView *dynamicBall;
@property (nonatomic, weak) UIView *datePickerView;

@property (nonatomic, weak) UILabel *startTimeLabel;
@property (nonatomic, weak) UILabel *endTimeLabel;

@property (nonatomic, weak) UISlider *startTimeSlider;
@property (nonatomic, weak) UISlider *endTimeSlider;

@property (nonatomic, weak) UIScrollView *pageScrollView;
@property (nonatomic, weak) UIPageControl *pageControl;

@property (nonatomic, weak) UITextView *descriptionTextView;

@property (nonatomic) NSMutableString* lastTextViewEditText;
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
    
    [self creareButtons];
    [self createBalls];
    [self createEventNameTextField];
    [self createSliders];
    [self createPageControl];
    [self createDescriptionTextView];
    [self createKeyboardToolBar];
    [self createDatePickerView];
}

#pragma mark - Creating methods

- (void)creareButtons {
    // init chooseButton
    UIButton *chooseDateButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 10, 190, 36)];
    chooseDateButton.backgroundColor = [UIColor colorWithRed:239/255. green:177/255. blue:27/255. alpha:1];
    chooseDateButton.layer.cornerRadius = 5.;
    [chooseDateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [chooseDateButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:.5] forState:UIControlStateSelected];
    chooseDateButton.titleLabel.font = [UIFont fontWithName:fMyriadProBold size:16];
    [chooseDateButton setTitle:@"CHOOSE DATE" forState:UIControlStateNormal];
    [chooseDateButton addTarget:self action:@selector(onChooseDateButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [chooseDateButton addTarget:self action:@selector(onChooseDateButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:chooseDateButton];
    self.chooseDateButton = chooseDateButton;
    
    // init saveButton
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 413.5, 190, 36)];
    saveButton.backgroundColor = [UIColor colorWithRed:140/255. green:186/255. blue:29/255. alpha:1];
    saveButton.layer.cornerRadius = 5.;
    saveButton.tintColor = [UIColor whiteColor];
    saveButton.titleLabel.font = [UIFont fontWithName:fMyriadProBold size:16];
    [saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(onSaveButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [saveButton addTarget:self action:@selector(onSaveButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    self.saveButton = saveButton;
    
    
    //init cancelButton
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 460.5, 190, 36)];
    cancelButton.backgroundColor = [UIColor colorWithRed:236/255. green:71/255. blue:19/255. alpha:1];
    cancelButton.layer.cornerRadius = 5.;
    cancelButton.titleLabel.font = [UIFont fontWithName:fMyriadProBold size:16];
    cancelButton.tintColor = [UIColor whiteColor];
    [cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(onCancelButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton addTarget:self action:@selector(onCancelButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:cancelButton];
    self.cancelButton = cancelButton;
    
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
    
    UIView *dynamicBall = [[UIView alloc] initWithFrame:CGRectMake(8.5, 21, 13, 13)];
    dynamicBall.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.5];
    dynamicBall.layer.cornerRadius = dynamicBall.frame.size.height / 2.;
    [self.view addSubview:dynamicBall];
    self.dynamicBall = dynamicBall;
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
    label.font = [UIFont fontWithName:fMyriadProRegular size:12];
    return label;
}

- (void)createEventNameTextField {
    UITextField *eventNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 56.5, 190, 36)];
    eventNameTextField.backgroundColor = [UIColor colorWithRed:35/255. green:37/255. blue:43/255. alpha:1];
    eventNameTextField.font = [UIFont fontWithName:fMyriadProRegular size:16];
    eventNameTextField.textColor = [UIColor whiteColor];
    eventNameTextField.textAlignment = NSTextAlignmentCenter;
    eventNameTextField.layer.cornerRadius = 5.;
    eventNameTextField.returnKeyType = UIReturnKeyDone;
    eventNameTextField.delegate = self;
    [eventNameTextField addTarget:self action:@selector(onEventNameTextFieldTouchDown) forControlEvents:UIControlEventTouchDown];
    if ([eventNameTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor colorWithRed:76/255. green:82/255. blue:92/255. alpha:1];
        eventNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Your party Name"
                                                                                   attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
    }
    [self.view addSubview:eventNameTextField];
    self.eventNameTextField = eventNameTextField;
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
    
    UIView *datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, datePicker.frame.size.height + toolbar.frame.size.height)];
    
    [datePickerView addSubview:toolbar];
    [datePickerView addSubview:datePicker];
    
    [self.view addSubview:datePickerView];
    self.datePickerView = datePickerView;
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
    UISlider *startTimeSlider = [[UISlider alloc] initWithFrame:CGRectMake(120, 107, 190, 30)];
    startTimeSlider.tintColor = [UIColor colorWithRed:238/255. green:178/255. blue:30/255. alpha:1];
    [startTimeSlider addTarget:self action:@selector(onStartTimeSliderTouchDown) forControlEvents:UIControlEventTouchDown];
    // set minimum and maximum time in minutes
    startTimeSlider.minimumValue = 0;    // minimum time = 0:00
    startTimeSlider.maximumValue = 1409; // maximum time = 23:29
    
    UISlider *endTimeSlider = [[UISlider alloc] initWithFrame:CGRectMake(120, 149.5, 190, 30)];
    endTimeSlider.tintColor = [UIColor colorWithRed:238/255. green:178/255. blue:30/255. alpha:1];
    [endTimeSlider addTarget:self action:@selector(onEndTimeSliderTouchDown) forControlEvents:UIControlEventTouchDown];
    // set minimum and maximum time in minutes
    endTimeSlider.minimumValue = 30;   // minimum time = 0:30
    endTimeSlider.maximumValue = 1439; // maximum time = 23:59
    
    startTimeSlider.minimumValueImage = [UIImage imageNamed:@"TimePopup"];
    endTimeSlider.maximumValueImage = [UIImage imageNamed:@"TimePopup_1"];
    
    [self.view addSubview:startTimeSlider];
    [self.view addSubview:endTimeSlider];
    
    [startTimeSlider addTarget:self
                             action:@selector(onStartTimeSliderValueChanged:)
                   forControlEvents:UIControlEventValueChanged];
    
    [endTimeSlider addTarget:self
                           action:@selector(onEndTimeSliderValueChanged:)
                 forControlEvents:UIControlEventValueChanged];
    
    [startTimeSlider setValue:.3 animated:YES];
    
    UILabel *startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 113, 32.5, 19)];
    startTimeLabel.font = [UIFont fontWithName:fMyriadProRegular size:10.6];
    startTimeLabel.textColor = [UIColor whiteColor];
    startTimeLabel.text = @"00:00";
    startTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:startTimeLabel];
    
    UILabel *endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(278, 148, 32.5, 32.5)];
    endTimeLabel.font = [UIFont fontWithName:fMyriadProRegular size:10.6];
    endTimeLabel.textColor = [UIColor whiteColor];
    endTimeLabel.text = @"00:30";
    endTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:endTimeLabel];
    
    self.startTimeSlider = startTimeSlider;
    self.startTimeLabel = startTimeLabel;
    self.endTimeSlider = endTimeSlider;
    self.endTimeLabel = endTimeLabel;
}

- (void)createPageControl {
    UIScrollView *pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(120, 192, 190, 100)];
    pageScrollView.pagingEnabled = YES;
    pageScrollView.backgroundColor = [UIColor colorWithRed:68/255. green:73/255. blue:83/255. alpha:1];
    pageScrollView.layer.cornerRadius = 4.;
    [pageScrollView setShowsHorizontalScrollIndicator:NO];
    pageScrollView.delegate = self;
    
    for (int i = 0; i < 6 ; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"PartyLogo_Small_%d", i]]];
        float xOffset = (pageScrollView.frame.size.width / 2 - imageView.frame.size.width / 2) + i * 190;
        imageView.frame =CGRectMake(xOffset, 9.5, imageView.frame.size.width, imageView.frame.size.height);
        [pageScrollView addSubview:imageView];
    }
    
    pageScrollView.contentSize = CGSizeMake(190 * 6, 63);
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(120, 272, 190, 20)];
    pageControl.numberOfPages = 6;
    pageControl.currentPage = 0;
    pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    pageControl.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:29/255. green:30/255. blue:36/255. alpha:1];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [pageControl setUserInteractionEnabled:NO];
    
    [pageControl addTarget:self
                         action:@selector(onPageChanged:)
               forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:pageScrollView];
    [self.view addSubview:pageControl];
    
    self.pageControl = pageControl;
    self.pageScrollView = pageScrollView;
}

- (void)createDescriptionTextView {
    UIView *blueLine = [[UIView alloc] initWithFrame:CGRectMake(120, 302.5, 184.5, 5)];
    blueLine.backgroundColor = [UIColor colorWithRed:40/255. green:132/255. blue:175/255. alpha:1];
    
    UITextView *descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(120, 302.5, 184.5, 99.5)];
    descriptionTextView.font = [UIFont fontWithName:fMyriadProRegular size:12];
    descriptionTextView.textColor = [UIColor whiteColor];
    descriptionTextView.backgroundColor = [UIColor colorWithRed:35/255. green:37/255. blue:43/255. alpha:1];
    descriptionTextView.layer.cornerRadius = 4.;
    descriptionTextView.delegate = self;
    
    [self.view addSubview:descriptionTextView];
    [self.view addSubview:blueLine];
    
    self.descriptionTextView = descriptionTextView;
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
    NSInteger currentPage = scrollView.contentOffset.x / self.pageScrollView.frame.size.width;
    [self.pageControl setCurrentPage:currentPage];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self moveBallToYCoordinate:354];
    [self.pageScrollView setUserInteractionEnabled:NO];
    
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
    [self.pageScrollView setUserInteractionEnabled:YES];
    [self.descriptionTextView resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.text.length > 100) {
        return NO;
    }
    return YES;
}

#pragma mark - OnEvent methods

- (void)onStartTimeSliderValueChanged:(UISlider *)sender {
    self.startTimeLabel.text = [self timeFromMinutes:(int)sender.value];
    
    if (sender.value > self.endTimeSlider.value - kTimeDifference) {
        self.endTimeSlider.value = sender.value + kTimeDifference;
        self.endTimeLabel.text = [self timeFromMinutes:(int)self.endTimeSlider.value];
    }
}

- (void)onEndTimeSliderValueChanged:(UISlider *)sender {
    self.endTimeLabel.text = [self timeFromMinutes:(int)sender.value];
    
    if (sender.value < self.startTimeSlider.value + kTimeDifference) {
        self.startTimeSlider.value = sender.value - kTimeDifference;
        self.startTimeLabel.text = [self timeFromMinutes:(int)self.startTimeSlider.value];
    }
}

- (void)onChooseDateButtonTouchUpInside {
    [self.eventNameTextField setUserInteractionEnabled:NO];
    __block __weak PMRAddEventViewController *weakSelf = self;
    [UIView animateWithDuration:.3 delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         weakSelf.datePickerView.frame = CGRectMake(0, weakSelf.view.frame.size.height - weakSelf.datePickerView.frame.size.height, weakSelf.datePickerView.frame.size.width, weakSelf.datePickerView.frame.size.height);
                     }
                     completion:nil];
    
    [UIView transitionWithView:weakSelf.chooseDateButton duration:.2
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [weakSelf.chooseDateButton setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
                    }
                    completion:nil];
}

- (void)onCancelDatePickerViewBarButtonTouch {
    [self.eventNameTextField setUserInteractionEnabled:YES];
    
    __block __weak PMRAddEventViewController *weakSelf = self;
    [UIView animateWithDuration:.3 delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         weakSelf.datePickerView.frame = CGRectMake(0, weakSelf.view.frame.size.height, weakSelf.datePickerView.frame.size.width, weakSelf.datePickerView.frame.size.height);
                     }
                     completion:nil];
}

- (void)onDoneDatePickerViewBarButtonTouch {
    [self.eventNameTextField setUserInteractionEnabled:YES];
    
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
    __block __weak PMRAddEventViewController *weakSelf = self;
    [UIView transitionWithView:weakSelf.cancelButton duration:.2
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [weakSelf.cancelButton setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
                    }
                    completion:nil];
    
    if ([self.navigationController isViewLoaded]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        NSLog(@"Error - navigation controller is not loaded");
    }
}

- (void)onCancelButtonTouchDown {
    __block __weak PMRAddEventViewController *weakSelf = self;
    
    [UIView transitionWithView:weakSelf.cancelButton duration:.2
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [weakSelf.cancelButton setTitleColor:[UIColor colorWithWhite:1 alpha:.5] forState:UIControlStateNormal];
                    }
                    completion:nil];
}

- (void)onCancelKeyboardBarButtonTouch {
    [self.descriptionTextView resignFirstResponder];
    self.descriptionTextView.text = self.lastTextViewEditText;
}

- (void)onDoneKeyboardBarButtonTouch {
    [self.descriptionTextView resignFirstResponder];
    [self.lastTextViewEditText setString:@""];
    [self.lastTextViewEditText appendString:self.descriptionTextView.text];
}

- (void)onPageChanged:(UIPageControl *)sender {
    [self moveBallToYCoordinate:235];
    CGPoint contentOffset = CGPointMake(sender.currentPage * self.pageScrollView.frame.size.width, 0);
    [self.pageScrollView setContentOffset:contentOffset animated:YES];
}

- (void)onChooseDateButtonTouchDown {
    [self moveBallToYCoordinate:21];
    __block __weak PMRAddEventViewController *weakSelf = self;
    [UIView transitionWithView:weakSelf.chooseDateButton duration:.2
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [weakSelf.chooseDateButton setTitleColor:[UIColor colorWithWhite:1 alpha:.5] forState:UIControlStateNormal];
                    }
                    completion:nil];
}

- (void)onSaveButtonTouchDown {
    [self moveBallToYCoordinate:472];
    __block __weak PMRAddEventViewController *weakSelf = self;
    [UIView transitionWithView:weakSelf.saveButton duration:.2
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [weakSelf.saveButton setTitleColor:[UIColor colorWithWhite:1 alpha:.5] forState:UIControlStateNormal];
                    }
                    completion:nil];
}

- (void)onSaveButtonTouchUpInside {
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

- (void)onEventNameTextFieldTouchDown {
    [self moveBallToYCoordinate:70];
    [self.chooseDateButton setUserInteractionEnabled:NO];
}

- (void)onStartTimeSliderTouchDown {
    [self moveBallToYCoordinate:117];
}

- (void)onEndTimeSliderTouchDown {
    [self moveBallToYCoordinate:159];
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

#pragma mark - Helpers

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
    NSInteger selectedImageIndex = self.pageScrollView.contentOffset.x / self.pageScrollView.frame.size.width;
    return [NSString stringWithFormat:@"PartyLogo_Small_%ld", (long)selectedImageIndex ];
}

@end
