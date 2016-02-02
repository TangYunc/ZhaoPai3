//
//  MainPageViewController.h
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/18.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import "BaseViewController.h"
#import "DropdownMenu.h"

@interface MainPageViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,dropdownDelegate>
{
    UITableView *_mainPageTableView;
    ConditionDoubleTableView *_tableView;
    NSArray *_titleArray;
    NSArray *_leftArray;
    NSArray *_rightArray;
}

@property(nonatomic,strong)NSArray *dataList;
@property(nonatomic,strong)NSString *codeString;
@property(nonatomic,strong)NSString *getResultString;
@end
