//
//  MyFoundListVC.m
//  立寻
//
//  Created by Mac on 17/6/30.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "MyFoundListVC.h"
#import "MyClaimCell.h"
#import "MyClainInfoVC.h"
@interface MyFoundListVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * cellDateArray;//cell数据
@property(nonatomic,strong)UIView * noDataView;//没有数据显示

@end

@implementation MyFoundListVC

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
    {
        UITableView * tableView = [UITableView new];
        tableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT - 64);
        self.automaticallyAdjustsScrollViewInsets = false;
        tableView.dataSource = self;
        tableView.delegate = self;
        [self.view addSubview:tableView];
        self.tableView = tableView;
        tableView.rowHeight = [MYTOOL getHeightWithIphone_six:122];
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

//
//下拉刷新
-(void)headerRefresh{
    NSString * interface = @"/publish/publish/getpublishclaimlist.html";
    NSMutableDictionary * send = [NSMutableDictionary new];
    [send setValue:self.publishDictionary[@"PublishID"] forKey:@"publishid"];
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
    NSString * interface = @"/publish/publish/getpublishclaimlist.html";
    NSMutableDictionary * send = [NSMutableDictionary new];
    [send setValue:self.publishDictionary[@"PublishID"] forKey:@"publishid"];
    if (self.cellDateArray.count) {
        [send setValue:self.cellDateArray[self.cellDateArray.count - 1][@"ClaimID"] forKey:@"lastnumber"];
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
#pragma mark - UITableViewDataSource,UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSDictionary * dic = self.cellDateArray[indexPath.section];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cellDateArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.cellDateArray[indexPath.section];
    MyClaimCell * cell = [[MyClaimCell alloc]initWithDictionary:dic andHeight:tableView.rowHeight andDelegate:self andIndexPath:indexPath];
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
