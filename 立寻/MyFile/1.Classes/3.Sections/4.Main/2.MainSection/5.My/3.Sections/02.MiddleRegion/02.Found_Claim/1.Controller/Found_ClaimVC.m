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
@interface Found_ClaimVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSArray * cellDateArray;//cell数据
@property(nonatomic,strong)NSMutableArray * btn_array;//按钮数组
@property(nonatomic,strong)UIView * btn_down_view;//按钮下侧状态view

@end

@implementation Found_ClaimVC
{
    NSString * currentButtonTitle;//当前选择的按钮标题
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellDateArray = @[
                           @{
                               @"state":@"等待验证中…",
                               @"extensionTime":@"12分钟前发布",
                               @"url":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495815455804&di=ed51db649dbb42387c611a890c5769f2&imgtype=0&src=http%3A%2F%2Fimg.tuku.cn%2Ffile_thumb%2F201503%2Fm2015032016253154.jpg",
                               @"title":@"寻找我家狗狗",
                               @"content":@"我家10月7日在江山大道附近走失狗狗一只，白颜色毛希望 有知道线索者提供信息，一定酬劳感谢!...",
                               @"money":@"10",
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
                               @"state":@"等待验证中…",
                               @"extensionTime":@"55分钟前发布",
                               @"url":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495815455804&di=ed51db649dbb42387c611a890c5769f2&imgtype=0&src=http%3A%2F%2Fimg.tuku.cn%2Ffile_thumb%2F201503%2Fm2015032016253154.jpg",
                               @"title":@"寻找我家狗狗",
                               @"content":@"我家10月7日在江山大道附近走失狗狗一只，白颜色毛希望 有知道线索者提供信息，一定酬劳感谢!...",
                               @"money":@"100",
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
                               @"state":@"等待验证中…",
                               @"extensionTime":@"1小时前发布",
                               @"url":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495815455804&di=ed51db649dbb42387c611a890c5769f2&imgtype=0&src=http%3A%2F%2Fimg.tuku.cn%2Ffile_thumb%2F201503%2Fm2015032016253154.jpg",
                               @"title":@"寻找我家狗狗",
                               @"content":@"我家10月7日在江山大道附近走失狗狗一只，白颜色毛希望 有知道线索者提供信息，一定酬劳感谢!...",
                               @"money":@"50",
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
        tableView.rowHeight = [MYTOOL getHeightWithIphone_six:195];
        tableView.backgroundColor = MYCOLOR_240_240_240;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
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
    if ([btn.currentTitle isEqualToString:@"我发出的招领"]) {
        self.cellDateArray = @[
                               @{
                                   @"state":@"等待验证中…",
                                   @"extensionTime":@"12分钟前发布",
                                   @"url":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495815455804&di=ed51db649dbb42387c611a890c5769f2&imgtype=0&src=http%3A%2F%2Fimg.tuku.cn%2Ffile_thumb%2F201503%2Fm2015032016253154.jpg",
                                   @"title":@"寻找我家狗狗",
                                   @"content":@"我家10月7日在江山大道附近走失狗狗一只，白颜色毛希望 有知道线索者提供信息，一定酬劳感谢!...",
                                   @"money":@"10",
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
                                   @"state":@"等待验证中…",
                                   @"extensionTime":@"55分钟前发布",
                                   @"url":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495815455804&di=ed51db649dbb42387c611a890c5769f2&imgtype=0&src=http%3A%2F%2Fimg.tuku.cn%2Ffile_thumb%2F201503%2Fm2015032016253154.jpg",
                                   @"title":@"寻找我家狗狗",
                                   @"content":@"我家10月7日在江山大道附近走失狗狗一只，白颜色毛希望 有知道线索者提供信息，一定酬劳感谢!...",
                                   @"money":@"100",
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
                                   @"state":@"等待验证中…",
                                   @"extensionTime":@"1小时前发布",
                                   @"url":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495815455804&di=ed51db649dbb42387c611a890c5769f2&imgtype=0&src=http%3A%2F%2Fimg.tuku.cn%2Ffile_thumb%2F201503%2Fm2015032016253154.jpg",
                                   @"title":@"寻找我家狗狗",
                                   @"content":@"我家10月7日在江山大道附近走失狗狗一只，白颜色毛希望 有知道线索者提供信息，一定酬劳感谢!...",
                                   @"money":@"50",
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
        [self.tableView reloadData];
    }else{
        self.cellDateArray = @[
                               @{
                                   @"user_url":@"http://img4.duitang.com/uploads/item/201509/02/20150902211915_SkL2u.png",
                                   @"user_nick":@"臭猴子",
                                   @"state":@"等待验证中…",
                                   @"extensionTime":@"2015-10-23:00",
                                   @"url":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495815455804&di=ed51db649dbb42387c611a890c5769f2&imgtype=0&src=http%3A%2F%2Fimg.tuku.cn%2Ffile_thumb%2F201503%2Fm2015032016253154.jpg",
                                   @"title":@"寻找我家狗狗",
                                   @"content":@"我家10月7日在江山大道附近走失狗狗一只，白颜色毛希望 有知道线索者提供信息，一定酬劳感谢!...",
                                   @"money":@"10",
                                   @"extensionList":@[
                                           @"http://cdn.duitang.com/uploads/item/201505/24/20150524103646_JUVwm.thumb.224_0.jpeg",
                                           @"http://img3.duitang.com/uploads/item/201510/11/20151011153646_e4XUM.png",
                                           @"http://img.jgzyw.com:8000/d/img/touxiang/2015/01/08/2015010800064318805.jpg",
                                           @"http://img4.duitang.com/uploads/item/201507/08/20150708134509_KdAUC.thumb.224_0.png",
                                           @"http://scimg.jb51.net/touxiang/201705/2017050421535596.jpg",
                                           @"http://k2.jsqq.net/uploads/allimg/1705/7_170523150407_6.jpg"
                                           ],
                                   @"extensionCount":@"12"
                                   },
                               @{
                                   @"user_url":@"http://img4.duitang.com/uploads/item/201509/02/20150902211915_SkL2u.png",
                                   @"user_nick":@"臭猴子",
                                   @"state":@"等待验证中…",
                                   @"extensionTime":@"2011-10-23:00",
                                   @"url":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495815455804&di=ed51db649dbb42387c611a890c5769f2&imgtype=0&src=http%3A%2F%2Fimg.tuku.cn%2Ffile_thumb%2F201503%2Fm2015032016253154.jpg",
                                   @"title":@"寻找我家狗狗",
                                   @"content":@"我家10月7日在江山大道附近走失狗狗一只，白颜色毛希望 有知道线索者提供信息，一定酬劳感谢!...",
                                   @"money":@"100",
                                   @"extensionList":@[
                                           @"http://cdn.duitang.com/uploads/item/201505/24/20150524103646_JUVwm.thumb.224_0.jpeg",
                                           @"http://img3.duitang.com/uploads/item/201510/11/20151011153646_e4XUM.png",
                                           @"http://img.jgzyw.com:8000/d/img/touxiang/2015/01/08/2015010800064318805.jpg",
                                           @"http://img4.duitang.com/uploads/item/201507/08/20150708134509_KdAUC.thumb.224_0.png",
                                           @"http://scimg.jb51.net/touxiang/201705/2017050421535596.jpg",
                                           @"http://k2.jsqq.net/uploads/allimg/1705/7_170523150407_6.jpg"
                                           ],
                                   @"extensionCount":@"8"
                                   },
                               @{
                                   @"user_url":@"http://img4.duitang.com/uploads/item/201509/02/20150902211915_SkL2u.png",
                                   @"user_nick":@"臭猴子",
                                   @"state":@"等待验证中…",
                                   @"extensionTime":@"2017-10-23:00",
                                   @"url":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495815455804&di=ed51db649dbb42387c611a890c5769f2&imgtype=0&src=http%3A%2F%2Fimg.tuku.cn%2Ffile_thumb%2F201503%2Fm2015032016253154.jpg",
                                   @"title":@"寻找我家狗狗",
                                   @"content":@"我家10月7日在江山大道附近走失狗狗一只，白颜色毛希望 有知道线索者提供信息，一定酬劳感谢!...",
                                   @"money":@"50",
                                   @"extensionList":@[
                                           @"http://cdn.duitang.com/uploads/item/201505/24/20150524103646_JUVwm.thumb.224_0.jpeg",
                                           @"http://img3.duitang.com/uploads/item/201510/11/20151011153646_e4XUM.png",
                                           @"http://img.jgzyw.com:8000/d/img/touxiang/2015/01/08/2015010800064318805.jpg"
                                           ],
                                   @"extensionCount":@"3"
                                   }
                               ];
        [self.tableView reloadData];
    }
}
//cell中按钮回调
-(void)cellBtnCallback:(UIButton *)btn{
    NSLog(@"我的寻找:%@",self.cellDateArray[btn.tag]);
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
    if ([currentButtonTitle isEqualToString:@"我发出的招领"]) {
        FoundClaimCell * cell = [[FoundClaimCell alloc] initWithDictionary:dic andHeight:tableView.rowHeight andDelegate:self andIndexPath:indexPath];
        return cell;
    }else{
        MyClaimCell * cell = [[MyClaimCell alloc] initWithDictionary:dic andHeight:tableView.rowHeight andDelegate:self andIndexPath:indexPath];
        return cell;
    }
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
