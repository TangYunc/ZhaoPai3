//
//  ReSetPasswordViewController.m
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/18.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import "ReSetPasswordViewController.h"

@interface ReSetPasswordViewController ()

@end

@implementation ReSetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"重置密码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化内容视图
    [self _initContentView];
}
//初始化内容视图
- (void)_initContentView{

    //01.提示Label
    NSArray *labelTitles = @[@"新密码",@"确认新密码"];
    for (int i = 0 ; i<labelTitles.count; i++) {
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10+i*(40+10), 100, 40)];
        lable.tag = 10+i;
        lable.text = labelTitles[i];
        lable.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:lable];
    }
    //02.输入文本框
    NSArray *placeholderTitles = @[@"密码需要6-20位数字或字母",@"密码需要6-20位数字或字母"];
    for (int i = 0 ; i<placeholderTitles.count; i++) {
        UILabel *label = (UILabel *)[self.view viewWithTag:10];
        //文本输入框宽度
        CGFloat textFieldWidth = kScreenWidth-label.right-10-20;
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(label.right+10, label.top+i*(40+10), textFieldWidth, 40)];
        textField.tag = 100+i;
        textField.autocapitalizationType = NO;
        textField.placeholder = placeholderTitles[i];
        textField.textAlignment = NSTextAlignmentLeft;
        textField.borderStyle = UITextBorderStyleLine;
        textField.clearButtonMode = YES;
        [self.view addSubview:textField];
    }

    //下一步按钮
    UITextField *confirmNewPasswordTF = (UITextField *)[self.view viewWithTag:101];
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmButton.frame = CGRectMake((kScreenWidth-155)/2, confirmNewPasswordTF.bottom+20, 155, 35);
    [_confirmButton setBackgroundImage:[UIImage imageNamed:@"u19findPassword.png"] forState:UIControlStateNormal];
    [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmButton];


}
#pragma mark - 确认按钮事件
- (void)confirmAction:(UIButton *)button{

    UITextField *firstPassword = (UITextField *)[self.view viewWithTag:100];
    UITextField *confirmPassword = (UITextField *)[self.view viewWithTag:101];
    if (firstPassword.text != confirmPassword.text) {
        //弹出提示窗口
        [self popAlertViewWithTitle:@"请确认输入信息" Message:@"两次密码不一致"];
    }else{
        if (firstPassword.text.length == 0 || confirmPassword.text.length ==0){
            //弹出提示窗口
            [self popAlertViewWithTitle:@"请确认输入信息" Message:@"输入信息不能为空"];
        }else{
        //找回密码成功，将所有的信息传给服务器
        
        //点击确认后弹出加载视图，加载成功则登录返回首页
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}
#pragma mark - 弹出alert视图提示输入账号密码
- (void)popAlertViewWithTitle:(NSString *)title Message:(NSString *)message{
    
    //弹出alert视图提示输入账号密码
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:confirm];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//注册当前视图未第一响应者
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UIView *view in self.view.subviews) {
        if ([view isFirstResponder]) {
            [view resignFirstResponder];
        }
    }
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
