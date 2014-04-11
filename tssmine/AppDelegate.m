//
//  AppDelegate.m
//  tssmine
//
//  Created by Bob Cao on 2/11/13.
//  Copyright (c) 2013 Bob Cao. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "TssLoginViewController.h"
#import "PayPalMobile.h"
#import "TssLoginViewController.h"
#import "MySMUViewController.h"
#import "RootTabBarViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Register Parse Application.
    [Parse setApplicationId:@"dwus9w9uMQdXlXxXMgvZawLzmKEhmKbGBGdLkInZ"
               clientKey:@"fXJDUlzqfqpcXJZDQAd62uDF5KmwA0mWz1qOHthT"];
    [PFFacebookUtils initializeFacebook];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Register for push notifications
    [application registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    
    [PayPalMobile initializeWithClientIdsForEnvironments:@{ PayPalEnvironmentSandbox : @"AQLv9RCZSfPuSSlSsxDohHBDiFnX8N-bOLx8oR7HLGSTk2HouT46jwsY0UHU"}];
    
    
    //UIControl config
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];

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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    
    [currentInstallation addUniqueObject:@"TSS" forKey:@"channels"];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
    
    
    
    PFQuery *queryExistingThumbUps = [PFQuery queryWithClassName:@"Token"];
    [queryExistingThumbUps whereKey:@"deviceToken" equalTo:[currentInstallation objectForKey:@"deviceToken"]];
    [queryExistingThumbUps findObjectsInBackgroundWithBlock:^(NSArray *tokens, NSError *error) {
        if ([tokens count] == 0) {
            PFObject *w = [PFObject objectWithClassName:@"Token"];
            w[@"deviceToken"] = [currentInstallation objectForKey:@"deviceToken"];
            w[@"deviceType"] = [currentInstallation objectForKey:@"deviceType"];
            [w saveInBackground];
        } else if ([tokens count] == 1){
            for (PFObject *token in tokens) {
                [token delete];
            }
            PFObject *w = [PFObject objectWithClassName:@"Token"];
            w[@"deviceToken"] = [currentInstallation objectForKey:@"deviceToken"];
            w[@"deviceType"] = [currentInstallation objectForKey:@"deviceType"];
            [w saveInBackground];
        }
    }];
    
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}


-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
     [tabBarController.moreNavigationController popToRootViewControllerAnimated:NO];
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
}

@end
