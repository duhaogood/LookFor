//
//  LookForVC.m
//  立寻
//
//  Created by mac_hao on 2017/5/23.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "LookForVC.h"
#import "FirstPageHeaderView.h"
@interface LookForVC ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
@property(nonatomic,strong)FirstPageHeaderView * headerView;
@property(nonatomic,strong)NSArray * btn_name_img_array;//中部按钮图片及名字
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * lookForArray;//找寻数据
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
//签到事件
-(void)signClick:(UIButton *)btn{
    [SVProgressHUD showSuccessWithStatus:@"签到成功" duration:1];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate

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
    tableView.tableHeaderView = headerView;
    tableView.backgroundColor = MYCOLOR_240_240_240;
    tableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT - 64 - 49);
    [self.view addSubview:tableView];
}

@end
