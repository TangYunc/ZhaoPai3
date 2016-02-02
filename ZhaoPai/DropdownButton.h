//
//  DropdownButton.h
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/27.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropdownButton;
@protocol showMenuDelegate <NSObject>

- (void)showMenu:(NSInteger)index;
- (void)hideMenu;


@end

@interface DropdownButton : UIView
{
    NSInteger _count;
    NSInteger _lastTap;
    NSString *_lastTapObj;
    UIImage *_image;
    
    BOOL _isButtion;
}

@property (nonatomic, strong) UIImageView *buttonImageView;
@property (nonatomic,assign) id<showMenuDelegate> delegate;

- (id)initDropdownButtonWithTitles:(NSArray*)titles;

@end
