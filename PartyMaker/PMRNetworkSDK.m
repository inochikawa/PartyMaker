//
//  PMRPartyMakerSDK.m
//  PartyMaker
//
//  Created by 2 on 2/16/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRNetworkSDK.h"
#import "PMRParty.h"
#import "NSDate+Utility.h"

static NSString *APIURLLink;

@interface PMRNetworkSDK()
@property (nonatomic) NSURLSession *defaultSession;
@end

@implementation PMRNetworkSDK

- (instancetype)init {
    self = [super init];
    
    if (!self) {
        NSLog(@"[Error] - Network SDK was not inited");
        return nil;
    }
    
    [self configureSession];
    return self;
}

- (void)configureSession {
    APIURLLink = @"http://itworksinua.km.ua/party";
    NSURLSessionConfiguration *sessionConf = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConf.timeoutIntervalForRequest = 5.;
    sessionConf.allowsCellularAccess = NO;
    self.defaultSession = [NSURLSession sessionWithConfiguration:sessionConf];
}

- (NSMutableURLRequest *)requestWithHTTPMethod:(NSString *)HTTPmethod
                            withMetodAPI:(NSString *)methodAPI
                    withHeaderDictionary:(NSDictionary *)headerDictionary
                withParametersDictionary:(NSDictionary *)parametrsDictionary {
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/%@", APIURLLink, methodAPI];
    [urlString setString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [urlRequest setHTTPMethod:HTTPmethod];
    
    if ([HTTPmethod isEqualToString:@"GET"]) {
        [urlString appendString:@"?"];
        
        for (NSString *key in parametrsDictionary) {
            [urlString appendString:[NSString stringWithFormat:@"%@=%@&", key, parametrsDictionary[key]]];
        }
        
        [urlString setString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        urlRequest.URL = [NSURL URLWithString:urlString];
        
    } else if ([HTTPmethod isEqualToString:@"POST"]){
        NSMutableString *tempUrl = [[NSMutableString alloc] initWithString:@""];
        
        for (NSString *key in headerDictionary) {
            [tempUrl appendString:[NSString stringWithFormat:@"%@=%@&", key, headerDictionary[key]]];
        }
        
        NSData *reqData = [tempUrl dataUsingEncoding:NSUTF8StringEncoding];
        [urlRequest setHTTPBody:reqData];
    }
    
    return urlRequest;
}

#pragma mark - GET

- (void) loginWithUserName:(NSString *) userName withPassword:(NSString *) password callback:(void (^) (NSDictionary *response, NSError *error))block {
    NSURLRequest *request = [self requestWithHTTPMethod:@"GET" withMetodAPI:@"login" withHeaderDictionary:nil withParametersDictionary:@{@"name":userName, @"password":password}];
    __weak __block PMRNetworkSDK *weakSelf = self;
    [[self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (block) {
            NSDictionary *responseDictionary = [weakSelf serialize:data statusCode:@([(NSHTTPURLResponse *)response statusCode])];
            [weakSelf pmr_performCompletionBlock:block responce:responseDictionary error:error];
        }
    }] resume];
}

- (void) loadAllPartiesByUserId:(NSNumber *)userId callback:(void (^) (NSArray *parties, NSError *error))block {
    NSURLRequest *request = [self requestWithHTTPMethod:@"GET" withMetodAPI:@"party" withHeaderDictionary:nil withParametersDictionary:@{@"creator_id":userId}];
    __weak __block PMRNetworkSDK *weakSelf = self;
    [[self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (block) {
            NSDictionary *responseDictionary = [weakSelf serialize:data statusCode:@([(NSHTTPURLResponse *)response statusCode])];
            
            NSMutableArray *parties = [NSMutableArray new];
            NSMutableArray *arrayOfDictionaries = [NSMutableArray new];
            
            if (![responseDictionary[@"response"] isEqual:[NSNull null]]) {
                [arrayOfDictionaries addObjectsFromArray:responseDictionary[@"response"]];
            }
            
            for (NSDictionary *dictionary in arrayOfDictionaries) {
                PMRParty *party = [PMRParty new];
                party.eventId = @([dictionary[@"id"] integerValue]);
                party.eventName = dictionary[@"name"];
                party.eventDescription = dictionary[@"comment"];
                party.startTime = @([dictionary[@"start_time"] integerValue]);
                party.endTime = @([dictionary[@"end_time"] integerValue]);
                party.imageIndex = @([dictionary[@"logo_id"] integerValue]);
                party.latitude = dictionary[@"latitude"];
                party.longitude = dictionary[@"longitude"];
                party.creatorId = @([dictionary[@"creator_id"] integerValue]);
                
                [parties addObject:party];
            }
            
            if (block) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(parties, error);
                });
            }
        }
    }] resume];
}

- (void) deletePartyWithPartyId:(NSNumber *)partyId withCreatorId:(NSNumber *)creatorId callback:(void (^) (NSDictionary *response, NSError *error))block {
    NSURLRequest *request = [self requestWithHTTPMethod:@"GET" withMetodAPI:@"deleteParty" withHeaderDictionary:nil withParametersDictionary:@{@"party_id":partyId, @"creator_id":creatorId}];
    __weak __block PMRNetworkSDK *weakSelf = self;
    [[self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (block) {
            NSDictionary *responseDictionary = [weakSelf serialize:data statusCode:@([(NSHTTPURLResponse *)response statusCode])];
            [weakSelf pmr_performCompletionBlock:block responce:responseDictionary error:error];
        }
    }] resume];
}

- (void)allUsersWithcallback:(void (^) (NSDictionary *response, NSError *error))block {
    NSURLRequest *request = [self requestWithHTTPMethod:@"GET" withMetodAPI:@"allUsers" withHeaderDictionary:nil withParametersDictionary:nil];
    __weak __block PMRNetworkSDK *weakSelf = self;
    [[self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (block) {
            NSDictionary *responseDictionary = [weakSelf serialize:data statusCode:@([(NSHTTPURLResponse *)response statusCode])];
            [weakSelf pmr_performCompletionBlock:block responce:responseDictionary error:error];
        }
    }] resume];
}

#pragma mark - POST 

- (void)registerUserWithName:(NSString *)userName witEmail:(NSString *)email withPassword:(NSString *)password callback:(void (^) (NSDictionary *response, NSError *error))block {
    NSURLRequest *request = [self requestWithHTTPMethod:@"POST" withMetodAPI:@"register" withHeaderDictionary:@{@"email":email, @"password":password, @"name":userName} withParametersDictionary:nil];
    __weak __block PMRNetworkSDK *weakSelf = self;
    [[self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (block) {
            NSDictionary *responseDictionary = [weakSelf serialize:data statusCode:@([(NSHTTPURLResponse *)response statusCode])];
            [weakSelf pmr_performCompletionBlock:block responce:responseDictionary error:error];
        }
    }] resume];
}

- (void)addPaty:(PMRParty *)party callback:(void (^) (NSNumber *partyId, NSError *error))block {
    NSURLRequest *request = [self requestWithHTTPMethod:@"POST"
                                           withMetodAPI:@"addParty"
                                   withHeaderDictionary:@{@"party_id":party.eventId,
                                                          @"name":party.eventName,
                                                          @"start_time":party.startTime,
                                                          @"end_time":party.endTime,
                                                          @"logo_id":party.imageIndex,
                                                          @"comment":party.eventDescription,
                                                          @"creator_id":party.creatorId,
                                                          @"latitude":party.latitude,
                                                          @"longitude":party.longitude }
                               withParametersDictionary:nil];
    NSNumber *partyCreatorId = party.creatorId;
    __block __weak PMRNetworkSDK *weakSelf = self;
    [[self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (block) {
            [weakSelf partyIdByUserId:partyCreatorId withCallback:^(NSNumber *partyId) {
                if (block) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(partyId, error);
                    });
                }
            }];
        }
    }] resume];
}

- (NSDictionary *) serialize:(NSData *) data statusCode:(NSNumber *) statusCode {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (statusCode && [statusCode intValue] != 0)
        [dict setValue:statusCode forKey:@"statusCode"];
    else
        [dict setValue:@505 forKey:@"statusCode"];
    id jsonArray;
    if (data) jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    if (!jsonArray) jsonArray = [NSNull null];
    [dict setValue:jsonArray forKey:@"response"];
    return dict;
}

#pragma mark - Helpers

- (void)pmr_performCompletionBlock:(void (^) (NSDictionary *response, NSError *error))block responce:(NSDictionary *)response error:(NSError *)error {
    if (block) {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(response, error);
        });
    }
}

- (void)partyIdByUserId:(NSNumber *)userId withCallback:(void (^) (NSNumber *partyId))callback{
    [self loadAllPartiesByUserId:userId callback:^(NSArray *parties, NSError *error) {
        if (!error) {
            NSInteger neededId = 0;
            
            for (PMRParty *party in parties) {
                if ([party.eventId integerValue] > neededId) {
                    neededId = [party.eventId integerValue];
                }
            }
            
            if (callback) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(@(neededId));
                });
            }
        }
        else {
            NSLog(@"%s --- [Error] - %@, user info - %@", __PRETTY_FUNCTION__, error, error.userInfo);
        }
        
    }];
}

@end
