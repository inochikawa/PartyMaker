//
//  PMRParty.h
//  PartyMaker
//
//  Created by Maksim Stecenko on 2/4/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

@interface PMRParty : NSObject <NSCoding>

@property (nonatomic) NSString *Id;
@property (nonatomic) NSString *eventName;
@property (nonatomic) NSString *eventDescription;
@property (nonatomic) NSString *imagePath;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;

@end
