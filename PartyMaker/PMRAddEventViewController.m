//
//  PMRAddEventViewController.m
//  PartyMaker
//
//  Created by 2 on 2/3/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRAddEventViewController.h"

@interface PMRAddEventViewController()<UITextFieldDelegate>
@property (nonatomic) UIButton *chooseDateButton;
@property (nonatomic) UIButton *saveButton;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UIView *dynamicBall;
@property (nonatomic) UITextField *eventNameTextField;
@property (nonatomic) UIView *datePickerView;
@property (nonatomic) UILabel *startTimeLabel;
@property (nonatomic) UILabel *endTimeLabel;
@end

@implementation PMRAddEventViewController

- (void)creareButtons {
    // init chooseButton
    self.chooseDateButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 10, 190, 36)];
    self.chooseDateButton.backgroundColor = [UIColor colorWithRed:239/255. green:177/255. blue:27/255. alpha:1];
    self.chooseDateButton.layer.cornerRadius = 5.;
    self.chooseDateButton.tintColor = [UIColor whiteColor];
    [self.chooseDateButton setTitle:@"Choose date" forState:UIControlStateNormal];
    [self.chooseDateButton addTarget:self action:@selector(onChooseDateButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)createBalls {
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

- (void)createTextField {
    self.eventNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 56.5, 190, 36)];
    self.eventNameTextField.placeholder = @"Your party Name";
    self.eventNameTextField.backgroundColor = [UIColor colorWithRed:35/255. green:37/255. blue:43/255. alpha:1];
    self.eventNameTextField.textColor = [UIColor whiteColor];
    self.eventNameTextField.textAlignment = NSTextAlignmentCenter;
    self.eventNameTextField.layer.cornerRadius = 5.;
    self.eventNameTextField.returnKeyType = UIReturnKeyDone;
    self.eventNameTextField.delegate = self;
    
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
    
    self.datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, datePicker.frame.size.height + toolbar.frame.size.height)];
    
    [self.datePickerView addSubview:toolbar];
    [self.datePickerView addSubview:datePicker];
    
    [self.view addSubview:self.datePickerView];
}

- (void)createSliders {
    UISlider *startTimeSlider = [[UISlider alloc] initWithFrame:CGRectMake(120, 122, 190, 1)];
    startTimeSlider.tintColor = [UIColor colorWithRed:238/255. green:178/255. blue:30/255. alpha:1];
    
    UISlider *endTimeSlider = [[UISlider alloc] initWithFrame:CGRectMake(120, 163.5, 190, 1)];
    endTimeSlider.tintColor = [UIColor colorWithRed:238/255. green:178/255. blue:30/255. alpha:1];
    
    startTimeSlider.minimumValueImage = [UIImage imageNamed:@"TimePopup"];
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"TimePopup"]];
    endTimeSlider.maximumValueImage = [[UIImage alloc] initWithCIImage:ciImage scale:2 orientation:UIImageOrientationUpMirrored];
    
    [self.view addSubview:startTimeSlider];
    [self.view addSubview:endTimeSlider];
    
    [startTimeSlider addTarget:self
                        action:@selector(onStartTimeSliderValueChanged:)
              forControlEvents:UIControlEventValueChanged];
    [endTimeSlider addTarget:self
                      action:@selector(onEndTimeSliderValueChanged:)
            forControlEvents:UIControlEventValueChanged];
    
    [startTimeSlider setValue:.3 animated:YES];
    
    self.startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 105, 32.5, 32.5)];
    self.startTimeLabel.font = [UIFont fontWithName:@"MyriadProRegular" size:10.6];
    self.startTimeLabel.textColor = [UIColor whiteColor];
    self.startTimeLabel.text = @"10:22";
    self.startTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.startTimeLabel];
    
    self.startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 147.5, 32.5, 32.5)];
    self.startTimeLabel.font = [UIFont fontWithName:@"MyriadProRegular" size:10.6];
    self.startTimeLabel.textColor = [UIColor whiteColor];
    self.startTimeLabel.text = @"10:22";
    self.startTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.startTimeLabel];
}

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

- (void)onStartTimeSliderValueChanged:(UISlider *)sender {
    int totalSeconds = 24 * 3600 * sender.value;
    
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    self.startTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",hours, minutes];
}

- (void)onEndTimeSliderValueChanged:(UISlider *)sender {
    int totalSeconds = 24 * 3600 * sender.value;
    
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    self.endTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",hours, minutes];
}

- (void)onChooseDateButtonTouchUpInside {
    [UIView animateWithDuration:.3 delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         self.datePickerView.frame = CGRectMake(0, self.view.frame.size.height - self.datePickerView.frame.size.height, self.datePickerView.frame.size.width, self.datePickerView.frame.size.height);
                     }
                     completion:nil];
}

- (void)onCancelDatePickerViewBarButtonTouch {
    [UIView animateWithDuration:.3 delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         self.datePickerView.frame = CGRectMake(0, self.view.frame.size.height, self.datePickerView.frame.size.width, self.datePickerView.frame.size.height);
                     }
                     completion:nil];
}

- (void)onDoneDatePickerViewBarButtonTouch {
    UIDatePicker *datePicker = (UIDatePicker *)self.datePickerView.subviews[1];
    
    if (![self isCurrentDateOrderedDescendingWithDate:datePicker.date]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"You selected small date"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
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

- (BOOL)isCurrentDateOrderedDescendingWithDate:(NSDate *)date {
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* currentDateComponents = [calendar components:flags fromDate:[NSDate date]];
    NSDateComponents* selectedDateComponents = [calendar components:flags fromDate:date];
    
    NSDate* currentDate = [calendar dateFromComponents:currentDateComponents];
    NSDate *selectedDate = [calendar dateFromComponents:selectedDateComponents];
    
    if ([selectedDate compare:currentDate] != NSOrderedSame)
        if ([selectedDate compare:currentDate] == NSOrderedAscending) {
            return NO;
        }
    
    return YES;
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
    [self createDatePickerView];
    [self createSliders];
}

@end
