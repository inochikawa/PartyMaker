//
//  PMRGuid.m
//  PartyMaker
//
//  Created by 2 on 2/12/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRGuid.h"

@implementation PMRGuid

+ (NSString *)newGuid {
    CFUUIDRef guidRef = CFUUIDCreate(NULL);
    CFStringRef guidStringRef = CFUUIDCreateString(NULL, guidRef);
    CFRelease(guidRef);
    return (__bridge_transfer NSString *)guidStringRef;
}

@end
