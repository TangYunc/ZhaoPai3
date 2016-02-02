//
//  AppDelegate.h
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/18.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetViewController.h"
#import "RootTabBarController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,strong)NSString *my_userSettingsId;
@property(nonatomic,strong)NSString *my_uniqueIdentifier;
@property (nonatomic, strong)NSString *my_userName;
@property (nonatomic, strong)NSString *my_password;

@property(nonatomic,strong)RootTabBarController *rootTBCtrl;

- (void)checkLogin;
@end

