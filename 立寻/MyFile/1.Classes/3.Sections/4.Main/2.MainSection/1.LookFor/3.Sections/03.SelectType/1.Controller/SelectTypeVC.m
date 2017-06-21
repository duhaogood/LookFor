//
//  SelectTypeVC.m
//  立寻
//
//  Created by mac on 2017/6/15.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "SelectTypeVC.h"

@interface SelectTypeVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSArray * cellDataArray;//二级分类数组
@end

@implementation SelectTypeVC
{
    NSArray * type_1_array;//一级分类数组
    NSMutableArray * btn_array;//一级按钮数组
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(popUpViewController)];
    self.view.backgroundColor = MYCOLOR_240_240_240;
    //加载主界面
    [self loadMainView];
}
//加载主界面
-(void)loadMainView{
    //图片按钮数组
    type_1_array = @[
                      @[@"网络曝光",@"80"],
                      @[@"网络求助",@"81",],
                      @[@"立寻圈子",@"549"],
                      @[@"委托寻人",@"83"],
                      @[@"委托寻物",@"82"],
                      @[@"招领认领",@"394"]
                       ];
    //加载一级分类
    {
        float view_width = WIDTH*140/375.0;
        //背景view
        UIView * bgView = [UIView new];
        {
            bgView.frame = CGRectMake(0, 0, view_width, HEIGHT-64);
            bgView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:bgView];
        }
        //提示
        {
            UILabel * label = [UILabel new];
            label.text = @"全部分类";
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [MYTOOL RGBWithRed:112 green:112 blue:112 alpha:1];
            [bgView addSubview:label];
            label.frame = CGRectMake(0, 0, view_width, 50);
            label.textAlignment = NSTextAlignmentCenter;
        }
        //按钮
        {
            btn_array = [NSMutableArray new];
            for (int i  = 0; i < type_1_array.count; i ++) {
                //背景view
                UIView * view = [UIView new];
                view.backgroundColor = [UIColor whiteColor];
                view.frame = CGRectMake(0, 50 + 50 * i, view_width, 50);
                [bgView addSubview:view];
                //图标
                {
                    UIImageView * icon = [UIImageView new];
                    icon.image = [UIImage imageNamed:@"arrow_right_md"];
                    [view addSubview:icon];
                    icon.frame = CGRectMake(view_width - 20, 25-6, 6, 12);
                }
                //文字
                {
                    UILabel * label = [UILabel new];
                    label.text = type_1_array[i][0];
                    label.font = [UIFont systemFontOfSize:15];
                    label.textColor = [MYTOOL RGBWithRed:112 green:112 blue:112 alpha:1];
                    [view addSubview:label];
                    label.frame = CGRectMake(0, 0, view_width-20, 50);
                    label.textAlignment = NSTextAlignmentCenter;
                }
                //覆盖view的按钮
                UIButton * btn = [UIButton new];
                {
                    btn.frame = view.bounds;
                    [view addSubview:btn];
                    btn.tag = i;
                    [btn addTarget:self action:@selector(selectType_1_callback:) forControlEvents:UIControlEventTouchUpInside];
                    [btn_array addObject:btn];
                }
                if (i == 0) {
                    view.backgroundColor = self.view.backgroundColor;
                    btn.enabled = false;
                }
            }
            
        }
    }
    //右侧tableview
    {
        UITableView * tableView = [UITableView new];
        self.tableView = tableView;
        tableView.frame = CGRectMake(WIDTH*140/375.0, 0, WIDTH - WIDTH*140/375.0, HEIGHT-64);
        tableView.dataSource = self;
        tableView.delegate = self;
        [self.view addSubview:tableView];
        tableView.backgroundColor = self.view.backgroundColor;
        tableView.rowHeight = 50;
        self.automaticallyAdjustsScrollViewInsets = false;
        //不显示分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    [self getType_2_dataWithParentid:type_1_array[0][1]];
}
//选择一级分类事件
-(void)selectType_1_callback:(UIButton *)btn{
    for (UIButton * button in btn_array) {
        button.enabled = true;
        UIView * view = button.superview;
        view.backgroundColor = [UIColor whiteColor];
    }
    btn.enabled = false;
    UIView * view = btn.superview;
    view.backgroundColor = self.view.backgroundColor;
    
    //重新加载二级分类数组
    [self getType_2_dataWithParentid:type_1_array[btn.tag][1]];
}
//重新获取二级分类数组
-(void)getType_2_dataWithParentid:(NSString *)parentid{
    NSString * interface = @"/publish/publish/getcategorytwolist.html";
    NSDictionary * send = @{
                            @"parentid":parentid
                            };
    [MYTOOL netWorkingWithTitle:@"重新读取二级分类"];
    [MYNETWORKING getWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        self.cellDataArray = back_dic[@"Data"];
        [self.tableView reloadData];
    }];
    
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [UITableViewCell new];
    float cell_width = WIDTH - WIDTH*140/375.0;
    
    //按钮
    UIButton * btn = [UIButton new];
    btn.frame = CGRectMake(cell_width/6, 8, cell_width *2 / 3.0, tableView.rowHeight - 16);
    btn.backgroundColor = [UIColor whiteColor];
    NSString * title = self.cellDataArray[indexPath.row][@"CategoryTitle"];
//    NSLog(@"cell:%@",title);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[MYTOOL RGBWithRed:112 green:112 blue:112 alpha:1] forState:UIControlStateNormal];
    [cell addSubview:btn];
    btn.tag = indexPath.row;
    [btn addTarget:self action:@selector(selectType_2_callback:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.backgroundColor = self.view.backgroundColor;
    //无法选中
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//二级分类按钮选择
-(void)selectType_2_callback:(UIButton *)btn{
    NSObject * CategoryID = self.cellDataArray[btn.tag][@"CategoryID"];
    NSLog(@"CategoryID:%@",CategoryID);
#warning 用二级分类id查询发布信息
    
}
//返回上个界面
-(void)popUpViewController{
    [self.navigationController popViewControllerAnimated:true];
}
-(void)viewWillAppear:(BOOL)animated{
    [MYTOOL hiddenTabBar];
}
-(void)viewWillDisappear:(BOOL)animated{
    [MYTOOL showTabBar];
}
@end
