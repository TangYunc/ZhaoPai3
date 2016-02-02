//
//  LoginViewController.m
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/18.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "FindPasswordViewController.h"
#import "MainPageViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //1.自定义子视图界面
    [self CustomSubView];
}

    //1.自定义子视图界面
- (void)CustomSubView{

    //01.标志图片视图
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-60)/2.0, (kScreenWidth-60)/2.0, 60, 60)];
    _iconImageView.image = [UIImage imageNamed:@"u2.png"];
    [self.view addSubview:_iconImageView];
    //02.账户输入文本框
    _accountNameTF = [[UITextField alloc] initWithFrame:CGRectMake(50, _iconImageView.bottom+100, kScreenWidth-50*2, 50)];
    _accountNameTF.placeholder = @"      请输入您的账户名";
    _accountNameTF.autocapitalizationType = NO;
    _accountNameTF.borderStyle = UITextBorderStyleNone;
    _accountNameTF.clearButtonMode = YES;
    _accountNameTF.textAlignment = NSTextAlignmentLeft;
    _accountNameTF.keyboardType = UIKeyboardTypeDefault;
    _accountNameTF.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_accountNameTF];
    //03.账户输入文本下面的线
    _lineImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(_accountNameTF.left, _accountNameTF.bottom, _accountNameTF.width, 1)];
    _lineImageView1.image = [UIImage imageNamed:@"u19_line.png"];
    [self.view addSubview:_lineImageView1];
    //04.密码输入文本框
    _passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(_lineImageView1.left, _lineImageView1.bottom, _lineImageView1.width, _accountNameTF.height)];
    _passwordTF.autocapitalizationType = NO;
    _passwordTF.placeholder = @"      请输入您的密码";
    _passwordTF.borderStyle = UITextBorderStyleNone;
    _passwordTF.clearButtonMode = YES;
    _passwordTF.textAlignment = NSTextAlignmentLeft;
    _passwordTF.keyboardType = UIKeyboardTypeDefault;
    _passwordTF.secureTextEntry = YES;
    [self.view addSubview:_passwordTF];
    //05.密码输入文本下面的线
    _lineImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(_passwordTF.left, _passwordTF.bottom, _passwordTF.width, 1)];
    _lineImageView2.image = [UIImage imageNamed:@"u19_line.png"];
    [self.view addSubview:_lineImageView2];

    //07.登录按钮
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginButton.frame = CGRectMake((kScreenWidth-195)/2, _lineImageView2.bottom+30, 195, 40);
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"u21login.png"] forState:UIControlStateNormal];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    _loginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _loginButton.titleLabel.textColor = [UIColor whiteColor];
    [_loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    //08.第三方登录按钮
    NSArray *otherLoginButtonTitleArr = @[@"QQ账号登录",@"微博账号登录",@"微信账号登录",@"人人账号登录"];
    for (int i = 0; i<otherLoginButtonTitleArr.count; i++) {
        //两个按钮之间的缝隙宽
        CGFloat gapWidth = kScreenWidth-(130*2+40*2);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(40+i%2*(130+gapWidth), _loginButton.bottom+40+i/2*(30+20), 130, 30);
        button.tag = i;
        [button setBackgroundImage:[UIImage imageNamed:@"u23.png"] forState:UIControlStateNormal];
        [button setTitle:otherLoginButtonTitleArr[i] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.textColor = [UIColor blackColor];
        [button addTarget:self action:@selector(otherButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    //09.注册与找回密码按钮
    NSArray *registerAndFindPasswordTitles = @[@"注册",@"找回密码"];
    for (int i = 0; i<registerAndFindPasswordTitles.count; i++) {
        //两个按钮中间的缝隙宽度
        CGFloat gapWidth = kScreenWidth-(160*2+2*2);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(2+i*(160+gapWidth), self.view.bottom-40, 160, 40);
        button.tag = 10+i;
        [button setBackgroundImage:[UIImage imageNamed:@"u27.png"] forState:UIControlStateNormal];
        [button setTitle:registerAndFindPasswordTitles[i] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.textColor = [UIColor blackColor];
        [button addTarget:self action:@selector(registerAndFindPasswordButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];

    }
}

#pragma mark - 登录按钮点击事件
- (void)loginButtonAction:(UIButton *)button{

    if (_accountNameTF.text.length == 0 || _passwordTF.text.length == 0) {
        //弹出alert视图提示输入账号密码
        [self popAlertViewWithTitle:@"登录失败" Message:@"输入信息不能为空"];
    }else{
    //点击登录
        //先判断当前输入的账户是否注册
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //配置参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //拼接URL
        NSString *urlString = [@"http://webapi.cmdi-info.com/" stringByAppendingString:@"CheckUser?"];
        NSString *unAndPswString = [NSString stringWithFormat:@"un=%@&pwd=%@",_accountNameTF.text,_passwordTF.text];
        NSString *String = [urlString stringByAppendingString:unAndPswString];
        
        [params setObject:_accountNameTF.text forKey:@"un"];
        [params setObject:_passwordTF.text forKey:@"pwd"];
        
        [manager POST:String parameters:params constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //请求成功
            //显示加载视图
            _activityIndicatorView = [[ActivityIndicatorView alloc] initWithFrame:CGRectZero];
            [self.view addSubview:_activityIndicatorView];
            [_activityIndicatorView showWithActivityIndicatorMessage:@"正在登陆，请稍后..."];
            NSLog(@"%@",responseObject);
            if ([responseObject[@"UserName"] isEqualToString: _accountNameTF.text] && [responseObject[@"Password"] isEqualToString: _passwordTF.text] ) {
                //用户已经注册，并且验证成功，保存当前用户信息到本地，登陆跳转到首页
                appDelegate.my_userName = responseObject[@"UserName"];
                appDelegate.my_uniqueIdentifier = responseObject[@"Id"];
                appDelegate.my_password = responseObject[@"Password"];
                appDelegate.my_userSettingsId = responseObject[@"UserSettingsId"];
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setObject:appDelegate.my_uniqueIdentifier forKey:kMY_uniqueIdentifiert];
                [userDefault setObject:appDelegate.my_userName forKey:kMY_userName];
                [userDefault setObject:appDelegate.my_password forKey:kMY_password];
                [userDefault setObject:appDelegate.my_userSettingsId forKey:kMY_UserSettingsId];
                [userDefault synchronize];
                NSLog(@"----dfafdsafas---%@",[[NSUserDefaults standardUserDefaults] objectForKey:kMY_uniqueIdentifiert]);
                [_activityIndicatorView hide];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else if (![responseObject[@"UserName"] isEqualToString: _accountNameTF.text]){
                [self popAlertViewWithTitle:@"登陆失败" Message:@"请确认您的账户是否正确"];
            
            }else if (![responseObject[@"Password"] isEqualToString: _passwordTF.text]){
                [self popAlertViewWithTitle:@"登陆失败" Message:@"请确认您的密码是否正确"];
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
  }
}
#pragma mark - 第三方按钮点击事件
- (void)otherButtonAction:(UIButton *)button{

    if (button.tag ==0) {
        //点击QQ登录
    }else if (button.tag ==1){
    //点击微博账号登录
    }else if (button.tag ==2){
    //点击微信账户登录
    }else{
    //点击人人账号登录
    }
}
#pragma mark - 弹出alert视图提示输入账号密码
- (void)popAlertViewWithTitle:(NSString *)title Message:(NSString *)message{
    
    //弹出alert视图提示输入账号密码
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}



#pragma mark - 注册与找回密码按钮
- (void)registerAndFindPasswordButtonAction:(UIButton *)button{

    if (button.tag ==10) {
        //点击的是注册按钮
        RegisterViewController *registerVC = [[RegisterViewController alloc] init];
        UINavigationController *registerNavCtrl = [[UINavigationController alloc] initWithRootViewController:registerVC];
        registerVC.navigationController.navigationBar.barTintColor = [UIColor greenColor];
        //设置导航栏字体颜色
        [registerVC.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        registerNavCtrl.navigationBar.translucent = NO;
        [self presentViewController:registerNavCtrl animated:YES completion:nil];
    }else{
    //点击的是找回密码按钮
        FindPasswordViewController *findPasswordVC = [[FindPasswordViewController alloc] init];
        UINavigationController *findPasswordNavCtrl = [[UINavigationController alloc] initWithRootViewController:findPasswordVC];
        findPasswordVC.navigationController.navigationBar.barTintColor = [UIColor greenColor];
        //设置导航栏字体颜色
        [findPasswordNavCtrl.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        findPasswordNavCtrl.navigationBar.translucent = NO;

        [self presentViewController:findPasswordNavCtrl animated:YES completion:nil];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//注册当前视图未第一响应者
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UIView *view in self.view.subviews) {
        if ([view isFirstResponder]) {
            [view resignFirstResponder];
        }
    }
}

@end
