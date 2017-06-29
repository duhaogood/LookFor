//
//  AccountBalanceVC.m
//  立寻
//
//  Created by mac on 2017/5/31.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "AccountBalanceVC.h"

@interface AccountBalanceVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSArray * cellDataArray;//cell数据数组

@end

@implementation AccountBalanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载主界面
    [self loadMainView];
}
//加载主界面
-(void)loadMainView{
    //返回按钮
    self.view.backgroundColor = [MYTOOL RGBWithRed:242 green:242 blue:242 alpha:1];
    //返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(popUpViewController)];
    NSLog(@"user:%@",MYTOOL.userInfo);
    //初始化界面数据
    //余额
    NSString * Balance = [NSString stringWithFormat:@"%.2f元",[MYTOOL.userInfo[@"Balance"] floatValue]];
    //悬赏金额
    NSString * BalanceNoCash = [NSString stringWithFormat:@"%.2f元",[MYTOOL.userInfo[@"BalanceNoCash"] floatValue]];
    //积分-Points
    NSString * Points = [NSString stringWithFormat:@"%d积分",[MYTOOL.userInfo[@"Points"] intValue]];
    self.cellDataArray = @[
                           @[@{@"left":@"账户余额",@"right":Balance}],
                           @[@{@"left":@"悬赏金额",@"right":BalanceNoCash}],
                           @[@{@"left":@"账户积分",@"right":Points}],
                           @[
                               @{@"left":@"提现",@"right":[NSString stringWithFormat:@"可提现%@",Balance]},
                               @{@"left":@"提现记录"},
                               @{@"left":@"收支明细"}
                               ]
                           ];
    UITableView * tableView = [UITableView new];
    tableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64);
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 48;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:tableView];
    self.automaticallyAdjustsScrollViewInsets = false;
}


#pragma mark - UITableViewDataSource,UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cellDataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.cellDataArray[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section < 3) {
        return 10;
    }
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [UITableViewCell new];
    NSDictionary * dict = self.cellDataArray[indexPath.section][indexPath.row];
    NSString * left = dict[@"left"];
    //左侧文字
    {
        UILabel * label = [UILabel new];
        label.font = [UIFont systemFontOfSize:13];
        label.text = left;
        label.textColor = MYCOLOR_48_48_48;
        CGSize size = [MYTOOL getSizeWithLabel:label];
        label.frame = CGRectMake(10, tableView.rowHeight/2 - size.height/2, size.width, size.height);
        [cell addSubview:label];
    }
    NSString * right = dict[@"right"];
    if (indexPath.section < 3) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        UIImageView * icon = [UIImageView new];
        icon.image = [UIImage imageNamed:@"arrow_right_md"];
        [cell addSubview:icon];
        icon.frame = CGRectMake(WIDTH - 11 - 6, tableView.rowHeight/2.0-6, 6, 12);
    }
    if (right) {
        UILabel * label = [UILabel new];
        label.font = [UIFont systemFontOfSize:12];
        label.text = right;
        label.textColor = MYCOLOR_144;
        CGSize size = [MYTOOL getSizeWithLabel:label];
        label.frame = CGRectMake(WIDTH - size.width - 25, tableView.rowHeight/2 - size.height/2, size.width, size.height);
        [cell addSubview:label];
    }
    //分割线
    if (indexPath.row ) {
        UIView * space = [UIView new];
        space.backgroundColor = MYCOLOR_240_240_240;
        space.frame = CGRectMake(10, 0, WIDTH - 20, 1);
        [cell addSubview:space];
    }
    
    return cell;
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
