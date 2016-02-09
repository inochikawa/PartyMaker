//
//  AppDelegate.m
//  PartyMaker
//
//  Created by 2 on 2/3/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRAppDelegate.h"

@interface PMRAppDelegate ()

@end

@implementation PMRAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"MyriadPro-Bold" size:15], NSFontAttributeName,nil]];
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
