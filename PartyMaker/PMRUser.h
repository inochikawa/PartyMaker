//
//  PMRUser.h
//  PartyMaker
//
//  Created by 2 on 2/19/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMRUser : NSObject

@property (nullable, nonatomic) NSString *name;
@property (nonatomic) NSInteger userId;
@property (nullable, nonatomic) NSString *password;
@property (nullable, nonatomic) NSString *email;

@end

