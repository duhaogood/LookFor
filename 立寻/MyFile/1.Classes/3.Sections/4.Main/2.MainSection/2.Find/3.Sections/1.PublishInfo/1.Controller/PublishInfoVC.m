//
//  PublishInfoVC.m
//  立寻
//
//  Created by mac on 2017/6/24.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "PublishInfoVC.h"
#import "PublishInfoView.h"
@interface PublishInfoVC ()

@end

@implementation PublishInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(popUpViewController)];
    self.view.backgroundColor = MYCOLOR_240_240_240;
    //加载主界面
    [self loadMainView];
    NSLog(@"info:%@",self.publishDictionary);
}
//加载主界面
-(void)loadMainView{
    //主scrollview
    UIScrollView * scrollView = [UIScrollView new];
    scrollView.backgroundColor = self.view.backgroundColor;
    scrollView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64-50);
    [self.view addSubview:scrollView];
    //用户信息view
    float top = 0;
    {
        UIView * view = [UIView new];
        float height = [MYTOOL getHeightWithIphone_six:75];
        view.frame = CGRectMake(0, 0, WIDTH, height);
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        
    }
    
    
    //底部按钮
    {
        
    }
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
