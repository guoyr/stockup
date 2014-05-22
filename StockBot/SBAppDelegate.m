//
//  SBAppDelegate.m
//  StockBot
//
//  Created by Robert Guo on 2/26/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <SDImageCache.h>
#import "SBAppDelegate.h"
#import "SBStocksViewController.h"
#import "SBConstants.h"
#import "SBLoginViewController.h"
#import "SBUserAlgoTableViewController.h"
#import "SBAlgosViewController.h"

@implementation SBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
//    int debug_mode = DEBUG_MODE_NONE;
    int debug_mode = DEBUG_MODE_ALGO;


    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.tintColor = GREEN_0;
    [[UINavigationBar appearance] setBarTintColor:BLUE_4];
    
    BOOL loggedin = [[NSUserDefaults standardUserDefaults] boolForKey:@"loggedin"];
    
    UIViewController *vc;
    if (loggedin) {
        vc = [[SBUserAlgoTableViewController alloc] initWithNibName:nil bundle:nil];
    } else {
        vc = [[SBLoginViewController alloc] initWithNibName:nil bundle:nil];

    }
    
    switch (debug_mode) {
        case DEBUG_MODE_ALGO:
            vc = [[SBAlgosViewController alloc] initWithNibName:nil bundle:nil];
            break;
            
        default:
            break;
    }
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [[nav navigationBar] setBarStyle:UIBarStyleBlackTranslucent];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
    
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] setMaxCacheAge:60];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
