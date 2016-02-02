//
//  UIViewController+BaseNavigationItemButton.m
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/22.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import "UIViewController+BaseNavigationItemButton.h"

@implementation UIViewController (BaseNavigationItemButton)

#pragma mark - 创建属性的名字
- (void)setIsBackItem:(BOOL)isBackItem{

    if (isBackItem == YES) {
        //返回按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 20, 30);
        [button setBackgroundImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}
#pragma mark - 导航栏左侧返回按钮事件
- (void)backButtonAction:(UIBarButtonItem *)backBarButton{
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
