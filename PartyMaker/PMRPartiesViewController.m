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

@property (nonatomic) NSMutableArray *data;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
    
    [self.tableView reloadData];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PMRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PMRTableViewCell reuseIdentifier] forIndexPath:indexPath];
    PMRParty *selectedParty = [PMRDataStorage dataStorage].parties[indexPath.row];
    [cell configureWithName:selectedParty.eventName timeStart:[selectedParty.startDate toString] logo:[UIImage imageNamed:selectedParty.imagePath]];
    
//    [self.tableView beginUpdates];
//    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView endUpdates];
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
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

- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    NSLog(@"LALALALALA --- %s", __PRETTY_FUNCTION__);
}

@end
