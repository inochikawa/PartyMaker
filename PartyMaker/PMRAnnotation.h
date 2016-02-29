//
//  PMRAnnotation.h
//  PartyMaker
//
//  Created by 2 on 2/23/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class PMRParty;

@interface PMRAnnotation : NSObject<MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSInteger partyLogoIndex;
@property (nonatomic) NSInteger partyId;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (instancetype)initWithParty:(PMRParty *)party;

@end
