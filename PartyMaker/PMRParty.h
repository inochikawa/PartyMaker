//
//  PMRParty.h
//  PartyMaker
//
//  Created by Maksim Stecenko on 2/4/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

@interface PMRParty : NSObject

@property (nonatomic) NSString *eventName;
@property (nonatomic) NSString *eventDescription;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic) UIImage *eventTitle;

@end
