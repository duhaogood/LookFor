//
//  MessageVC.m
//  立寻
//
//  Created by mac_hao on 2017/5/23.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "MessageVC.h"

@interface MessageVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * cellDataArray;//cell数据
@property(nonatomic,strong)UIView * noDataView;//没有数据显示

@end

@implementation MessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载主界面
    [self loadMainView];
}
//加载主界面
-(void)loadMainView{
    self.view.backgroundColor = MYCOLOR_240_240_240;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search_btn"] style:UIBarButtonItemStyleDone target:self action:@selector(submitSearchBtn)];
    //tableView
    {
        UITableView * tableView = [UITableView new];
        tableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT - 64-50);
        self.automaticallyAdjustsScrollViewInsets = false;
        tableView.dataSource = self;
        tableView.delegate = self;
        [self.view addSubview:tableView];
        self.tableView = tableView;
        tableView.rowHeight = [MYTOOL getHeightWithIphone_six:75];
        tableView.backgroundColor = MYCOLOR_240_240_240;
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
    }
    
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
    NSString * interface = @"/common/messages/getstationmsglist.html";
    NSMutableDictionary * send = [NSMutableDictionary new];
    [send setValue:@"2" forKey:@"categoryid"];
    if (USER_ID) {
        [send setValue:USER_ID forKey:@"userid"];
    }else{
        return;
    }
    //是否下拉
    if (!flag) {
        if (self.cellDataArray && self.cellDataArray.count > 0) {
            NSObject * lastnumber = self.cellDataArray[self.cellDataArray.count - 1][@"ID"];
            [send setValue:lastnumber forKey:@"lastnumber"];
        }
    }
    [MYNETWORKING getNoPopWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
//        NSLog(@"back:%@",back_dic);
        NSArray * array = back_dic[@"Data"];
        if (flag) {
            self.cellDataArray = [NSMutableArray arrayWithArray:array];
        }else{
            if (array == nil || array.count == 0) {
                //                [SVProgressHUD showErrorWithStatus:@"到底啦" duration:2];
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
#pragma mark - UITableViewDataSource,UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSDictionary * dic = self.cellDataArray[indexPath.row];
    //如果消息未读，置为已读
    bool readType = [dic[@"IsRead"] boolValue];
    if (!readType) {
        NSString * msgId = [NSString stringWithFormat:@"%ld",[dic[@"ID"] longValue]];
        NSString * interface = @"/common/messages/setmsgread.html";
        NSDictionary * send = @{
                                @"userid":USER_ID,
                                @"idlist":msgId
                                };
        [MYNETWORKING getWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
            [self headerRefresh];
            [self getUnreadMessageCount];
        }];
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.cellDataArray[indexPath.row];
    UITableViewCell * cell = [UITableViewCell new];
    float left = 10;
    float top = tableView.rowHeight/6.0;
    //头像
    {
        UIImageView * icon = [UIImageView new];
        float img_width = tableView.rowHeight * 2 / 3.0;
        icon.frame = CGRectMake(left, top, img_width, img_width);
        icon.layer.masksToBounds = true;
        icon.layer.cornerRadius = img_width/2.0;
        NSString * url = dic[@"url"];
        [MYTOOL setImageIncludePrograssOfImageView:icon withUrlString:url];
//        [cell addSubview:icon];
//        left += img_width + 10;
    }
    left += 10;
    //是否已读
    {
        bool readType = [dic[@"IsRead"] boolValue];
        if (!readType) {
            UIView * view = [UIView new];
            view.backgroundColor = [UIColor redColor];
            view.frame = CGRectMake(5, tableView.rowHeight/2-2, 4, 4);
            view.layer.masksToBounds = true;
            view.layer.cornerRadius = 2;
            [cell addSubview:view];
        }
    }
    float time_middle_top = 0;
    //昵称
    {
        NSString * nickName = dic[@"MessageBody"];
        UILabel * label = [UILabel new];
        label.text = nickName;
        label.textColor = MYCOLOR_48_48_48;
        label.font = [UIFont systemFontOfSize:14];
        CGSize size = [MYTOOL getSizeWithLabel:label];
        label.frame = CGRectMake(left, top, size.width, size.height);
        [cell addSubview:label];
        time_middle_top = top + size.height / 2.0;
    }
    //时间
    {
        NSString * time = dic[@"MessageTime"];
        UILabel * label = [UILabel new];
        label.text = time;
        label.textColor = [MYTOOL RGBWithRed:112 green:112 blue:112 alpha:1];
        label.font = [UIFont systemFontOfSize:10];
        CGSize size = [MYTOOL getSizeWithLabel:label];
        label.frame = CGRectMake(WIDTH - 10 - size.width, time_middle_top-size.height/2, size.width, size.height);
        [cell addSubview:label];
    }
    //消息文字
    {
        NSString * message = dic[@"MessageSubject"];
        UILabel * label = [UILabel new];
        label.text = message;
        label.textColor = [MYTOOL RGBWithRed:112 green:112 blue:112 alpha:1];
        label.font = [UIFont systemFontOfSize:13];
        CGSize size = [MYTOOL getSizeWithLabel:label];
        label.frame = CGRectMake(left, tableView.rowHeight/2, WIDTH-10-left, size.height);
        if (size.width > WIDTH - 10 - left + label.font.pointSize) {
            label.frame = CGRectMake(left, tableView.rowHeight/2, WIDTH-10-left, size.height*2);
            label.numberOfLines = 0;
        }
        [cell addSubview:label];
    }
    
    
    //分割线
    {
        if (indexPath.row < self.cellDataArray.count - 1) {
            UIView * space = [UIView new];
            space.backgroundColor = MYCOLOR_240_240_240;
            space.frame = CGRectMake(0, tableView.rowHeight - 1, WIDTH, 1);
            [cell addSubview:space];
        }
    }
    return cell;
}
//获取未读消息数量
-(void)getUnreadMessageCount{
    NSString * interface = @"/common/messages/getmsgcount.html";
    NSDictionary * send = @{@"userid":USER_ID};
    [MYNETWORKING getNoPopWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        NSArray * array = back_dic[@"Data"];
        if (array.count > 2) {
            NSInteger count = [array[2] longValue];
            if (count > 0) {
                //设置消息数量
                self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",count];
            }else{
                //设置消息数量
                self.navigationController.tabBarItem.badgeValue = nil;
            }
        }
    }];
}
#pragma mark - 按钮事件
//搜索事件
-(void)submitSearchBtn{
    NSLog(@"搜索");
}

-(void)viewWillAppear:(BOOL)animated{
    [self getUnreadMessageCount];
}

@end
