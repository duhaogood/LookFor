//
//  CertificationView.m
//  立寻
//
//  Created by mac on 2017/6/11.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "CertificationView.h"
#import "PersonalCertificationVC.h"

@implementation CertificationView


-(instancetype)initWithFrame:(CGRect)frame andDelegate:(id)delegate andUserInfo:(NSDictionary *)userInfo{
    if (self = [super initWithFrame:frame]) {
        float top = 0;
        //上部背景view
        {
            float height = [MYTOOL getHeightWithIphone_six:155];
            UIView * view = [UIView new];
            view.frame = CGRectMake(0, 0, WIDTH, height);
            view.backgroundColor = [MYTOOL RGBWithRed:0 green:201 blue:25 alpha:1];
            [self addSubview:view];
            top += height;
            //下侧弧形
            {
                UIImageView * lower_icon = [UIImageView new];
                lower_icon.image = [UIImage imageNamed:@"arc"];
                [self addSubview:lower_icon];
                float icon_height = WIDTH / 375.0 * 21;
                lower_icon.frame = CGRectMake(0, top, WIDTH, icon_height);
                top += icon_height;
            }
            //头像
            float tel_top = 0;
            {
                UIImageView * icon = [UIImageView new];
                [delegate setUser_icon:icon];
                icon.backgroundColor = [UIColor whiteColor];
                float r = [MYTOOL getHeightWithIphone_six:73];
                icon.frame = CGRectMake(WIDTH/2-r/2.0, top/2.0-r/2.0, r, r);
                icon.layer.masksToBounds = true;
                icon.layer.cornerRadius = r/2.0;
                [self addSubview:icon];
                [delegate setUser_icon:icon];
                tel_top = top/2.0 + r/2.0;
                //添加点击事件
                [icon setUserInteractionEnabled:YES];
                UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:delegate action:@selector(clickImgOfUser:)];
                tapGesture.numberOfTapsRequired=1;
                [icon addGestureRecognizer:tapGesture];
            }
            //手机号码
            {
                UILabel * label = [UILabel new];
                [delegate setPhone_label:label];
                label.frame = CGRectMake(0, tel_top+10, WIDTH, 15);
                label.font = [UIFont systemFontOfSize:12];
                label.textColor = [UIColor whiteColor];
                label.text = userInfo[@"CellPhone"];
                label.textAlignment = NSTextAlignmentCenter;
                [self addSubview:label];
            }
        }
        top += 20;
        //warning
        {
            UIImageView * icon = [UIImageView new];
            icon.image = [UIImage imageNamed:@"warning"];
            icon.frame = CGRectMake(WIDTH/2-12, top, 24, 24);
            [self addSubview:icon];
        }
        top += 36;
        //状态
        {
            UILabel * label = [UILabel new];
            //认证状态  1未认证 2等待认证  3认证没通过 4认证通过
            int ApproveState = [userInfo[@"ApproveState"] intValue];
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
            label.text = text;
            [delegate setState_label:label];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [MYTOOL RGBWithRed:51 green:51 blue:51 alpha:1];
            label.textAlignment = NSTextAlignmentCenter;
            label.frame = CGRectMake(0, top, WIDTH, 15);
            [self addSubview:label];
        }
        //认证按钮-btn_hollow_red_md,148*37
        top = HEIGHT/2-37;
        {
            UIButton * btn = [UIButton new];
            [delegate setGoCertification_btn:btn];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_hollow_red_md"] forState:UIControlStateNormal];
            [btn setTitle:@"去认证" forState:UIControlStateNormal];
            [btn setTitleColor:[MYTOOL RGBWithRed:255 green:101 blue:101 alpha:1] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            btn.frame = CGRectMake(WIDTH/2-74, top, 148, 37);
            [self addSubview:btn];
            [btn addTarget:delegate action:@selector(goCertification_btnCallback) forControlEvents:UIControlEventTouchUpInside];
        }
        //文字提醒
        top += 37 + 10;
        {
            UILabel * label = [UILabel new];
            label.font = [UIFont systemFontOfSize:12];
            label.text = @"认证通过后即可开启发现寻找之旅";
            label.textColor = [MYTOOL RGBWithRed:164 green:164 blue:164 alpha:1];
            label.textAlignment = NSTextAlignmentCenter;
            label.frame = CGRectMake(0, top, WIDTH, 14);
            [self addSubview:label];
        }
        //以后再说按钮-btn_hollow_blue_md
        top = (HEIGHT - top - 37)/2.0+top;
        {
            UIButton * btn = [UIButton new];
            [delegate setLaterSay_btn:btn];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_hollow_blue_md"] forState:UIControlStateNormal];
            [btn setTitle:@"以后再说" forState:UIControlStateNormal];
            [btn setTitleColor:[MYTOOL RGBWithRed:188 green:188 blue:188 alpha:1] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            btn.frame = CGRectMake(WIDTH/2-74, top, 148, 37);
            [self addSubview:btn];
            [btn addTarget:delegate action:@selector(laterSay_btnCallback) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}


@end
