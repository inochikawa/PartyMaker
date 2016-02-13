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

-(instancetype) initUniqueInstance {
    return [super init];
}

+ (instancetype) dataStorage {
    static dispatch_once_t pred;
    static id storage = nil;
    dispatch_once(&pred, ^{
        storage = [[super alloc] initUniqueInstance];
    });
    return storage;
}

- (void)loadAllParties {
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:kDataFile];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.parties = [unarchiver decodeObjectForKey:kDataKey];
        [unarchiver finishDecoding];
        NSLog(@"%s --- Parties array was loaded.", __PRETTY_FUNCTION__);
    } else {
        self.parties = [NSMutableArray new];
        NSLog(@"%s --- Parties array was created.", __PRETTY_FUNCTION__);
    }
}

- (void)savePatryToPlist:(PMRParty *)party {
    if (!self.parties) {
        self.parties = [NSMutableArray new];
        NSLog(@"%s --- Parties array was created.", __PRETTY_FUNCTION__);
    }
    
    if (![self isPartyExist:party]) {
        [self.parties addObject:party];
    }
//    else {
//        int partyIndex = 0;
//        for (PMRParty *currentPaty in self.parties) {
//            if ([currentPaty isEqual:party]) {
//                [self.parties removeObject:party];
//                break;
//            }
//            partyIndex++;
//        }
//        [self.parties insertObject:party atIndex:partyIndex];
//    }
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:kDataFile];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [self copyPlistFile];
    }
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.parties forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:path atomically:YES];
    NSLog(@"%s --- Party was saved.", __PRETTY_FUNCTION__);
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

- (void)removePlistFile {
    NSFileManager *fileManger=[NSFileManager defaultManager];
    NSError *error;
    
    NSString *destinationPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:kDataFile];
    
    if ([fileManger removeItemAtPath:destinationPath error:&error]) {
        NSLog(@"%s --- Parties.plist removed from Documents directory.", __PRETTY_FUNCTION__);
    }
    else {
        NSLog(@"%s - [Error] - %@", __PRETTY_FUNCTION__, error);
    }
}

- (BOOL)isPartyExist:(PMRParty *)party {
    for (PMRParty *currentPaty in self.parties) {
        if ([currentPaty isEqual:party]) {
            return YES;
        }
    }
    return NO;
}

@end
