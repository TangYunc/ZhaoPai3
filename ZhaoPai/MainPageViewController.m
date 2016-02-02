//
//  MainPageViewController.m
//  ZhaoPai
//
//  Created by Mr_Tang on 16/1/18.
//  Copyright © 2016年 Mr_Tang. All rights reserved.
//

#import "MainPageViewController.h"
#import "ZhaoPai-swift.h"
#import "MainPageCell.h"

@interface MainPageViewController ()

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    [self creatSubView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getResultView:) name:@"CMDI.SCAN_RESULT.GET" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getVideoLayer:) name:@"CMDI.VIDEOLAYER.GET" object:nil]; 
}

//创建子视图
- (void)creatSubView{


    //1.设置导航栏的搜索框
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 143*2, 64)];
    searchBar.barStyle = UIBarStyleBlackTranslucent;
    [searchBar setBackgroundImage:[UIImage imageNamed:@"体验_u30_selected.png"]];
    [searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"体验_u30_selected.png"] forState:UIControlStateNormal];
    [searchBar setImage:[UIImage imageNamed:@"u10searchBar.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.keyboardType = UIKeyboardTypeDefault;
    self.navigationItem.titleView = searchBar;
    
    //2.创建一个扫描按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"saoma.png"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [button addTarget:self action:@selector(scanCodeNuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    //3.创建表shi图
    _mainPageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-40) style:UITableViewStylePlain];
    _mainPageTableView.dataSource = self;
    _mainPageTableView.delegate = self;
    _mainPageTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_mainPageTableView];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"cellId";
    MainPageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MainPageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //计算单元格高度
    CGFloat cellHeight = 10+30+20+20+10;
    return cellHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    [self testData];
    DropdownMenu *dropdown = [[DropdownMenu alloc] initDropdownWithButtonTitles:_titleArray andLeftListArray:_leftArray andRightListArray:_rightArray];
    dropdown.delegate = self;   //此句的代理方法可返回选中下标值


    return dropdown.view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 40;
}

//测试数据
- (void)testData {
    [self testTitleArray];
    [self testLeftArray];
    [self testRightArray];
}

//每个下拉的标题
- (void) testTitleArray {
    _titleArray = @[@"全部分类",@"智能排序"];
}

//左边列表可为空，则为单下拉菜单，可以根据需要传参
- (void)testLeftArray {
    NSArray *One_leftArray = @[@"全部分类", @"体验", @"搜罗", @"监察", @"调研"];
    //    NSArray *Two_leftArray = @[@"dfa",@"fagag"];
    NSArray *Two_leftArray = [[NSArray alloc] init];
    //    NSArray *R_leftArray = @[@"Test1", @"Test2"];
   
    _leftArray = [[NSArray alloc] initWithObjects:One_leftArray, Two_leftArray, nil];
}

//右边列表不可为空
- (void)testRightArray {
    NSArray *F_rightArray = @[
                              @[
                                  @{@"title":@""},
                                  ] ,
                              @[
                                  @{@"title":@"全部"},
                                  @{@"title":@"到店体验"},
                                  @{@"title":@"活动参与"},
                                  @{@"title":@"产品试用"},
                                  @{@"title":@"金融产品"},
                                  @{@"title":@"游戏体验"},
                                  @{@"title":@"热门抢购"},
                                  @{@"title":@"购物返现"},
                                  @{@"title":@"众包销售"},
                                  @{@"title":@"线上互动"},
                                  @{@"title":@"试驾体验"},
                                  @{@"title":@"注册体验"},
                                  @{@"title":@"应用体验"},
                                  ],
                              @[
                                  @{@"title":@"全部"},
                                  @{@"title":@"信息收集"},
                                  @{@"title":@"门牌搜集"},
                                  ],
                              @[
                                  @{@"title":@"全部"},
                                  @{@"title":@"门店检查"},
                                  @{@"title":@"户外检查"},
                                  ],
                              @[
                                  @{@"title":@"全部"},
                                  @{@"title":@"数据调研"},
                                  ]
                              ];
    
    NSArray *S_rightArray = @[
                              @[
                                  @{@"title":@"one"},
                                  @{@"title":@"two"},
                                  @{@"title":@"three"}
                                  ] ,
                              @[
                                  @{@"title":@"four"}
                                  ],
                              @[
                                  @{@"title":@"全部"},
                                  @{@"title":@"信息收集"},
                                  @{@"title":@"门牌搜集"},
                                  ],

                              ];
    
    _rightArray = [[NSArray alloc] initWithObjects:F_rightArray, S_rightArray, nil];
}

//实现代理，返回选中的下标，若左边没有列表，则返回0
- (void)dropdownSelectedLeftIndex:(NSString *)left RightIndex:(NSString *)right; {
    NSLog(@"%s : You choice %@ and %@", __FUNCTION__, left, right);
}



#pragma mark - 扫码按钮
- (void)scanCodeNuttonAction:(UIButton *)button{

    
    //点击扫码
    CaptureBoard *captureBardCtrl = [CaptureBoard shareInstance];
    [captureBardCtrl viewDidAppear:YES];
    [self.navigationController pushViewController:captureBardCtrl animated:YES];
    [captureBardCtrl setUseNotification:YES AndNoResultView:NO];


}

#pragma mark - 接收到通知调用的方法
- (void)getResultView:(NSNotification *)notif{

    _codeString = notif.object;
    ResultBoard *resultBoard = [ResultBoard shareInstance];
    //确定文件路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dataBasePath = [path stringByAppendingString:@"/BarCode_Demo.text"];
    //将扫描结果存入文件中
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_codeString forKey:@"_codeString"];
    [dic writeToFile:dataBasePath atomically:YES];

    //判断扫描的结果是商品码还是URL地址
    NSRange rang1 = [_codeString rangeOfString:@"^[0-9]+$" options:NSRegularExpressionSearch];
    NSRange rang2 = [_codeString rangeOfString:@"(?<=[0-9a-z])://(?=[0-9a-z])" options:NSRegularExpressionSearch | NSCaseInsensitiveSearch];
    
    if (rang1.location != NSNotFound) {
        //商品码
        NSString *actURLString = [NSString stringWithFormat:@"http://webapi.chinatrace.org/api/getProductData?productCode=%@",_codeString];
        NSURL *actURL = [NSURL URLWithString:actURLString];
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:actURL];
        [urlRequest setHTTPMethod:@"GET"];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.allowsCellularAccess = NO;
        NSURLSession *taskPr = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *dataTask = [taskPr dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil) {
                //将获得的数据转换成json字符串
                NSString *getResultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                //存入文件
                [dic setObject:getResultString forKey:@"getResultString"];
                [dic writeToFile:dataBasePath atomically:YES];

            }else{
                NSLog(@"error:%@",error);
            }
        }];
        [dataTask resume];
        
    }else if(rang2.location !=NSNotFound){
        //URL地址
        NSURL *actURL = [NSURL URLWithString:_codeString];
        if ([[UIApplication sharedApplication] canOpenURL:actURL]) {
            [[UIApplication sharedApplication] openURL:actURL];
        }
        if ([_codeString hasSuffix:@"/BarCode_Demo.plist"]) {
            [resultBoard exitApplication];
        }
    }
//    [self postUpload];
}

#pragma mark  - post上传
- (void)postUpload{

    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dataBasePath = [path stringByAppendingString:@"/BarCode_Demo.text"];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //上传文件
    NSString *headUrlString = @"http://webapi.cmdi-info.com/api/File";
    //当前用户名
    NSString *userNameString = appDelegate.my_userName;
    //确定当前设备
    NSString *UUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //确定时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    //确定时间戳,并以此作为文件名
    NSDate *fromDate = [NSDate date];
    long time = (long)[fromDate timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%ld.text", time];

    NSString *parmasString = [NSString stringWithFormat:@"?path=%@/%@/%@/%@",userNameString,UUID,str,fileName];
    NSString *escapeUrlString = [parmasString stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
    //拼接URL地址
    NSString *urlString = [headUrlString stringByAppendingString:escapeUrlString];
    // 1.获得请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 在此位置生成一个要上传的数据体
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:dataBasePath];
        //将配置的参数转换成二进制数据
        NSData *postData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
                 /*
                   此方法参数
                   1.FileData 要上传的[二进制数据]
                   2.name 后台接受的参数,对应网站上[upload.php中]处理文件的[字段"file"]
                   3.fileName 要保存在服务器上的[文件名]
                   4. 上传文件的[mimeType]
                   */
        [formData appendPartWithFileData:postData name:@"path" fileName:fileName mimeType:@"application/octet-stream"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"完成：%@",result);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"错误：%@",error.localizedDescription);
    }];
}
- (void)getVideoLayer:(NSNotification *)notif{
//AVCaptureFileOutputDelegate
//    AVCaptureVideoDataOutput
    NSLog(@"getVideoLayer:%@",notif.object);
    AVCaptureVideoPreviewLayer *videoLayer = nil;
    videoLayer = notif.object;
    UIImage *curImg = nil;
    UIGraphicsBeginImageContext(videoLayer.bounds.size);
    [videoLayer renderInContext:UIGraphicsGetCurrentContext()];
    curImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();


 
    NSLog(@"curImage:%@",curImg);
    [self postScanCurImage:curImg];
}

- (void)postScanCurImage:(UIImage *)curImage{

    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //上传文件
    NSString *headUrlString = @"http://webapi.cmdi-info.com/api/File";
    //当前用户名
    NSString *userNameString = appDelegate.my_userName;
    //确定当前设备
    NSString *UUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //确定时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    //确定时间戳,并以此作为文件名
    NSDate *fromDate = [NSDate date];
    long time = (long)[fromDate timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%ld.png", time];
    
    NSString *parmasString = [NSString stringWithFormat:@"?path=%@/%@/%@/%@",userNameString,UUID,str,fileName];
    NSString *escapeUrlString = [parmasString stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
    //拼接URL地址
    NSString *urlString = [headUrlString stringByAppendingString:escapeUrlString];
    // 1.获得请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 在此位置生成一个要上传的数据体,将配置的参数转换成二进制数据
        NSData *data = UIImagePNGRepresentation(curImage);
        /*
         此方法参数
         1.FileData 要上传的[二进制数据]
         2.name 后台接受的参数,对应网站上[upload.php中]处理文件的[字段"file"]
         3.fileName 要保存在服务器上的[文件名]
         4. 上传文件的[mimeType]
         */
        [formData appendPartWithFileData:data name:@"path" fileName:fileName mimeType:@"image/png"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"完成：%@",result);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"错误1：%@",error.localizedDescription);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
