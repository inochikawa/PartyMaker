//
//  PMRDataStorage.h
//  PartyMaker
//
//  Created by 2 on 2/9/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PMRParty;

@interface PMRDataStorage : NSObject

@property (nonatomic) NSMutableArray *parties;

- (void)loadAllParties;
- (void)savePatryToPlist:(PMRParty *)party;
- (void)savePlistFile;
+ (instancetype) dataStorage;

@end
