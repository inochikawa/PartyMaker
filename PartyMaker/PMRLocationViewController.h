//
//  PMRLocationViewController.h
//  PartyMaker
//
//  Created by 2 on 2/23/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PMRLocationViewControllerProtocol <NSObject>
@required
- (void)locationWithLatitude:(double)latitude withLongitude:(double)longitude withAddress:(NSString *)Address;
@end

@class PMRParty;

@interface PMRLocationViewController : UIViewController

@property (nonatomic) PMRParty *party;
@property (nonatomic, weak) id<PMRLocationViewControllerProtocol> delegate;
@property (nonatomic) BOOL editingMode;

@end
