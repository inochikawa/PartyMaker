//
//  PMRDataStorage.m
//  PartyMaker
//
//  Created by 2 on 2/9/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRDataStorage.h"
#import "PMRParty.h"

#define kDataFile   @"Parties.plist"
#define kDataKey    @"Parties"

@interface PMRDataStorage()

@end

@implementation PMRDataStorage

+ (NSArray *)loadAllParties {
    NSArray *parties;
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
        return nil;
    }
    return parties;
}

+ (void)savePatryToPlist:(PMRParty *)party {
    NSMutableArray *parties = [[NSMutableArray alloc] initWithArray:[self loadAllParties]];
    
    if (!parties) {
        parties = [NSMutableArray new];
        NSLog(@"%s --- Parties array was created.", __PRETTY_FUNCTION__);
    }
    
    [parties addObject:party];
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:kDataFile];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [self copyPlistFile];
    }
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:parties forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:path atomically:YES];
    NSLog(@"%s --- Party was saved.", __PRETTY_FUNCTION__);
}

+ (void)copyPlistFile {
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

@end
