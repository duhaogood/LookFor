//
//  Found_ClaimVC.m
//  立寻
//
//  Created by mac on 2017/5/31.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "Found_ClaimVC.h"
#import "FoundClaimCell.h"
#import "MyClaimCell.h"
#import "PublishInfoVC.h"
#import "MyFoundListVC.h"
#import "MyClainInfoVC.h"
@interface Found_ClaimVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * cellDateArray;//cell数据
@property(nonatomic,strong)NSMutableArray * btn_array;//按钮数组
@property(nonatomic,strong)UIView * btn_down_view;//按钮下侧状态view
@property(nonatomic,strong)UIView * noDataView;//没有数据显示



@end

@implementation Found_ClaimVC
{
    NSString * currentButtonTitle;//当前选择的按钮标题
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
        NSArray * title_array = @[@"我发出的招领",@"我的认领"];
        float width = WIDTH/2.0;
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
            btn.tag = i;
            [btn addTarget:self action:@selector(selectDateCallback:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                btn.enabled = false;
                currentButtonTitle = @"我发出的招领";
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
        tableView.rowHeight = [MYTOOL getHeightWithIphone_six:146.0];
        tableView.backgroundColor = MYCOLOR_240_240_240;
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
        //
        //@property(nonatomic,strong)UIView * noDataView;//没有数据显示
        {
            UIView * view = [UIView new];
            self.noDataView = view;
            view.frame = tableView.frame;
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
    [self headerRefresh];
}
//下拉刷新
-(void)headerRefresh{
    NSString * interface = @"publish/publish/getuserrecruitpublishlist.html";//我的招领
    if ([currentButtonTitle isEqualToString:@"我的认领"]) {
        interface = @"publish/publish/getuserclaimlist.html";
    }
    NSMutableDictionary * send = [NSMutableDictionary new];
    [send setValue:USER_ID forKey:@"userid"];
    [MYNETWORKING getWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        self.cellDateArray = [NSMutableArray arrayWithArray:back_dic[@"Data"]];
        [self.tableView reloadData];
        if (self.cellDateArray.count) {
            self.noDataView.hidden = true;
        }else{
            self.noDataView.hidden = false;
        }
    }];
}
//上啦刷新
-(void)footerRefresh{
    NSString * interface = @"publish/publish/getuserrecruitpublishlist.html";//我的招领
    if ([currentButtonTitle isEqualToString:@"我的认领"]) {
        interface = @"publish/publish/getuserclaimlist.html";
    }
    NSMutableDictionary * send = [NSMutableDictionary new];
    [send setValue:USER_ID forKey:@"userid"];
    if (self.cellDateArray.count) {
        [send setValue:self.cellDateArray[self.cellDateArray.count - 1][@"PublishID"] forKey:@"lastnumber"];
    }
    [MYNETWORKING getWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        NSArray * array = back_dic[@"Data"];
        if (array.count > 0) {
            [self.cellDateArray addObjectsFromArray:array];
        }else{
            [SVProgressHUD showErrorWithStatus:@"到底了" duration:2];
            return;
        }
        [self.tableView reloadData];
        if (self.cellDateArray.count) {
            self.noDataView.hidden = true;
        }else{
            self.noDataView.hidden = false;
        }
    }];
}

#pragma mark - 按钮回调
//选择数据源按钮回调
-(void)selectDateCallback:(UIButton *)btn{
    for (UIButton * button in self.btn_array) {
        if ([btn isEqual:button]) {
            currentButtonTitle = btn.currentTitle;
            btn.enabled = false;
            [UIView animateWithDuration:0.3 animations:^{
                self.btn_down_view.frame = CGRectMake(btn.frame.origin.x, self.btn_down_view.frame.origin.y, self.btn_down_view.frame.size.width, self.btn_down_view.frame.size.height);
            }];
        }else{
            button.enabled = true;
        }
    }
    [self headerRefresh];
}



#pragma mark - UITableViewDataSource,UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSDictionary * dic = self.cellDateArray[indexPath.section];
    if ([currentButtonTitle isEqualToString:@"我发出的招领"]) {
        NSObject * PublishID = dic[@"PublishID"];
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
                vc.delegate = self;
                vc.publishDictionary = publishDictionary;
                [self.navigationController pushViewController:vc animated:true];
            }else{
                [SVProgressHUD showErrorWithStatus:@"此信息有问题" duration:2];
            }
        }];
    }else{//我的认领
        NSString * interface = @"/publish/publish/getclaimdetailcomplex.html";
        NSDictionary * send = @{
                                @"claimid":dic[@"ClaimID"]
                                };
        [MYTOOL netWorkingWithTitle:@"加载中……"];
        [MYNETWORKING getWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
            MyClainInfoVC * vc = [MyClainInfoVC new];
            vc.title = @"认领详情";
            vc.claimDictionary = back_dic[@"Data"];
            vc.isMine = true;
            [self.navigationController pushViewController:vc animated:true];
        }];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cellDateArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.cellDateArray[indexPath.section];
    if ([currentButtonTitle isEqualToString:@"我发出的招领"]) {
        FoundClaimCell * cell = [[FoundClaimCell alloc] initWithDictionary:dic andHeight:tableView.rowHeight andDelegate:self andIndexPath:indexPath];
        return cell;
    }else{
        MyClaimCell * cell = [[MyClaimCell alloc] initWithDictionary:dic andHeight:tableView.rowHeight andDelegate:self andIndexPath:indexPath];
        return cell;
    }
}

//重新刷新当前页面
-(void)refreshViewData{
    [self headerRefresh];
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
