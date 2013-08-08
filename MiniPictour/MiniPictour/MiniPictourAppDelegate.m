//
//  MiniPictourAppDelegate.m
//  MiniPictour
//
//  Created by Miguel Elvir on 22/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import "MiniPictourAppDelegate.h"
#import <Parse/Parse.h>
#import "UserLoginViewController.h"
#import "UserToursViewController.h"
#import "MiniPictourMapViewController.h"
#import "UsersViewController.h"

@implementation MiniPictourAppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}


// FBSample logic
// If we have a valid session at the time of openURL call, we handle Facebook transitions
// by passing the url argument to handleOpenURL; see the "Just Login" sample application for
// a more detailed discussion of handleOpenURL
/*- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                    fallbackHandler:^(FBAppCall *call) {
                        NSLog(@"In fallback handler");
                    }];
}*/
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    //Parse Configuration
    [Parse setApplicationId:@"X3iEwzzDFUjZvTIcZzPHTYbCCC5cJiln5tWl48ft"
                  clientKey:@"CZC3zizMFFK95wuqzEGWUAOAkvFNkhpDoe8gaRMT"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [PFFacebookUtils initializeFacebook];
    //Application main controller:
    UserLoginViewController *userLoginViewController = [[UserLoginViewController alloc] init];
    userLoginViewController.title = @"User account";
    userLoginViewController.tabBarItem.image = [UIImage imageNamed:@"111-user.png"];
        UITabBarController  *mainController = [[UITabBarController alloc] init];
    
    
    UsersViewController *usersViewController = [[UsersViewController alloc] init];
    usersViewController.title = @"Users";
    usersViewController.tabBarItem.image = [UIImage imageNamed:@"112-group.png"];
    
    
    if ([PFUser currentUser]){
        //User Tours:
        UserToursViewController *userTours = [[UserToursViewController alloc] initWithClassName:@"Tour" forUser:[PFUser currentUser]];
        userTours.title = @"My Tours";
        userTours.tabBarItem.image = [UIImage imageNamed:@"72-pin.png"];
        
        //General Map
        MiniPictourMapViewController *map = [[MiniPictourMapViewController alloc] initWithUser:[PFUser  currentUser]];
        map.title = @"Map";
        map.tabBarItem.image = [UIImage imageNamed:@"103-map.png"];
        
        [mainController setViewControllers:
            @[[[[UINavigationController alloc]initWithRootViewController:userTours ] autorelease] ,
              [[[UINavigationController alloc]initWithRootViewController:map ] autorelease] ,
              [[[UINavigationController alloc]initWithRootViewController:usersViewController ] autorelease],
              userLoginViewController]];
        [userTours release];
        [map release];
    }else{
        [mainController setViewControllers:@[[[[UINavigationController alloc]initWithRootViewController:usersViewController] autorelease],userLoginViewController]];
    }
    self.window.rootViewController = mainController;
    
    [userLoginViewController release];
    [usersViewController release];
    [mainController release];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
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
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [FBSession.activeSession close];

}


@end
