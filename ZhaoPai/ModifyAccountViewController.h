//
//  ModifyAccountViewController.h
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/28.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModifyAccountPickerView.h"

@interface ModifyAccountViewController : UIViewController<UITextFieldDelegate,ModifyAccountPickerViewDelegate>
{
    UIView *_basicView;
    UIView *_detailView;
    UIView *_payView;
    UIView *_toolsView;//工具栏的子视图
    ModifyAccountPickerView *_pickerView;//选择元素视图
}
@property(nonatomic,assign)BOOL isShowPickerView;
@end
