//
//  DraftsVC.m
//  立寻
//
//  Created by mac on 2017/5/31.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "DraftsVC.h"
#import "DraftsCell.h"
@interface DraftsVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * cellDateArray;//cell数据
@property(nonatomic,strong)UIView * noDataView;//没有数据显示
@end

@implementation DraftsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载主界面
    [self loadMainView];
}
//加载主界面
-(void)loadMainView{
    //返回按钮
    self.view.backgroundColor = MYCOLOR_240_240_240;
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
        tableView.rowHeight = [MYTOOL getHeightWithIphone_six:145];
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
    DraftsCell * cell = [[DraftsCell alloc] initWithDictionary:dic andHeight:tableView.rowHeight andDelegate:self andIndexPath:indexPath];
    return cell;
}
//cell编辑回调
-(void)cellEditCallback:(UIButton *)btn{
    NSLog(@"点击:%@",self.cellDateArray[btn.tag]);
}
//加载所有数据
-(void)loadCellData{
    
    
    
}
//下拉刷新
-(void)headerRefresh{
    NSString * interface = @"/publish/publish/getuserdraftpublishlist.html";
    NSDictionary * send = @{@"userid":USER_ID};
    [MYNETWORKING getNoPopWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
//        NSLog(@"back:%@",back_dic);
        NSArray * array = back_dic[@"Data"];
        self.cellDateArray = [NSMutableArray arrayWithArray:array];
        if (array && array.count > 0) {
            self.noDataView.hidden = true;
        }else{
            self.noDataView.hidden = false;
        }
        [self.tableView reloadData];
    }];
    
}
//上拉刷新
-(void)footerRefresh{
    
    
    
    
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
    [self headerRefresh];
}
-(void)viewWillDisappear:(BOOL)animated{
    [MYTOOL showTabBar];
}
@end
