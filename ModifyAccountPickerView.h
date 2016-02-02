//
//  ModifyAccountPickerView.h
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/28.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ModifyAccountPickerView;

@protocol ModifyAccountPickerViewDelegate <NSObject>

// 点击到选择元素视图上调用的协议方法，会把表情的数据反馈给我们
- (void)touchEndPickerViewWithPickerDic:(NSDictionary *)pickerDic;


@end
@interface ModifyAccountPickerView : UIView
{
//选择元素视图的子视图


}

@property (nonatomic, weak) id<ModifyAccountPickerViewDelegate> delegate;

@end
