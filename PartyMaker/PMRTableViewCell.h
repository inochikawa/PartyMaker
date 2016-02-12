//
//  PMRTableViewCell.h
//  PartyMaker
//
//  Created by 2 on 2/11/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMRTableViewCell : UITableViewCell

- (void)configureWithName:(NSString *)eventName timeStart:(NSString *)eventTimeStart logo:(UIImage *)logo;
+ (NSString *)reuseIdentifier;

@end
