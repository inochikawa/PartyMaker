//
//  PMRMainViewController.m
//  PartyMaker
//
//  Created by 2 on 2/3/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRPartiesViewController.h"
#import "PMRAddEventViewController.h"
#import "PMRTableViewCell.h"
#import "PMRParty.h"
#import "PMRPartyInfoViewController.h"
#import "NSDate+Utility.h"
#import "PMRApiController.h"
#import "PMRUser.h"
#import "PMRPartyMakerNotification.h"
#import <MBProgressHUD/MBProgressHUD.h>

#define kPartyEventId            @"id"
#define kPartyEventName          @"name"
#define kPartyEventDescription   @"comment"
#define kPartyCreatorId          @"creator_id"
#define kPartyStartTime          @"start_time"
#define kPartyEndTime            @"end_time"
#define kPartyImageIndex         @"logo_id"
#define kPartyIsChanged          @"isPartyChahged"
#define kPartyIsDeleted          @"isPartyDeleted"
#define kPartyLatitude           @"latitude"
#define kPartyLongitude          @"longitude"

@interface PMRPartiesViewController() <UITableViewDataSource,
                                       UITableViewDelegate>

@property (nonatomic) NSMutableArray *data;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *parties;
@property (nonatomic) PMRTableViewCell *selectedCell;

@end


@implementation PMRPartiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
    [backButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIColor colorWithRed:29/255. green:31/255. blue:36/255. alpha:1], NSForegroundColorAttributeName, [UIFont fontWithName:@"MyriadPro-Regular" size:16], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = backButton;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:29/255. green:31/255. blue:36/255. alpha:1];
    self.parties = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    __block __weak PMRPartiesViewController *weakSelf = self;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    
    dispatch_async(dispatch_get_main_queue(), ^{
        PMRUser *user = [PMRApiController apiController].user;
        [[PMRApiController apiController] loadAllPartiesByUserId:user.userId withCallback:^(NSArray *parties) {
            [weakSelf.parties removeAllObjects];
            [weakSelf.parties addObjectsFromArray:parties];
            [weakSelf.tableView reloadData];
            [weakSelf recreateAllNotificationsForEachParty];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
            });
        }];
    });
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PMRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PMRTableViewCell reuseIdentifier] forIndexPath:indexPath];
    NSDictionary *selectedPartyDictionary = self.parties[indexPath.row];
    [cell configureWithPartyDictionary:selectedPartyDictionary];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.parties.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"ToPartyInfoViewController" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ToPartyInfoViewController"]) {
        PMRPartyInfoViewController *partyInfoViewController = segue.destinationViewController;
        NSDictionary *selectedPartyDictionary = [self partyDictionaryById:self.selectedCell.partyId];
        partyInfoViewController.partyDictionary = selectedPartyDictionary;
    }
}

- (NSDictionary *)partyDictionaryById:(NSNumber *)partyId {
    for (NSDictionary *partyDictionary in self.parties) {
        if ([partyDictionary[kPartyEventId] integerValue] == [partyId integerValue]) {
            return partyDictionary;
        }
    }
    return nil;
}

- (void)recreateAllNotificationsForEachParty {
    [PMRPartyMakerNotification deleteAllLocalNotifications];
    [PMRPartyMakerNotification createNewLocalNotificationsForParties:self.parties];
}

@end
