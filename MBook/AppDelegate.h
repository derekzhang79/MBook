//
//  AppDelegate.h
//  MBook
//
//  Created by  on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (retain, nonatomic) UIWindow *window;

@property (retain, nonatomic) UINavigationController *navigationController;
@property (retain, nonatomic) UITabBarController *tabBarController;


@end
