//
//  PMRCoreDataStack.h
//  PartyMaker
//
//  Created by 2 on 2/28/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext;

@interface PMRCoreDataStack : NSObject

- (nullable NSManagedObjectContext *)mainManagedObjectContext;
- (nullable NSManagedObjectContext *)backgroundManagedObjectContext;

@end
