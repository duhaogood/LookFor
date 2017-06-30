//
//  MyLookingVC.m
//  立寻
//
//  Created by mac on 2017/5/31.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "MyLookingVC.h"
#import "MyLookingForCell.h"
#import "PublishInfoVC.h"
@interface MyLookingVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * cellDateArray;//cell数据
@property(nonatomic,strong)NSMutableArray * btn_array;//按钮数组
@property(nonatomic,strong)UIView * btn_down_view;//按钮下侧状态view
@property(nonatomic,strong)UIView * noDataView;//没有数据显示
@end

@implementation MyLookingVC
{
    int currentTypeIndex;//当前类别id
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //加载主界面
    [self loadMainView];
}
//加载主界面
-(void)loadMainView{
    //返回按钮
    self.view.backgroundColor = [MYTOOL RGBWithRed:242 green:242 blue:242 alpha:1];
    //返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(popUpViewController)];
    //上部按钮view
    {
        UIView * view = [UIView new];
        view.frame = CGRectMake(0, 0, WIDTH, 50);
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        NSArray * title_array = @[@"全部",@"委托找人",@"委托找物"];
        NSArray * calegary_array = @[@"0",@"83",@"82"];
        float width = WIDTH/3.0;
        self.btn_array = [NSMutableArray new];
        for (int i = 0; i < title_array.count; i ++) {
            NSString * title = title_array[i];
            //按钮
            UIButton * btn = [UIButton new];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:MYCOLOR_40_199_0 forState:UIControlStateDisabled];
            [btn setTitleColor:MYCOLOR_48_48_48 forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.frame = CGRectMake(width*i, 5, width, view.frame.size.height-10);
            [view addSubview:btn];
            btn.tag = [calegary_array[i] intValue];
            [btn addTarget:self action:@selector(selectDateCallback:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                btn.enabled = false;
                currentTypeIndex = [calegary_array[0] intValue];
            }
            [self.btn_array addObject:btn];
        }
        //绿色view
        {
            UIView * btn_down_view = [UIView new];
            btn_down_view.backgroundColor = MYCOLOR_40_199_0;
            btn_down_view.frame = CGRectMake(0, view.frame.size.height-3, width, 3);
            [view addSubview:btn_down_view];
            self.btn_down_view = btn_down_view;
            btn_down_view.layer.masksToBounds = true;
            btn_down_view.layer.cornerRadius = 1.5;
        }
    }
    //tableView
    {
        UITableView * tableView = [UITableView new];
        tableView.frame = CGRectMake(0, 50, WIDTH, HEIGHT - 64 - 50);
        self.automaticallyAdjustsScrollViewInsets = false;
        tableView.dataSource = self;
        tableView.delegate = self;
        [self.view addSubview:tableView];
        self.tableView = tableView;
        tableView.rowHeight = [MYTOOL getHeightWithIphone_six:146];
        tableView.backgroundColor = MYCOLOR_240_240_240;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    }
    [self headerRefresh];
}
//下拉刷新
-(void)headerRefresh{
    
    NSString * interface = @"publish/publish/getusersearchpublishlist.html";
    NSMutableDictionary * send = [NSMutableDictionary new];
    [send setValue:USER_ID forKey:@"userid"];
    if (currentTypeIndex) {
        [send setValue:@(currentTypeIndex) forKey:@"parentid"];
    }
    [MYNETWORKING getNoPopWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        NSArray * array = back_dic[@"Data"];
        self.cellDateArray = [NSMutableArray arrayWithArray:array];
        if (self.cellDateArray && self.cellDateArray.count > 0) {
            self.noDataView.hidden = true;
        }else{
            self.noDataView.hidden = false;
        }
        [self.tableView reloadData];
    }];
    
}
//上拉刷新
-(void)footerRefresh{
    NSString * interface = @"publish/publish/getusersearchpublishlist.html";
    NSMutableDictionary * send = [NSMutableDictionary new];
    [send setValue:USER_ID forKey:@"userid"];
    if (currentTypeIndex) {
        [send setValue:@(currentTypeIndex) forKey:@"parentid"];
    }
    if (self.cellDateArray.count) {
        NSDictionary * dict = self.cellDateArray[self.cellDateArray.count - 1];
        [send setValue:dict[@"PublishID"] forKey:@"lastnumber"];
    }
    [MYNETWORKING getNoPopWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        NSArray * array = back_dic[@"Data"];
        if (array && array.count) {
            [self.cellDateArray addObjectsFromArray:array];
        }
        if (self.cellDateArray && self.cellDateArray.count > 0) {
            self.noDataView.hidden = true;
        }else{
            self.noDataView.hidden = false;
        }
        [self.tableView reloadData];
    }];
    
}
#pragma mark - 按钮回调
//选择数据源按钮回调
-(void)selectDateCallback:(UIButton *)btn{
    for (UIButton * button in self.btn_array) {
        if ([btn isEqual:button]) {
            currentTypeIndex = (int)btn.tag;
            [self headerRefresh];
            btn.enabled = false;
            [UIView animateWithDuration:0.3 animations:^{
                self.btn_down_view.frame = CGRectMake(btn.frame.origin.x, self.btn_down_view.frame.origin.y, self.btn_down_view.frame.size.width, self.btn_down_view.frame.size.height);
            }];
        }else{
            button.enabled = true;
        }
    }
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSDictionary * publishDic = self.cellDateArray[indexPath.section];
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
            vc.isMine = true;
            vc.publishDictionary = publishDictionary;
            [self.navigationController pushViewController:vc animated:true];
        }else{
            [SVProgressHUD showErrorWithStatus:@"此信息有问题" duration:2];
        }
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cellDateArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.cellDateArray[indexPath.section];
    MyLookingForCell * cell = [[MyLookingForCell alloc] initWithDictionary:dic andHeight:tableView.rowHeight andDelegate:self andIndexPath:indexPath];
    return cell;
}
//返回上个界面
-(void)popUpViewController{
    [self.navigationController popViewControllerAnimated:true];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [MYTOOL hideKeyboard];
}
-(void)viewWillAppear:(BOOL)animated{
    [MYTOOL hiddenTabBar];
}
-(void)viewWillDisappear:(BOOL)animated{
    [MYTOOL showTabBar];
}
@end
