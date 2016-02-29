//
//  PMRAnnotation.m
//  PartyMaker
//
//  Created by 2 on 2/23/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRAnnotation.h"
#import"PMRParty.h"

@implementation PMRAnnotation

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    
    if (!self) {
        NSLog(@"PMRAnnotation doesn't created");
        return nil;
    }
    
    self.coordinate = coordinate;
    return self;
}

- (instancetype)initWithParty:(PMRParty *)party {
    self = [super init];
    
    if (!self) {
        NSLog(@"PMRAnnotation doesn't created");
        return nil;
    }
    
    if ([self isValidLocationString:party.longitude]) {
        self.coordinate = [self parseLocationFromString:party.longitude];
    }
    
    self.title = party.eventName;
    self.subtitle = party.latitude;
    self.partyId = party.eventId;
    self.partyLogoIndex = party.imageIndex;
    return self;

}

- (CLLocationCoordinate2D)parseLocationFromString:(NSString *)locationString {
    CLLocationCoordinate2D coordinate;
    NSArray *strings = [locationString componentsSeparatedByString:@";"];
    coordinate.latitude = [strings[0] doubleValue];
    coordinate.longitude = [strings[1] doubleValue];
    return coordinate;
}

- (BOOL)isValidLocationString:(NSString *)locationString {
    NSArray *strings = [locationString componentsSeparatedByString:@";"];
    if (strings.count != 2) {
        return NO;
    }
    return YES;
}

@end
