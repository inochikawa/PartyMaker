//
//  PMRParty.m
//  PartyMaker
//
//  Created by Maksim Stecenko on 2/4/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRParty.h"

#define kEventNameKey           @"eventName"
#define kEventDescriptionKey    @"eventDescription"
#define kStartDateKey           @"startDate"
#define kEndDateKey             @"endDate"
#define kEventTitleKey          @"eventTitle"
#define kDataFile               @"Parties.plist"
#define kDataKey                @"Party"

@interface PMRParty()
@property (nonatomic) NSString *documentsPath;
@end

@implementation PMRParty

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    self.documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return self;
}

- (instancetype)initWithName:(NSString *)eventName {
    self = [self init];
    self.eventName = eventName;
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) return nil;
    
    self.eventName = [aDecoder decodeObjectForKey:kEventNameKey];
    self.eventDescription = [aDecoder decodeObjectForKey:kEventDescriptionKey];
    self.startDate = [aDecoder decodeObjectForKey:kStartDateKey];
    self.endDate = [aDecoder decodeObjectForKey:kEndDateKey];
    self.eventTitle = [aDecoder decodeObjectForKey:kEventTitleKey];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.eventName forKey:kEventNameKey];
    [aCoder encodeObject:self.eventDescription forKey:kEventDescriptionKey];
    [aCoder encodeObject:self.startDate forKey:kStartDateKey];
    [aCoder encodeObject:self.endDate forKey:kEndDateKey];
    [aCoder encodeObject:self.eventTitle forKey:kEventTitleKey];
}

- (void)save {
    // [self createDataPath];
    
    NSString *dataPath = [self.documentsPath stringByAppendingPathComponent:kDataFile];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:[NSString stringWithFormat:kDataKey]];
    [archiver finishEncoding];
    [data writeToFile:dataPath atomically:YES];
    NSLog(@"%@", dataPath);
}

- (BOOL)createDataPath {
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:self.documentsPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (!success) {
        NSLog(@"Error creating data path: %@", [error localizedDescription]);
    }
    return success;
}

@end
