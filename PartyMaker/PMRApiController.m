//
//  PMRApiController.m
//  PartyMaker
//
//  Created by 2 on 2/18/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRApiController.h"
#import "PMRCoreData.h"
#import "PMRCoreDataStack.h"
#import "PMRNetworkSDK.h"
#import "PMRUser.h"

@interface PMRApiController()
@end

@implementation PMRApiController

-(instancetype) initUniqueInstance {
    return [super init];
}

+ (instancetype)apiController {
    static dispatch_once_t pred;
    static id instance = nil;
    dispatch_once(&pred, ^{
        instance = [[super alloc] initUniqueInstance];
        [instance configureApiController];
    });
    return instance;
}

#pragma mark - Configure API controller

- (void)configureApiController {
    self.user = [PMRUser new];
    self.coreData = [PMRCoreData new];
    self.networkSDK = [PMRNetworkSDK new];
    self.coreData.coreDataStack = [PMRCoreDataStack new];
}

- (void)pmr_performCompletionBlock:(void (^) ())block {
    if (block) {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

@end
