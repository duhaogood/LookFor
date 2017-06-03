//
//  LookForVC.m
//  立寻
//
//  Created by mac_hao on 2017/5/23.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "LookForVC.h"
#import "FirstPageHeaderView.h"
#import "LookForCell.h"
@interface LookForVC ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
@property(nonatomic,strong)FirstPageHeaderView * headerView;
@property(nonatomic,strong)NSArray * btn_name_img_array;//中部按钮图片及名字
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * lookForArray;//找寻数据
@property(nonatomic,strong)NSArray * cell_show_array;//cell数据源
@end

@implementation LookForVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载主界面
    [self loadMainView];
}
//加载主界面
-(void)loadMainView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    //加载轮播图数据
    [self loadBannerArray];
    
    
}
#pragma mark - 头view点击事件
//tableview数据源选择
-(void)selectServiceType:(UIButton *)btn{
    //更新数据源，然后给头view更新界面
    [self.headerView selectServiceCallback:btn.tag];
}
//中部图标点击事件
-(void)iconClick:(UIButton *)tap{
    NSInteger tag = tap.tag;
    NSString * name = self.btn_name_img_array[tag][1];
    [SVProgressHUD showSuccessWithStatus:name duration:1];
}
//置顶、最新事件
-(void)up_newClick:(UIButton *)btn{
    [self.headerView selectBtnForUpOrNew:btn];
}
//签到事件
-(void)signClick:(UIButton *)btn{
    [SVProgressHUD showSuccessWithStatus:@"签到成功" duration:1];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MYTOOL getHeightWithIphone_six:200];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cell_show_array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LookForCell * cell = [[LookForCell alloc] initWithDictionary:self.cell_show_array[indexPath.row] isFirstPage:true];
    
    
    return cell;
}
#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"轮播图tag:%ld,点击了第%ld张图片",cycleScrollView.tag,index);
}
//加载轮播图数据
-(void)loadBannerArray{
    NSArray * up = @[
                     @{
                         @"url":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495815455804&di=ed51db649dbb42387c611a890c5769f2&imgtype=0&src=http%3A%2F%2Fimg.tuku.cn%2Ffile_thumb%2F201503%2Fm2015032016253154.jpg"
                         },
                     @{
                         @"url":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495815455804&di=837cd658ac3fc5fe60f4a5ca5119e258&imgtype=0&src=http%3A%2F%2Fpic17.nipic.com%2F20111122%2F6759425_152002413138_2.jpg"
                         },
                     @{
                         @"url":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495815567450&di=bbac4e0a2357629213fcec439bc6622a&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D1610953019%2C3012342313%26fm%3D214%26gp%3D0.jpg"
                         }
                     ];
    NSArray * down = @[
                     @{
                         @"url":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495815455803&di=60817710354f91b20cf6c0643d0454d2&imgtype=0&src=http%3A%2F%2Fpic41.nipic.com%2F20140519%2F18165794_221908372105_2.jpg"
                         },
                     @{
                         @"url":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495815455803&di=8576a6101f90ac5c4974d2b4e1c674cf&imgtype=0&src=http%3A%2F%2Ft1.niutuku.com%2F190%2F14%2F14-117639.jpg"
                         },
                     @{
                         @"url":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495815455802&di=0eb01ea5f1e45542c9314f6ea55c1c0b&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F10%2F32%2F14%2F72bOOOPIC7a.jpg"
                         }
                     ];
    //头view中间按钮图标及名字数组
    self.btn_name_img_array = @[
                                 @[@"menu_xr",@"委托寻人"],
                                 @[@"menu_xw",@"委托寻物"],
                                 @[@"menu_zlrl",@"招领认领"],
                                 @[@"menu_zsjm",@"招商加盟"],
                                 @[@"menu_wlbg",@"网络曝光"],
                                 @[@"menu_wlqz",@"网络求助"],
                                 @[@"menu_quanzi",@"立寻圈子"],
                                 @[@"menu_shop",@"积分商城"]
                                 ];
    //表视图
    UITableView * tableView = [UITableView new];
    //头视图
    FirstPageHeaderView * headerView = [[FirstPageHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [MYTOOL getHeightWithIphone_six:550]) andDelegate:self andUpBannerArray:up andDownBannerArray:down andBtnName_imgArray:self.btn_name_img_array];
    self.headerView = headerView;
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableHeaderView = headerView;
    tableView.backgroundColor = MYCOLOR_240_240_240;
    tableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT - 64 - 49);
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadCellDate];
}
//加载cell数据
-(void)loadCellDate{
    self.cell_show_array = @[
                             @{
                                 @"user_url":@"http://p9.qhimg.com/t01e6067def5d05fa70.jpg",
                                 @"user_name":@"灰太狼",
                                 @"user_state":@"1",
                                 @"title":@"我丢了一只狗狗",//标题
                                 @"type":@"找宠",//找人还是找宠。。。
                                 @"range":@"全国推广",//推广范围
                                 @"lost_place":@"江苏省 宿迁市 宿豫区",//丢失地
                                 @"money":@"50",//悬赏金
                                 @"content":@"我家10月7日在江山大道附近走失狗狗一只，白颜色毛希望有知道线索者提供信息，一定酬劳感谢!....",//内容
                                 @"url":@[  //图片链接
                                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495906001486&di=599eaacfc57580b1617da5f185ace5ad&imgtype=0&src=http%3A%2F%2Fwww.monsterparent.com%2Fwp-content%2Fuploads%2F2014%2F05%2Fdf0fead6-5353-a177-b9da-cef468fe43cd.jpg",
                                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495906001486&di=735a99c6d92aaaca1ae992197f23e3be&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20160811%2Fd4d58e59d45440bba4810ed2d726b203_th.jpg",
                                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495906001486&di=cdeaf0275907c1558fc6ef9494818703&imgtype=0&src=http%3A%2F%2Ftao.goulew.com%2Fusers%2Fupfile%2F201705%2F201705041133443big.jpg"
                                         ],
                                 @"time":@"55分钟前发布",//发布时间
                                 @"n1":@"123",
                                 @"n2":@"222",
                                 @"n3":@"441"
                                 },
                             @{
                                 @"user_url":@"http://k2.jsqq.net/uploads/allimg/1704/7_170426152706_11.jpg",
                                 @"user_name":@"喜羊羊",
                                 @"user_state":@"0",
                                 @"title":@"我捡到一个钱包",//标题
                                 @"type":@"招领",//找人还是找宠。。。
                                 @"range":@"全国推广",//推广范围
                                 @"lost_place":@"江苏省 宿迁市 宿豫区",//丢失地
                                 @"money":@"40",//悬赏金
                                 @"content":@"我在宝龙广场美食城捡到一个钱包，里面有几张银行卡和驾驶证，身份证，还有零钱若干...",//内容
                                 @"url":@[  //图片链接
                                         @"http://d6.yihaodianimg.com/N07/M0B/1F/72/CgQIz1QDx_uACkLCAAIGj0Cx4yE42500.jpg",
                                         @"http://pic31.nipic.com/20130706/10803163_142911714165_2.jpg",
                                         @"http://pic31.nipic.com/20130706/10803163_125034217165_2.jpg"
                                         ],
                                 @"time":@"44分钟前发布",//发布时间
                                 @"n1":@"123",
                                 @"n2":@"222",
                                 @"n3":@"441"
                                 },
                             @{
                                 @"user_url":@"http://dynamic-image.yesky.com/300x-/uploadImages/upload/20140912/upload/201409/nfnllt13f5ejpg.jpg",
                                 @"user_name":@"红太狼",
                                 @"user_state":@"1",
                                 @"title":@"我家狗狗不见了",//标题
                                 @"type":@"找宠",//找人还是找宠。。。
                                 @"range":@"全国推广",//推广范围
                                 @"lost_place":@"江苏省 宿迁市 宿豫区",//丢失地
                                 @"money":@"60",//悬赏金
                                 @"content":@"我家10月7日在江山大道附近走失狗狗一只，白颜色毛希望有知道线索者提供信息，一定酬劳感谢!我家10月7日在江山大道附近走失狗狗一只，白颜色毛希望有知道线索者提供信息，一定酬劳感谢!",//内容
                                 @"url":@[  //图片链接
                                         @"http://image.cnpp.cn/upload2/goodpic/20140418/img_280520_1_35.jpg_800_600.jpg",
                                         @"http://c.hiphotos.baidu.com/zhidao/pic/item/bd315c6034a85edfef11fff44e540923dc547543.jpg",
                                         @"http://imgsrc.baidu.com/imgad/pic/item/34fae6cd7b899e518001433648a7d933c8950d00.jpg"
                                         ],
                                 @"time":@"12分钟前发布",//发布时间
                                 @"n1":@"123",
                                 @"n2":@"222",
                                 @"n3":@"441"
                                 }
                             ];
    [self.tableView reloadData];
}
@end
