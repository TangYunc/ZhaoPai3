//
//  DropdownMenu.h
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/27.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropdownButton.h"
#import "ConditionDoubleTableView.h"

@class DropdownMenu;

@protocol dropdownDelegate <NSObject>

@optional
- (void)dropdownSelectedLeftIndex:(NSString *)left RightIndex:(NSString *)right;

@end

@interface DropdownMenu : UIViewController<showMenuDelegate, ConditionDoubleTableViewDelegate> {
    DropdownButton *_button;
    ConditionDoubleTableView *_tableView;
    NSInteger _lastIndex;
    
    NSInteger _buttonSelectedIndex;
    NSMutableArray *_buttonIndexArray;
    
    NSArray *_leftArray;
    NSArray *_rightArray;
}

@property (assign, nonatomic) id<dropdownDelegate>delegate;

- (id)initDropdownWithButtonTitles:(NSArray*)titles andLeftListArray:(NSArray*)leftArray andRightListArray:(NSArray *)rightArray;


@end
