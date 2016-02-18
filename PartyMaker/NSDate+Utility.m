//
//  NSDate+Utility.m
//  PartyMaker
//
//  Created by 2 on 2/11/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "NSDate+Utility.h"

@implementation NSDate (Utility)

- (NSString *)toStringWithDateFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];
    return [dateFormatter stringFromDate:self];
}

- (NSNumber *)toSeconds {
    return @([self timeIntervalSince1970]);
}

+ (NSDate *)dateFromSeconds:(NSNumber *)seconds {
    return [NSDate dateWithTimeIntervalSince1970:(NSInteger)seconds];
}

+ (NSString *)stringDateFromSeconds:(NSNumber *)seconds withDateFormat:(NSString *)dateFormat{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(NSInteger)seconds];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:dateFormat];
    
    return [formatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)date withDateFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter dateFromString:date];
}

@end
