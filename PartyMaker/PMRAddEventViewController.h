//
//  PMRAddEventViewController.h
//  PartyMaker
//
//  Created by 2 on 2/8/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMRAddEventViewController : UIViewController

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
