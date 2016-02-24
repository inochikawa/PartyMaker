//
//  PMRAnnotation.m
//  PartyMaker
//
//  Created by 2 on 2/23/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRAnnotation.h"

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

@end
