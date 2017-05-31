//
//  FindVC.m
//  立寻
//
//  Created by mac_hao on 2017/5/23.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "FindVC.h"
#import "LookForCell.h"
@interface FindVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray * select_1_array;//一级分类数据
@property(nonatomic,strong)NSDictionary * select_2_dict;//二级分类数据
@property(nonatomic,strong)UIView * select_1_view;//一级分类按钮提示view
@property(nonatomic,strong)UIScrollView * select_2_view;//二级分类滚动view
@property(nonatomic,strong)UIButton * up_btn;//置顶按钮
@property(nonatomic,strong)UIButton * newest_btn;//最新按钮
@property(nonatomic,strong)UIButton * money_btn;//悬赏按钮

@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSArray * cell_show_array;//cell数据源
@end

@implementation FindVC
{
    NSMutableArray * select_1_btn_array;//一级分类按钮数组
    NSMutableArray * select_2_btn_array;//二级分类按钮数组
    NSMutableArray * select_3_btn_array;//三级分类按钮数组
    UIButton * current_1_btn;//一级分类当前选中按钮
    UIButton * current_2_btn;//二级分类当前选中按钮
    UIButton * current_3_btn;//三级分类当前选中按钮
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.select_1_array = @[
                            @"委托寻人", @"委托寻物",@"认领招领",@"网络求助",@"网络曝光"
                            ];
    self.select_2_dict = @{
                           @"委托寻人":@[@"全部",@"找债权人",@"找战友",@"找同学",@"找朋友"],
                           @"委托寻物":@[@"全部",@"找宠",@"找钱包",@"找衣服",@"找什么"],
                           @"认领招领":@[@"全部",@"领宠",@"领钱包",@"领衣服",@"领什么"],
                           @"网络求助":@[@"全部",@"举报",@"求助",@"再举报",@"再求助"],
                           @"网络曝光":@[@"全部",@"曝光",@"再曝光",@"有意思吗",@"没意思"]
                           };
    //加载主界面
    [self loadMainView];
}
//加载主界面
-(void)loadMainView{
    self.view.backgroundColor = MYCOLOR_240_240_240;
    //表视图
    UITableView * tableView = [UITableView new];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = MYCOLOR_240_240_240;
    tableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT - 64 - 49);
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = false;
    [self loadCellDate];
    //选择数据源view
    {
        float height = 140;
        UIView * view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(0, 0, WIDTH, height);
        tableView.tableHeaderView = view;
        //一级分类按钮及下侧提示view
        {
            //初始化一级分类数组
            select_1_btn_array = [NSMutableArray new];
            for (int i = 0; i < self.select_1_array.count; i ++) {
                UIButton * btn = [UIButton new];
                [btn setTitle:self.select_1_array[i] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(select_1_callback:) forControlEvents:UIControlEventTouchUpInside];
                btn.titleLabel.font = [UIFont systemFontOfSize:14];
                [btn setTitleColor:[MYTOOL RGBWithRed:51 green:51 blue:51 alpha:1] forState:UIControlStateNormal];
                btn.frame = CGRectMake(10 + (10 + 60) * i, 10, 60, 30);
                [view addSubview:btn];
                btn.tag = i;
                [select_1_btn_array addObject:btn];
                if ( i == 0) {
                    current_1_btn = btn;
                }
            }
            //按钮下方提示view
            {
                UIView * state_view = [UIView new];
                state_view.backgroundColor = [MYTOOL RGBWithRed:40 green:199 blue:0 alpha:1];
                [view addSubview:state_view];
                self.select_1_view = state_view;
                CGRect frame = [select_1_btn_array[0] frame];
                state_view.frame = CGRectMake(frame.origin.x + frame.size.width/2 - 9, 46, 18, 4);
            }
        }
        //分割线
        {
            UIView * space = [UIView new];
            space.frame = CGRectMake(0, 50, WIDTH, 1);
            space.backgroundColor = MYCOLOR_240_240_240;
            [view addSubview:space];
        }
        //二级分类按钮
        {
            //二级分类按钮数据数组
            NSArray * btn_data_array = self.select_2_dict[@"委托寻人"];
            select_2_btn_array = [NSMutableArray new];
            //初始化滚动view
            {
                self.select_2_view = [UIScrollView new];
                self.select_2_view.frame = CGRectMake(0, 50, WIDTH - 60, 50);
                [view addSubview:self.select_2_view];
            }
            float left = 20;
            for (int i = 0; i < btn_data_array.count; i ++) {
                UIButton * btn = [UIButton new];
                UILabel * label = [UILabel new];
                label.font = [UIFont systemFontOfSize:14];
                label.text = btn_data_array[i];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                float width = size.width + 20;
                if (width < 60) {
                    width = 60;
                }
                btn.frame = CGRectMake(left, 10, width, 30);
                left += width + 20;
                btn.titleLabel.font = [UIFont systemFontOfSize:14];
                [btn setTitle:btn_data_array[i] forState:UIControlStateNormal];
                [btn setTitleColor:[MYTOOL RGBWithRed:102 green:102 blue:102 alpha:1] forState:UIControlStateNormal];
                [btn setTitleColor:[MYTOOL RGBWithRed:40 green:199 blue:0 alpha:1] forState:UIControlStateDisabled];
                btn.layer.borderWidth = 0;
                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0, 1, 0, 1 });
                [btn.layer setBorderColor:colorref];
                [select_2_btn_array addObject:btn];
                [self.select_2_view addSubview:btn];
                btn.layer.masksToBounds = true;
                btn.layer.cornerRadius = 15;
                [btn addTarget:self action:@selector(select_2_callback:) forControlEvents:UIControlEventTouchUpInside];
                if (i == 0) {
                    btn.enabled = false;
                    btn.layer.borderWidth = 1;
                    current_2_btn = btn;
                }
            }
            self.select_2_view.contentSize = CGSizeMake(left, 0);
        }
        //筛选按钮 - 60x50
        {
            //背景-shaixuan_bj
            {
                UIImageView * bgView = [UIImageView new];
                bgView.image = [UIImage imageNamed:@"shaixuan_bj"];
                bgView.frame = CGRectMake(WIDTH-70, 55, 70, 45);
                [view addSubview:bgView];
            }
            float left_123 = 0;
            //文字
            {
                UILabel * label = [UILabel new];
                label.text = @"筛选";
                label.font = [UIFont systemFontOfSize:13];
                label.textColor = MYCOLOR_40_199_0;
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(WIDTH-30-(size.width + 4+12)/2, 75 - size.height/2, size.width, size.height);
                left_123 = WIDTH-30-(size.width + 4+12)/2 + size.width + 4;
                [view addSubview:label];
            }
            //图标-filter_green
            {
                UIImageView * bgView = [UIImageView new];
                bgView.image = [UIImage imageNamed:@"filter_green"];
                bgView.frame = CGRectMake(left_123, 75-6, 12, 12);
                [view addSubview:bgView];
            }
            //按钮
            {
                UIButton * btn = [UIButton new];
                [btn addTarget:self action:@selector(selectCallback) forControlEvents:UIControlEventTouchUpInside];
                btn.frame = CGRectMake(WIDTH - 60, 50, 60, 50);
                [view addSubview:btn];
            }
        }
        //下分割线
        {
            UIView * space = [UIView new];
            space.frame = CGRectMake(0, 100, WIDTH, 1);
            space.backgroundColor = MYCOLOR_240_240_240;
            [view addSubview:space];
        }
        //三个按钮
        {
            select_3_btn_array = [NSMutableArray new];
            //置顶
            {
                UIButton * btn = [UIButton new];
                self.up_btn = btn;
                btn.tag = 100;
                [btn setTitle:@"置顶" forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:11];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
                [btn setTitleColor:[MYTOOL RGBWithRed:64 green:64 blue:64 alpha:1] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"zuixin"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"zhiding"] forState:UIControlStateDisabled];
                btn.frame = CGRectMake(10, 110, 50, 20);
                [view addSubview:btn];
                btn.enabled = false;
                current_3_btn = btn;
                [btn addTarget:self action:@selector(select_3_btns_callback:) forControlEvents:UIControlEventTouchUpInside];
                [select_3_btn_array addObject:btn];
            }
            //最新
            {
                UIButton * btn = [UIButton new];
                btn.tag = 200;
                [btn setTitle:@"最新" forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:11];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
                [btn setTitleColor:[MYTOOL RGBWithRed:64 green:64 blue:64 alpha:1] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"zuixin"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"zhiding"] forState:UIControlStateDisabled];
                btn.frame = CGRectMake(70, 110, 50, 20);
                [view addSubview:btn];
                [btn addTarget:self action:@selector(select_3_btns_callback:) forControlEvents:UIControlEventTouchUpInside];
                [select_3_btn_array addObject:btn];
            }
            //悬赏
            {
                UIButton * btn = [UIButton new];
                btn.tag = 300;
                [btn setTitle:@"悬赏" forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:11];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
                [btn setTitleColor:[MYTOOL RGBWithRed:64 green:64 blue:64 alpha:1] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"zuixin"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"zhiding"] forState:UIControlStateDisabled];
                btn.frame = CGRectMake(130, 110, 50, 20);
                [view addSubview:btn];
                [btn addTarget:self action:@selector(select_3_btns_callback:) forControlEvents:UIControlEventTouchUpInside];
                [select_3_btn_array addObject:btn];
            }
        }
        
    }
    
    
    
    
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
    LookForCell * cell = [[LookForCell alloc] initWithDictionary:self.cell_show_array[indexPath.row]];
    
    
    return cell;
}
#pragma mark - 按钮事件
//筛选事件
-(void)selectCallback{
    NSLog(@"别急哈");
}
//置顶、最新、悬赏  按钮事件
-(void)select_3_btns_callback:(UIButton *)btn{
    current_3_btn = btn;
    for (UIButton * button in select_3_btn_array) {
        if ([button isEqual:btn]) {
            button.enabled = false;
        }else{
            button.enabled = true;
        }
    }
}
//二级按钮事件
-(void)select_2_callback:(UIButton *)btn{
    NSLog(@"%@",btn.currentTitle);
    btn.enabled = false;
    current_2_btn = btn;
    btn.layer.borderWidth = 1;
    //其他按钮重置可用
    for (UIButton * button in select_2_btn_array) {
        if ([btn isEqual:button]) {
            continue;
        }
        button.enabled = true;
        button.layer.borderWidth = 0;
    }
}
//一级按钮事件
-(void)select_1_callback:(UIButton *)btn{
    current_1_btn = btn;
    CGRect frame = btn.frame;
    [UIView animateWithDuration:0.3 animations:^{
        self.select_1_view.frame = CGRectMake(frame.origin.x + frame.size.width/2 - 9, 46, 18, 4);
    }];
    //二级分类按钮数据数组
    NSArray * btn_data_array = self.select_2_dict[btn.currentTitle];
    select_2_btn_array = [NSMutableArray new];
    //清空滚动view
    {
        for (UIView * v in self.select_2_view.subviews) {
            [v removeFromSuperview];
        }
    }
    for (int i = 0; i < btn_data_array.count; i ++) {
        UIButton * btn = [UIButton new];
        btn.frame = CGRectMake(20 + 80 * i, 10, 60, 30);
        self.select_2_view.contentSize = CGSizeMake(btn.frame.origin.x + btn.frame.size.width + 20, 0);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:btn_data_array[i] forState:UIControlStateNormal];
        [btn setTitleColor:[MYTOOL RGBWithRed:102 green:102 blue:102 alpha:1] forState:UIControlStateNormal];
        [btn setTitleColor:[MYTOOL RGBWithRed:40 green:199 blue:0 alpha:1] forState:UIControlStateDisabled];
        btn.layer.borderWidth = 0;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0, 1, 0, 1 });
        [btn.layer setBorderColor:colorref];
        [select_2_btn_array addObject:btn];
        [self.select_2_view addSubview:btn];
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 15;
        [btn addTarget:self action:@selector(select_2_callback:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            btn.enabled = false;
            btn.layer.borderWidth = 1;
        }
    }
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
