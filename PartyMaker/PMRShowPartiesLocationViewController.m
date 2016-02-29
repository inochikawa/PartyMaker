//
//  PMRShowPartiesLocationViewController.m
//  PartyMaker
//
//  Created by 2 on 2/26/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PMRShowPartiesLocationViewController.h"
#import "PMRPartyInfoViewController.h"
#import "PMRUser.h"
#import "PMRParty.h"
#import "PMRUserTableViewCell.h"
#import "PMRApiController.h"
#import "PMRAnnotation.h"

@interface PMRShowPartiesLocationViewController ()<UITableViewDataSource,
                                                   UITableViewDelegate,
                                                   CLLocationManagerDelegate,
                                                   MKMapViewDelegate>

@property (nonatomic) BOOL isUsersTableViewOpened;
@property (nonatomic) NSMutableArray *parties;
@property (nonatomic) NSMutableArray *users;
@property (nonatomic) PMRAnnotation *selectedAnnotation;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UITableView *usersTableView;

@end

@implementation PMRShowPartiesLocationViewController

- (void)dealloc {
    
    NSLog(@"sdf");
    self.mapView = nil;
    self.mapView.delegate = nil;
    [self.mapView removeFromSuperview];
    self.parties = nil;
    self.users = nil;
    self.selectedAnnotation = nil;
    self.locationManager.delegate = nil;
    self.locationManager = nil;
    self.usersTableView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUsersTableView];
    [self configureLocationManager];
    
    NSInteger userId = [PMRApiController apiController].user.userId;
    [self showAllPartyAnnotationsOnMapByUserId:userId];
    
    self.users = [[NSMutableArray alloc] init];
    self.parties = [[NSMutableArray alloc] init];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureUsersTableView {
    self.isUsersTableViewOpened = NO;
    [self.view addSubview:self.usersTableView];
    float tableViewWidth = self.view.bounds.size.width / 2.;
    float tableViewHeight = self.view.bounds.size.height;
    CGRect tableViewRect = CGRectMake(- tableViewWidth, 0, tableViewWidth, tableViewHeight);
    self.usersTableView.frame = tableViewRect;
}

#pragma  mark - TableView delegates implementation

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PMRUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PMRUserTableViewCell reuseIdentifier] forIndexPath:indexPath];
    PMRUser *selectedUser = self.users[indexPath.row];
    [cell configureWithUser:selectedUser];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.users.count) {
        return 0;
    }
    return self.users.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PMRUserTableViewCell *selectedCell = [self.usersTableView cellForRowAtIndexPath:indexPath];
    [self showAllPartyAnnotationsOnMapByUserId:selectedCell.userId];
    __block __weak PMRShowPartiesLocationViewController *weakSelf = self;
    float tableViewWidth = self.usersTableView.bounds.size.width;
    float tableViewHeight = self.usersTableView.bounds.size.height;
    [UIView animateWithDuration:.3 delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         weakSelf.usersTableView.frame = CGRectMake(- tableViewWidth, 0, tableViewWidth, tableViewHeight);
                     }
                     completion:nil];
}

#pragma mark - MapKit implementation

- (void)configureLocationManager {
    if (!self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 10; // meters
    [self.locationManager requestAlwaysAuthorization];
}

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
            annotationView.draggable = NO;
            
            UIImage *rightButtonImage = [UIImage imageNamed:@"done"];
            
            UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
            [rightButton setImage:rightButtonImage forState:UIControlStateNormal];
            [rightButton addTarget:self action:@selector(onInformationButtonTouch) forControlEvents:UIControlEventTouchUpInside];
            annotationView.rightCalloutAccessoryView = rightButton;
            
            UIImage *partyImage = [UIImage imageNamed:[NSString stringWithFormat:@"PartyLogo_Small_%ld", (long)((PMRAnnotation *)annotation).partyLogoIndex]];
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

#pragma mark - Annotation actions

- (void)onInformationButtonTouch {
    self.selectedAnnotation = [[self.mapView selectedAnnotations] firstObject];
    [self performSegueWithIdentifier:@"ShowPartiesLocationViewControllerToPartyInfoViewController" sender:self];
}

#pragma mark - Actions

- (IBAction)onSelectFriendButtonTouch:(id)sender {
    float tableViewWidth = self.usersTableView.bounds.size.width;
    float tableViewHeight = self.usersTableView.bounds.size.height;
    
    __block __weak PMRShowPartiesLocationViewController *weakSelf = self;
    
    if (self.isUsersTableViewOpened) {
        [UIView animateWithDuration:.3 delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^ {
                             weakSelf.usersTableView.frame = CGRectMake(- tableViewWidth, 0, tableViewWidth, tableViewHeight);
                         }
                         completion:nil];
        
        self.isUsersTableViewOpened = NO;
    }
    else {
        
        [[PMRApiController apiController] loadAllUsersWithCallback:^(NSArray *users) {
            [weakSelf.users removeAllObjects];
            NSInteger currentUserId = [PMRApiController apiController].user.userId;
            

            
            NSArray *sortedArrayOfUsers = [users sortedArrayUsingComparator:^NSComparisonResult(PMRUser * _Nonnull obj1, PMRUser *  _Nonnull obj2) {
                NSString *firstUserName = obj1.name;
                NSString *secondUserName = obj2.name;
                return [firstUserName compare:secondUserName];
            }];

            
            for (PMRUser *user in sortedArrayOfUsers) {
                if (user.userId != currentUserId) {
                    [weakSelf.users addObject:user];
                }
            }
            
            [weakSelf.usersTableView reloadData];
        }];
        
        [UIView animateWithDuration:.3 delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^ {
                             weakSelf.usersTableView.frame = CGRectMake(0, 0, tableViewWidth, tableViewHeight);
                         }
                         completion:nil];
        
        self.isUsersTableViewOpened = YES;
    }
}

- (IBAction)onResetButtonTouch:(id)sender {
    NSInteger userId = [PMRApiController apiController].user.userId;
    [self showAllPartyAnnotationsOnMapByUserId:userId];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowPartiesLocationViewControllerToPartyInfoViewController"]) {
        NSInteger partyId = self.selectedAnnotation.partyId;
        PMRParty *selectedParty = nil;
        
        for (PMRParty *party in self.parties) {
            if (party.eventId == partyId) {
                selectedParty = party;
                break;
            }
        }
        
        PMRPartyInfoViewController *partyInfoViewController = segue.destinationViewController;
        partyInfoViewController.party = selectedParty;
        partyInfoViewController.needHideButtons = YES;
    }
}

#pragma mark - Helpers

- (void)showAllPartyAnnotationsOnMapByUserId:(NSInteger)userId {
    [[PMRApiController apiController] loadAllPartiesFromNetworkByUserId:userId withCallback:^(NSArray *parties) {
        
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.parties removeAllObjects];
        
        NSMutableArray *annotations = [NSMutableArray new];
        
        for (PMRParty *party in parties) {
            if (![party.longitude isEqualToString:@""]) {
                PMRAnnotation *annotation = [[PMRAnnotation alloc] initWithParty:party];
                [annotations addObject:annotation];
                [self.parties addObject:party];
            }
        }
        
        [self.mapView showAnnotations:annotations animated:YES];
    }];
}

@end
