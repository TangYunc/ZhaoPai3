//
//  AppDelegate.m
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/18.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import "AppDelegate.h"
#import "RootTabBarController.h"
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //判断之前应用是否已经完成登陆
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:kMY_uniqueIdentifiert] != nil) {
        //获取用户id和用户的密码
        self.my_userName =[userDefault objectForKey:kMY_userName];
        self.my_uniqueIdentifier = [userDefault objectForKey:kMY_uniqueIdentifiert];
    }
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor= [UIColor blackColor];
    _rootTBCtrl = [[RootTabBarController alloc] init];
    _window.rootViewController = _rootTBCtrl;
    //设置状态栏颜色
    [self preferredStatusBarStyle];
    [_window makeKeyAndVisible];
    // 判读之前应用程序是否已经完成登陆
    [self checkLogin];
    return YES;
}
- (UIStatusBarStyle)preferredStatusBarStyle{

    return UIStatusBarStyleDefault;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//检测用户是否登陆
- (void)checkLogin{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kMY_uniqueIdentifiert] == nil ) {

        LoginViewController *loginVC = [[LoginViewController alloc] init];
        //判断controller是不是有presentedViewController，没有的话才可以present
        if ([UIApplication sharedApplication].delegate.window.rootViewController.presentedViewController == nil) {
            [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:loginVC animated:YES completion:nil];
        }
    }else
    {
        _rootTBCtrl.selectedIndex = 1;
    }
}
@end
