//
//  FindVC.m
//  立寻
//
//  Created by mac_hao on 2017/5/23.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "FindVC.h"
#import "LookForCell.h"
#import "FirstPageMiddleNextCell.h"
#import "PublishInfoVC.h"
@interface FindVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray * select_1_array;//一级分类数据
@property(nonatomic,strong)NSDictionary * select_2_dict;//二级分类数据
@property(nonatomic,strong)UIView * select_1_view;//一级分类按钮提示view
@property(nonatomic,strong)UIView * select_3_view;//三级分类按钮view
@property(nonatomic,strong)UIScrollView * select_2_view;//二级分类滚动view
@property(nonatomic,strong)UIButton * up_btn;//置顶按钮
@property(nonatomic,strong)UIButton * newest_btn;//最新按钮
@property(nonatomic,strong)UIButton * money_btn;//悬赏按钮
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSArray * cell_show_array;//cell数据源

@property(nonatomic,strong)NSMutableArray * cellDataArray;//cell数据
@property(nonatomic,strong)UIView * noDataView;//没有数据显示
@property(nonatomic,strong)NSMutableArray * select_2_data_array;//二级分类数据数组
@end

@implementation FindVC
{
    NSMutableArray * select_1_btn_array;//一级分类按钮数组
    NSMutableArray * select_2_btn_array;//二级分类按钮数组
    NSMutableArray * select_3_btn_array;//三级分类按钮数组
    UIButton * current_1_btn;//一级分类当前选中按钮
    UIButton * current_2_btn;//二级分类当前选中按钮
    UIButton * current_3_btn;//三级分类当前选中按钮
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.select_1_array = @[
                            @[@"委托寻人",@"83"],
                            @[@"委托寻物",@"82"],
                            @[@"认领招领",@"394"],
                            @[@"网络求助",@"81"],
                            @[@"网络曝光",@"80"]
                            ];
    //加载主界面
    [self loadMainView];
}
//加载主界面
-(void)loadMainView{
    self.view.backgroundColor = MYCOLOR_240_240_240;
    //表视图
    UITableView * tableView = [UITableView new];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = MYCOLOR_240_240_240;
    [self.view addSubview:tableView];
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
    tableView.rowHeight = [MYTOOL getHeightWithIphone_six:200];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = false;
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
    //选择数据源view
    {
        float height = 100;
        UIView * view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(0, 0, WIDTH, height);
        tableView.frame = CGRectMake(0, height, WIDTH, HEIGHT - 64 - 49-100);
        [self.view addSubview:view];
        //一级分类按钮及下侧提示view
        {
            //初始化一级分类数组
            select_1_btn_array = [NSMutableArray new];
            UILabel * label = [UILabel new];
            label.font = [UIFont systemFontOfSize:13];
            label.text = @"委托找人";
            CGSize size = [MYTOOL getSizeWithLabel:label];
            float space_btn = (WIDTH - 5 * (size.width + 10))/6.0;
            for (int i = 0; i < self.select_1_array.count; i ++) {
                UIButton * btn = [UIButton new];
                [btn setTitle:self.select_1_array[i][0] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(select_1_callback:) forControlEvents:UIControlEventTouchUpInside];
                btn.titleLabel.font = [UIFont systemFontOfSize:13];
                [btn setTitleColor:[MYTOOL RGBWithRed:51 green:51 blue:51 alpha:1] forState:UIControlStateNormal];
                btn.frame = CGRectMake(space_btn + (space_btn + size.width+10) * i, 10, 60, 30);
                [view addSubview:btn];
                btn.tag = [self.select_1_array[i][1] intValue];
                [select_1_btn_array addObject:btn];
                if ( i == 0) {
                    current_1_btn = btn;
                }
            }
            //按钮下方提示view
            {
                UIView * state_view = [UIView new];
                state_view.backgroundColor = [MYTOOL RGBWithRed:40 green:199 blue:0 alpha:1];
                [view addSubview:state_view];
                self.select_1_view = state_view;
                CGRect frame = [select_1_btn_array[0] frame];
                state_view.frame = CGRectMake(frame.origin.x + frame.size.width/2 - 9, 46, 18, 4);
            }
        }
        //分割线
        {
            UIView * space = [UIView new];
            space.frame = CGRectMake(0, 50, WIDTH, 1);
            space.backgroundColor = MYCOLOR_240_240_240;
            [view addSubview:space];
        }
        //二级分类按钮
        {
            //初始化滚动view
            {
                self.select_2_view = [UIScrollView new];
                self.select_2_view.frame = CGRectMake(0, 50, WIDTH - 60, 50);
                [view addSubview:self.select_2_view];
            }
            //加载二级分类按钮
            [self select_1_callback:select_1_btn_array[0]];
        }
        //筛选按钮 - 60x50
        {
            //背景-shaixuan_bj
            {
                UIImageView * bgView = [UIImageView new];
                bgView.image = [UIImage imageNamed:@"shaixuan_bj"];
                bgView.frame = CGRectMake(WIDTH-70, 55, 70, 45);
                [view addSubview:bgView];
            }
            float left_123 = 0;
            //文字
            {
                UILabel * label = [UILabel new];
                label.text = @"筛选";
                label.font = [UIFont systemFontOfSize:13];
                label.textColor = MYCOLOR_40_199_0;
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(WIDTH-30-(size.width + 4+12)/2, 75 - size.height/2, size.width, size.height);
                left_123 = WIDTH-30-(size.width + 4+12)/2 + size.width + 4;
                [view addSubview:label];
            }
            //图标-filter_green
            {
                UIImageView * bgView = [UIImageView new];
                bgView.image = [UIImage imageNamed:@"filter_green"];
                bgView.frame = CGRectMake(left_123, 75-6, 12, 12);
                [view addSubview:bgView];
            }
            //按钮
            {
                UIButton * btn = [UIButton new];
                [btn addTarget:self action:@selector(selectCallback) forControlEvents:UIControlEventTouchUpInside];
                btn.frame = CGRectMake(WIDTH - 60, 50, 60, 50);
                [view addSubview:btn];
            }
        }
        //下分割线
        {
            UIView * space = [UIView new];
            space.frame = CGRectMake(0, 99, WIDTH, 1);
            space.backgroundColor = MYCOLOR_240_240_240;
            [view addSubview:space];
        }
        //三个按钮
        {
            select_3_btn_array = [NSMutableArray new];
            //背景view
            {
                self.select_3_view = [UIView new];
                self.select_3_view.frame = CGRectMake(0, 60, WIDTH, 40);
                self.select_3_view.hidden = true;
                self.select_3_view.backgroundColor = [UIColor whiteColor];
                [self.view insertSubview:self.select_3_view atIndex:0];
            }
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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cellDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FirstPageMiddleNextCell * cell = [[FirstPageMiddleNextCell alloc] initWithDictionary:self.cellDataArray[indexPath.section] isFirstPage:false];
    return cell;
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.select_3_view.hidden) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.select_3_view.frame = CGRectMake(0, 60, WIDTH, 40);
        self.tableView.frame = CGRectMake(0, 100, WIDTH, HEIGHT-64-49-100);
    } completion:^(BOOL finished) {
        self.select_3_view.hidden = true;
    }];
}
#pragma mark - 按钮事件
//筛选事件
-(void)selectCallback{
    if (self.select_3_view.hidden) {
        self.select_3_view.hidden = false;
        [UIView animateWithDuration:0.3 animations:^{
            self.select_3_view.frame = CGRectMake(0, 100, WIDTH, 40);
            self.tableView.frame = CGRectMake(0, 140, WIDTH, HEIGHT-64-49-140);
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.select_3_view.frame = CGRectMake(0, 60, WIDTH, 40);
            self.tableView.frame = CGRectMake(0, 100, WIDTH, HEIGHT-64-49-100);
        } completion:^(BOOL finished) {
            self.select_3_view.hidden = true;
        }];
    }
}
//一级按钮事件
-(void)select_1_callback:(UIButton *)btn{
    current_1_btn = btn;
    CGRect frame = btn.frame;
    //重置按钮状态
    for (UIButton * button_0 in select_1_btn_array) {
        button_0.enabled = true;
    }
    btn.enabled = false;
    [UIView animateWithDuration:0.3 animations:^{
        self.select_1_view.frame = CGRectMake(frame.origin.x + frame.size.width/2 - 9, 46, 18, 4);
    }];
    //获取二级分类数据数组
    NSString * parentid = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    NSString * interface = @"publish/publish/getcategorytwolist.html";
    NSDictionary * send = @{
                            @"appid":APPID_MINE,
                            @"parentid":parentid
                            };
    [MYTOOL netWorkingWithTitle:@"加载中…"];
    [MYNETWORKING getWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        NSArray * array = back_dic[@"Data"];
        //初始化第一个全部的按钮
        NSDictionary * allDic = @{
                                  @"CategoryID":@"0",
                                  @"CategoryTitle":@"全部"
                                  };
        self.select_2_data_array = [NSMutableArray arrayWithArray:array];
        [self.select_2_data_array insertObject:allDic atIndex:0];
        //二级分类按钮清空
        select_2_btn_array = [NSMutableArray new];
        //清空滚动view
        {
            for (UIView * v in self.select_2_view.subviews) {
                [v removeFromSuperview];
            }
        }
        float contentWidth = 10;//滚动范围
        for (int i = 0; i < self.select_2_data_array.count; i ++) {
            NSDictionary * btn_data_dic = self.select_2_data_array[i];
            //二级分类id
            int CategoryID = [btn_data_dic[@"CategoryID"] intValue];
            //二级分类名字
            NSString * CategoryTitle = btn_data_dic[@"CategoryTitle"];
            //计算宽度
            UILabel * label = [UILabel new];
            label.font = [UIFont systemFontOfSize:14];
            label.text = CategoryTitle;
            CGSize size = [MYTOOL getSizeWithLabel:label];
            //按钮宽度最小宽度60
            float btn_width = size.width + 10;
            if (btn_width < 60) {
                btn_width = 60;
            }
            
            UIButton * btn = [UIButton new];
            btn.frame = CGRectMake(contentWidth, 10, btn_width, 30);
            
            contentWidth += btn_width;
            self.select_2_view.contentSize = CGSizeMake(btn.frame.origin.x + btn.frame.size.width + 20, 0);
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitle:CategoryTitle forState:UIControlStateNormal];
            [btn setTitleColor:[MYTOOL RGBWithRed:102 green:102 blue:102 alpha:1] forState:UIControlStateNormal];
            [btn setTitleColor:[MYTOOL RGBWithRed:40 green:199 blue:0 alpha:1] forState:UIControlStateDisabled];
            btn.layer.borderWidth = 0;
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0, 1, 0, 1 });
            [btn.layer setBorderColor:colorref];
            [select_2_btn_array addObject:btn];
            [self.select_2_view addSubview:btn];
            btn.layer.masksToBounds = true;
            btn.tag = CategoryID;
            btn.layer.cornerRadius = 15;
            [btn addTarget:self action:@selector(select_2_callback:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                btn.enabled = false;
                btn.layer.borderWidth = 1;
            }
        }
        self.select_2_view.contentSize = CGSizeMake(contentWidth + 10, 0);
        [self select_2_callback:select_2_btn_array[0]];
    }];
}
//二级按钮事件
-(void)select_2_callback:(UIButton *)btn{
    btn.enabled = false;
    current_2_btn = btn;
    btn.layer.borderWidth = 1;
    //其他按钮重置可用
    for (UIButton * button in select_2_btn_array) {
        if ([btn isEqual:button]) {
            continue;
        }
        button.enabled = true;
        button.layer.borderWidth = 0;
    }
    //重置3级按钮
    [self select_3_btns_callback:select_3_btn_array[1]];
    
    
    
    
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
    //加载数据
    [self headerRefresh];
    
    
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
        [send setValue:@(current_1_btn.tag) forKey:@"parentid"];
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
            self.noDataView.hidden = true;
        }else{
            self.noDataView.hidden = false;
        }
        [self.tableView reloadData];
    }];
}



@end
