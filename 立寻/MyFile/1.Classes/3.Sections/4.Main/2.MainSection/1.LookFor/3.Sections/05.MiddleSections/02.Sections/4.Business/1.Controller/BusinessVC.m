//
//  BusinessVC.m
//  立寻
//
//  Created by mac on 2017/6/21.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "BusinessVC.h"

@interface BusinessVC ()

@end

@implementation BusinessVC

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
