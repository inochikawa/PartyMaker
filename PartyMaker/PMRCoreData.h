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

NS_ASSUME_NONNULL_BEGIN

@property (nonatomic) NSManagedObjectContext *mainManagedObjectContext;
@property (nonatomic) NSManagedObjectContext *backgroundManagedObjectContext;
@property (nonatomic) NSManagedObjectModel *managedObjectModel;
@property (nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

NS_ASSUME_NONNULL_END

- (nullable PMRParty *)fetchPartyByPartyId:(nonnull NSNumber *)partyId inContext:(nonnull NSManagedObjectContext *)context;
- (nullable NSArray *)allPartiesInUser:(nonnull NSNumber *)userId;
- (void)saveParty:(nonnull PMRParty *)party withCallback:(void (^ _Nullable)(NSError * _Nullable completionError))completion;
- (void)updateParty:(nonnull PMRParty *)party withCallback:(void (^ _Nullable)(NSError * _Nullable completionError))completion;
- (void)deleteParty:(nonnull PMRParty *)party withCallback:(void (^ _Nullable)(NSError * _Nullable completionError))completion;

@end
