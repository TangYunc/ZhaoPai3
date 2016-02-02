//
//  ActivityIndicatorView.h
//  ZhaoPai
//
//  Created by Mr_Tang on 16/2/1.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityIndicatorView : UIView
{
    UILabel *_ActivityIndicatorLabel;
    UIActivityIndicatorView *_ActivityIndicatorView;

}

-(void)showWithActivityIndicatorMessage:(NSString*)msg;
-(void)hide;

@end
