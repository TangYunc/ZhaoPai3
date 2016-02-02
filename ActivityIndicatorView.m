//
//  ActivityIndicatorView.m
//  ZhaoPai
//
//  Created by Mr_Tang on 16/2/1.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import "ActivityIndicatorView.h"

@implementation ActivityIndicatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(kScreenWidth/2-20, kScreenHeight/2-20, 40, 40);
        
        _ActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _ActivityIndicatorView.frame = (CGRect) {
            .origin.x = kScreenWidth/2.0-(self.frame.size.height - 6)/2.0,
            .origin.y = kScreenHeight/2.0-(self.frame.size.height - 6)/2.0,
            .size.width = self.frame.size.height - 6,
            .size.height = self.frame.size.height - 6
        };
        _ActivityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:_ActivityIndicatorView];
        //文字信息，用于和用户进行交互，最好能提示用户当前是什么操作
        _ActivityIndicatorLabel = [[UILabel alloc] initWithFrame:(CGRect){.origin.x = _ActivityIndicatorView.left-80, .origin.y = _ActivityIndicatorView.bottom, .size.width = 200.0f, .size.height = self.frame.size.height}];
        _ActivityIndicatorLabel.backgroundColor = [UIColor clearColor];
        _ActivityIndicatorLabel.textColor = [UIColor blackColor];
        _ActivityIndicatorLabel.font = [UIFont boldSystemFontOfSize:10.0f];
        [self addSubview:_ActivityIndicatorLabel];

        
    }
    return self;
}
-(void)showWithActivityIndicatorMessage:(NSString*)msg; {
    if (!msg) return;
    _ActivityIndicatorLabel.text = msg;
    [_ActivityIndicatorView startAnimating];
    self.hidden = NO;
}


- (void) hide {
    [_ActivityIndicatorView stopAnimating];
    self.hidden = YES;
}
@end
