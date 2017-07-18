//
//  SettingVC.m
//  立寻
//
//  Created by mac on 2017/5/31.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "SettingVC.h"
#import "MainVC.h"
#import "MessageVC.h"
@interface SettingVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSArray * view_data_array;//界面数据数组
@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化界面数据数组
    self.view_data_array = @[
                             @[
                                 @[@"消息",@"NotificationMessageVC"],
                                 @[@"清除缓存",@"ClearCacheVC"]
                                 ],
                             @[
//                                 @[@"检查更新",@"CheckUpdateVC"],
                                 @[@"关于立寻",@"AboutVC"],
                                 @[@"反馈意见",@"FeedbackVC"]
                                 ]
                             ];
    //加载主界面
    [self loadMainView];
}
//加载主界面
-(void)loadMainView{
    //返回按钮
    self.view.backgroundColor = [MYTOOL RGBWithRed:240 green:240 blue:240 alpha:1];
    //返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(popUpViewController)];
    //tableView
    {
        UITableView * tableView = [UITableView new];
        tableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64-100);
        //不显示分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        self.tableView = tableView;
        [self.view addSubview:tableView];
        tableView.backgroundColor = MYCOLOR_240_240_240;
        tableView.rowHeight = [MYTOOL getHeightWithIphone_six:48];
    }
    //按钮-btn_red
    {
        UIButton * btn = [UIButton new];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_red"] forState:UIControlStateNormal];
        [btn setTitle:@"退出当前帐号" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake(10, HEIGHT-64-100, WIDTH-20, [MYTOOL getHeightWithIphone_six:40]);
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(exitCurrentUser) forControlEvents:UIControlEventTouchUpInside];
    }
}

//退出当前帐号
-(void)exitCurrentUser{
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"退出登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * aa_sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MYTOOL setProjectPropertyWithKey:@"isLogin" andValue:@"0"];
        [SVProgressHUD showSuccessWithStatus:@"退出成功" duration:1];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        MainVC * main = (MainVC *)delegate.window.rootViewController;
        [main setSelectedIndex:0];
    }];
    UIAlertAction * aa_cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [ac addAction:aa_sure];
    [ac addAction:aa_cancel];
    [self presentViewController:ac animated:true completion:nil];
}

#pragma mrak  - UITableViewDataSource,UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    //界面数据
    NSArray * view_array = self.view_data_array[indexPath.section][indexPath.row];
    NSString * text = view_array[0];//要显示的文字
    NSString * className = view_array[1];//跳转的类名
    if([text isEqualToString:@"清除缓存"]){
        CGFloat size =
        [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject]
        + [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject]
        + [self folderSizeAtPath:NSTemporaryDirectory()];
        NSString *message = size > 1 ? [NSString stringWithFormat:@"缓存%.2fM, 删除缓存", size] : [NSString stringWithFormat:@"缓存%.2fK, 删除缓存", size * 1024.0];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            [self cleanCaches:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject];
            [self cleanCaches:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject];
            [self cleanCaches:NSTemporaryDirectory()];
            [self.tableView reloadData];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        [alert addAction:action];
        [alert addAction:cancel];
        [self showDetailViewController:alert sender:nil];
    }else{//其他的跳转
        Class class = NSClassFromString(className);
        UIViewController * vc = [class new];
        vc.title = text;
        [self.navigationController pushViewController:vc animated:true];
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8.0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.view_data_array.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.view_data_array[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [UITableViewCell new];
    //界面数据
    NSArray * view_array = self.view_data_array[indexPath.section][indexPath.row];
    NSString * text = view_array[0];//要显示的文字
    NSString * className = view_array[1];//跳转的类名
    //文字
    {
        UILabel * label = [UILabel new];
        label.text = text;
        label.textColor = [MYTOOL RGBWithRed:48 green:48 blue:48 alpha:1];
        label.font = [UIFont systemFontOfSize:14/47.0*tableView.rowHeight];
        CGSize size = [MYTOOL getSizeWithLabel:label];
        label.frame = CGRectMake(15, (tableView.rowHeight-1)/2.0-size.height/2, size.width, size.height);
        [cell addSubview:label];
    }
    if ([text isEqualToString:@"清除缓存"]) {
        CGFloat size =
        [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject]
        + [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject]
        + [self folderSizeAtPath:NSTemporaryDirectory()];
        //显示缓存大小
        UILabel * cache_label = [UILabel new];
        cache_label.text = [NSString stringWithFormat:@"%.2fM",size];
        cache_label.textAlignment = NSTextAlignmentRight;
        cache_label.textColor = [MYTOOL RGBWithRed:181 green:181 blue:181 alpha:1];
        cache_label.font = [UIFont systemFontOfSize:12];
        CGSize labelSize = [MYTOOL getSizeWithLabel:cache_label];
        
        cache_label.frame = CGRectMake(WIDTH-35-labelSize.width, tableView.rowHeight/2-6, labelSize.width, 13);
        [cell addSubview:cache_label];
    }
    
    
    
    
    //右侧图标-arrow_right-7*12
    {
        UIImageView * icon = [UIImageView new];
        icon.image = [UIImage imageNamed:@"arrow_right"];
        icon.frame = CGRectMake(WIDTH-15, (tableView.rowHeight-1)/2-6, 7, 12);
        [cell addSubview:icon];
    }
    //分割线
    {
        if (indexPath.row < [self.view_data_array[indexPath.section] count] - 1) {
            UIView * space = [UIView new];
            space.backgroundColor = MYCOLOR_240_240_240;
            space.frame = CGRectMake(10, tableView.rowHeight-1, WIDTH-20, 1);
            [cell addSubview:space];
        }
    }
    return cell;
}
// 根据路径删除文件
- (void)cleanCaches:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        // 获取该路径下面的文件名
        NSArray *childrenFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childrenFiles) {
            // 拼接路径
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            // 将文件删除
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
}
// 计算目录大小
- (CGFloat)folderSizeAtPath:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        // 获取该目录下的文件，计算其大小
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        // 将大小转化为M
        return size / 1024.0 / 1024.0;
    }
    return 0;
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
