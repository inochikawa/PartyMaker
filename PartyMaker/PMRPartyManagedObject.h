//
//  PMRPartyManagedObject.h
//  PartyMaker
//
//  Created by 2 on 2/24/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PMRParty;

NS_ASSUME_NONNULL_BEGIN

@interface PMRPartyManagedObject : NSManagedObject

+ (instancetype)fetchFromContext:(NSManagedObjectContext *)context withPartyId:(NSInteger)partyId;
- (instancetype)produceUsingParty:(PMRParty *)party;

@end

NS_ASSUME_NONNULL_END

#import "PMRPartyManagedObject+CoreDataProperties.h"
