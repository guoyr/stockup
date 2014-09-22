//
//  SBAppDelegate.m
//  StockBot
//
//  Created by Robert Guo on 2/26/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBAppDelegate.h"
#import "SBStocksViewController.h"
#import "SBConstants.h"
#import "SBLoginViewController.h"
#import "SBUserAlgoTableViewController.h"
#import "SBAlgosViewController.h"
#import "SBDataManager.h"
#import "AFHTTPRequestOperationManager.h"

@implementation SBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
//    int debug_mode = DEBUG_MODE_ALGO;
    int debug_mode = 0;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.tintColor = GREY_LIGHT;
    [[UINavigationBar appearance] setBarTintColor:GREY_DARK];
    
    SBUserAlgoTableViewController *vc1 = [[SBUserAlgoTableViewController alloc] initWithNibName:nil bundle:nil];
    SBLoginViewController *vc2 =[[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];

    UIViewController *curvc;
    if ([[SBDataManager sharedManager] authCookie]) {
        NSLog(@"logged in");
        curvc = vc1;
    } else {
        curvc = vc2;
    }
    
    UINavigationController *nav = [[UINavigationController alloc] init];
    [nav setViewControllers:@[curvc]];
    [[nav navigationBar] setBarStyle:UIBarStyleBlackTranslucent];
    
    UIViewController *vc;
    switch (debug_mode) {
        case DEBUG_MODE_ALGO:
            vc = [[SBAlgosViewController alloc] initWithNibName:nil bundle:nil];
            [nav pushViewController:vc animated:YES];
            break;
        case DEBUG_MODE_STOCK:
            vc = [[SBStocksViewController alloc] initWithNibName:nil bundle:nil];
            [nav pushViewController:vc animated:YES];
        default:
            break;
    }
    
    // find out enabled notification types
    // UIRemoteNotificationType enabledTypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:nil]];
    
    
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *authCookie = [[SBDataManager sharedManager] authCookie];

    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];

    if (authCookie) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params = @{@"Cookie": authCookie, @"apns_token": token, @"user_id": @"admin"};
        NSString *urlString = [NSString stringWithFormat: @"%@add-token", SERVER_URL];
        [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (!((NSDictionary *) responseObject)[@"error"]) {
                NSLog(@"added token");
            } else {
                //TODO: deal with error (most likely not logged in)
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error");
        }];
    }
    NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

@end
