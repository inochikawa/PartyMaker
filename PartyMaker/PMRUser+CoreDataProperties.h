//
//  PMRUser+CoreDataProperties.h
//  PartyMaker
//
//  Created by 2 on 2/19/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PMRUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface PMRUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSNumber *userId;
@property (nullable, nonatomic, retain) NSSet<PMRParty *> *userToParty;

@end

@interface PMRUser (CoreDataGeneratedAccessors)

- (void)addUserToPartyObject:(PMRParty *)value;
- (void)removeUserToPartyObject:(PMRParty *)value;
- (void)addUserToParty:(NSSet<PMRParty *> *)values;
- (void)removeUserToParty:(NSSet<PMRParty *> *)values;

@end

NS_ASSUME_NONNULL_END
