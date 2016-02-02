//
//  UserSettings.h
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/19.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import "BaseModel.h"

@interface UserSettings : BaseModel

@property(nonatomic,strong)NSString *Id;
@property(nonatomic,strong)NSString *Email;
@property(nonatomic,strong)NSString *Address;

@end
