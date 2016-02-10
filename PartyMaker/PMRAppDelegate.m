//
//  AppDelegate.m
//  PartyMaker
//
//  Created by 2 on 2/3/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRAppDelegate.h"
#import "PMRDataStorage.h"

@interface PMRAppDelegate ()

@end

@implementation PMRAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"MyriadPro-Bold" size:15], NSFontAttributeName,nil]];

    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"MyriadPro-Regular" size:12.0f],
                                                        NSForegroundColorAttributeName : [UIColor whiteColor]
                                                        } forState:UIControlStateSelected];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"MyriadPro-Regular" size:12.0f],
                                                        NSForegroundColorAttributeName : [UIColor colorWithRed:35/255. green:37/255. blue:43/255. alpha:1]
                                                        } forState:UIControlStateNormal];
    
    [[PMRDataStorage dataStorage] loadAllParties];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
