//
//  ModifyAccountViewController.m
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/28.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import "ModifyAccountViewController.h"

@interface ModifyAccountViewController ()

@end

@implementation ModifyAccountViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 注册键盘改变的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardExChangedNotif:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        // 注册键盘收起的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHideNotif:) name:UIKeyboardWillHideNotification object:nil];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改资料";
    self.view.backgroundColor = [UIColor whiteColor];
    //创建修改的内容视图
    [self creatModifyContentView];
}
//创建修改的内容视图
- (void)creatModifyContentView{

    //1.创建顶部按钮
    NSArray *modifyTitle = @[@"基础资料",@"详细资料",@"支付资料"];
    float buttonWidth = kScreenWidth/3;
    for (int i = 0 ; i<modifyTitle.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 10+i;
        button.frame = CGRectMake(i*buttonWidth , 0, buttonWidth, 40);
        [button setTitle:modifyTitle[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
    }
    // 2 创建工具栏视图
    _toolsView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64 - 70, kScreenWidth, 70)];
    _toolsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    [self.view addSubview:_toolsView];


    
    
}
#pragma mark - 顶部按钮事件
- (void)buttonAction:(UIButton *)button{
    if (button.tag == 10) {
        //基础资料
        NSArray *titleArray = @[@"用户昵称",@"注册手机",@"性别",@"出生日期"];
        NSArray *placeholderArray = @[@"请点击输入",@"请输入手机号",@"请选择性别",@"请选择出生日期"];
        _basicView = [[UIView alloc] initWithFrame:CGRectMake(5, button.bottom + 5 , kScreenWidth-5*2, 40*titleArray.count)];
        [self.view addSubview:_basicView];

        //2.创建文本输入
        for (int i = 0; i<titleArray.count; i++) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,  i*40, kScreenWidth-5*2, 40)];
            imageView.image = [UIImage imageNamed:@"u15MyAccount.png"];
            imageView.userInteractionEnabled = YES;
            [_basicView addSubview:imageView];
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 90, imageView.height-2)];
            lable.textAlignment = NSTextAlignmentLeft;
            lable.textColor = [UIColor grayColor];
            lable.font = [UIFont boldSystemFontOfSize:16];
            lable.text = titleArray[i];
            [imageView addSubview:lable];
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(lable.right, lable.top, imageView.width-lable.width, lable.height)];
            textField.tag = 10+i;
            textField.textAlignment = NSTextAlignmentLeft;
            textField.textColor = [UIColor grayColor];
            textField.delegate = self;
            textField.placeholder = placeholderArray[i];
            textField.font = [UIFont boldSystemFontOfSize:13];
            [imageView addSubview:textField];
        }
        _basicView.hidden = NO;
        _detailView.hidden = YES;
        _payView.hidden = YES;


    }else if (button.tag == 11){
    //详细资料
        NSArray *titleArray = @[@"您的邮箱",@"您的月收入",@"您的家庭月收入",@"您的学历",@"您的婚姻状况",@"您是否有孩子"];
        NSArray *placeholderArray = @[@"请填写邮箱",@"请填写月收入",@"请填写月收入",@"请填写学历",@"请填写婚姻状况",@"请填写有几个孩子"];
        _detailView = [[UIView alloc] initWithFrame:CGRectMake(5, button.bottom + 5 , kScreenWidth-5*2, 40*titleArray.count)];
        [self.view addSubview:_detailView];

        //2.创建文本输入
        for (int i = 0; i<titleArray.count; i++) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, i*40, kScreenWidth-5*2, 40)];
            imageView.image = [UIImage imageNamed:@"u15MyAccount.png"];
            imageView.userInteractionEnabled = YES;
            [_detailView addSubview:imageView];
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 90, imageView.height-2)];
            lable.textAlignment = NSTextAlignmentLeft;
            lable.textColor = [UIColor grayColor];
            lable.font = [UIFont boldSystemFontOfSize:16];
            lable.text = titleArray[i];
            [imageView addSubview:lable];
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(lable.right, lable.top, imageView.width-lable.width, lable.height)];
            textField.tag = 20+i;
            textField.textAlignment = NSTextAlignmentLeft;
            textField.delegate = self;
            textField.textColor = [UIColor grayColor];
            textField.placeholder = placeholderArray[i];
            textField.font = [UIFont boldSystemFontOfSize:13];
            [imageView addSubview:textField];
        }
        _basicView.hidden = YES;
        _detailView.hidden = NO;
        _payView.hidden = YES;


    }else{
    //支付资料
        NSArray *titleArray = @[@"支付宝账户",@"支付宝实名"];
        NSArray *placeholderArray = @[@"请输入支付宝账户",@"请输入支付宝实名"];
        _payView = [[UIView alloc] initWithFrame:CGRectMake(0, button.bottom + 5 , kScreenWidth-5*2, 40*titleArray.count)];
        [self.view addSubview:_payView];

        //2.创建文本输入
        for (int i = 0; i<titleArray.count; i++) {
        
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, i*40, kScreenWidth-5*2, 40)];
            imageView.image = [UIImage imageNamed:@"u15MyAccount.png"];
            imageView.userInteractionEnabled = YES;
            [_payView addSubview:imageView];
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 90, imageView.height-2)];
            lable.textAlignment = NSTextAlignmentLeft;
            lable.textColor = [UIColor grayColor];
            lable.font = [UIFont boldSystemFontOfSize:16];
            lable.text = titleArray[i];
            [imageView addSubview:lable];
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(lable.right, lable.top, imageView.width-lable.width, lable.height)];
            textField.tag = 30+i;
            textField.textAlignment = NSTextAlignmentLeft;
            textField.textColor = [UIColor grayColor];
            textField.delegate = self;
            textField.placeholder = placeholderArray[i];
            textField.font = [UIFont boldSystemFontOfSize:13];
            [imageView addSubview:textField];
            
        }
        _basicView.hidden = YES;
        _detailView.hidden = YES;
        _payView.hidden = NO;
    }

}
#pragma mark - 文本按钮的协议UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{

    UITextField *basic1TF = (UITextField*)[self.view viewWithTag:10];
    UITextField *basic2TF = (UITextField*)[self.view viewWithTag:11];
    UITextField *basic3TF = (UITextField*)[self.view viewWithTag:12];
    UITextField *basic4TF = (UITextField*)[self.view viewWithTag:13];
    UITextField *detial1TF = (UITextField*)[self.view viewWithTag:20];
    UITextField *detial2TF = (UITextField*)[self.view viewWithTag:21];
    UITextField *detial3TF = (UITextField*)[self.view viewWithTag:22];
    UITextField *detial4TF = (UITextField*)[self.view viewWithTag:23];
    UITextField *detial5TF = (UITextField*)[self.view viewWithTag:24];
    UITextField *detial6TF = (UITextField*)[self.view viewWithTag:25];
    UITextField *pay1TF = (UITextField*)[self.view viewWithTag:30];
    UITextField *pay2TF = (UITextField*)[self.view viewWithTag:31];
    if (basic1TF || basic2TF || detial1TF || pay1TF || pay2TF) {
        //显示键盘
        _isShowPickerView = NO;
    }else if(basic2TF || basic3TF || basic4TF || detial2TF ||detial3TF || detial4TF || detial5TF || detial6TF){
        // 显示或者隐藏选择元素视图面板
        if (_pickerView == nil) {
            _pickerView = [[ModifyAccountPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 271)];
            _pickerView.backgroundColor = [UIColor orangeColor];
            //设置点击选择元素视图的代理对象
            //        _pickerView.delegate = self;
        }
        // 设置当前状态为切换选择选择元素视图状态
        _isShowPickerView = YES;
        // 收起键盘
        [textField resignFirstResponder];
        textField.inputView = textField.inputView == nil ? _pickerView : nil;
        // 打开键盘
        [textField becomeFirstResponder];
        
    }
    
}


#pragma mark - 键盘改变通知
//显示键盘的通知
- (void)keyboardExChangedNotif:(NSNotification *)notif
{
    // 获取键盘的高度
    float height = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    // 设置工具栏视图的位置
    _toolsView.bottom = kScreenHeight - 64 - height;
    NSLog(@"%@",notif.userInfo);
}

// 键盘隐藏的通知
- (void)keyboardHideNotif:(NSNotification *)notif
{
    if (_isShowPickerView == NO) {
        _toolsView.bottom = kScreenHeight - 64;
    } else {
        // 当前设置已经结束，需要恢复原始状态
        _isShowPickerView = NO;
    }
    
}
#pragma mark - ModifyAccountPickerViewDelegate
- (void)touchEndFaceImageWithFaceDic:(NSDictionary *)faceDic
{
//    // 获取表情文本
//    NSString *faceText = faceDic[@"chs"];
//    _textView.text = [NSString stringWithFormat:@"%@%@",_textView.text,faceText];
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
