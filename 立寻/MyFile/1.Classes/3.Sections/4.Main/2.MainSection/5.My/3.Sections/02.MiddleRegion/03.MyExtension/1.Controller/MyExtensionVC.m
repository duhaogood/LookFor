//
//  MyExtensionVC.m
//  立寻
//
//  Created by mac on 2017/5/31.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "MyExtensionVC.h"
#import "ExtensionCell.h"
@interface MyExtensionVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * cellDateArray;//cell数据
@property(nonatomic,strong)UIView * noDataView;//没有数据显示
@end

@implementation MyExtensionVC

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
    //tableView
    {
        UITableView * tableView = [UITableView new];
        tableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT - 64);
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
    NSString * interface = @"publish/publish/getuserpushpublishlist.html";
    NSMutableDictionary * send = [NSMutableDictionary new];
    [send setValue:USER_ID forKey:@"userid"];
    [MYNETWORKING getWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        NSLog(@"back:%@",back_dic);
        self.cellDateArray = back_dic[@"Data"];
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
    NSString * interface = @"publish/publish/getuserpushpublishlist.html";
    NSMutableDictionary * send = [NSMutableDictionary new];
    [send setValue:USER_ID forKey:@"userid"];
    if (self.cellDateArray.count) {
        [send setValue:self.cellDateArray[self.cellDateArray.count - 1][@"PublishID"] forKey:@"lastnumber"];
    }
    [MYNETWORKING getWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        NSLog(@"back:%@",back_dic);
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
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cellDateArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.cellDateArray[indexPath.section];
    ExtensionCell * cell = [[ExtensionCell alloc] initWithDictionary:dic andHeight:tableView.rowHeight andDelegate:self andIndexPath:indexPath];
    return cell;
}
//cell中按钮回调
-(void)cellBtnCallback:(UIButton *)btn{
    NSLog(@"%@",self.cellDateArray[btn.tag]);
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
