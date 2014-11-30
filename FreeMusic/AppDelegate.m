//
//  AppDelegate.m
//  FreeMusic
//
//  Created by zhaojianguo-PC on 14-5-27.
//  Copyright (c) 2014年 xiaozi. All rights reserved.
//

#import "AppDelegate.h"
#import "MCDataEngine.h"
#import "Globle.h"
#import "FMSingerModel.h"
#import "FMMainViewController.h"
#import "FMHomeViewController.h"
#import "FMTudouViewController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    Globle * globle = [Globle shareGloble];
    [globle copySqlitePath];
    globle.isPlaying = YES;
//    NSLog(@"%@",[NSProcessInfo processInfo].globallyUniqueString);
    
//    [self addSingerToDB];
//    NSString * string = [[NSString alloc] initWithCString:"火影" encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",string);b30323ace96d8762
    
    self.mainViewController = [[FMMainViewController alloc] init];
    self.rootNavigationController = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
    
    self.homeViewController = [[FMHomeViewController alloc] init];
    self.homeNavigationController = [[UINavigationController alloc] initWithRootViewController:self.homeViewController];
    
    self.tudouViewController = [[FMTudouViewController alloc] init];
    self.tudouNavigationController = [[UINavigationController alloc] initWithRootViewController:self.tudouViewController];


    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:self.homeNavigationController,self.rootNavigationController,self.tudouNavigationController, nil];
    
    self.homeNavigationController.tabBarItem.title = @"我的音乐";
    self.homeNavigationController.tabBarItem.image = [UIImage imageNamed:@"mymusci"];
    self.rootNavigationController.tabBarItem.title = @"搜索";
    self.rootNavigationController.tabBarItem.image = [UIImage imageNamed:@"tabbarSearch"];
    self.tudouNavigationController.tabBarItem.title = @"土豆视频";
    self.tudouNavigationController.tabBarItem.image = [UIImage imageNamed:@"tabbarMovie"];

    self.tabBarController.selectedViewController = self.rootNavigationController;
    
    [self.window addSubview:self.tabBarController.view];
    
//    [self.window setRootViewController:self.tabBarController]
    
    [self.window makeKeyAndVisible];
    return YES;
}
//-(void)addSongToDB
//{
//    MCDataEngine * engine = [MCDataEngine new];
//    FMSingerModel * model = [array objectAtIndex:index];
//    
//    [engine getSingerSongListWith:model.ting_uid :model.songs_total WithCompletionHandler:^(FMSongList *songList) {
//        
//         index+=1;
//        [self performSelector:@selector(addSongToDB) withObject:nil afterDelay:0.1];
//       
//    } errorHandler:^(NSError *error) {
//        
//    }];
//}
-(void)addSingerToDB
{
    long long uid = 60467713;//[[array objectAtIndex:index] longLongValue];
    MCDataEngine * engine = [MCDataEngine new];
    [engine getSingerInformationWith:uid WithCompletionHandler:^(NSArray *array) {
//        index+=1;
//        NSLog(@"%ld",(long)index);
//        [self performSelector:@selector(addSingerToDB) withObject:nil afterDelay:0.1];
    } errorHandler:^(NSError *error) {
        
    }];
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
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
	[self becomeFirstResponder];
    [Globle shareGloble].isApplicationEnterBackground = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:FMRFRadioViewSetSongInformationNotification object:nil userInfo:nil];
}
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    NSString * statu = nil;
	if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPause:
                statu = @"UIEventSubtypeRemoteControlPause";
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                statu = @"UIEventSubtypeRemoteControlPreviousTrack";
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                statu = @"UIEventSubtypeRemoteControlNextTrack";
                break;
            case UIEventSubtypeRemoteControlPlay:
                statu = @"UIEventSubtypeRemoteControlPlay";
                break;
            default:
                break;
        }
    }
    NSMutableDictionary * dict = [NSMutableDictionary new];
    [dict setObject:statu forKey:@"keyStatus"];
    [[NSNotificationCenter defaultCenter] postNotificationName:FMRFRadioViewStatusNotifiation object:nil userInfo:dict];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [Globle shareGloble].isApplicationEnterBackground = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
