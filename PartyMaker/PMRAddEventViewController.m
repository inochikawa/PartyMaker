//
//  PMRAddEventViewController.m
//  PartyMaker
//
//  Created by 2 on 2/8/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRAddEventViewController.h"
#import "PMRParty.h"
#import "PMRUser.h"
#import "PMRCoreData.h"
#import "NSDate+Utility.h"
#import "UIImage+Utility.h"
#import "PMRApiController.h"
#import "PMRPartyMakerNotification.h"
#import "PMRLocationViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

#define kTimeDifference                     30
#define kDistanceBetwenControls             9
#define kDefaultControlHeight               36
#define kDistanceBetwenLeadingAndControls   120

@interface PMRAddEventViewController ()<UITextFieldDelegate,
                                        UIScrollViewDelegate,
                                        UITextViewDelegate,
                                        PMRLocationViewControllerProtocol>

@property (nonatomic) NSMutableString* lastTextViewEditText;

@property (nonatomic, weak) IBOutlet UIButton *chooseDateButton;
@property (nonatomic, weak) IBOutlet UIButton *locationButton;

@property (weak, nonatomic) IBOutlet UILabel *choodeDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *partyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *logoLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

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

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *balls;

@property (nonatomic) BOOL isKeyboardOnDescriptionTextViewShowed;

@end

@implementation PMRAddEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedStringFromTable(@"Back", @"Language", nil)]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
    [backButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor colorWithRed:29/255. green:31/255. blue:36/255. alpha:1], NSForegroundColorAttributeName, [UIFont fontWithName:@"MyriadPro-Regular" size:16], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = backButton;

    self.lastTextViewEditText = [[NSMutableString alloc] initWithString:@""];
    self.isKeyboardOnDescriptionTextViewShowed = NO;
    
    self.choodeDateLabel.text = NSLocalizedStringFromTable(@"CHOOSE DATE", @"Language", nil);
    self.partyNameLabel.text = NSLocalizedStringFromTable(@"PARTY NAME", @"Language", nil);
    self.startLabel.text = NSLocalizedStringFromTable(@"START", @"Language", nil);
    self.endLabel.text = NSLocalizedStringFromTable(@"END", @"Language", nil);
    self.logoLabel.text = NSLocalizedStringFromTable(@"LOGO", @"Language", nil);
    self.descriptionLabel.text = NSLocalizedStringFromTable(@"DESCRIPTION", @"Language", nil);
    self.locationLabel.text = NSLocalizedStringFromTable(@"LOCATION", @"Language", nil);
    
    self.navigationItem.title = NSLocalizedStringFromTable(@"CREATE PARTY", @"Language", nil);
    
    if (!self.party) {
        [self createDefaultPartyInstanse];
    }
    
    [self configureDatePickerView];
    [self configureKeyboardToolBar];
    [self configureDynamicBall];
    [self configureButton];
    [self configureDescriptionTextView];
    [self configureEventNameTextField];
    [self configureImagePageControl];
    [self configureImageScrollView];
    [self loadPicturesToScrollView];
    
    [self establishPartyInformation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Create default party

- (void)createDefaultPartyInstanse {
    NSDate *startDate = [self selectedDateWithTime:@"00:00"];
    NSDate *endDate = [self selectedDateWithTime:@"00:30"];
    
    self.party = [PMRParty new];
    self.party.eventId = @0;
    self.party.creatorId = @0;
    self.party.latitude = @"";
    self.party.longitude = @"";
    self.party.eventName = @"";
    self.party.eventDescription = @"";
    self.party.startTime = [startDate toSeconds];
    self.party.endTime = [endDate toSeconds];
    self.party.imageIndex = @0;
    self.party.latitude = @"";
    self.party.longitude = @"";

}

#pragma mark - Configure methods

- (void)configureButton {
    self.chooseDateButton.layer.cornerRadius = 5.;
    self.locationButton.layer.cornerRadius = 5.;
    [self.locationButton setTitle:NSLocalizedStringFromTable(@"LOCATION", @"Language", nil) forState:UIControlStateNormal];
    [self.chooseDateButton setTitle:NSLocalizedStringFromTable(@"CHOOSE DATE", @"Language", nil) forState:UIControlStateNormal];
}

- (void)configureEventNameTextField {
    self.eventNameTextField.backgroundColor = [UIColor colorWithRed:35/255. green:37/255. blue:43/255. alpha:1];
    self.eventNameTextField.layer.cornerRadius = 5.;
    self.eventNameTextField.returnKeyType = UIReturnKeyDone;
    self.eventNameTextField.delegate = self;
    if ([self.eventNameTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor colorWithRed:76/255. green:82/255. blue:92/255. alpha:1];
        self.eventNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedStringFromTable(@"Your party Name", @"Language", nil)
                                                                                   attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
    }
}

- (void)configureImageScrollView {
    self.imageScrollView.delegate = self;
}

- (void)configureImagePageControl {
    self.imagePageControl.pageIndicatorTintColor = [UIColor colorWithRed:29/255. green:30/255. blue:36/255. alpha:1];
    self.imagePageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.imagePageControl.pageIndicatorTintColor = [UIColor colorWithRed:29/255. green:30/255. blue:36/255. alpha:1];
    self.imagePageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
}

- (void)configureDescriptionTextView {
    self.descriptionTextView.layer.cornerRadius = 3.;
    self.descriptionTextView.delegate = self;
}

- (void)configureDatePickerView {
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    self.datePickerView.frame = CGRectMake(0, screenFrame.size.height, screenFrame.size.width, screenFrame.size.height / 3.);
    [self.datePickerControl setMinimumDate:[NSDate date]];
    [self.view addSubview:self.datePickerView];
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
    if (!self.isKeyboardOnDescriptionTextViewShowed) {
        CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        float duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        __block __weak PMRAddEventViewController *weakSelf = self;
        
        [UIView animateWithDuration:duration animations:^{
            CGRect viewFrame = weakSelf.view.frame;
            viewFrame.origin.y -= keyboardRect.size.height - 100;
            weakSelf.view.frame = viewFrame;
        }];
        self.isKeyboardOnDescriptionTextViewShowed = YES;
    }
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
    self.isKeyboardOnDescriptionTextViewShowed = NO;
}

#pragma mark - IBActions

- (IBAction)onImagePageChanged:(id)sender {
    [self moveBallToElement:self.imageScrollView];
    CGPoint contentOffset = CGPointMake(((UIPageControl *)sender).currentPage * self.imageScrollView.frame.size.width, 0);
    [self.imageScrollView setContentOffset:contentOffset animated:YES];
}

- (IBAction)onSaveButtonTouchUpInside {
    if ([self.chooseDateButton.titleLabel.text  isEqual:NSLocalizedStringFromTable(@"CHOOSE DATE", @"Language", nil)]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Error", @"Language", nil) message:NSLocalizedStringFromTable(@"You did not choose date.", @"Language", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if ([self.eventNameTextField.text isEqual:@""]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Error", @"Language", nil) message:NSLocalizedStringFromTable(@"You did not input event name.", @"Language", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    [self saveParty];
    
    
}

- (IBAction)onCancelButtonTouchUpInside {
    if ([self.navigationController isViewLoaded]) {
        [self.navigationController popViewControllerAnimated:YES];
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
    NSInteger tag = ((UIControl *)sender).tag;
    UIView *currentBall;
    
    for (UIView *ball in self.balls) {
        if (ball.tag == tag) {
            currentBall = ball;
        }
    }
    
    __block __weak PMRAddEventViewController *weakSelf = self;
    [UIView animateWithDuration:.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         weakSelf.dynamicBall.center = currentBall.center;
                     }
                     completion:nil];
    
}

#pragma mark - Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.chooseDateButton setUserInteractionEnabled:YES];
    self.party.eventName = textField.text;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length > 20) {
        textField.text = [textField.text substringWithRange:NSMakeRange(0, 20)];
        return NO;
    }
    else {
        return YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self moveBallToElement:scrollView];
    NSInteger currentPage = scrollView.contentOffset.x / self.imageScrollView.frame.size.width;
    [self.imagePageControl setCurrentPage:currentPage];
    self.party.imageIndex = @(currentPage);
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self moveBallToElement:textView];
    [self.imageScrollView setUserInteractionEnabled:NO];
    [self.imagePageControl setUserInteractionEnabled:NO];
    
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
    [self.imagePageControl setUserInteractionEnabled:YES];
    [self.descriptionTextView resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.text.length > 400) {
        textView.text = [textView.text substringWithRange:NSMakeRange(0, 400)];
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

- (NSInteger)minutesFromTime:(NSString *)time {
    NSArray *timeArray = [time componentsSeparatedByString:@":"];
    NSInteger hours = [timeArray[0] integerValue];
    NSInteger minutes = [timeArray[1] integerValue];
    return hours * 60 + minutes;
}

- (void)saveParty {
    NSDate *startDate = [self selectedDateWithTime:self.startTimeLabel.text];
    NSDate *endDate = [self selectedDateWithTime:self.endTimeLabel.text];
    
    self.party.eventName = self.eventNameTextField.text;
    self.party.eventDescription = self.descriptionTextView.text;
    self.party.startTime = [startDate toSeconds];
    self.party.endTime = [endDate toSeconds];
    self.party.imageIndex = @(self.imagePageControl.currentPage);
    
    __block __weak PMRAddEventViewController *weakSelf = self;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedStringFromTable(@"Loading...", @"Language", nil);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[PMRApiController apiController] saveOrUpdateParty:self.party withCallback:^{
            if ([weakSelf.navigationController isViewLoaded]) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
            else {
                NSLog(@"Error - navigation controller is not loaded");
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
            });
        }];
    });
}

- (NSDate *)selectedDateWithTime:(NSString *)time {
    NSDate *date = self.datePickerControl.date;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    [gregorian setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date];
    NSArray *timeArray = [time componentsSeparatedByString:@":"];
    [components setHour:[timeArray[0] integerValue]];
    [components setMinute: [timeArray[1] integerValue]];
    [components setSecond: 0];
    [components setNanosecond:0];
    
    return [gregorian dateFromComponents: components];
}

- (NSString *)selectedImagePath {
    NSInteger selectedImageIndex = self.imageScrollView.contentOffset.x / self.imageScrollView.frame.size.width;
    return [NSString stringWithFormat:@"PartyLogo_Small_%ld", (long)selectedImageIndex ];
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

- (void)loadPicturesToScrollView {
    CGRect scrollViewFrame = [self estimatedImageScrollViewFrame];
    self.imageScrollView.contentSize = CGSizeMake(scrollViewFrame.size.width * 6, scrollViewFrame.size.height);
    for (int i = 0; i < 6 ; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"PartyLogo_Small_%d", i]]];
        float xOffset = (scrollViewFrame.size.width / 2. - imageView.frame.size.width / 2.) + i * scrollViewFrame.size.width;
        int deltaHeight = 0;
        if (scrollViewFrame.size.height < 150) {
            deltaHeight = 60;
        }
        else {
            deltaHeight = 40;
        }
        float yOffset = scrollViewFrame.size.height / 2. - imageView.frame.size.height / 2. - deltaHeight;
        imageView.frame =CGRectMake(xOffset, yOffset, imageView.frame.size.width, imageView.frame.size.height);
        [self.imageScrollView addSubview:imageView];
    }
}

- (CGRect)estimatedImageScrollViewFrame {
    return CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width - kDistanceBetwenLeadingAndControls - kDistanceBetwenControls, ([[UIScreen mainScreen] bounds].size.height - 8 * kDistanceBetwenControls - 5 * kDefaultControlHeight) / 2.);
}

- (void)establishPartyInformation {
    NSString *startTime = [NSDate stringDateFromSeconds:self.party.startTime withDateFormat:@"HH:mm"];
    NSString *endTime = [NSDate stringDateFromSeconds:self.party.endTime withDateFormat:@"HH:mm"];
    
    self.eventNameTextField.text = self.party.eventName;
    self.descriptionTextView.text = self.party.eventDescription;
    [self.chooseDateButton setTitle:NSLocalizedStringFromTable(@"CHOOSE DATE", @"Language", nil) forState:UIControlStateNormal];
    self.startTimeLabel.text = startTime;
    self.endTimeLabel.text = endTime;
    self.datePickerControl.date = [NSDate dateFromSeconds:self.party.startTime];
    self.startTimeSlider.value = [self minutesFromTime:startTime];
    self.endTimeSlider.value = [self minutesFromTime:endTime];
    if (![self.party.latitude isEqualToString:@""]) {
        [self.locationButton setTitle:self.party.latitude forState:UIControlStateNormal];
    }    
    
    self.imagePageControl.currentPage = [self.party.imageIndex integerValue];
    
    CGRect scrollViewFrame = [self estimatedImageScrollViewFrame];
    CGPoint contentOffset = CGPointMake([self.party.imageIndex integerValue] * scrollViewFrame.size.width, 0);
    [self.imageScrollView setContentOffset:contentOffset animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addEventViewControllerToLocationViewController"]) {
        PMRLocationViewController *locationViewController = segue.destinationViewController;
        locationViewController.party = self.party;
        locationViewController.delegate = self;
        locationViewController.editingMode = YES;
    }
}

#pragma mark - Implement PMRLocationViewControllerProtocol

- (void)locationWithLatitude:(double)latitude withLongitude:(double)longitude withAddress:(NSString *)address {
    NSString *coordinateString = [NSString stringWithFormat:@"%f;%f", latitude, longitude];
    [self.locationButton setTitle:address forState:UIControlStateNormal];
    self.party.latitude = address;
    self.party.longitude = coordinateString;
}

@end
