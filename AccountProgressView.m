//
//  AccountProgressView.m
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/27.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import "AccountProgressView.h"

#define H_HEIGHT 70

@implementation AccountProgressView

-(id)initWithFrame:(CGRect)frame withProgress:(float)progress{

    self = [super initWithFrame:frame];
    if (self) {
        
        CGSize size = self.frame.size;
        _trackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 32, size.width, size.height)];
        _trackView.image = [UIImage imageNamed:@"buttonbigsecondary_u45.png"];//进度条为填充部分显示的图像
        [self addSubview:_trackView];
        
        UIView *progressViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height+60)];
        progressViewBg.alpha = 0.85f;
        progressViewBg.clipsToBounds = YES;//当前view的主要作用是将出界了的_progressView剪切掉，所以需将clipsToBounds设置为YES
//        progressViewBg.backgroundColor = [UIColor cyanColor];
        [self addSubview:progressViewBg];
        _progressView = [[UIImageView alloc] init];
        _progressView.image = [UIImage imageNamed:@"buttonbigsecondary_u47.png"];//进度条填充部分显示的图片
        NSArray *nodeArray = @[@"70",@"1000",@"5000",@"10000",@"30000"];
        NSArray *regionArray = @[@"冻结区",@"   ",@"   ",@"   ",@"   "];
        for (int i = 0; i<nodeArray.count; i++) {
            UILabel *regionLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*(60+10), 10, 40, 15)];
            regionLabel.text = regionArray[i];
            regionLabel.font = [UIFont systemFontOfSize:12];
            [progressViewBg addSubview:regionLabel];
            
            UILabel *nodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(55+i*(40+13), _trackView.bottom+5, 40, 23)];
            nodeLabel.text = nodeArray[i];
            nodeLabel.font = [UIFont systemFontOfSize:12];
            [progressViewBg addSubview:nodeLabel];
            [self setProgress:progress];//设置进度
            [progressViewBg addSubview:_progressView];
            //        UILabel *msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 61, 320, 23)];
            //        msgLabel.font = [UIFont systemFontOfSize:12];
            //        msgLabel.text = [NSString stringWithFormat:@"还差%d积分升级",2573];
            //        [progressViewBg addSubview:msgLabel];
        }
    }
    return self;
}
- (void)setProgress:(float)fprogress{

    float progress;
    progress = fprogress;
    CGSize size = self.frame.size;
    _progressView.frame = CGRectMake(size.width*progress-size.width, 32, size.width, size.height);//image的宽和高不变，将x轴的坐标根据progress的大小左右移动即可显示出进度的大小，progress的值介于0.0至1.0之间。因为_progressView的父级view上clipsToBounds属性为YES，所以当_progressView的frame出界后不会被显示出来。
}
@end
