//
//  PMRLocationViewController.m
//  PartyMaker
//
//  Created by 2 on 2/23/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRLocationViewController.h"
#import "PMRAnnotation.h"
#import "PMRParty.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define kDefaultAnnotationTitle @"New party"

@interface PMRLocationViewController ()<CLLocationManagerDelegate,
                                        MKMapViewDelegate,
                                        UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) PMRAnnotation *partyAnnotation;

@end

@implementation PMRLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedStringFromTable(@"LOCATION", @"Language", nil);
    
    [self configureLocationManager];
    [self configureActionForLongTapRecognized];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    if ([self isValidLocationString:self.party.longitude]) {
        CLLocationCoordinate2D partyCoordinate = [self parseLocationFromString:self.party.longitude];
        [self configurePartyAnnotationWithCoordinate:partyCoordinate];
        [self configureMapViewWithCoordinate:partyCoordinate];
    }
    else {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.locationManager.location.coordinate.latitude,
                                                                       self.locationManager.location.coordinate.longitude);
        [self configureMapViewWithCoordinate:coordinate];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Configure methods

- (void)configureLocationManager {
    if (!self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 10;
    [self.locationManager requestAlwaysAuthorization];
}

- (void)configureMapViewWithCoordinate:(CLLocationCoordinate2D)coordinate {
    float spanX = 0.00725;
    float spanY = 0.00725;
    MKCoordinateRegion region;
    region.center.latitude = coordinate.latitude;
    region.center.longitude = coordinate.longitude;
    region.span = MKCoordinateSpanMake(spanX, spanY);
    [self.mapView setRegion:region animated:YES];
}

- (void)configureActionForLongTapRecognized {
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(mapPressed:)];
    longPressRecognizer.minimumPressDuration = 1.0;
    [self.mapView addGestureRecognizer:longPressRecognizer];
}

- (void)configurePartyAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate {
    self.partyAnnotation = [[PMRAnnotation alloc] initWithCoordinate:coordinate];
    
    if ([self.party.eventName isEqualToString:@""]) {
        self.partyAnnotation.title = kDefaultAnnotationTitle;
    }
    else {
        self.partyAnnotation.title = self.party.eventName;
    }
    
    self.partyAnnotation.subtitle = self.party.latitude;
    [self.mapView addAnnotation:self.partyAnnotation];
}

#pragma mark - Map view delegates methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if ([annotation isKindOfClass:[PMRAnnotation class]]) {
        MKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"PMRAnnotation"];
        
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:@"PMRAnnotation"];
            UIImage *pinImage = [UIImage imageNamed:@"blue_pin"];
            annotationView.image = pinImage;
            annotationView.centerOffset = CGPointMake(10, - (pinImage.size.height / 2.));
            annotationView.canShowCallout = YES;
            annotationView.draggable = self.editingMode;
            
            UIImage *rightButtonImage = [UIImage imageNamed:@"done"];
            
            UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
            [rightButton setImage:rightButtonImage forState:UIControlStateNormal];
            [rightButton addTarget:self action:@selector(onDoneButtonTouch) forControlEvents:UIControlEventTouchUpInside];
            annotationView.rightCalloutAccessoryView = rightButton;
            
            UIImage *partyImage = [UIImage imageNamed:[NSString stringWithFormat:@"PartyLogo_Small_%d", self.party.imageIndex]];
            UIImageView *myCustomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            myCustomImage.image = partyImage;
            myCustomImage.contentMode = UIViewContentModeScaleAspectFit;
            annotationView.leftCalloutAccessoryView = myCustomImage;
            
        }
        else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedCoordinate = view.annotation.coordinate;
        CLLocation *tapCoordinate = [[CLLocation alloc] initWithLatitude:droppedCoordinate.latitude longitude:droppedCoordinate.longitude];
        [self addressFromLocation:tapCoordinate];
    }
    
    if (newState == MKAnnotationViewDragStateStarting) {
        view.dragState = MKAnnotationViewDragStateDragging;
    }
    else if (newState == MKAnnotationViewDragStateEnding || newState == MKAnnotationViewDragStateCanceling) {
        view.dragState = MKAnnotationViewDragStateNone;
    }
}

#pragma mark - Action methods

-(void)mapPressed:(UILongPressGestureRecognizer *)recognizer {
    if (self.editingMode) {
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            CGPoint point = [recognizer locationInView:self.mapView];
            CLLocationCoordinate2D tapPoint = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
            
            if (!self.partyAnnotation) {
                [self configurePartyAnnotationWithCoordinate:tapPoint];
            }
            self.partyAnnotation.coordinate = tapPoint;
            CLLocation *tapLocation = [[CLLocation alloc] initWithLatitude:tapPoint.latitude longitude:tapPoint.longitude];
            [self addressFromLocation:tapLocation];
            
        }
    }
}

- (void)onDoneButtonTouch {
    if (self.delegate && [self.delegate respondsToSelector:@selector(locationWithLatitude:withLongitude:withAddress:)]) {
        NSString *resultAddress = [self.partyAnnotation.subtitle stringByReplacingOccurrencesOfString:@"'" withString:@""];
        [self.delegate locationWithLatitude:self.partyAnnotation.coordinate.latitude withLongitude:self.partyAnnotation.coordinate.longitude withAddress:resultAddress];
    }
    if ([self.navigationController isViewLoaded]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Helpers

- (CLLocationCoordinate2D)parseLocationFromString:(NSString *)locationString {
    CLLocationCoordinate2D coordinate;
    NSArray *strings = [locationString componentsSeparatedByString:@";"];
    coordinate.latitude = [strings[0] doubleValue];
    coordinate.longitude = [strings[1] doubleValue];
    return coordinate;
}

- (BOOL)isValidLocationString:(NSString *)locationString {
     NSArray *strings = [locationString componentsSeparatedByString:@";"];
    if (strings.count != 2) {
        return NO;
    }
    return YES;
}

- (void)addressFromLocation:(CLLocation *)location {
    __block __weak PMRLocationViewController *weakSelf = self;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            weakSelf.party.latitude = placemark.name;
            weakSelf.partyAnnotation.subtitle = weakSelf.party.latitude;
        }
    }];
}

@end
