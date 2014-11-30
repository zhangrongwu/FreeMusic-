//
//  AppDelegate.h
//  FreeMusic
//
//  Created by zhaojianguo-PC on 14-5-27.
//  Copyright (c) 2014年 xiaozi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FMMainViewController,FMHomeViewController,FMTudouViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSInteger index;
    NSMutableArray * array;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FMMainViewController *mainViewController;
@property (strong, nonatomic) UINavigationController * rootNavigationController;
@property (strong, nonatomic) FMHomeViewController * homeViewController;
@property (strong, nonatomic) UINavigationController * homeNavigationController;

@property (strong, nonatomic) FMTudouViewController * tudouViewController;
@property (strong, nonatomic) UINavigationController * tudouNavigationController;


@property (strong, nonatomic) UITabBarController * tabBarController;

@end
