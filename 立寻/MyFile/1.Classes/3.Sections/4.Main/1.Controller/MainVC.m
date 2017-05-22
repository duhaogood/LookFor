//
//  MainVC.m
//  立寻
//
//  Created by mac_hao on 2017/5/23.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "MainVC.h"

@interface MainVC ()

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor * bgColor = [MYTOOL RGBWithRed:0 green:201 blue:25 alpha:1];
    //改变tabbar选中及未选中的字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[DHTOOL RGBWithRed:46 green:42 blue:42 alpha:1]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[DHTOOL RGBWithRed:113 green:157 blue:52 alpha:1]} forState:UIControlStateSelected];
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
    }
    //发现
    {
        FindVC * find = [FindVC new];
        UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:find];
        //修改navigationbar背景色
        nc.navigationBar.translucent = NO;
        nc.title = @"发现";
        nc.navigationBar.barTintColor = bgColor;
        //修改title字体颜色及大小
        nc.navigationBar.titleTextAttributes = dictColor;
        [self addChildViewController:nc];
    }
    //发布
    {
        IssueVC * issue = [IssueVC new];
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
        UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:message];
        //修改navigationbar背景色
        nc.navigationBar.translucent = NO;
        nc.title = @"消息";
        nc.navigationBar.barTintColor = bgColor;
        //修改title字体颜色及大小
        nc.navigationBar.titleTextAttributes = dictColor;
        [self addChildViewController:nc];
    }
    //我的
    {
        MyVC * my = [MyVC new];
        UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:my];
        //修改navigationbar背景色
        nc.navigationBar.translucent = NO;
        nc.title = @"我的";
        nc.navigationBar.barTintColor = [MYTOOL RGBWithRed:0 green:204 blue:203 alpha:1];
        //修改title字体颜色及大小
        nc.navigationBar.titleTextAttributes = dictColor;
        [self addChildViewController:nc];
    }
    
    
    
}


@end
