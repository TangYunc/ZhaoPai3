//
//  DropdownMenu.m
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/27.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import "DropdownMenu.h"

@interface DropdownMenu ()

@end

@implementation DropdownMenu

- (id)initDropdownWithButtonTitles:(NSArray*)titles andLeftListArray:(NSArray*)leftArray andRightListArray:(NSArray *)rightArray {
    self = [super init];
    if (self) {
        self.view.frame = CGRectMake(0, 0, kScreenWidth, 130);
        //创建下滑按钮
        _button = [[DropdownButton alloc] initDropdownButtonWithTitles:titles];
        _button.frame = CGRectMake(0, 0, kScreenWidth, 40);
        _button.delegate = self;
        
        [self.view addSubview:_button];
        //点击下滑按钮后显示 的二级菜单的视图
        _tableView = [[ConditionDoubleTableView alloc] initWithFrame:self.view.bounds andLeftItems:leftArray andRightItems:rightArray];
        _tableView.delegate = self;
        //添加一个事件，即当收起事件发生后^按钮的状态由下变为上
        [self.view addSubview:_tableView.view];
        [self initSelectedArray:titles];
        //添加一个通知，当为收起事件的时候的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reduceBackgroundSize) name:@"hideMenu" object:nil];
    }
    return self;
}
        //添加一个事件，即当收起事件发生后^按钮的状态由下变为上
- (void)initSelectedArray:(NSArray *)titles {
    _buttonIndexArray = [[NSMutableArray alloc] initWithCapacity:titles.count];
}

//button点击代理
- (void)showMenu:(NSInteger)index {
    _lastIndex = index;
    [self.view setFrame:kScreenRect];
    _buttonSelectedIndex = index - 10000;
    NSString *selected = @"0-0";
    if (_buttonIndexArray.count > _buttonSelectedIndex){
        selected = [_buttonIndexArray objectAtIndex:_buttonSelectedIndex];
    } else {
        [_buttonIndexArray addObject:selected];
    }
    NSArray *selectedArray = [selected componentsSeparatedByString:@"-"];
    NSString *left = [selectedArray objectAtIndex:0];
    NSString *right = [selectedArray objectAtIndex:1];
    [_tableView showTableView:_buttonSelectedIndex WithSelectedLeft:left Right:right];
}

- (void)hideMenu {
    [_tableView hideTableView];
}

- (void)reduceBackgroundSize {
    [self.view setFrame:CGRectMake(0, 0, kScreenWidth, 104)];
}

- (void)selectedFirstValue:(NSString *)first SecondValue:(NSString *)second{
    NSString *index = [NSString stringWithFormat:@"%@-%@", first, second];
    [_buttonIndexArray setObject:index atIndexedSubscript:_buttonSelectedIndex];
    [self returnSelectedLeftIndex:first RightIndex:second];
}

- (void)returnSelectedLeftIndex:(NSString *)left RightIndex:(NSString *)right {
    if (_delegate && [_delegate respondsToSelector:@selector(dropdownSelectedLeftIndex:RightIndex:)]) {
        [_delegate performSelector:@selector(dropdownSelectedLeftIndex:RightIndex:) withObject:left withObject:right];
    }
}
@end
