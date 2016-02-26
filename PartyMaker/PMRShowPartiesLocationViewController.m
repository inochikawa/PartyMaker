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
#import "PMRUser.h"
#import "PMRParty.h"
#import "PMRUserTableViewCell.h"
#import "PMRApiController.h"

@interface PMRShowPartiesLocationViewController ()<UITableViewDataSource,
                                                   UITableViewDelegate>

@property (nonatomic) NSMutableArray *users;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *usersTableView;

@end

@implementation PMRShowPartiesLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.users = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - TableView delegates implementation

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PMRUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PMRUserTableViewCell reuseIdentifier] forIndexPath:indexPath];
    PMRUser *selectedUser = self.users[indexPath.row];
    [cell configureWithUserName:selectedUser.name];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (<#condition#>) {
    <#statements#>
}
    return self.users.count;
}

#pragma mark - Actions

- (IBAction)onSelectFriendButtonTouch:(id)sender {
    [self.view addSubview:self.usersTableView];
    float tableViewWidth = self.view.bounds.size.width - 100;
    float tableViewHeight = self.view.bounds.size.height;
    CGRect tableViewRect = CGRectMake(- tableViewWidth, 0, tableViewWidth, tableViewHeight);
    
    self.usersTableView.frame = tableViewRect;
    
    __block __weak PMRShowPartiesLocationViewController *weakSelf = self;
    
    [[PMRApiController apiController] loadAllUsersWithCallback:^(NSArray *users) {
        [weakSelf.users removeAllObjects];
        [weakSelf.users addObjectsFromArray:users];
        [weakSelf.usersTableView reloadData];
    }];
    
    [UIView animateWithDuration:.3 delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         weakSelf.usersTableView.frame = CGRectMake(0, 0, tableViewWidth, tableViewHeight);
                     }
                     completion:nil];
}

@end
