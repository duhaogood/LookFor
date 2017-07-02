//
//  DraftsVC.m
//  立寻
//
//  Created by mac on 2017/5/31.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "DraftsVC.h"
#import "DraftsCell.h"
#import "LookForCircleVC.h"
#import "NetShowHelpVC.h"
#import "LookManSomeThingVC.h"
#import "PickUpSomeThingVC.h"
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
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary * publishDic = self.cellDateArray[indexPath.section];
        //要删除的发布id
        NSObject * PublishID = publishDic[@"PublishID"];
        NSString * interface = @"/publish/publish/deletepublishinfo.html";
        NSDictionary * send = @{
                                @"publishid":PublishID
                                };
        [MYTOOL netWorkingWithTitle:@"删除中…"];
        [MYNETWORKING getWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
            [self headerRefresh];
        }];
    }
}
//cell编辑回调
-(void)cellEditCallback:(UIButton *)btn{
    NSDictionary * publishDic = self.cellDateArray[btn.tag];
    //点击的分类id
    int CategoryID_1 = [publishDic[@"CategoryID"] intValue];
    //获取分类id数组
    NSString * interface = @"/publish/publish/getcategoryiteratelist.html";
    [MYTOOL netWorkingWithTitle:@"加载中"];
    [MYNETWORKING getWithInterfaceName:interface andDictionary:[NSDictionary new] andSuccess:^(NSDictionary *back_dic) {
        NSArray * array = back_dic[@"Data"];
        //便利array
        for (NSDictionary * typeDic in array) {
            //分类id
            int CategoryID_2 = [typeDic[@"CategoryID"] intValue];
            //查找此发布所对应的父分类id
            if (CategoryID_1 == CategoryID_2) {
                //父id
                int ParentID = [typeDic[@"ParentID"] intValue];
                NSString * CategoryName = typeDic[@"CategoryTitle"];
                NSArray * parentArray = @[
                                          @[@"fbbtn_baoguang",@"网络曝光",@"96",@"109",@"80",@"NetShowHelpVC"],
                                          @[@"fbbtn_qiuzhu",@"网络求助",@"88",@"96",@"81",@"NetShowHelpVC"],
                                          @[@"fbbtn_quanzi",@"立寻圈子",@"96",@"109",@"549",@"LookForCircleVC"],
                                          @[@"fbbtn_xunren",@"委托寻人",@"96",@"109",@"83",@"LookManSomeThingVC"],
                                          @[@"fbbtn_xw",@"委托寻物",@"88",@"96",@"82",@"LookManSomeThingVC"],
                                          @[@"fbbtn_zlrl",@"招领认领",@"96",@"109",@"394",@"PickUpSomeThingVC"]
                                          ];
                for (NSArray * pArray in parentArray) {
                    int parentId = [pArray[4] intValue];
                    if (parentId == ParentID) {
                        //一级分类的CategoryID------获取二级分类的依据
                        NSString * parentid = pArray[4];
                        NSString * interface2 = @"publish/publish/getcategorytwolist.html";
                        NSDictionary * send2 = @{
                                                @"appid":APPID_MINE,
                                                @"parentid":parentid
                                                };
                        [MYNETWORKING getNoPopWithInterfaceName:interface2 andDictionary:send2 andSuccess:^(NSDictionary *back_dic) {
                            //取得对应的控制器类名
                            NSString * className = pArray[5];
                            NSString * title = pArray[1];
                            Class class = NSClassFromString(className);
                            UIViewController * vc = [class new];
                            vc.title = title;
                            ((PickUpSomeThingVC *)vc).secondTypeList = back_dic[@"Data"];
                            ((PickUpSomeThingVC *)vc).publishDic = publishDic;
                            //跳转
                            [self.navigationController pushViewController:vc animated:true];
                        }];
                        
                        break;
                    }
                }
                
                
                break;
            }
            
            
        }
        
    }];
    
    
    
    
}
//下拉刷新
-(void)headerRefresh{
    NSString * interface = @"/publish/publish/getuserdraftpublishlist.html";
    NSDictionary * send = @{@"userid":USER_ID};
    [MYNETWORKING getNoPopWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
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
    NSString * interface = @"/publish/publish/getuserdraftpublishlist.html";
    NSDictionary * send = @{@"userid":USER_ID};
    //最后一条数据
    if (self.cellDateArray && self.cellDateArray.count > 0) {
        NSDictionary * lastPublistDic = self.cellDateArray[self.cellDateArray.count-1];
        NSObject * PublishID = lastPublistDic[@"PublishID"];
        send = @{
                 @"userid":USER_ID,
                 @"lastnumber":PublishID
                 };
    }
    [MYNETWORKING getNoPopWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        NSArray * array = back_dic[@"Data"];
        if (array && array.count > 0) {
            [self.cellDateArray addObjectsFromArray:array];
        }else{
            [SVProgressHUD showErrorWithStatus:@"到底了" duration:2];
            return;
        }
        if (array && array.count > 0) {
            self.noDataView.hidden = true;
        }else{
            self.noDataView.hidden = false;
        }
        [self.tableView reloadData];
    }];
    
    
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
