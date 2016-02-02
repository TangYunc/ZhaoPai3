//
//  AccountViewController.m
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/18.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import "AccountViewController.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的账户";
    self.navigationController.navigationBar.translucent = NO;
    //1.创建子视图
    [self CustomSubView];
 
}
    //1.创建子视图
- (void)CustomSubView{

    _accountView = [[AccountView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49)];
    _accountView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_accountView];

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
