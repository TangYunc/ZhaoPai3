//
//  AccountProgressView.h
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/27.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountProgressView : UIView

@property(nonatomic,strong) UIImageView *progressView;//进度填充部分显示
@property(nonatomic,strong) UIImageView *trackView;//进度为填充部分显示

-(id)initWithFrame:(CGRect)frame withProgress:(float)progress;
//- (id)initWithFrame:(CGRect)frame withProgress:(float)progress withDistanceProgress:(float)distanceProgress;
@end
