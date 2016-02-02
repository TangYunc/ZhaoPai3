//
//  UserInfo.h
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/19.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import "BaseModel.h"
#import "UserSettings.h"

@interface UserInfo : BaseModel

@property(nonatomic,strong)NSString *uniqueIdentifier;//设备标识Id
@property(nonatomic,strong)NSNumber *UserName;//手机号码(phoneNum)
@property(nonatomic,strong)NSString *Password;//密码
@property(nonatomic,strong)NSString *UserSettingsId;
@property(nonatomic,strong)UserSettings *UserSettings;

@property(nonatomic,strong)NSString *nickName;//昵称
@property(nonatomic,strong)NSString *recommendCode;//推荐码
@property(nonatomic,strong)NSNumber *identifyingCode;//验证码
@property(nonatomic,assign)BOOL isAgreeProtocol;//是否同意协议政策
@end
