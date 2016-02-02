//
//  MainPageCell.m
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/22.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import "MainPageCell.h"

@implementation MainPageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = nil;
        //初始化单元格
        [self _initCell];
    }
    return self;
}
        //初始化单元格
- (void)_initCell{

    //01.标题
    _titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titlelabel.font = [UIFont boldSystemFontOfSize:16];
    _titlelabel.numberOfLines = 0;
//    _titlelabel.backgroundColor = [UIColor orangeColor];
    _titlelabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_titlelabel];
    //02.顶视图
    _dingImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _dingImageView.backgroundColor = [UIColor grayColor];
//    _dingImageView.image = [UIImage imageNamed:@""];
    [self.contentView addSubview:_dingImageView];
    //03.任务积分
    _integralLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _integralLabel.font = [UIFont boldSystemFontOfSize:14];
    _integralLabel.textColor = [UIColor redColor];
//    _integralLabel.backgroundColor = [UIColor redColor];
    _integralLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_integralLabel];
/*    //04.隐藏的东西
    _hiddenLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _hiddenLabel.font = [UIFont boldSystemFontOfSize:16];
//    _hiddenLabel.backgroundColor = [UIColor yellowColor];
    _hiddenLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_hiddenLabel];
    */
    //05.需要定位的图像
    _mapLocationImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _mapLocationImageView.backgroundColor = [UIColor grayColor];
//    _mapLocationImageView.image = [UIImage imageNamed:@""];
    [self.contentView addSubview:_mapLocationImageView];
    //06.关注
    _attentionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _attentionLabel.font = [UIFont boldSystemFontOfSize:12];
//    _attentionLabel.backgroundColor = [UIColor greenColor];
    _attentionLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_attentionLabel];
    //07.任务难度
    _difficutyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _difficutyLabel.font = [UIFont boldSystemFontOfSize:12];
//    _difficutyLabel.backgroundColor = [UIColor cyanColor];
    _difficutyLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_difficutyLabel];

    //08.结束时间
    _endTiemLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _endTiemLabel.font = [UIFont boldSystemFontOfSize:12];
//    _endTiemLabel.backgroundColor = [UIColor blueColor];
    _endTiemLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_endTiemLabel];
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    //01.标题
    _titlelabel.frame = CGRectMake(5, 10, 220, 50);
    _titlelabel.text = @"［新手必打］拍拍赚新手任务(160)";
    //02.任务积分
    _integralLabel.frame = CGRectMake(self.width-5-40, _titlelabel.top, 40, _titlelabel.height);
    _integralLabel.text =@"1.0";
    //05.需要定位的图像
    _mapLocationImageView.frame = CGRectMake(_integralLabel.left-20-40, _integralLabel.top, 40, 40);
    _mapLocationImageView.image = [UIImage imageNamed:@""];

    //03.顶视图
    _dingImageView.frame = CGRectMake(_mapLocationImageView.left-10-40, _integralLabel.top, 40, 40);
    _dingImageView.image = [UIImage imageNamed:@""];
//    //04.隐藏的东西
//    _hiddenLabel.frame = CGRectMake(_titlelabel.left, _titlelabel.bottom, _titlelabel.width, 20);
//    _hiddenLabel.text = @"(160)";
    //06.关注
    _attentionLabel.frame = CGRectMake(_titlelabel.left, _titlelabel.bottom, 120, 20);
    _attentionLabel.text = @"关注：139547人";
    //07.任务难度
    _difficutyLabel.frame = CGRectMake(_attentionLabel.right, _attentionLabel.top, 100, _attentionLabel.height);
    _difficutyLabel.text = @"难度：简单";
    //08.结束时间
    _endTiemLabel.frame = CGRectMake(self.width-10-150, _attentionLabel.top, 150, _attentionLabel.height);
    _endTiemLabel.text = @"结束时间:2016-1-30";

}
@end
