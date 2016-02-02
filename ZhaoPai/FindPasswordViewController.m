//
//  FindPasswordViewController.m
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/18.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "ReSetPasswordViewController.h"

@interface FindPasswordViewController ()

@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"找回密码";
    
    //初始化子视图的内容
    [self _initSubViewContent];
}
    //初始化子视图的内容
- (void)_initSubViewContent{

    //导航栏返回按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 30);
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    NSArray *labelTitle =@[@"手机号码:",@"验证码:"];
    for (int i = 0; i<labelTitle.count; i++) {
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10+i*(40+10), 80, 40)];
        lable.tag = 10+i;
        lable.text = labelTitle[i];
        lable.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:lable];
    }
    //手机号码输入框
    //获取推荐码文本框
    UILabel *phoneNumLabel = (UILabel *)[self.view viewWithTag:10];
    //文本输入框宽度
    CGFloat textFieldWidth = kScreenWidth-phoneNumLabel.right-10-20;
    _phoneNumTF = [[UITextField alloc] initWithFrame:CGRectMake(phoneNumLabel.right+5, phoneNumLabel.top, textFieldWidth, 40)];
    _phoneNumTF.placeholder = @"输入11位手机号码";
    _phoneNumTF.autocapitalizationType = NO;
    _phoneNumTF.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:_phoneNumTF];
    //验证码文本框
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(_phoneNumTF.left, _phoneNumTF.bottom+10, _phoneNumTF.width/2, _phoneNumTF.height)];
    _textField.autocapitalizationType = NO;
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.borderStyle = UITextBorderStyleLine;
    _textField.clearButtonMode = YES;
    [self.view addSubview:_textField];
    //04.获取短信验证码按钮
    UIButton *getMessageIdentifyingCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    getMessageIdentifyingCodeButton.frame = CGRectMake(_textField.right+10, _textField.top, _phoneNumTF.width-_textField.width-10, _textField.height);
    [getMessageIdentifyingCodeButton setBackgroundImage:[UIImage imageNamed:@"获取短信_u26.png"] forState:UIControlStateNormal];
    [getMessageIdentifyingCodeButton setTitle:@"获取短信验证码" forState:UIControlStateNormal];
    [getMessageIdentifyingCodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    getMessageIdentifyingCodeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [getMessageIdentifyingCodeButton addTarget:self action:@selector(getMessageIdentifyingCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getMessageIdentifyingCodeButton];

    //下一步按钮
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextButton.frame = CGRectMake((kScreenWidth-155)/2, getMessageIdentifyingCodeButton.bottom+20, 155, 35);
    [_nextButton setBackgroundImage:[UIImage imageNamed:@"u19findPassword.png"] forState:UIControlStateNormal];
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextButton];

}

#pragma mark - 导航栏返回按钮事件
- (void)buttonAction:(UIBarButtonItem *)buttonItem{

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 获取短信验证码事件
- (void)getMessageIdentifyingCodeAction:(UIButton *)button{
    
    //点击获取短信验证码
}

#pragma mark - 下一步按钮事件
- (void)nextAction:(UIButton *)button{

    if (_phoneNumTF.text.length == 0 ||_textField.text == 0) {
        //弹出提示窗口
        [self popAlertViewWithTitle:@"注册失败" Message:@"输入信息不能为空"];
    }else{
    //根据情况看是否需要返回手机号给登录界面的手机号输入框
    }
    //点击进入重置密码确认页面
    ReSetPasswordViewController *reSetPasswordVC = [[ReSetPasswordViewController alloc] init];
    [self.navigationController pushViewController:reSetPasswordVC animated:YES];
    
}
#pragma mark - 弹出alert视图提示输入账号密码
- (void)popAlertViewWithTitle:(NSString *)title Message:(NSString *)message{
    
    //弹出alert视图提示输入账号密码
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:confirm];
    
    [self presentViewController:alert animated:YES completion:nil];
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
