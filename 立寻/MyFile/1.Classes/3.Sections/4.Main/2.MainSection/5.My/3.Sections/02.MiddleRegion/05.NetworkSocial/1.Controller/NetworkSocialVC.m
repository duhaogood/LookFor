//
//  NetworkSocialVC.m
//  立寻
//
//  Created by mac on 2017/5/31.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "NetworkSocialVC.h"
#import "NetworkSocialCell.h"
#import "NetworkSocialInfoVC.h"
@interface NetworkSocialVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)UIView * noDataView;//没有数据显示
@property(nonatomic,strong)NSMutableArray * cellDataArray;//cell数组
@property(nonatomic,strong)UIView * downBtnView;//按钮下方标志view
@end

@implementation NetworkSocialVC
{
    NSArray * btn_title_array;//按钮标题数组
    NSMutableArray * btn_array;//按钮数组
    int current_categoryid;//当前选中的di
}
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
    btn_title_array = @[
                        @[@"全部",@"0"],
                        @[@"网络曝光",@"80"],
                        @[@"网络求助",@"81",],
                        @[@"立寻圈子",@"549"]
                        ];
    btn_array = [NSMutableArray new];
    //4个按钮
    for (int i = 0; i < btn_title_array.count; i ++) {
        UIButton * btn = [UIButton new];
        [btn setTitle:btn_title_array[i][0] forState:UIControlStateNormal];
        [btn setTitleColor:MYCOLOR_48_48_48 forState:UIControlStateNormal];
        [btn setTitleColor:MYCOLOR_40_199_0 forState:UIControlStateDisabled];
        btn.frame = CGRectMake(WIDTH/4 * i, 0, WIDTH/4, 45);
        [btn addTarget:self action:@selector(select_type_1_callback:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        if ( i == 0) {
            btn.enabled = false;
            current_categoryid = 0;
        }
        btn.tag = i;
        [btn_array addObject:btn];
    }
    //下部view
    {
        UIView * view = [UIView new];
        view.frame = CGRectMake(0, 47, WIDTH/4, 2);
        view.backgroundColor = MYCOLOR_40_199_0;
        [self.view addSubview:view];
        self.downBtnView = view;
    }
    //表视图
    {
        UITableView * tableView = [UITableView new];
        tableView.backgroundColor = self.view.backgroundColor;
        tableView.frame = CGRectMake(0, 50, WIDTH, HEIGHT-64-50);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = [MYTOOL getHeightWithIphone_six:122];
        self.tableView = tableView;
        self.automaticallyAdjustsScrollViewInsets = false;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    }
    [self getViewDataWithCategoryid:0];
}
//一级分类按钮事件
-(void)select_type_1_callback:(UIButton *)btn{
    for (UIButton * button in btn_array) {
        button.enabled = true;
    }
    btn.enabled = false;
    [UIView animateWithDuration:0.3 animations:^{
        self.downBtnView.frame = CGRectMake(btn.frame.origin.x, self.downBtnView.frame.origin.y, self.downBtnView.frame.size.width, self.downBtnView.frame.size.height);
    }];
    int categoryid = [btn_title_array[btn.tag][1] intValue];
    current_categoryid = categoryid;
    [self getViewDataWithCategoryid:categoryid];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    //发布id
    NSObject * PublishID = self.cellDataArray[indexPath.section][@"PublishID"];
    NSString * interface = @"/publish/publish/getpublishdetailcomplex.html";
    NSDictionary * send = @{
                            @"publishid":PublishID
                            };
    [MYTOOL netWorkingWithTitle:@"加载发布详情…"];
    [MYNETWORKING getWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        NSDictionary * publishDic = back_dic[@"Data"];
        NetworkSocialInfoVC * info = [NetworkSocialInfoVC new];
        info.title = @"发布详情";
        info.publishDictionary = publishDic;
        [self.navigationController pushViewController:info animated:true];
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cellDataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * infoDic = self.cellDataArray[indexPath.section];
    NetworkSocialCell * cell = [[NetworkSocialCell alloc] initWithDictionary:infoDic andHeight:tableView.rowHeight andDelegate:self andIndexPath:indexPath];
    return cell;
}
//获取界面信息
-(void)getViewDataWithCategoryid:(int)categoryid{
    NSString * interface = @"/publish/publish/getusersocialpublishlist.html";
    NSMutableDictionary * send = [NSMutableDictionary new];
    [send setValue:USER_ID forKey:@"userid"];
    if (categoryid) {
        [send setValue:@(categoryid) forKey:@"parentid"];
    }
    [MYNETWORKING getNoPopWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        NSArray * array = back_dic[@"Data"];
        NSLog(@"count:%ld",array.count);
        self.cellDataArray = array;
        if (self.cellDataArray.count) {
            self.noDataView.hidden = true;
        }else{
            self.noDataView.hidden = false;
        }
        [self.tableView reloadData];
    }];
    /*
     userid	YES	int	发布用户ID
     categoryid	NO	int	发布类别ID
     pagesize	NO	int	每页显示条数（默认10条）
     lastnumber	NO	int	最后一条记录的ID
     */
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
