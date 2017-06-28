//
//  IssueInfoLowerView.m
//  立寻
//
//  Created by Mac on 17/6/9.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "IssueInfoLowerView.h"
#import "PickUpSomeThingVC.h"

@implementation IssueInfoLowerView

-(instancetype)initWithFrame:(CGRect)frame andDelegate:(id)delegate{
    if (self = [super initWithFrame:frame]) {
        float top = 0;
        //图标
        {
            UIImageView * icon = [UIImageView new];
            icon.image = [UIImage imageNamed:@"fbfuwutit"];
            icon.frame = CGRectMake(10, 17, 15, 15);
            [self addSubview:icon];
            top += 40;
        }
        //提示文字
        {
            UILabel * label = [UILabel new];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = MYCOLOR_48_48_48;
            label.text = @"服务支持";
            CGSize size = [MYTOOL getSizeWithLabel:label];
            label.frame = CGRectMake(35, 17+7.5 - size.height/2, size.width, size.height);
            [self addSubview:label];
        }
        //推送地区
        {
            float middle_top = 0;
            float left = 10;
            top += 10;
            //提示
            {
                UILabel * label = [UILabel new];
                label.font = [UIFont systemFontOfSize:12];
                label.textColor = MYCOLOR_48_48_48;
                label.text = @"推送地区：";
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(left, top, size.width, size.height);
                [self addSubview:label];
                middle_top = top + size.height/2;
                left += 60;
            }
            //右边两个按钮-选择地区／全国
            {
                //选择地区-btn_selected-btn_select
                {
                    UIButton * btn = [UIButton new];
                    btn.tag = 100;
                    [btn setBackgroundImage:[UIImage imageNamed:@"btn_select"] forState:UIControlStateNormal];
                    [btn setBackgroundImage:[UIImage imageNamed:@"btn_selected"] forState:UIControlStateDisabled];
                    [btn setTitle:@"选择地区" forState:UIControlStateNormal];
                    [btn setTitleColor:MYCOLOR_48_48_48 forState:UIControlStateNormal];
                    [btn setTitleColor:MYCOLOR_40_199_0 forState:UIControlStateDisabled];
                    btn.titleLabel.font = [UIFont systemFontOfSize:12];
                    [self addSubview:btn];
                    [delegate setAreaSelectBtn:btn];
                    btn.frame = CGRectMake(left, middle_top-11.5, 60,23);
                    [btn addTarget:delegate action:@selector(pushAreaButtonCallback:) forControlEvents:UIControlEventTouchUpInside];
                }
                //全国
                {
                    left += 67;
                    UIButton * btn = [UIButton new];
                    btn.tag = 200;
                    [btn setBackgroundImage:[UIImage imageNamed:@"btn_select"] forState:UIControlStateNormal];
                    [btn setBackgroundImage:[UIImage imageNamed:@"btn_selected"] forState:UIControlStateDisabled];
                    [btn setTitle:@"全国" forState:UIControlStateNormal];
                    [btn setTitleColor:MYCOLOR_48_48_48 forState:UIControlStateNormal];
                    [btn setTitleColor:MYCOLOR_40_199_0 forState:UIControlStateDisabled];
                    btn.titleLabel.font = [UIFont systemFontOfSize:12];
                    [self addSubview:btn];
                    [delegate setAllCountryBtn:btn];
                    btn.enabled = false;
                    btn.frame = CGRectMake(left, middle_top-11.5, 60,23);
                    [btn addTarget:delegate action:@selector(pushAreaButtonCallback:) forControlEvents:UIControlEventTouchUpInside];
                }
                left -= 67;
            }
            //金额view
            {
                top += 23;
                //总view
                UIView * view = [UIView new];
                {
                    view.frame = CGRectMake(left, top, WIDTH-10-left, 23);
                    [delegate setAreaMoneyView:view];
                    view.backgroundColor = [UIColor clearColor];
                    [self addSubview:view];
                    top += 20;
                }
                //文本框
                {
                    UITextField * moneyTF = [UITextField new];
                    moneyTF.frame = CGRectMake(0, 0, 90, 23);
                    moneyTF.layer.masksToBounds = true;
                    moneyTF.layer.borderWidth = 1;
                    moneyTF.layer.borderColor = [MYCOLOR_240_240_240 CGColor];
                    [delegate setPushMoneyTF:moneyTF];
                    [view addSubview:moneyTF];
                    moneyTF.font = [UIFont systemFontOfSize:10];
                    moneyTF.placeholder = @"全国推送金额";
                    moneyTF.textAlignment = NSTextAlignmentCenter;
                }
                left = 95;
                //元
                {
                    UILabel * label = [UILabel new];
                    label.text = @"元";
                    label.font = [UIFont systemFontOfSize:14];
                    label.textColor = MYCOLOR_48_48_48;
                    label.frame = CGRectMake(left, 4, 20, 15);
                    [view addSubview:label];
                }
                left += 20;
                //右侧提示
                {
                    UILabel * label = [UILabel new];
                    label.text = @"目前已有最高出价金额";
                    label.font = [UIFont systemFontOfSize:9];
                    label.textColor = [MYTOOL RGBWithRed:168 green:168 blue:168 alpha:1];
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(left, 23/2.0-size.height/2, size.width, size.height);
                    [view addSubview:label];
                    left += size.width;
                }
                //金额
                {
                    UILabel * label = [UILabel new];
                    label.text = @"50元/天";
                    label.font = [UIFont systemFontOfSize:9];
                    label.textColor = [MYTOOL RGBWithRed:255 green:101 blue:101 alpha:1];
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(left, 23/2.0-size.height/2, size.width, size.height);
                    [view addSubview:label];
                }
            }
        }
        //地区置顶
        {
            float middle_top = 0;
            float left = 10;
            top += 20;
            //提示
            {
                UILabel * label = [UILabel new];
                label.font = [UIFont systemFontOfSize:12];
                label.textColor = MYCOLOR_48_48_48;
                label.text = @"地区置顶：";
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(left, top, size.width, size.height);
                [self addSubview:label];
                middle_top = top + size.height/2;
                left += 60;
            }
            //右边两个按钮-不需要／需要
            {
                //不需要-btn_selected-btn_select
                {
                    UIButton * btn = [UIButton new];
                    btn.tag = 100;
                    [btn setBackgroundImage:[UIImage imageNamed:@"btn_select"] forState:UIControlStateNormal];
                    [btn setBackgroundImage:[UIImage imageNamed:@"btn_selected"] forState:UIControlStateDisabled];
                    [btn setTitle:@"不需要" forState:UIControlStateNormal];
                    [btn setTitleColor:MYCOLOR_48_48_48 forState:UIControlStateNormal];
                    [btn setTitleColor:MYCOLOR_40_199_0 forState:UIControlStateDisabled];
                    btn.titleLabel.font = [UIFont systemFontOfSize:12];
                    [self addSubview:btn];
                    [delegate setNoHaveBtn:btn];
                    btn.frame = CGRectMake(left, middle_top-11.5, 60,23);
                    [btn addTarget:delegate action:@selector(areaUpButtonCallback:) forControlEvents:UIControlEventTouchUpInside];
                }
                //需要
                {
                    left += 67;
                    UIButton * btn = [UIButton new];
                    btn.tag = 200;
                    [btn setBackgroundImage:[UIImage imageNamed:@"btn_select"] forState:UIControlStateNormal];
                    [btn setBackgroundImage:[UIImage imageNamed:@"btn_selected"] forState:UIControlStateDisabled];
                    [btn setTitle:@"需要" forState:UIControlStateNormal];
                    [btn setTitleColor:MYCOLOR_48_48_48 forState:UIControlStateNormal];
                    [btn setTitleColor:MYCOLOR_40_199_0 forState:UIControlStateDisabled];
                    btn.titleLabel.font = [UIFont systemFontOfSize:12];
                    [self addSubview:btn];
                    [delegate setHaveBtn:btn];
                    btn.enabled = false;
                    btn.frame = CGRectMake(left, middle_top-11.5, 60,23);
                    [btn addTarget:delegate action:@selector(areaUpButtonCallback:) forControlEvents:UIControlEventTouchUpInside];
                }
                left -= 67;
            }
            //金额view
            {
                top += 23;
                //总view
                UIView * view = [UIView new];
                {
                    view.frame = CGRectMake(left, top, WIDTH-10-left, 23);
                    [delegate setHaveMoneyView:view];
                    view.backgroundColor = [UIColor clearColor];
                    [self addSubview:view];
                    top += 20;
                }
                //文本框
                {
                    UITextField * moneyTF = [UITextField new];
                    moneyTF.frame = CGRectMake(0, 0, 90, 23);
                    moneyTF.layer.masksToBounds = true;
                    moneyTF.layer.borderWidth = 1;
                    moneyTF.layer.borderColor = [MYCOLOR_240_240_240 CGColor];
                    [delegate setHaveMoneyTF:moneyTF];
                    [view addSubview:moneyTF];
                    moneyTF.font = [UIFont systemFontOfSize:10];
                    moneyTF.placeholder = @"地区置顶金额";
                    moneyTF.textAlignment = NSTextAlignmentCenter;
                }
                left = 95;
                //元
                {
                    UILabel * label = [UILabel new];
                    label.text = @"元";
                    label.font = [UIFont systemFontOfSize:14];
                    label.textColor = MYCOLOR_48_48_48;
                    label.frame = CGRectMake(left, 4, 20, 15);
                    [view addSubview:label];
                }
                left += 20;
                //右侧提示
                {
                    UILabel * label = [UILabel new];
                    label.text = @"目前已有最高出价金额";
                    label.font = [UIFont systemFontOfSize:9];
                    label.textColor = [MYTOOL RGBWithRed:168 green:168 blue:168 alpha:1];
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(left, 23/2.0-size.height/2, size.width, size.height);
                    [view addSubview:label];
                    left += size.width;
                }
                //金额
                {
                    UILabel * label = [UILabel new];
                    label.text = @"50元/天";
                    label.font = [UIFont systemFontOfSize:9];
                    label.textColor = [MYTOOL RGBWithRed:255 green:101 blue:101 alpha:1];
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(left, 23/2.0-size.height/2, size.width, size.height);
                    [view addSubview:label];
                }
            }
        }
        //下部提示信息
        {
            top += 10;
            UILabel * label = [UILabel new];
            label.text = @"选择推广服务您的信息将在同类信息中强制置顶，置顶幅度根据您的 支付金额有关，金额越大信息越靠前，咨询热线：400-110-1100";
            label.font = [UIFont systemFontOfSize:8];
            label.textColor = [MYTOOL RGBWithRed:168 green:168 blue:168 alpha:1];
            CGSize size = [MYTOOL getSizeWithLabel:label];
            float width = size.width/2;
            label.frame = CGRectMake(WIDTH/2-width/2 , top, width+10, size.height*2);
            label.numberOfLines = 0;
            [self addSubview:label];
            top += size.height*2;
        }
        //底部还剩总高度
        float lower_height = frame.size.height - top;
        //按钮间隔
        float space = (lower_height - 80)/3.0;
        top += space;
        //保存至草稿箱按钮
        {
            UIButton * btn = [UIButton new];
            btn.frame = CGRectMake(10, top, WIDTH-20, 40);
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_green"] forState:UIControlStateNormal];
            [btn setTitle:@"保存至草稿箱" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [self addSubview:btn];
            [btn addTarget:delegate action:@selector(saveBtnCallback) forControlEvents:UIControlEventTouchUpInside];
        }
        //现在发布按钮
        top += space + 40;
        {
            UIButton * btn = [UIButton new];
            btn.frame = CGRectMake(10, top, WIDTH-20, 40);
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_red"] forState:UIControlStateNormal];
            [btn setTitle:@"现在发布" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [self addSubview:btn];
            [btn addTarget:delegate action:@selector(issueBtnCallback) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
    }
    return self;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [MYTOOL hideKeyboard];
}
@end
