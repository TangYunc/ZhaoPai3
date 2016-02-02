//
//  RegisterViewController.h
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/18.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
@interface RegisterViewController : UIViewController<NSURLSessionDelegate,UITextFieldDelegate>
{
    UITextField *_textField;//验证码输入框
    UIButton *_registerButton;//注册按钮
    BOOL _isAgreeProtocol;//记录是否同意保护隐私政策协议
    NSString *_GUID;
}
@property(nonatomic,strong)UserInfo *userModel;
@end
