//
//  DropdownButton.m
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/27.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import "DropdownButton.h"

#define button_Height 40.0

@implementation DropdownButton

- (id)initDropdownButtonWithTitles:(NSArray*)titles{
    self = [super initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, kScreenWidth, button_Height)];
    if (self) {
        _isButtion = NO;
        _count = titles.count;
        //按钮上的子视图，竖线，按钮底部 的横线
        [self addButtonToView:titles];
        //注册一个通知，当隐藏事件发生的时候，接受通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMenu:) name:@"hideMenu" object:_lastTapObj];
    }
    return self;
}
//按钮上的子视图，竖线，按钮底部 的横线
- (void)addButtonToView:(NSArray *)titles {
    for (int i = 0; i < _count; i++) {
        //自定义创建按钮
        UIButton *button = [self makeButton:[titles objectAtIndex:i] andIndex:i];
        [self addSubview:button];
        if (i > 0) {
            //按钮与按钮之间的间隔线
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(button.frame.origin.x, 10, 1, 20)];
            lineView.backgroundColor = [UIColor colorWithRed:(217.0 / 255.0) green:(217.0 / 255.0) blue:(217.0 / 255.0) alpha:1.0f];
            [self addSubview:lineView];
        }
    }
    //按钮底部的线
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, button_Height, kScreenWidth, 1)];
    bottomLine.backgroundColor = [UIColor colorWithRed:(217.0 / 255.0) green:(217.0 / 255.0) blue:(217.0 / 255.0) alpha:1.0f];
    [self addSubview:bottomLine];
}
//自定义创建按钮
- (UIButton *)makeButton:(NSString *) title andIndex:(int)index{
    //每个按钮宽度
    float width = [self returnTitlesWidth];
    //当点击某个按钮，的偏移量
    float offsetX = width * index;
    //^的图片
    _image = [UIImage imageNamed:@"expandableImage"];
    float padding = (width - (_image.size.width + [title sizeWithFont:[UIFont systemFontOfSize:13.0f]].width)) / 2;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(offsetX, 0, width, button_Height)];
    button.tag = 10000 + index;
    [button setImage:_image forState:UIControlStateNormal];
    //编辑按钮上图片的位置
    [button setImageEdgeInsets:UIEdgeInsetsMake(11, [title sizeWithFont:[UIFont systemFontOfSize:13.0f]].width + padding + 5, 11, 0)];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [button setTitle:title forState:UIControlStateNormal];
    //编辑按钮上标题的位置
    [button setTitleEdgeInsets:UIEdgeInsetsMake(11, 0, 11, _image.size.width + 5)];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (float)returnTitlesWidth {
    float width = kScreenWidth / _count;
    return width;
}
#pragma mark - 按钮的点击事件
- (void)showMenuAction:(id)sender {
    NSInteger i = [sender tag];
    [self openMenuBtnAnimation:i];
}
//点击按钮后打开相应的菜单
- (void)openMenuBtnAnimation:(NSInteger)index{
    if (_lastTap != index) {
        if (_lastTap > 0) {
            [self changeButtionTag:_lastTap Rotation:0];
        }
        _lastTap = index;
        [self changeButtionTag:index Rotation:M_PI];
        [self.delegate showMenu:index];
    } else {
        _isButtion = YES;
        [self changeButtionTag:_lastTap Rotation:0];
        _lastTap = 0;
        [self.delegate hideMenu];
    }
}
- (void)changeButtionTag:(NSInteger)index Rotation:(CGFloat)angle {
    [UIView animateWithDuration:0.1f animations:^{
        UIButton *btn = (UIButton *)[self viewWithTag:index];
        if (angle == 0) {
            [btn setBackgroundColor:[UIColor whiteColor]];
        } else {
            [btn setBackgroundColor:[UIColor colorWithRed:(221.0/255.0) green:(221.0/255.0) blue:(221.0/255.0) alpha:1.0f]];
        }
        btn.imageView.transform = CGAffineTransformMakeRotation(angle);
    }];
}
#pragma mark - 收到通知隐藏事件发生时的处理方法
- (void)hideMenu:(NSNotification *)notification {
    _lastTapObj = [notification object];
    if (_isButtion != YES) {
        [self changeButtionTag:([_lastTapObj intValue] + 10000) Rotation:0];
        _isButtion = NO;
    }
    _lastTap = 0;
}


@end
