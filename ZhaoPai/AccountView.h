//
//  AccountView.h
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/25.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountProgressView.h"

@interface AccountView : UIView
{
    UIImageView *_headerImageView;
    UIView *_headerView;//01.头视图
    UIButton *_headPortraitButton;//02.用户头像
    UILabel *_creditRatingLabel;//03.信用等级
    AccountProgressView *_progressView;//进度条
    UILabel *_percentageOfProcessLabel;//06.任务进度百分比
    UILabel *_informLabel;//08.提示信誉等级是衡量用户在平台做任务的品质指标
    UIView *_bjView;//09.大视图，内部包含四个按钮
    UIButton *_modifyData;//10.修改资料
    UIButton *_amountOfAccount;//11.账户金额
    UIButton *_recommendFriends;//12.推荐好友
    UIButton *_projectStatistics;//13.项目统计
}
@property(nonatomic,assign)float percentageOfProcess;//百分比
@end
