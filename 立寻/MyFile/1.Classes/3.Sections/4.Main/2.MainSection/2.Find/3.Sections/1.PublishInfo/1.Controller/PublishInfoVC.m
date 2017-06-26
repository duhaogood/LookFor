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
    PublishInfoView * view = [[PublishInfoView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) andPublishDictionary:self.publishDictionary andDelegate:self];
    [self.view addSubview:view];
    self.automaticallyAdjustsScrollViewInsets = false;
}





#pragma mark - 用户按钮事件
//评论列表事件
-(void)submitCommentListBtn:(UIButton *)btn{
    [SVProgressHUD showSuccessWithStatus:@"评论列表事件" duration:1];
}
//举报事件
-(void)submitReportBtn:(UIButton *)btn{
    [SVProgressHUD showSuccessWithStatus:@"举报事件" duration:1];
}
//个人详情事件
-(void)submitPersonalBtn:(UIButton *)btn{
    [SVProgressHUD showSuccessWithStatus:@"个人详情事件" duration:1];
}
//关注事件
-(void)submitAttentionBtn:(UIButton *)btn{
    [SVProgressHUD showSuccessWithStatus:@"关注事件" duration:1];
}
//评论事件
-(void)submitCommentBtn:(UIButton *)btn{
    [SVProgressHUD showSuccessWithStatus:@"评论事件" duration:1];
}
//留言事件
-(void)submitMessageBtn:(UIButton *)btn{
    [SVProgressHUD showSuccessWithStatus:@"留言事件" duration:1];
}
//我有线索事件
-(void)submitMyClueBtn:(UIButton *)btn{
    [SVProgressHUD showSuccessWithStatus:@"我有线索事件" duration:1];
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
