//
//  MyVC.m
//  立寻
//
//  Created by mac_hao on 2017/5/23.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "MyVC.h"

@interface MyVC ()

@end

@implementation MyVC
{
    NSArray * middle_data_array;//中间功能区数据
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //加载主界面
    [self loadMainView];
}
//加载主界面
-(void)loadMainView{
    self.view.backgroundColor = [MYTOOL RGBWithRed:240 green:240 blue:240 alpha:1];
    float top_all = 0;
    //个人资料
    {
        float view_height = [MYTOOL getHeightWithIphone_six:98];
        UIView * view = [UIView new];
        view.frame = CGRectMake(0, 0, WIDTH, view_height);
        view.backgroundColor = [MYTOOL RGBWithRed:239 green:223 blue:3 alpha:1];
        [self.view addSubview:view];
        top_all += view_height;
    }
    //余额
    {
        float view_height = [MYTOOL getHeightWithIphone_six:76];
        UIView * view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(0, top_all, WIDTH, view_height);
        [self.view addSubview:view];
        top_all += view_height + [MYTOOL getHeightWithIphone_six:10];
    }
    //功能区-270
    {
        float view_height = HEIGHT - 64 - 49 - top_all - [MYTOOL getHeightWithIphone_six:80];
        UIView * view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(0, top_all, WIDTH, view_height);
        [self.view addSubview:view];
        top_all += view_height + [MYTOOL getHeightWithIphone_six:10];
        //8个按钮区域
        {
            //每一块区域的尺寸
            float width = (WIDTH - 2)/3.0;
            float height = (view_height - 2)/3.0;
            //4条分割线
            {
                UIColor * bgColor = [MYTOOL RGBWithRed:240 green:240 blue:240 alpha:1];
                //横
                {
                    UIView * space1 = [UIView new];
                    space1.backgroundColor = bgColor;
                    space1.frame = CGRectMake(0, height, WIDTH, 1);
                    [view addSubview:space1];
                    
                    UIView * space2 = [UIView new];
                    space2.backgroundColor = bgColor;
                    space2.frame = CGRectMake(0, height * 2 + 1, WIDTH, 1);
                    [view addSubview:space2];
                }
                //竖
                {
                    UIView * space1 = [UIView new];
                    space1.backgroundColor = bgColor;
                    space1.frame = CGRectMake(width, 0, 1, view_height);
                    [view addSubview:space1];
                    
                    UIView * space2 = [UIView new];
                    space2.backgroundColor = bgColor;
                    space2.frame = CGRectMake(width*2+1, 0, 1, view_height);
                    [view addSubview:space2];
                }
            }
            //图片、文字  数据
            middle_data_array = @[
                                  @[@"我的寻找",@""],
                                  @[@"招领认领",@""],
                                  @[@"我的推广",@""],
                                  @[@"草稿箱",@""],
                                  @[@"网络社交",@""],
                                  @[@"我的关注",@""],
                                  @[@"提供线索",@""],
                                  @[@"好友邀请",@""]
                                  ];
            //加载图片和文字
            {
                for (int i = 0; i < middle_data_array.count; i ++) {
                    int row = i / 3;//行
                    int col = i % 3;//列
                    //文字
                    {
                        UILabel * label = [UILabel new];
                        label.text = middle_data_array[i][0];
                        label.font = [UIFont systemFontOfSize:12];
                        label.textColor = [MYTOOL RGBWithRed:112 green:112 blue:112 alpha:1];
                        CGSize size = [MYTOOL getSizeWithLabel:label];
                        label.frame = CGRectMake(width/2-size.width/2 + (width+1)*col, height*2/3.0+(height+1)*row, size.width, size.height);
                        [view addSubview:label];
                    }
                    //图片
                    {
                        UIImageView * icon = [UIImageView new];
                        icon.backgroundColor = [UIColor greenColor];
                        icon.frame = CGRectMake(width/2-15 + (width+1)*col, 15+(height+1)*row, 30, 30);
                        [view addSubview:icon];
                    }
                    //按钮
                    {
                        UIButton * btn = [UIButton new];
                        btn.frame = CGRectMake((width+1)*col, (height+1)*row, width, height);
                        btn.backgroundColor = [UIColor clearColor];
                        [view addSubview:btn];
                        btn.tag = i;
                        [btn addTarget:self action:@selector(middleBtnCallback:) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
            }
        }
    }
    //设置
    {
        float view_height = HEIGHT - 64 - 49 - top_all;
        view_height = [MYTOOL getHeightWithIphone_six:80];
        UIView * view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(0, top_all, WIDTH, view_height);
        [self.view addSubview:view];
        top_all += view_height;
        //3个按钮
        {
            float top_up = view_height/2 - 30;
            float top_down = view_height/2 + 5;
            //个人认证
            {
                //图片-30*30
                {
                    UIImageView * icon = [UIImageView new];
                    icon.backgroundColor = [UIColor redColor];
                    icon.frame = CGRectMake(WIDTH/6.0-15, top_up, 30, 30);
                    [view addSubview:icon];
                }
                //文字
                {
                    UILabel * label = [UILabel new];
                    label.text = @"个人认证";
                    label.textColor = [MYTOOL RGBWithRed:112 green:112 blue:112 alpha:1];
                    label.font = [UIFont systemFontOfSize:12];
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(WIDTH/6.0 - size.width/2, top_down, size.width, size.height);
                    [view addSubview:label];
                }
                //按钮
                {
                    UIButton * btn = [UIButton new];
                    btn.frame = CGRectMake(0, 0, WIDTH/3, view_height);
                    [btn addTarget:self action:@selector(personalCertifyCallback) forControlEvents:UIControlEventTouchUpInside];
                    btn.backgroundColor = [UIColor clearColor];
                    [view addSubview:btn];
                }
            }
            //设置
            {
                //图片-30*30
                {
                    UIImageView * icon = [UIImageView new];
                    icon.backgroundColor = [UIColor redColor];
                    icon.frame = CGRectMake(WIDTH/2.0-15, top_up, 30, 30);
                    [view addSubview:icon];
                }
                //文字
                {
                    UILabel * label = [UILabel new];
                    label.text = @"设置";
                    label.textColor = [MYTOOL RGBWithRed:112 green:112 blue:112 alpha:1];
                    label.font = [UIFont systemFontOfSize:12];
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(WIDTH/2.0 - size.width/2, top_down, size.width, size.height);
                    [view addSubview:label];
                }
                //按钮
                {
                    UIButton * btn = [UIButton new];
                    btn.frame = CGRectMake(WIDTH/3.0, 0, WIDTH/3, view_height);
                    [btn addTarget:self action:@selector(settingCallback) forControlEvents:UIControlEventTouchUpInside];
                    btn.backgroundColor = [UIColor clearColor];
                    [view addSubview:btn];
                }
            }
            //投诉建议
            {
                //图片-30*30
                {
                    UIImageView * icon = [UIImageView new];
                    icon.backgroundColor = [UIColor redColor];
                    icon.frame = CGRectMake(WIDTH/6.0*5-15, top_up, 30, 30);
                    [view addSubview:icon];
                }
                //文字
                {
                    UILabel * label = [UILabel new];
                    label.text = @"投诉建议";
                    label.textColor = [MYTOOL RGBWithRed:112 green:112 blue:112 alpha:1];
                    label.font = [UIFont systemFontOfSize:12];
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(WIDTH/6.0*5 - size.width/2, top_down, size.width, size.height);
                    [view addSubview:label];
                }
                //按钮
                {
                    UIButton * btn = [UIButton new];
                    btn.frame = CGRectMake(WIDTH/3.0*2, 0, WIDTH/3, view_height);
                    [btn addTarget:self action:@selector(complainProposeCallback) forControlEvents:UIControlEventTouchUpInside];
                    btn.backgroundColor = [UIColor clearColor];
                    [view addSubview:btn];
                }
            }
        }
    }
}
#pragma mark - 按钮回调
//中间功能区按钮回调
-(void)middleBtnCallback:(UIButton *)btn{
    NSString * text = middle_data_array[btn.tag][0];
    [SVProgressHUD showSuccessWithStatus:text duration:1];
}
//个人认证
-(void)personalCertifyCallback{
    [SVProgressHUD showSuccessWithStatus:@"个人认证" duration:1];
}
//设置回调
-(void)settingCallback{
    [SVProgressHUD showSuccessWithStatus:@"设置回调" duration:1];
}
//投诉建议
-(void)complainProposeCallback{
    [SVProgressHUD showSuccessWithStatus:@"投诉建议" duration:1];
}
@end
