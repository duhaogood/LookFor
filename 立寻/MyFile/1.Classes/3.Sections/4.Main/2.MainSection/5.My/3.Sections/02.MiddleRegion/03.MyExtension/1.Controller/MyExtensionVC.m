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
@property(nonatomic,strong)NSArray * cellDateArray;//cell数据

@end

@implementation MyExtensionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellDateArray = @[
                           @{
                               @"extensionTime":@"2017-10-15 12:30",
                               @"url":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495815455804&di=ed51db649dbb42387c611a890c5769f2&imgtype=0&src=http%3A%2F%2Fimg.tuku.cn%2Ffile_thumb%2F201503%2Fm2015032016253154.jpg",
                               @"title":@"寻找我家狗狗",
                               @"content":@"我家10月7日在江山大道附近走失狗狗一只，白颜色毛希望 有知道线索者提供信息，一定酬劳感谢!...",
                               @"money":@"10元/天",
                               @"extensionList":@[
                                                @"http://cdn.duitang.com/uploads/item/201505/24/20150524103646_JUVwm.thumb.224_0.jpeg",
                                                @"http://img3.duitang.com/uploads/item/201510/11/20151011153646_e4XUM.png",
                                                @"http://img.jgzyw.com:8000/d/img/touxiang/2015/01/08/2015010800064318805.jpg",
                                                @"http://img4.duitang.com/uploads/item/201507/08/20150708134509_KdAUC.thumb.224_0.png",
                                                @"http://scimg.jb51.net/touxiang/201705/2017050421535596.jpg",
                                                @"http://k2.jsqq.net/uploads/allimg/1705/7_170523150407_6.jpg"
                                                ],
                               @"browse":@"43",
                               @"follow":@"24",
                               @"comment":@"12",
                               @"scope":@"南京",
                               @"extensionCount":@"12"
                               },
                           @{
                               @"extensionTime":@"2017-10-15 12:30",
                               @"url":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495815455804&di=ed51db649dbb42387c611a890c5769f2&imgtype=0&src=http%3A%2F%2Fimg.tuku.cn%2Ffile_thumb%2F201503%2Fm2015032016253154.jpg",
                               @"title":@"寻找我家狗狗",
                               @"content":@"我家10月7日在江山大道附近走失狗狗一只，白颜色毛希望 有知道线索者提供信息，一定酬劳感谢!...",
                               @"money":@"100元/天",
                               @"extensionList":@[
                                       @"http://cdn.duitang.com/uploads/item/201505/24/20150524103646_JUVwm.thumb.224_0.jpeg",
                                       @"http://img3.duitang.com/uploads/item/201510/11/20151011153646_e4XUM.png",
                                       @"http://img.jgzyw.com:8000/d/img/touxiang/2015/01/08/2015010800064318805.jpg",
                                       @"http://img4.duitang.com/uploads/item/201507/08/20150708134509_KdAUC.thumb.224_0.png",
                                       @"http://scimg.jb51.net/touxiang/201705/2017050421535596.jpg",
                                       @"http://k2.jsqq.net/uploads/allimg/1705/7_170523150407_6.jpg"
                                       ],
                               @"browse":@"43",
                               @"follow":@"24",
                               @"comment":@"12",
                               @"scope":@"全国",
                               @"extensionCount":@"8"
                               },
                           @{
                               @"extensionTime":@"2017-10-15 12:30",
                               @"url":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495815455804&di=ed51db649dbb42387c611a890c5769f2&imgtype=0&src=http%3A%2F%2Fimg.tuku.cn%2Ffile_thumb%2F201503%2Fm2015032016253154.jpg",
                               @"title":@"寻找我家狗狗",
                               @"content":@"我家10月7日在江山大道附近走失狗狗一只，白颜色毛希望 有知道线索者提供信息，一定酬劳感谢!...",
                               @"money":@"50元/天",
                               @"extensionList":@[
                                       @"http://cdn.duitang.com/uploads/item/201505/24/20150524103646_JUVwm.thumb.224_0.jpeg",
                                       @"http://img3.duitang.com/uploads/item/201510/11/20151011153646_e4XUM.png",
                                       @"http://img.jgzyw.com:8000/d/img/touxiang/2015/01/08/2015010800064318805.jpg"
                                       ],
                               @"browse":@"43",
                               @"follow":@"24",
                               @"comment":@"12",
                               @"scope":@"江苏",
                               @"extensionCount":@"3"
                               }
                           ];
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
        tableView.rowHeight = [MYTOOL getHeightWithIphone_six:195];
        tableView.backgroundColor = MYCOLOR_240_240_240;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
