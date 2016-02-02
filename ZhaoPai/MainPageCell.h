//
//  MainPageCell.h
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/22.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPageCell : UITableViewCell
{
    UILabel *_titlelabel;//标题
    UIImageView *_dingImageView;//顶视图
    UILabel *_integralLabel;//任务积分
    UILabel *_attentionLabel;//关注
    UILabel *_difficutyLabel;//任务难度
    UILabel *_endTiemLabel;//结束时间
    UILabel *_hiddenLabel;//隐藏的东西
    UIImageView *_mapLocationImageView;//需要定位的图像
}
@end
