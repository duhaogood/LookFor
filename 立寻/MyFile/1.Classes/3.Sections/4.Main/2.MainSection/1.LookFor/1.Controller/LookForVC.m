//
//  LookForVC.m
//  立寻
//
//  Created by mac_hao on 2017/5/23.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "LookForVC.h"
#import "FirstPageHeaderView.h"
#import "LookForCell.h"
#import "GYZChooseCityController.h"
#import "PYSearch.h"
#import "SelectTypeVC.h"
#import "FirstPageMiddleNextVC.h"
#import "FirstPageMiddleNextCell.h"
#import "PublishInfoVC.h"
@interface LookForVC ()<PYSearchViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,UISearchBarDelegate,GYZChooseCityDelegate>
@property(nonatomic,strong)FirstPageHeaderView * headerView;
@property(nonatomic,strong)NSArray * btn_name_img_array;//中部按钮图片及名字
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * lookForArray;//找寻数据
@property(nonatomic,strong)NSArray * cell_show_array;//cell数据源
@property(nonatomic,strong)UILabel * cityLabel;//城市名label
@property(nonatomic,strong)UISearchBar * searchBar;//搜索框
@property(nonatomic,strong)UIImageView * areaIcon;//城市图标

@property(nonatomic,strong)NSMutableArray * cellDataArray;//cell数据
@property(nonatomic,strong)UIView * noDataView;//没有数据显示
@property(nonatomic,strong)NSArray * upBannerImgArray;//上部banner数据
@property(nonatomic,strong)NSArray * downBannerImgArray;//下部banner数据
@property(nonatomic,strong)NSArray * cityArray;//城市数组
@end

@implementation LookForVC
{
    NSString * cityId;//定位到的cityId
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * path = [[NSBundle mainBundle] pathForResource:@"area_code" ofType:@"plist"];
    self.cityArray = [NSArray arrayWithContentsOfFile:path];
    //加载主界面
    [self loadMainView];
}
//加载主界面
-(void)loadMainView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    //加载轮播图数据
    [self loadBannerArray];
    //左侧定位按钮
    {
        UIView * v = [UIView new];
        v.frame = CGRectMake(0, 0, 70, 44);
        UIBarButtonItem * bar = [[UIBarButtonItem alloc] initWithCustomView:v];
        self.navigationItem.leftBarButtonItem = bar;
        //右侧图标-arrow_bottom_md 11*6
        {
            UIImageView * icon = [UIImageView new];
            icon.image = [UIImage imageNamed:@"arrow_bottom_md"];
            self.areaIcon = icon;
            [v addSubview:icon];
            //城市名称
            UILabel * label = [UILabel new];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor whiteColor];
            [v addSubview:label];
            label.text = @"定位中…";
            self.cityLabel = label;
            CGSize size = [MYTOOL getSizeWithLabel:label];
            label.frame = CGRectMake(0, 22-size.height/2, size.width, size.height);
            icon.frame = CGRectMake(label.frame.origin.x + label.frame.size.width + 5, 19, 11, 6);
        }
        //按钮
        {
            UIButton * btn = [UIButton new];
            btn.frame = v.bounds;
            [v addSubview:btn];
            [btn addTarget:self action:@selector(clickUpLeftCityBtn) forControlEvents:UIControlEventTouchUpInside];
        }
        [[MyLocationManager sharedLocationManager] startLocation];
    }
    //右侧筛选按钮
    {
        UIView * view = [UIView new];
        view.frame = CGRectMake(0, 0, 50, 44);
//        view.backgroundColor = [UIColor redColor];
        UIBarButtonItem * barBtn = [[UIBarButtonItem alloc] initWithCustomView:view];
        self.navigationItem.rightBarButtonItem = barBtn;
        //图标
        UIImageView * icon = [UIImageView new];
        icon.image = [UIImage imageNamed:@"filter"];
        icon.frame = CGRectMake(view.frame.size.width-12, view.frame.size.height/2-6, 12, 12);
        [view addSubview:icon];
        //文字
        UILabel * label = [UILabel new];
        label.text = @"筛选";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        CGSize size = [MYTOOL getSizeWithLabel:label];
        label.frame = CGRectMake(view.frame.size.width-12-size.width, view.frame.size.height/2-size.height/2, size.width, size.height);
        [view addSubview:label];
        //按钮
        UIButton * btn = [UIButton new];
        btn.frame = view.bounds;
        [view addSubview:btn];
        [btn addTarget:self action:@selector(clickUpRightSelectBtn) forControlEvents:UIControlEventTouchUpInside];
    }
}
//点击左上角定位城市事件
-(void)clickUpLeftCityBtn{
    GYZChooseCityController *cityPickerVC = [[GYZChooseCityController alloc] init];
    [cityPickerVC setDelegate:self];
    [self.navigationController pushViewController:cityPickerVC animated:true];
}
//点击右上角筛选
-(void)clickUpRightSelectBtn{
    SelectTypeVC * select = [SelectTypeVC new];
    select.title = @"选择分类";
    [self.navigationController pushViewController:select animated:true];
}
#pragma mark - 头view点击事件
//tableview数据源选择
-(void)selectServiceType:(UIButton *)btn{
    //更新数据源，然后给头view更新界面
    [self.headerView selectServiceCallback:btn.tag];
    self.current_money_type_btn = btn;
    [self up_newClick:self.leftTypeBtn];
}
//中部图标点击事件
-(void)iconClick:(UIButton *)tap{
    NSInteger tag = tap.tag;
    NSString * name = self.btn_name_img_array[tag][1];
    if ([name isEqualToString:@"招商加盟"] || [name isEqualToString:@"公共平台"]) {
        [SVProgressHUD showErrorWithStatus:@"开发中" duration:1];
        return;
    }
    FirstPageMiddleNextVC * vc = [FirstPageMiddleNextVC new];
    vc.title = name;
    vc.parentid = self.btn_name_img_array[tag][3];
    [self.navigationController pushViewController:vc animated:true];
}
//置顶、最新事件
-(void)up_newClick:(UIButton *)btn{
    [self.headerView selectBtnForUpOrNew:btn];
    self.current_toptype_btn = btn;
    
    [self getCellDataWithHeader:true];
    
    
}
//签到事件
-(void)signClick:(UIButton *)btn{
    if (![MYTOOL isLogin]) {
        //跳转至登录页
        LoginVC * login = [LoginVC new];
        login.title = @"登录";
        [self.navigationController pushViewController:login animated:true];
        return;
    }
    NSString * title = btn.currentTitle;
    if ([title isEqualToString:@"已签到"]) {
        [SVProgressHUD showErrorWithStatus:@"今天已签到" duration:2];
        return;
    }else{
        NSString * interface = @"user/memberuser/usersignaddpoint.html";
        NSDictionary * send = @{
                                @"userid":USER_ID
                                };
        [MYTOOL netWorkingWithTitle:@"签到中……"];
        [MYNETWORKING getWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
            [self.signBtn setTitle:@"已签到" forState:UIControlStateNormal];
        }];
    }
    
    
    
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSDictionary * publishDic = self.cellDataArray[indexPath.section];
    NSObject * PublishID = publishDic[@"PublishID"];
    if (!PublishID) {
        [SVProgressHUD showErrorWithStatus:@"此信息有问题" duration:2];
        return;
    }
    NSString * interface = @"publish/publish/getpublishdetailcomplex.html";
    NSDictionary * send = @{@"publishid":PublishID};
    [MYTOOL netWorkingWithTitle:@"加载中……"];
    [MYNETWORKING getWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        NSDictionary * publishDictionary = back_dic[@"Data"];
        if (publishDictionary) {
            PublishInfoVC * vc = [PublishInfoVC new];
            vc.title = @"信息详情";
            vc.publishDictionary = publishDictionary;
            [self.navigationController pushViewController:vc animated:true];
        }else{
            [SVProgressHUD showErrorWithStatus:@"此信息有问题" duration:2];
        }
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MYTOOL getHeightWithIphone_six:200];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FirstPageMiddleNextCell * cell = [[FirstPageMiddleNextCell alloc] initWithDictionary:self.cellDataArray[indexPath.row] isFirstPage:true];
    return cell;
}
#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"轮播图tag:%ld,点击了第%ld张图片",cycleScrollView.tag,index);
    NSDictionary * imgDic = self.upBannerImgArray[index];
    
}
//下部banner图片点击事件
-(void)downBannerImageClick:(UITapGestureRecognizer *)tap{
    NSInteger tag = tap.view.tag;
    NSDictionary * imgDic = self.downBannerImgArray[tag];
    
    NSLog(@"tag:%ld",tag);
}
#pragma mark - UISearchBarDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    /*接口-----获取热门标签--->初始化数组*/
#warning 接口待调
    NSArray *hotSeaches = @[@"找人", @"找什么", @"举报", @"找狗狗", @"招领人",@"找债权人",@"我的好战友",@"我的钱包丢了",@"失踪儿童",@"法律顾问"];
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"找亲人", @"搜索编程语言") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        
        //[searchViewController.navigationController pushViewController:[[PYTempViewController alloc] init] animated:YES];
    }];

    searchViewController.hotSearchStyle = 3;
    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault;
   
    searchViewController.delegate = self;
    [self.navigationController pushViewController:searchViewController animated:true];

    return false;
}
//加载轮播图数据
-(void)loadBannerArray{
    //头view中间按钮图标及名字数组
    self.btn_name_img_array = @[
                                @[@"menu_xr",@"委托寻人",@"LookPersonVC",@"83"],
                                @[@"menu_xw",@"委托寻物",@"LookSomethingVC",@"82"],
                                @[@"menu_zlrl",@"招领认领",@"PersonLookVC",@"394"],
                                @[@"menu_zsjm",@"招商加盟",@"BusinessVC",@"0"],
                                @[@"menu_wlbg",@"网络曝光",@"NetShowVC",@"80"],
                                @[@"menu_wlqz",@"网络求助",@"NetHelpVC",@"81"],
                                @[@"menu_quanzi",@"立寻圈子",@"LookCircleVC",@"549"],
                                @[@"menu_shop",@"公共平台",@"PointStoreVC",@"0"]
                                ];
    //加载下部banner数据
    NSString * interface = @"/common/advert/getindexadvertlist.html";
    [MYTOOL netWorkingWithTitle:@"加载中……"];
    [MYNETWORKING getWithInterfaceName:interface andDictionary:[NSDictionary new] andSuccess:^(NSDictionary *back_dic) {
        NSArray * down = back_dic[@"Data"];
        //表视图
        UITableView * tableView = [UITableView new];
        //头视图
        FirstPageHeaderView * headerView = [[FirstPageHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [MYTOOL getHeightWithIphone_six:593]) andDelegate:self andUpBannerArray:nil andDownBannerArray:down andBtnName_imgArray:self.btn_name_img_array];
        self.headerView = headerView;
        self.tableView = tableView;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tableHeaderView = headerView;
        tableView.backgroundColor = MYCOLOR_240_240_240;
        tableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT - 64 - 49);
        [self.view addSubview:tableView];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self headerRefresh];
            // 结束刷新
            [tableView.mj_header endRefreshing];
        }];
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        tableView.mj_header.automaticallyChangeAlpha = YES;
        // 上拉刷新
        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self footerRefresh];
            [tableView.mj_footer endRefreshing];
        }];
        self.automaticallyAdjustsScrollViewInsets = false;
        self.tableView = tableView;
        tableView.rowHeight = [MYTOOL getHeightWithIphone_six:200];
        [self.view addSubview:tableView];
        //不显示分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //@property(nonatomic,strong)UIView * noDataView;//没有数据显示
        {
            UIView * view = [UIView new];
            self.noDataView = view;
            view.frame = tableView.bounds;
            view.backgroundColor = MYCOLOR_240_240_240;
            //        [tableView addSubview:view];
            //图片-170*135
            {
                UIImageView * icon = [UIImageView new];
                icon.image = [UIImage imageNamed:@"nodate"];
                icon.frame = CGRectMake(WIDTH/2-169/2.0, (HEIGHT-64)/2-135, 169, 135);
                [view addSubview:icon];
            }
        }
        //加载签到状态
        [self getSignStatus];
        //加载上部banner数据
        [self getUpBannerImageDataWithCityId:0];
    }];
}
//加载上部banner数据
-(void)getUpBannerImageDataWithCityId:(int)cityId1{
    NSString * interface = @"/common/advert/getindexrecommendadvertlist.html";
    [MYTOOL netWorkingWithTitle:@"加载中……"];
    [MYNETWORKING getWithInterfaceName:interface andDictionary:@{@"cityid":[NSString stringWithFormat:@"%d",cityId1]} andSuccess:^(NSDictionary *back_dic) {
        NSArray * array = back_dic[@"Data"];
        self.upBannerImgArray = array;
        NSMutableArray * url_arr = [NSMutableArray new];
        for (NSDictionary * dic in array) {
            [url_arr addObject:dic[@"imgpath"]];
        }
        [self.upBannerView setImageURLStringsGroup:url_arr];
    }];
}
//加载签到状态
-(void)getSignStatus{
    if (![MYTOOL isLogin]) {
        return;
    }
    NSString * interface = @"user/memberuser/userissign.html";
    NSDictionary * send = @{
                            @"userid":USER_ID
                            };
    [MYNETWORKING getDataWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        [self.signBtn setTitle:@"已签到" forState:UIControlStateNormal];
    } andNoSuccess:^(NSDictionary *back_dic) {
        [self.signBtn setTitle:@"签到" forState:UIControlStateNormal];
    } andFailure:^(NSURLSessionTask *operation, NSError *error) {
        
    }];
    
}
#pragma mark - 上啦下啦刷新
-(void)headerRefresh{
    [self getCellDataWithHeader:true];
}
-(void)footerRefresh{
    [self getCellDataWithHeader:false];
}
//重新加载数据
-(void)getCellDataWithHeader:(BOOL)flag{
    NSString * interface = @"/publish/publish/getindexpublishcomplexlist.html";
    NSMutableDictionary * send = [NSMutableDictionary new];
    //是否下拉
    if (!flag) {
        if (self.cellDataArray && self.cellDataArray.count > 0) {
            NSObject * lastnumber = self.cellDataArray[self.cellDataArray.count - 1][@"PublishID"];
            [send setValue:lastnumber forKey:@"lastnumber"];
        }
    }
    //置顶-最新-悬赏
    {
        NSString * moneytype = self.current_money_type_btn.tag == 100 ? @"1" : @"2";
        [send setValue:moneytype forKey:@"moneytype"];
        NSString * toptype = self.current_toptype_btn.tag == 100 ? @"1" : @"0";
        [send setValue:toptype forKey:@"toptype"];
    }
    [MYNETWORKING getNoPopWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        NSArray * array = back_dic[@"Data"];
        if (flag) {
            self.cellDataArray = [NSMutableArray arrayWithArray:array];
        }else{
            if (array == nil || array.count == 0) {
                [SVProgressHUD showErrorWithStatus:@"到底啦" duration:2];
                return;
            }
            [self.cellDataArray addObjectsFromArray:array];
        }
        if (self.cellDataArray && self.cellDataArray.count > 0) {
            self.noDataView.hidden = true;
        }else{
            self.noDataView.hidden = false;
        }
        [self.tableView reloadData];
    }];
}
//加载cell数据
-(void)loadCellDate{
    
    [self.tableView reloadData];
}
//设置顶上文字
-(void)setCityName:(NSString *)city{
    if (city && city.length > 0) {
        if (city.length > 4) {//如果长度大于4，取前3个字+…
            city = [city substringToIndex:3];
            city = [NSString stringWithFormat:@"%@…",city];
        }
        self.cityLabel.text = city;
        CGSize size = [MYTOOL getSizeWithLabel:self.cityLabel];
        self.cityLabel.frame = CGRectMake(0, 22-size.height/2, size.width, size.height);
        self.areaIcon.frame = CGRectMake(self.cityLabel.frame.origin.x + self.cityLabel.frame.size.width + 5, 19, 11, 6);
    }
}
#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
    if (searchText.length) {
        // Simulate a send request to get a search suggestions
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableArray *searchSuggestionsM = [NSMutableArray array];
            for (int i = 0; i < arc4random_uniform(5) + 10; i++) {
                NSString *searchSuggestion = [NSString stringWithFormat:@"Search suggestion %d", i];
                [searchSuggestionsM addObject:searchSuggestion];
            }
            // Refresh and display the search suggustions
//            searchViewController.searchSuggestions = searchSuggestionsM;
        });
    }
}
#pragma mark - GYZCityPickerDelegate
- (void) cityPickerController:(GYZChooseCityController *)chooseCityController didSelectCity:(GYZCity *)city
{
    [chooseCityController.navigationController popViewControllerAnimated:true];
    [self setCityName:city.cityName];
    NSString * name = city.cityName;
    for (NSDictionary * shengDic in self.cityArray) {
        NSArray * cityArray = shengDic[@"cityArray"];
        for (NSDictionary * cityDic in cityArray) {
            NSString * cityName = cityDic[@"cityName"];
            if ([cityName isEqualToString:name] || [cityName rangeOfString:name].location != NSNotFound
                || [name rangeOfString:cityName].location != NSNotFound) {
                NSString * cityId1 = cityDic[@"cityId"];
                cityId = cityId1;
                [self getUpBannerImageDataWithCityId:[cityId1 intValue]];
                return;
            }
        }
    }
}

- (void) cityPickerControllerDidCancel:(GYZChooseCityController *)chooseCityController
{
    [chooseCityController.navigationController popViewControllerAnimated:true];
}
//接收到定位成功通知
-(void)receiveUpdateLocationSuccessNotification:(NSNotification *)notification{
    NSDictionary * obj = notification.object;
    NSString * city = obj[@"city"];
    [self setCityName:city];
    for (NSDictionary * shengDic in self.cityArray) {
        NSArray * cityArray = shengDic[@"cityArray"];
        for (NSDictionary * cityDic in cityArray) {
            NSString * cityName = cityDic[@"cityName"];
            if ([cityName isEqualToString:city] || [cityName rangeOfString:city].location != NSNotFound
                || [city rangeOfString:cityName].location != NSNotFound) {
                NSString * cityId1 = cityDic[@"cityId"];
                [self getUpBannerImageDataWithCityId:[cityId1 intValue]];
                return;
            }
        }
    }
}
//接收到定位失败通知
-(void)receiveUpdateLocationFailedNotification:(NSNotification *)notification{
    
}
-(void)viewWillAppear:(BOOL)animated{
    [MYCENTER_NOTIFICATION addObserver:self selector:@selector(receiveUpdateLocationSuccessNotification:) name:NOTIFICATION_UPDATELOCATION_SUCCESS object:nil];
    [MYCENTER_NOTIFICATION addObserver:self selector:@selector(receiveUpdateLocationFailedNotification:) name:NOTIFICATION_UPDATELOCATION_FAILED object:nil];
    //搜索框
    UISearchBar * searchBar = [[UISearchBar alloc]init];
    searchBar.delegate = self;
    self.searchBar = searchBar;
    searchBar.frame = CGRectMake(90, 14, WIDTH-160, 14.5);
    [self.navigationController.navigationBar addSubview:searchBar];
    searchBar.placeholder = @"请输入查询的关键字";
    //加载签到状态
    [self getSignStatus];
}
-(void)viewWillDisappear:(BOOL)animated{
    //删除通知
    [MYCENTER_NOTIFICATION removeObserver:self name:NOTIFICATION_UPDATELOCATION_SUCCESS object:nil];
    [MYCENTER_NOTIFICATION removeObserver:self name:NOTIFICATION_UPDATELOCATION_FAILED object:nil];
    [self.searchBar removeFromSuperview];
    self.searchBar = nil;
}



@end
