//
//  BaseModel.h
//  RegisterAndLogin
//
//  Created by Mr_Tang on 16/1/9.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

//自定义一个初始化方法
- (id)initWithContentsOfDic:(NSDictionary *)dic;

//创建映射关系
- (NSDictionary *)keyToAtt:(NSDictionary *)dic;

@end
