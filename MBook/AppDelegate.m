//
//  AppDelegate.m
//  MBook
//
//  Created by  on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

//书架
#import "BookShelfViewController.h"

//书店
#import "BookStroeViewController.h"

//设置

#import "SettingViewController.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize tabBarController =_tabBarController;

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    //书架
    BookShelfViewController *bShelfVC = [[[BookShelfViewController alloc] init] autorelease];
    //书城
    BookStroeViewController *bStroreVC = [[[BookStroeViewController alloc]initWithNibName:@"BookStroeViewController" bundle:nil]autorelease];
    //设置
    SettingViewController *settingVC = [[[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil] autorelease];
    

    self.navigationController = [[[UINavigationController alloc]initWithRootViewController:bShelfVC] autorelease];
    
    self.tabBarController = [[UITabBarController alloc]init];
  
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:self.navigationController,bStroreVC,settingVC,nil];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
