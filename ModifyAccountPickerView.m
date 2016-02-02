//
//  ModifyAccountPickerView.m
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/28.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import "ModifyAccountPickerView.h"

@implementation ModifyAccountPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //选择元素子视图中选中的元素
    }
    return self;
}

#pragma mark - 重写设置代理对象的set方法
- (void)setDelegate:(id<ModifyAccountPickerViewDelegate>)delegate
{
    // 获取所选择的元素，并设置代理对象
    
}


@end
