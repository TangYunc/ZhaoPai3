//
//  SetViewController.m
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/18.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import "SetViewController.h"
#import "LoginViewController.h"

@interface SetViewController ()

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title = @"个人设置";
    

//    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"u45.png"]];
    //1.创建子视图内容
    [self SubViewsContent];    
}

    //1.创建子视图内容
- (void)SubViewsContent{

    //01.内容视图
    _view = [[UIView alloc] initWithFrame:CGRectMake(5, 10, kScreenWidth-5*2, 44*4)];
    _view.layer.borderWidth = 1;
    _view.layer.shadowColor = [UIColor blackColor].CGColor;
    _view.layer.shadowOffset = CGSizeMake(1, 1);
    _view.layer.shadowOpacity = 1;
    NSArray *titleArr = @[@"通知",@"找拍留言",@"使用帮助",@"关于我们"];
    CGFloat buttonHeight = _view.height/4.0;
    for (int i =0; i<titleArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, i*buttonHeight, _view.width, buttonHeight);
        button.tag = 10+i;
        [button setBackgroundImage:[UIImage imageNamed:@"u15MyAccount.png"] forState:UIControlStateNormal];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_view addSubview:button];
    }
    [self.view addSubview:_view];
    //02.退出登录按钮
    _logOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _logOutButton.frame = CGRectMake(_view.left+2, _view.bottom+20, kScreenWidth-(_view.left+2)*2, 40);
    [_logOutButton setBackgroundImage:[UIImage imageNamed:@"u45setButton.png"] forState:UIControlStateNormal];
    [_logOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [_logOutButton addTarget:self action:@selector(logOutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_logOutButton];


}

#pragma mark - 按钮点击事件
- (void)buttonAction:(UIButton *)button{

    if (button.tag == 10) {
        //点击的是通知按钮
    }else if (button.tag == 11){
    //点击的是找拍留言
    }else if (button.tag == 12){
    //点击的是使用帮助
    }else{
    //点击的是关于我们
    }
}

#pragma mark - 退出登录按钮事件
- (void)logOutButtonAction:(UIButton *)button{
    
//    NSLog(@"----dfafdsafas---%@",[[NSUserDefaults standardUserDefaults] objectForKey:kMY_uniqueIdentifiert]);
    NSLog(@"注销成功");
    //清除AppDelegate对象中的UserName和Password
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.my_userName = nil;
    appDelegate.my_uniqueIdentifier = nil;
    appDelegate.my_password = nil;
    appDelegate.my_userSettingsId = nil;
    //清除本地缓存
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kMY_userName];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kMY_uniqueIdentifiert];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kMY_UserSettingsId];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kMY_password];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"-------%@",[[NSUserDefaults standardUserDefaults] objectForKey:kMY_uniqueIdentifiert]);

    //弹出登陆页面
    [appDelegate checkLogin];
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
