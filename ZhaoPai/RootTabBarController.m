//
//  RootTabBarController.m
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/18.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import "RootTabBarController.h"
#import "AccountViewController.h"
#import "MainPageViewController.h"
#import "SetViewController.h"

#import "BaseNavigationController.h"

@interface RootTabBarController ()

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1.初始化子视图控制器
    [self _initSubViewControllers];
    
    //2.自定义标签栏
    [self CustomTabBar];
    
    
}

    //1.初始化子视图控制器
- (void)_initSubViewControllers{

//1.创建所有的子视图控制器
    //01.账户
    AccountViewController *accountVC = [[AccountViewController alloc] init];
    
    //02.首页
    MainPageViewController *mainPageVC = [[MainPageViewController alloc] init];
    
    //03.设置
    SetViewController *setVC = [[SetViewController alloc] init];
    
    //04.创建一个数组用于存放子视图控制器
    NSArray *viewCtrls = @[accountVC,mainPageVC,setVC];

//2.为每个子视图控制器创建一个对应的导航控制器
    //创建一个可变数组用于存放所有的导航控制器
    NSMutableArray *navCtrls = [NSMutableArray array];
    for (UIViewController *viewCtrl in viewCtrls) {
        BaseNavigationController *baseNavCtrl = [[BaseNavigationController alloc] initWithRootViewController:viewCtrl];
        [navCtrls addObject:baseNavCtrl];
    }

//3.把所有的导航控制器给标签控制器
    self.viewControllers = navCtrls;
}

    //2.自定义标签栏
- (void)CustomTabBar{

    self.tabBar.translucent = NO;
    self.tabBar.barStyle = UIBarStyleDefault;
    //1.移除系统的标签栏上所有的子视图
    for (UIView  *view in self.tabBar.subviews) {
        //移除视图
        [view removeFromSuperview];
    }
    //2.创建视图控制器按钮
    NSArray *imageNames = @[@"u5.png",@"u5.png",@"u5.png"];
    NSArray *titles = @[@"账户",@"首页",@"个人"];
    CGFloat buttonWidth = kScreenWidth/3.0;
    for (int i = 0; i<titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*buttonWidth, 0, buttonWidth, 49);
        button.tag = i;
        [button setBackgroundImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:button];
    }




}

#pragma mark - 标签按钮事件
- (void)buttonAction:(UIButton *)button{

    self.selectedIndex = button.tag;



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
