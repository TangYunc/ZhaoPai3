//
//  AccountView.m
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/25.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import "AccountView.h"
#import "ModifyAccountViewController.h"
#import "AccountMoneyViewController.h"
#import "RecommendFriendViewController.h"
#import "ProjectStatisticsViewController.h"

@implementation AccountView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //创建内容视图
        [self creatContentView];
    }
    return self;
}
        //创建内容视图
- (void)creatContentView{

    //01.头视图
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 186)];
    _headerImageView = [[UIImageView alloc] initWithFrame:_headerView.frame];
    UIImage *image = [UIImage imageNamed:@"u5MyAccount.png"];
    _headerImageView.image = image;
    [self addSubview:_headerImageView];
    //02.用户头像
    _headPortraitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _headPortraitButton.frame = CGRectMake(40, 20, 40, 40);
    [_headPortraitButton setBackgroundImage:[UIImage imageNamed:@"u39MyAccount.png"] forState:UIControlStateNormal];
//    [_headPortraitButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    _headPortraitButton.clipsToBounds = YES;
    [_headPortraitButton addTarget:self action:@selector(headerPortraitButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerImageView addSubview:_headPortraitButton];
    //03.信用等级
    _creditRatingLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headPortraitButton.right+10, _headPortraitButton.top+10, 200, 20)];
    _creditRatingLabel.text = [NSString stringWithFormat:@"信用等级： ❤️（100分）"];
    _creditRatingLabel.textAlignment = NSTextAlignmentCenter;
    _creditRatingLabel.font = [UIFont boldSystemFontOfSize:16];
    [_headerImageView addSubview:_creditRatingLabel];

    
    //完成任务进度条
    _percentageOfProcess = 0.3;
    _progressView = [[AccountProgressView alloc] initWithFrame:CGRectMake(25, _headPortraitButton.bottom+5, kScreenWidth-25*2-55, 20) withProgress: _percentageOfProcess];//传入参数范围0~1

    [_headerImageView addSubview:_progressView];
    //06.任务进度百分比
    _percentageOfProcessLabel = [[UILabel alloc] initWithFrame:CGRectMake(_progressView.right+5, _progressView.top+30, 80, _progressView.height)];
    _percentageOfProcessLabel.textAlignment = NSTextAlignmentCenter;
    _percentageOfProcessLabel.font = [UIFont systemFontOfSize:16];
    _percentageOfProcessLabel.text = [NSString stringWithFormat:@"%.f％",_percentageOfProcess*100];
    [_headerImageView addSubview:_percentageOfProcessLabel];
    //08.提示信誉等级是衡量用户在平台做任务的品质指标
    _informLabel = [[UILabel alloc] initWithFrame:CGRectMake(_progressView.left, _headerImageView.bottom-10-15, 300, 15)];
    _informLabel.textAlignment = NSTextAlignmentCenter;
    _informLabel.font = [UIFont boldSystemFontOfSize:13];
    _informLabel.text = @"信誉等级是衡量用户在平台做任务的品质指标";
    [_headerImageView addSubview:_informLabel];

    //09.大视图，内部包含四个按钮
    //01.内容视图
    _bjView = [[UIView alloc] initWithFrame:CGRectMake(5, _headerView.bottom+10, kScreenWidth-5*2, 40*4)];
    _bjView.layer.borderWidth = 1;
    _bjView.layer.shadowColor = [UIColor blackColor].CGColor;
    _bjView.layer.shadowOffset = CGSizeMake(1, 1);
    _bjView.layer.shadowOpacity = 1;
    NSArray *titleArr = @[@"修改资料",@"账户金额",@"推荐好友",@"项目统计"];
    CGFloat buttonHeight = _bjView.height/4.0;
    for (int i =0; i<titleArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, i*buttonHeight, _bjView.width, buttonHeight);
        button.tag = 10+i;
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"u9MyAccount.png"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bjView addSubview:button];
    }
    [self addSubview:_bjView];

}
#pragma mark - 头像按钮点击事件
- (void)headerPortraitButton:(UIButton *)button{

}
#pragma mark - 内容视图的按钮事件
- (void)buttonAction:(UIButton *)button{

    if (button.tag == 10) {
    //10.修改资料
        ModifyAccountViewController *modifyAccountVC = [[ModifyAccountViewController alloc] init];
        [self.ViewController.navigationController pushViewController:modifyAccountVC animated:YES];
    }else if (button.tag == 11){
    //11.账户金额
        AccountMoneyViewController *accountMoneyVC = [[AccountMoneyViewController alloc] init];
        [self.ViewController.navigationController pushViewController:accountMoneyVC animated:YES];
    }else if (button.tag == 12){
    //12.推荐好友
        RecommendFriendViewController *recommendFriendVC = [[RecommendFriendViewController alloc]  init];
        [self.ViewController.navigationController pushViewController:recommendFriendVC animated:YES];
    }else{
    //13.项目统计
        ProjectStatisticsViewController *projectStatisticsVC = [[ProjectStatisticsViewController alloc] init];
        [self.ViewController.navigationController  pushViewController:projectStatisticsVC animated:YES];
    }


}
@end
