//
//  PMRPartyManagedObject.m
//  PartyMaker
//
//  Created by 2 on 2/24/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRPartyManagedObject.h"

@implementation PMRPartyManagedObject

+ (instancetype)fetchFromContext:(NSManagedObjectContext *)context withPartyId:(NSNumber *)partyId {
    NSFetchRequest *fetch = [NSFetchRequest new];
    fetch.entity = [NSEntityDescription entityForName:@"Party" inManagedObjectContext:context];
    fetch.predicate = [NSPredicate predicateWithFormat:@"eventId == %@", partyId];
    NSError *fetchError = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetch error:&fetchError];
    
    if (fetchError) {
        NSLog(@"%s --- [Fetch error] - %@, user info - %@", __PRETTY_FUNCTION__, fetchError, fetchError.userInfo);
        return nil;
    }
    
    return [fetchedObjects firstObject];
}

@end
