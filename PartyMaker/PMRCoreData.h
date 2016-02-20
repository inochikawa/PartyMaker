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
@class PMRParty;
@class NSError;

@interface PMRCoreData : NSObject

- (nullable NSManagedObjectContext *)mainManagedObjectContext;
- (nullable NSManagedObjectContext *)backgroundManagedObjectContext;

- (nullable PMRParty *)fetchPartyByPartyId:(nonnull NSNumber *)partyId inContext:(nonnull NSManagedObjectContext *)context;
- (void)loadAllPartiesByUserId:(nonnull NSNumber *)userId withCallback:(void (^ _Nullable)(NSArray * _Nullable parties, NSError * _Nullable completionError))completion;
- (void)saveParty:(nonnull PMRParty *)party withCallback:(void (^ _Nullable)(NSError * _Nullable completionError))completion;
- (void)savePartiesFromArray:(nonnull NSArray *)parties withCallback:(void (^ _Nullable)(NSError * _Nullable completionError))completion;
- (void)updateParty:(nonnull PMRParty *)party withCallback:(void (^ _Nullable)(NSError * _Nullable completionError))completion;
- (void)deleteParty:(nonnull NSNumber *)eventID withCallback:(void (^ _Nullable)(NSError * _Nullable completionError))completion;
- (void)deleteAllUserPartiesByUserId:(nonnull NSNumber *)userId withCallback:(void (^ _Nullable)(NSError * _Nullable completionError))completion;
- (void)dropTableByEntityName:(nonnull NSString *)entityName withCallback:(void (^ _Nullable) (NSError * _Nullable completionError))completion;

@end
