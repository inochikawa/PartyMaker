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
#import "PMRDataStorage.h"
#import "PMRParty.h"
#import "PMRPartyInfoViewController.h"
#import "NSDate+Utility.h"

@interface PMRPartiesViewController() <UITableViewDataSource,
                                       UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end


@implementation PMRPartiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PMRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PMRTableViewCell reuseIdentifier] forIndexPath:indexPath];
    PMRParty *selectedParty = [PMRDataStorage dataStorage].parties[indexPath.row];
    [cell configureWithName:selectedParty.eventName timeStart:[selectedParty.startDate toString] logo:[UIImage imageNamed:selectedParty.imagePath]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [PMRDataStorage dataStorage].parties.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TableViewCellToPMRCurrentVIewControllerSegue"]) {
        int selectedRow = (int)[self.tableView indexPathForSelectedRow].row;
        PMRPartyInfoViewController *partyInfoViewController = segue.destinationViewController;
        PMRParty *selectedParty = [PMRDataStorage dataStorage].parties[selectedRow];
        partyInfoViewController.party = selectedParty;
    }
}

@end
