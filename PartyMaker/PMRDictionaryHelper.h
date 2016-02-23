//
//  PMRPartyDictionaryHelper.h
//  PartyMaker
//
//  Created by 2 on 2/22/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PMRParty;

@interface PMRDictionaryHelper : NSObject

+ (NSDictionary *)basePartyDictionary:(PMRParty *)party;
+ (NSDictionary *)fullPartyDictionary:(PMRParty *)party;

@end
