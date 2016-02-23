//
//  PMRDataStorage.h
//  PartyMaker
//
//  Created by 2 on 2/9/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext;
@class NSManagedObjectModel;
@class NSPersistentStoreCoordinator;
@class NSError;
@class PMRParty;
@class PMRUser;

@interface PMRCoreData : NSObject

- (nullable NSManagedObjectContext *)mainManagedObjectContext;
- (nullable NSManagedObjectContext *)backgroundManagedObjectContext;

- (nullable NSArray *)loadAllPartiesByUserId:(nonnull NSNumber *)userId;
- (void)saveParty:(nonnull NSDictionary *)partyDictionary withCallback:(void (^ _Nullable)(NSError * _Nullable completionError))completion;
- (void)saveOrUpadatePartiesFromArrayOfPartyDictionaries:(nonnull NSArray *)partyDictionaries withCallback:(void (^ _Nullable)(NSError * _Nullable completionError))completion;
- (void)saveOrUpadatePartyFromPartyDictionary:(nonnull NSDictionary *)partyDictionary inContext:(nonnull NSManagedObjectContext *)context;
- (void)updateParty:(nonnull NSDictionary *)partyDictionary withCallback:(void (^ _Nullable)(NSError * _Nullable completionError))completion;
- (void)deleteParty:(nonnull NSNumber *)eventID withCallback:(void (^ _Nullable)(NSError * _Nullable completionError))completion;
- (void)deleteAllUserPartiesByUserId:(nonnull NSNumber *)userId withCallback:(void (^ _Nullable)(NSError * _Nullable completionError))completion;

- (void)markPartyAsDeletedByPartyId:(nonnull NSNumber *)partyId;

@end
