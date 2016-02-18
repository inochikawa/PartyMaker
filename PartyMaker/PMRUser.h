//
//  PRMUser.h
//  PartyMaker
//
//  Created by 2 on 2/16/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PMRUser : NSManagedObject

+ (instancetype)user;

@end

#import "PMRUser+CoreDataProperties.h"
