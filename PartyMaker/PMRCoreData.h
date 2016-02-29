//
//  PMRDataStorage.h
//  PartyMaker
//
//  Created by 2 on 2/9/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext;
@class NSError;
@class PMRParty;
@class PMRUser;
@class PMRCoreDataStack;

@interface PMRCoreData : NSObject

@property (nonatomic) PMRCoreDataStack * _Nullable coreDataStack;

- (nullable NSArray *)loadAllPartiesByUserId:(NSInteger)userId;
- (void)saveOrUpdatePartiesFromArrayOfParties:(nonnull NSArray *)parties withCallback:(void (^ _Nullable)(NSError *_Nullable completionError))completion;
- (void)saveOrUpdateParty:(nonnull PMRParty *)party inContext:(nonnull NSManagedObjectContext *)context;
- (void)saveOrUpdateParty:(nonnull PMRParty *)party;
- (void)deleteParty:(NSInteger)eventID withCallback:(void (^ _Nullable)(NSError * _Nullable completionError))completion;
- (void)deleteAllUserPartiesByUserId:(NSInteger)userId withCallback:(void (^ _Nullable)(NSError * _Nullable completionError))completion;

- (void)markPartyAsDeletedByPartyId:(NSInteger)partyId;

@end
