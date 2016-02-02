//
//  UserInfo.m
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/19.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
- (id)initWithContentsOfDic:(NSDictionary *)dic{

    self = [super initWithContentsOfDic:dic];
    if (self) {
        self.uniqueIdentifier = dic[@"Id"];
        self.UserSettings = [[UserSettings alloc] initWithContentsOfDic:dic[@"UserSettings"]];
    }

    return self;
}
@end
