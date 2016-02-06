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
#define kImagePathKey           @"imagePath"
#define kDataFile               @"Parties.plist"
#define kDataKey                @"Parties"

@implementation PMRParty

static NSMutableArray *parties;

- (instancetype)init {
    self = [super init];
    if (!self) {
        NSLog(@"%s - [Error] - PMRPArty doesn't init.", __PRETTY_FUNCTION__);
        return nil;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (!self) {
        NSLog(@"%s - [Error] - PMRPArty doesn't init.", __PRETTY_FUNCTION__);
        return nil;
    }
    
    self.eventName = [aDecoder decodeObjectForKey:kEventNameKey];
    self.eventDescription = [aDecoder decodeObjectForKey:kEventDescriptionKey];
    self.startDate = [aDecoder decodeObjectForKey:kStartDateKey];
    self.endDate = [aDecoder decodeObjectForKey:kEndDateKey];
    self.imagePath = [aDecoder decodeObjectForKey:kImagePathKey];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.eventName forKey:kEventNameKey];
    [aCoder encodeObject:self.eventDescription forKey:kEventDescriptionKey];
    [aCoder encodeObject:self.startDate forKey:kStartDateKey];
    [aCoder encodeObject:self.endDate forKey:kEndDateKey];
    [aCoder encodeObject:self.imagePath forKey:kImagePathKey];
}

- (void)save {
    if (!parties) {
        parties = [NSMutableArray new];
        NSLog(@"%s --- Parties array was created.", __PRETTY_FUNCTION__);
    }
    
    [parties addObject:self];
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:kDataFile];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [self copyPlistFile];
    }
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:parties forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:path atomically:YES];
}

- (void)copyPlistFile {
    NSFileManager *fileManger=[NSFileManager defaultManager];
    NSError *error;
    
    NSString *destinationPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:kDataFile];
    
    NSString *sourcePath=[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:kDataFile];
    
    if ([fileManger copyItemAtPath:sourcePath toPath:destinationPath error:&error]) {
        NSLog(@"%s --- Parties.plist copies from bundle to Documents directory.", __PRETTY_FUNCTION__);
    }
    else {
        NSLog(@"%s - [Error] - %@", __PRETTY_FUNCTION__, error);
    }
}

#pragma mark - Class methods

+ (NSMutableArray *)parties {
    if (!parties) {
        parties = [NSMutableArray new];
        NSLog(@"%s --- Parties array was created.", __PRETTY_FUNCTION__);
    }
    return parties;
}

+ (void)loadAllPatries {
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:kDataFile];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        parties = [unarchiver decodeObjectForKey:kDataKey];
        [unarchiver finishDecoding];
        NSLog(@"%s --- Parties array was loaded.", __PRETTY_FUNCTION__);
    } else {
        parties = [NSMutableArray new];
        NSLog(@"%s --- Parties array was created.", __PRETTY_FUNCTION__);
    }
}

@end
