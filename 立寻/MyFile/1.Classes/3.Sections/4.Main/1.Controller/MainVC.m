//
//  MainVC.m
//  立寻
//
//  Created by mac_hao on 2017/5/23.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "MainVC.h"
#import "IssueFirstPageVC.h"
#import "LoginVC.h"
@interface MainVC ()<UITabBarControllerDelegate>
@property(nonatomic,strong)MessageVC * messageVC;
@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([MYTOOL isLogin]) {
        [MYTOOL getUserInfo];
    }
    self.delegate = self;
    UIColor * bgColor = [MYTOOL RGBWithRed:0 green:201 blue:25 alpha:1];
    //改变tabbar选中及未选中的字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[DHTOOL RGBWithRed:48 green:48 blue:48 alpha:1]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[DHTOOL RGBWithRed:40 green:199 blue:0 alpha:1]} forState:UIControlStateSelected];
    //改变字体大小
    //字体 ,UIFontDescriptorTextStyleAttribute:[UIFont systemFontOfSize:12]
    UIColor * titleColor = [UIColor whiteColor];
    NSDictionary * dictColor = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:18],
                                 NSForegroundColorAttributeName:titleColor
                                 };
    //立寻
    {
        LookForVC * look = [LookForVC new];
        UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:look];
        //修改navigationbar背景色
        nc.navigationBar.translucent = NO;
        nc.title = @"立寻";
        nc.navigationBar.barTintColor = bgColor;
        //修改title字体颜色及大小
        nc.navigationBar.titleTextAttributes = dictColor;
        [self addChildViewController:nc];
        nc.tabBarItem.image = [UIImage imageNamed:@"home"];
        nc.tabBarItem.selectedImage = [UIImage imageNamed:@"home_active"];
    }
    //发现
    {
        FindVC * find = [FindVC new];
        find.title = @"发现";
        UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:find];
        //修改navigationbar背景色
        nc.navigationBar.translucent = NO;
        nc.title = @"发现";
        nc.navigationBar.barTintColor = bgColor;
        //修改title字体颜色及大小
        nc.navigationBar.titleTextAttributes = dictColor;
        [self addChildViewController:nc];
        nc.tabBarItem.image = [UIImage imageNamed:@"find"];
        nc.tabBarItem.selectedImage = [UIImage imageNamed:@"find_active"];
    }
    //发布
    {
        IssueVC * issue = [IssueVC new];
        issue.title = @"发布";
        UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:issue];
        //修改navigationbar背景色
        nc.navigationBar.translucent = NO;
        nc.title = @"发布";
        nc.navigationBar.barTintColor = bgColor;
        //修改title字体颜色及大小
        nc.navigationBar.titleTextAttributes = dictColor;
        [self addChildViewController:nc];
    }
    //消息
    {
        MessageVC * message = [MessageVC new];
        self.messageVC = message;
        message.title = @"消息";
        UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:message];
        //修改navigationbar背景色
        nc.navigationBar.translucent = NO;
        nc.title = @"消息";
        nc.navigationBar.barTintColor = bgColor;
        //修改title字体颜色及大小
        nc.navigationBar.titleTextAttributes = dictColor;
        [self addChildViewController:nc];
        
        nc.tabBarItem.image = [UIImage imageNamed:@"notice"];
        nc.tabBarItem.selectedImage = [UIImage imageNamed:@"notice_active"];
    }
    //我的
    {
        MyVC * my = [MyVC new];
        my.title = @"我的";
        UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:my];
        //修改navigationbar背景色
        nc.navigationBar.translucent = NO;
        nc.title = @"我的";
        nc.navigationBar.barTintColor = bgColor;
        //修改title字体颜色及大小
        nc.navigationBar.titleTextAttributes = dictColor;
        [self addChildViewController:nc];
        nc.tabBarItem.image = [UIImage imageNamed:@"mine"];
        nc.tabBarItem.selectedImage = [UIImage imageNamed:@"mine_active"];
    }
    
    
    //发布按钮-40*40
    UIButton * btn = [UIButton new];
    [btn setImage:[UIImage imageNamed:@"release"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(WIDTH/2 - 20, -8, 40, 40);
    [self.tabBar addSubview:btn];
    [btn addTarget:self action:@selector(issueBtnCallback) forControlEvents:UIControlEventTouchUpInside];
    [self getUnreadMessageCount];
    
//    self.selectedIndex = 4;//以后删除
}
//获取未读消息数量
-(void)getUnreadMessageCount{
    NSString * interface = @"/common/messages/getmsgcount.html";
    if (![MYTOOL isLogin]) {
        return;
    }
    NSDictionary * send = @{@"userid":USER_ID};
    [MYNETWORKING getNoPopWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        NSArray * array = back_dic[@"Data"];
        if (array.count > 2) {
            NSInteger count = [array[2] longValue];
            if (count > 0) {
                //设置消息数量
                self.messageVC.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",count];
            }else{
                //设置消息数量
                self.messageVC.navigationController.tabBarItem.badgeValue = nil;
            }
        }
    }];
}
//发布按钮
-(void)issueBtnCallback{
    IssueFirstPageVC * first = [IssueFirstPageVC new];
    UINavigationController * nc = self.selectedViewController;
    first.delegate = nc.topViewController;
    [first show];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
//发布不让选择
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    NSString * title = viewController.title;
    if ([title isEqualToString:@"发布"] || [title isEqualToString:@"我的"] || [title isEqualToString:@"消息"]) {
        if (![MYTOOL isLogin]) {
            UINavigationController * nc = self.selectedViewController;
            LoginVC * login = [LoginVC new];
            login.title = @"登录";
            [nc pushViewController:login animated:true];
            return false;
        }
    }
    if ([title isEqualToString:@"发布"]) {
        [self issueBtnCallback];
        return false;
    }
    return true;
}

@end
