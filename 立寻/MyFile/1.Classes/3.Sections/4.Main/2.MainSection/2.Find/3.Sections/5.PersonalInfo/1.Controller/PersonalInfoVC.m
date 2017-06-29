//
//  PersonalInfoVC.m
//  立寻
//
//  Created by Mac on 17/6/29.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "PersonalInfoVC.h"

@interface PersonalInfoVC ()

@end

@implementation PersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(popUpViewController)];
    self.view.backgroundColor = [UIColor whiteColor];
    //加载主界面
    [self loadMainView];
}
//加载主界面
-(void)loadMainView{
    float top_all = 0;
    //背景
    {
        float height = [MYTOOL getHeightWithIphone_six:200];
        UIImageView * bg = [UIImageView new];
        bg.frame = CGRectMake(0, top_all, WIDTH, height);
        bg.image = [UIImage imageNamed:@"hdbj"];
        [self.view addSubview:bg];
        top_all += height;
        float left = 10;
        float top = height - 50 - 10;
        //头像
        {
            UIImageView * icon = [UIImageView new];
            icon.frame = CGRectMake(left, top, 50, 50);
            icon.layer.masksToBounds = true;
            icon.layer.cornerRadius = 25;
            [bg addSubview:icon];
            //用户头像
            NSString * url = self.userInfo[@"ImgFilePath"];
            if (url) {
                [icon sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"morenhdpic"]];
            }
        }
        left += 60;
        top += 25;
        //用户名字
        {
            NSString * userName = self.userInfo[@"UserName"];
            UILabel * label = [UILabel new];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor whiteColor];
            label.text = userName;
            CGSize size = [MYTOOL getSizeWithLabel:label];
            label.frame = CGRectMake(left, top - size.height, size.width, size.height);
            [bg addSubview:label];
        }
        //是否认证
        {
            // 认证状态  1未认证 2等待认证  3认证没通过 4认证通过
            int ApproveState = [self.userInfo[@"ApproveState"] intValue];
            NSString * text = @"";
            switch (ApproveState) {
                case 1:
                    text = @"未认证";
                    break;
                case 2:
                    text = @"等待认证";
                    break;
                case 3:
                    text = @"认证没通过";
                    break;
                default:
                    text = @"认证通过";
                    break;
            }
            UILabel * label = [UILabel new];
            label.text = text;
            label.font = [UIFont systemFontOfSize:10];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [MYTOOL RGBWithRed:162 green:211 blue:87 alpha:1];
            CGSize size = [MYTOOL getSizeWithLabel:label];
            label.textAlignment = NSTextAlignmentCenter;
            label.frame = CGRectMake(left, top + 1, size.width + 10, size.height + 2);
            [bg addSubview:label];
            label.layer.masksToBounds = true;
            label.layer.cornerRadius = 3;
        }
    }
    top_all += 20;
    //签名-Motto
    {
        UILabel * leftLabel = [UILabel new];
        leftLabel.text = @"签名:";
        leftLabel.font = [UIFont systemFontOfSize:13];
        leftLabel.textColor = [MYTOOL RGBWithRed:48 green:48 blue:48 alpha:1];
        leftLabel.frame = CGRectMake(10, top_all, 50, 15);
        [self.view addSubview:leftLabel];
        //
        NSString * text = self.userInfo[@"Motto"];
        UILabel * rightLabel = [UILabel new];
        rightLabel.text = text;
        rightLabel.font = [UIFont systemFontOfSize:13];
        rightLabel.textColor = [MYTOOL RGBWithRed:112 green:112 blue:112 alpha:1];
        rightLabel.frame = CGRectMake(60, top_all, WIDTH - 70, 15);
        [self.view addSubview:rightLabel];
    }
    top_all += 35;
    //地址-Address
    {
        UILabel * leftLabel = [UILabel new];
        leftLabel.text = @"地址:";
        leftLabel.font = [UIFont systemFontOfSize:13];
        leftLabel.textColor = [MYTOOL RGBWithRed:48 green:48 blue:48 alpha:1];
        leftLabel.frame = CGRectMake(10, top_all, 50, 15);
        [self.view addSubview:leftLabel];
        //
        NSString * text = self.userInfo[@"Address"];
        UILabel * rightLabel = [UILabel new];
        rightLabel.text = text;
        rightLabel.font = [UIFont systemFontOfSize:13];
        rightLabel.textColor = [MYTOOL RGBWithRed:112 green:112 blue:112 alpha:1];
        rightLabel.frame = CGRectMake(60, top_all, WIDTH - 70, 15);
        [self.view addSubview:rightLabel];
    }
    top_all += 35;
    //爱好-MySummary
    {
        UILabel * leftLabel = [UILabel new];
        leftLabel.text = @"爱好:";
        leftLabel.font = [UIFont systemFontOfSize:13];
        leftLabel.textColor = [MYTOOL RGBWithRed:48 green:48 blue:48 alpha:1];
        leftLabel.frame = CGRectMake(10, top_all, 50, 15);
        [self.view addSubview:leftLabel];
        //
        NSString * text = self.userInfo[@"MySummary"];
        UILabel * rightLabel = [UILabel new];
        rightLabel.text = text;
        rightLabel.font = [UIFont systemFontOfSize:13];
        rightLabel.textColor = [MYTOOL RGBWithRed:112 green:112 blue:112 alpha:1];
        rightLabel.frame = CGRectMake(60, top_all, WIDTH - 70, 15);
        [self.view addSubview:rightLabel];
    }
    top_all += 40;
    //分割线
    {
        UIView * space = [UIView new];
        space.backgroundColor = MYCOLOR_240_240_240;
        space.frame = CGRectMake(10, top_all, WIDTH-20, 1);
        [self.view addSubview:space];
    }
}







-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [MYTOOL hideKeyboard];
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
