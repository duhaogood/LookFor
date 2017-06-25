//
//  FirstPageMiddleNextVC.m
//  立寻
//
//  Created by mac on 2017/6/21.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "FirstPageMiddleNextVC.h"
#import "FirstPageMiddleNextCell.h"
#import "PublishInfoVC.h"
@interface FirstPageMiddleNextVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSArray * typeArray;//二级分类数组
@property(nonatomic,strong)UIScrollView * select_2_view;//二级分类滚动view
@property(nonatomic,strong)UIView * select_3_view;//三级分类按钮view
@property(nonatomic,strong)UIButton * up_btn;//置顶按钮
@property(nonatomic,strong)NSMutableArray * cellDataArray;//cell数据
@property(nonatomic,strong)UIView * noDataView;//没有数据显示


@end

@implementation FirstPageMiddleNextVC
{
    NSMutableArray * select_2_btn_array;//二级分类按钮数组
    NSMutableArray * select_3_btn_array;//三级分类按钮数组
    UIButton * current_2_btn;//二级分类当前选中按钮
    UIButton * current_3_btn;//三级分类当前选中按钮
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(popUpViewController)];
    self.view.backgroundColor = MYCOLOR_240_240_240;
    
    //加载主界面
    [self loadMainView];
    
}
//加载主界面
-(void)loadMainView{
    //先获取二级分类标题
    NSString * interface = @"/publish/publish/getcategorytwolist.html";
    NSDictionary * send = @{
                            @"parentid":_parentid
                            };
    [MYTOOL netWorkingWithTitle:@"重新读取二级分类"];
    [MYNETWORKING getWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        NSArray * array = back_dic[@"Data"];
        NSMutableArray * typeArray = [NSMutableArray arrayWithArray:array];
        NSDictionary * allDic = @{
                                  @"CategoryTitle":@"全部",
                                  @"CategoryID":@"0"
                                  };
        [typeArray insertObject:allDic atIndex:0];
        self.typeArray = [NSArray arrayWithArray:typeArray];
        [self loadType_2_btns];
        [self loadTableView];
        [self select_3_btns_callback:select_3_btn_array[1]];
    }];
}
//加载tableview
-(void)loadTableView{
    UITableView * tableView = [UITableView new];
    tableView.frame = CGRectMake(0, 90, WIDTH, HEIGHT-64-90);
    tableView.dataSource = self;
    tableView.delegate = self;
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
        [tableView addSubview:view];
        //图片-170*135
        {
            UIImageView * icon = [UIImageView new];
            icon.image = [UIImage imageNamed:@"nodate"];
            icon.frame = CGRectMake(WIDTH/2-169/2.0, (HEIGHT-64)/2-135, 169, 135);
            [view addSubview:icon];
        }
    }
}
//加载二级分类按钮
-(void)loadType_2_btns{
    self.select_2_view = [UIScrollView new];
    self.select_2_view.frame = CGRectMake(0, 0, WIDTH, 49);
    self.select_2_view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.select_2_view];
    select_2_btn_array = [NSMutableArray new];
    for (int i = 0; i < _typeArray.count; i ++) {
        UIButton * btn = [UIButton new];
        btn.frame = CGRectMake(20 + 80 * i, 10, 70, 30);
        self.select_2_view.contentSize = CGSizeMake(btn.frame.origin.x + btn.frame.size.width + 20, 0);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:_typeArray[i][@"CategoryTitle"] forState:UIControlStateNormal];
        [btn setTitleColor:[MYTOOL RGBWithRed:102 green:102 blue:102 alpha:1] forState:UIControlStateNormal];
        [btn setTitleColor:[MYTOOL RGBWithRed:40 green:199 blue:0 alpha:1] forState:UIControlStateDisabled];
        btn.layer.borderWidth = 0;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0, 1, 0, 1 });
        [btn.layer setBorderColor:colorref];
        btn.tag = [_typeArray[i][@"CategoryID"] intValue];
        [select_2_btn_array addObject:btn];
        [self.select_2_view addSubview:btn];
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 15;
        [btn addTarget:self action:@selector(select_2_callback:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            btn.enabled = false;
            btn.layer.borderWidth = 1;
        }
    }
    //三个按钮
    {
        //背景view
        {
            self.select_3_view = [UIView new];
            self.select_3_view.frame = CGRectMake(0, 50, WIDTH, 40);
            self.select_3_view.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:self.select_3_view];
        }
        select_3_btn_array = [NSMutableArray new];
        //置顶
        {
            UIButton * btn = [UIButton new];
            self.up_btn = btn;
            btn.tag = 100;
            [btn setTitle:@"置顶" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:11];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            [btn setTitleColor:[MYTOOL RGBWithRed:64 green:64 blue:64 alpha:1] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"zuixin"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"zhiding"] forState:UIControlStateDisabled];
            btn.frame = CGRectMake(10, 10, 50, 20);
            [self.select_3_view addSubview:btn];
            [btn addTarget:self action:@selector(select_3_btns_callback:) forControlEvents:UIControlEventTouchUpInside];
            [select_3_btn_array addObject:btn];
        }
        //最新
        {
            UIButton * btn = [UIButton new];
            btn.tag = 200;
            [btn setTitle:@"最新" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:11];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            [btn setTitleColor:[MYTOOL RGBWithRed:64 green:64 blue:64 alpha:1] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"zuixin"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"zhiding"] forState:UIControlStateDisabled];
            btn.frame = CGRectMake(70, 10, 50, 20);
            btn.enabled = false;
            current_3_btn = btn;
            [self.select_3_view addSubview:btn];
            [btn addTarget:self action:@selector(select_3_btns_callback:) forControlEvents:UIControlEventTouchUpInside];
            [select_3_btn_array addObject:btn];
        }
        //悬赏
        {
            UIButton * btn = [UIButton new];
            btn.tag = 300;
            [btn setTitle:@"悬赏" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:11];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            [btn setTitleColor:[MYTOOL RGBWithRed:64 green:64 blue:64 alpha:1] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"zuixin"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"zhiding"] forState:UIControlStateDisabled];
            btn.frame = CGRectMake(130, 10, 50, 20);
            [self.select_3_view addSubview:btn];
            [btn addTarget:self action:@selector(select_3_btns_callback:) forControlEvents:UIControlEventTouchUpInside];
            [select_3_btn_array addObject:btn];
        }
    }
}
//二级按钮事件
-(void)select_2_callback:(UIButton *)btn{
    btn.enabled = false;
    current_2_btn = btn;
    UIButton * btn_3 = select_3_btn_array[1];
    [self select_3_btns_callback:btn_3];
    btn.layer.borderWidth = 1;
    //其他按钮重置可用
    for (UIButton * button in select_2_btn_array) {
        if ([btn isEqual:button]) {
            continue;
        }
        button.enabled = true;
        button.layer.borderWidth = 0;
    }
}
//置顶、最新、悬赏  按钮事件
-(void)select_3_btns_callback:(UIButton *)btn{
    current_3_btn = btn;
    for (UIButton * button in select_3_btn_array) {
        if ([button isEqual:btn]) {
            button.enabled = false;
        }else{
            button.enabled = true;
        }
    }
    //重新获取数据
    [self getCellDataWithHeader:true];
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
    int categoryId = (int)current_2_btn.tag;
    NSString * interface = @"/publish/publish/getfindpublishcomplexlist.html";
    NSMutableDictionary * send = [NSMutableDictionary new];
    //如果是全部就不传发布类别ID-categoryid
    if (categoryId) {
        [send setValue:@(categoryId) forKey:@"categoryid"];
    }else{
        [send setValue:self.parentid forKey:@"parentid"];
    }
    //是否下拉
    if (!flag) {
        if (self.cellDataArray && self.cellDataArray.count > 0) {
            NSObject * lastnumber = self.cellDataArray[self.cellDataArray.count - 1][@"PublishID"];
            [send setValue:lastnumber forKey:@"lastnumber"];
        }
    }
    //置顶-最新-悬赏
    {
        NSInteger index = [select_3_btn_array indexOfObject:current_3_btn];
        switch (index) {
            case 0://置顶
                [send setValue:@"0" forKey:@"pushtype"];//int	推广类型（0所有，1推广，2不推广）
                [send setValue:@"1" forKey:@"toptype"];//int	置顶类型（0所有，1置顶，2不置顶）
                [send setValue:@"0" forKey:@"moneytype"];//赏金类型（0所有，1有赏金，2无赏金）
                break;
            case 1://最新
                [send setValue:@"0" forKey:@"pushtype"];//int	推广类型（0所有，1推广，2不推广）
                [send setValue:@"0" forKey:@"toptype"];//int	置顶类型（0所有，1置顶，2不置顶）
                [send setValue:@"0" forKey:@"moneytype"];//赏金类型（0所有，1有赏金，2无赏金）
                break;
            default://悬赏
                [send setValue:@"0" forKey:@"pushtype"];//int	推广类型（0所有，1推广，2不推广）
                [send setValue:@"0" forKey:@"toptype"];//int	置顶类型（0所有，1置顶，2不置顶）
                [send setValue:@"1" forKey:@"moneytype"];//赏金类型（0所有，1有赏金，2无赏金）
                break;
        }
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
            NSLog(@"第一条数据:%@",self.cellDataArray[0]);
            self.noDataView.hidden = true;
        }else{
            self.noDataView.hidden = false;
        }
        [self.tableView reloadData];
    }];
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cellDataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FirstPageMiddleNextCell * cell = [[FirstPageMiddleNextCell alloc] initWithDictionary:self.cellDataArray[indexPath.section] isFirstPage:false];
    return cell;
}
//返回上个界面
-(void)popUpViewController{
    [self.navigationController popViewControllerAnimated:true];
}
-(void)viewWillAppear:(BOOL)animated{
    [MYTOOL hiddenTabBar];
}
-(void)viewWillDisappear:(BOOL)animated{
    [MYTOOL showTabBar];
}
@end
