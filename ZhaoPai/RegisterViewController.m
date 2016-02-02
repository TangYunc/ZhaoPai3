//
//  RegisterViewController.m
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/18.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end
#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define ACCOUNT_MAX_CHARS 16

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注册找拍";
    self.isBackItem = YES;
    
    //1.初始化子视图内容
    [self _initSubViewContent];
}
    //1.初始化子视图内容
- (void)_initSubViewContent{

    //01.提示Label
    NSArray *labelTitles = @[@"手机号码:",@"密码:",@"昵称:",@"推荐码:",@"验证码:"];
    for (int i = 0 ; i<labelTitles.count; i++) {
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10+i*(40+10), 80, 40)];
        lable.tag = 10+i;
        lable.text = labelTitles[i];
        lable.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:lable];
    }
    //02.输入文本框
    NSArray *placeholderTitles = @[@"输入11位手机号码",@"密码需要6-20位数字或字母",@"中文或英文均可",@"非必填"];
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
    //03.获取推荐码文本框
    UITextField *recommedTextField = (UITextField *)[self.view viewWithTag:103];
    //验证码文本框
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(recommedTextField.left, recommedTextField.bottom+10, recommedTextField.width/2, recommedTextField.height)];
    _textField.autocapitalizationType = NO;
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.borderStyle = UITextBorderStyleLine;
    _textField.clearButtonMode = YES;
    [self.view addSubview:_textField];
    //04.获取短信验证码按钮
    UIButton *getMessageIdentifyingCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    getMessageIdentifyingCodeButton.frame = CGRectMake(_textField.right+10, _textField.top, recommedTextField.width-_textField.width-10, _textField.height);
    [getMessageIdentifyingCodeButton setBackgroundImage:[UIImage imageNamed:@"获取短信_u26.png"] forState:UIControlStateNormal];
    [getMessageIdentifyingCodeButton setTitle:@"获取短信验证码" forState:UIControlStateNormal];
    [getMessageIdentifyingCodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    getMessageIdentifyingCodeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [getMessageIdentifyingCodeButton addTarget:self action:@selector(getMessageIdentifyingCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getMessageIdentifyingCodeButton];
    //05.使用条款和隐私政策
    UIButton *selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectedButton.frame = CGRectMake(_textField.left+120, _textField.bottom+20, 15, 15);
    [selectedButton setBackgroundImage:[UIImage imageNamed:@"checkbox_off.png"] forState:UIControlStateNormal];
    [selectedButton addTarget:self action:@selector(selectedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectedButton];
    UILabel *protocolLale = [[UILabel alloc] initWithFrame:CGRectMake(selectedButton.right, selectedButton.top, 150, 15)];
    protocolLale.text = @"使用条款和隐私政策";
    protocolLale.font = [UIFont boldSystemFontOfSize:13];
    protocolLale.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:protocolLale];
    //06.注册按钮
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerButton.frame = CGRectMake((kScreenWidth-205)/2, getMessageIdentifyingCodeButton.bottom+80, 205, 35);
    [_registerButton setBackgroundImage:[UIImage imageNamed:@"u30registerButton.png"] forState:UIControlStateNormal];
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [_registerButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerButton];

}

#pragma mark - 获取短信验证码事件
- (void)getMessageIdentifyingCodeAction:(UIButton *)button{

//点击获取短信验证码
}

- (UserInfo *)getUserModel{

//    _userModel = [[UserInfo alloc] init];
    _isAgreeProtocol = YES;
    UITextField *phoneNumTF = (UITextField *)[self.view viewWithTag:100];
    UITextField *passwordTF = (UITextField *)[self.view viewWithTag:101];
    UITextField *nickNameTF = (UITextField *)[self.view viewWithTag:102];
    UITextField *recommendCodeTF = (UITextField *)[self.view viewWithTag:103];
    //将字符串转换为NSNumber类型给userModel
    NSNumberFormatter *numberFormatter1 = [[NSNumberFormatter alloc] init];
    [numberFormatter1 setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *numBer1 = [numberFormatter1 numberFromString:phoneNumTF.text];
    _userModel = [[UserInfo alloc] init];
    _userModel.UserName = numBer1;
    
    _userModel.Password = passwordTF.text;
    _userModel.nickName = nickNameTF.text;
    _userModel.recommendCode = recommendCodeTF.text;
    //将验证码转换成NSNumber类型给userModel
    NSNumberFormatter *numberFormatter2 = [[NSNumberFormatter alloc] init];
    [numberFormatter2 setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *numBer2 = [numberFormatter2 numberFromString:_textField.text];
    //生成一个GUID
    _GUID = [self getUniqueStrByUUID];
    
    _userModel.uniqueIdentifier = _GUID;

    _userModel.identifyingCode = numBer2;
    _userModel.isAgreeProtocol = _isAgreeProtocol;
    _userModel.UserSettingsId = _GUID;
    return _userModel;
}
    //生成一个GUID
- (NSString *)getUniqueStrByUUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    
    CFRelease(uuidObj);
    return  uuidString;
}
#pragma mark - 重写返回按钮事件
- (void)backButtonAction:(UIBarButtonItem *)backBarButton{

    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 注册事件
- (void)registerAction:(UIButton *)button{
    
    UITextField *phoneNumTF = (UITextField *)[self.view viewWithTag:100];
    UITextField *passwordTF = (UITextField *)[self.view viewWithTag:101];
    UITextField *nickNameTF = (UITextField *)[self.view viewWithTag:102];
    if (phoneNumTF.text.length ==0 || passwordTF.text.length == 0 || nickNameTF.text.length == 0) {
        [self popAlertViewWithTitle:@"注册失败" Message:@"输入信息不能为空"];
    }else{
//如果是11位的手机号码
        if ([self isMobileNumber:phoneNumTF.text] == NO) {
        
            [self popAlertViewWithTitle:@"请输入11位手机号码" Message:@"请确认您输入的是正确的手机信息"];
        }else if (passwordTF.text.length <6 || passwordTF.text.length>20){
//密码需要6-20位数字或字母
            passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
            passwordTF.delegate  = self;
            [self popAlertViewWithTitle:@"密码输入有误" Message:@"密码需要6-20位数字或字母"];
        
        }else{
            //将输入的手机号码发送给服务器，通过服务器判断此手机号是否注册，如果注册则服务器返回的信息为false，如果没有注册，则返回信息为true，此时可进行注册操作
            NSString *userString = [NSString stringWithFormat:@"CanRegistUserName?un=%@",phoneNumTF.text];
            NSString *VerificationUrlString = [@"http://webapi.cmdi-info.com/" stringByAppendingString:userString];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager GET:VerificationUrlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //请求成功，通过返回的信息判断当前手机号是否已经注册
    
                NSLog(@"responseObject：%@",task);
                if (task.taskIdentifier == 1) {
                    //用户已经注册
                    [self popAlertViewWithTitle:@"注册失败" Message:@"用户名已存在"];
                }else{
                    //该账户名没有注册，现在可以进行注册
                    //配置参数
                    NSString *url = [@"http://webapi.cmdi-info.com/" stringByAppendingString:@"api/UserAccounts"];
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    _userModel = [self getUserModel];
                    [params setObject:_userModel.uniqueIdentifier forKey:kMY_uniqueIdentifiert];
                    [params setObject:_userModel.UserName forKey:kMY_userName];
                    [params setObject:_userModel.Password forKey:kMY_password];
                    [params setObject:_userModel.UserSettingsId forKey:kMY_UserSettingsId];
                    NSDictionary *UserSettings = @{@"Id":_GUID,@"Email1":@"sample string 7",@"Address":@"sample string 9"};
                    [params setObject:UserSettings forKey:kMY_UserSettings];
                    
                    NSError *error;
                    
                    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
                    NSURL *URL = [NSURL URLWithString:url];
                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
                    //设置请求头
                    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
                    //设置请求方式为POST
                    [request setHTTPMethod:@"POST"];
                    //将配置的参数转换成二进制数据
                    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
                    //设置请求体
                    [request setHTTPBody:postData];
                    
                    // 开始上传信息
                    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"response data : %@, response : %@, error : %@", responseStr, response, error);
                        
                        NSData * jsonData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
                        NSError * err = nil;
                        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&err];
                        NSLog(@"json:%@",json);
                    }];
                    [postDataTask resume];
                    
                    //弹出alert视图提示输入账号密码
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注册完成" message:@"注册完成，即将返回登陆" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                    [alert addAction:cancel];
                    [self presentViewController:alert animated:YES completion:nil];
                }

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
            }];
        }
        }
    }

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string // return NO to not change text
{
    //判断是否超过 ACCOUNT_MAX_CHARS 个字符,注意要判断当string.leng>0
    //的情况才行，如果是删除的时候，string.length==0
    unsigned long length = textField.text.length;
    if (length >= ACCOUNT_MAX_CHARS && string.length >0)
    {
        return NO;
    }
    
    
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    NSString *filtered =
    [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [string isEqualToString:filtered];
    return basic;
}


#pragma mark - 使用条款和隐私政策事件
- (void)selectedButtonAction:(UIButton *)button{

//点击选中使用条款和隐私政策协议
    NSLog(@"点击选中使用条款和隐私政策协议");
    //改变当前的状态
    _isAgreeProtocol =! _isAgreeProtocol;
    if (_isAgreeProtocol == NO) {
        //不同意时显示的图片
        [button setImage:[UIImage imageNamed:@"checkbox_off.png"] forState:UIControlStateNormal];
    }else{
    //同意协议条款后显示的图片
        [button setImage:[UIImage imageNamed:@"checkbox_on.png"] forState:UIControlStateNormal];
    }
}
    //弹出alert视图提示输入账号密码
- (void)popAlertViewWithTitle:(NSString *)title Message:(NSString *)message{

    //弹出alert视图提示输入账号密码
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];

    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - 手机号码的有效性判断
//检测是否是手机号码
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
              * 手机号码
              * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
              * 联通：130,131,132,152,155,156,185,186
              * 电信：133,1349,153,180,189
              */
    NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
              10         * 中国移动：China Mobile
              11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
              12         */
    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
              15         * 中国联通：China Unicom
              16         * 130,131,132,152,155,156,185,186
              17         */
    NSString *CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
        /**
              20         * 中国电信：China Telecom
              21         * 133,1349,153,180,189
              22         */
    NSString *CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
              25         * 大陆地区固话及小灵通
              26         * 区号：010,020,021,022,023,024,025,027,028,029
              27         * 号码：七位或八位
              28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
        NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
        NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
        if (([regextestmobile evaluateWithObject:mobileNum] == YES)
                    || ([regextestcm evaluateWithObject:mobileNum] == YES)
                    || ([regextestct evaluateWithObject:mobileNum] == YES)
                    || ([regextestcu evaluateWithObject:mobileNum] == YES))
                {
                    return YES;
                    }
            else
                    {
                        return NO;
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
