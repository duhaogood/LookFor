//
//  UpUserCardView.m
//  立寻
//
//  Created by mac on 2017/6/11.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "UpUserCardView.h"
#import "UpUserCardVC.h"
@implementation UpUserCardView


-(instancetype)initWithFrame:(CGRect)frame andDelegate:(id)delegate{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        float top = 0;
        float tf_left = 0;//文本框左侧
        //姓名
        {
            float height = [MYTOOL getHeightWithIphone_six:50];
            float middle_top = top+height/2-10;
            float left = 10;
            //图标
            {
                UIImageView * icon = [UIImageView new];
                icon.image = [UIImage imageNamed:@"truename"];
                icon.frame = CGRectMake(left, middle_top, 20, 20);
                [self addSubview:icon];
                left += 25;
                middle_top += 10;
            }
            //提示
            {
                UILabel * label = [UILabel new];
                label.text = @"您的姓名";
                label.font = [UIFont systemFontOfSize:14];
                label.textColor = [MYTOOL RGBWithRed:51 green:51 blue:51 alpha:1];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(left, middle_top - size.height/2, size.width, size.height);
                [self addSubview:label];
            }
            //文本框
            {
                UILabel * label = [UILabel new];
                label.text = @"身份证照片(正)";
                label.font = [UIFont systemFontOfSize:14];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                tf_left = left + size.width + 10;
                //姓名文本框
                UITextField * tf = [UITextField new];
                tf.placeholder = @"请输入您身份证上的姓名";
                tf.font = [UIFont systemFontOfSize:14];
                [delegate setNameTF:tf];
                tf.frame = CGRectMake(tf_left, middle_top - 8, WIDTH - 10 - tf_left, 16);
                [self addSubview:tf];
            }
            //分割线
            {
                UIView * space = [UIView new];
                space.backgroundColor = MYCOLOR_240_240_240;
                space.frame = CGRectMake(10, top + height-1, WIDTH-10, 1);
                [self addSubview:space];
            }
            top += height;
        }
        //身份证照片正
        {
            float height = [MYTOOL getHeightWithIphone_six:147];
            float middle_top = top+25;
            float left = 10;
            //图标
            {
                UIImageView * icon = [UIImageView new];
                icon.image = [UIImage imageNamed:@"idpicfacade"];
                icon.frame = CGRectMake(10, top+15, 20, 20);
                [self addSubview:icon];
                left += 25;
            }
            //提示
            {
                UILabel * label = [UILabel new];
                label.text = @"身份证照片(正)";
                label.font = [UIFont systemFontOfSize:14];
                label.textColor = [MYTOOL RGBWithRed:51 green:51 blue:51 alpha:1];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(left, middle_top - size.height/2, size.width, size.height);
                [self addSubview:label];
            }
            //提示二
            {
                UILabel * label = [UILabel new];
                label.text = @"请上传本人身份证个人信息页";
                label.font = [UIFont systemFontOfSize:13];
                label.textColor = [MYTOOL RGBWithRed:154 green:154 blue:154 alpha:1];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(tf_left, middle_top - size.height/2, size.width, size.height);
                [self addSubview:label];
            }
            //图片
            {
                UIImageView * icon = [UIImageView new];
                [delegate setCard_up_icon:icon];
                //上部坐标
                float up = middle_top + 10;
                //下部坐标
                float down = top + height;
                //图片高度
                float icon_height = (down - up)*73/114.0;
                icon.frame = CGRectMake(left, up + (down - up)/2.0 - icon_height/2.0, icon_height, icon_height);
                [self addSubview:icon];
                icon.tag = 0;
                icon.image = [UIImage imageNamed:@"Rounded-Rectangle-34-copy-2"];
                
                [icon setUserInteractionEnabled:YES];
                UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:delegate action:@selector(clickImgOfCardUp:)];
                tapGesture.numberOfTapsRequired=1;
                [icon addGestureRecognizer:tapGesture];
            }
            
            
            //分割线
            {
                UIView * space = [UIView new];
                space.backgroundColor = MYCOLOR_240_240_240;
                space.frame = CGRectMake(10, top + height-1, WIDTH-10, 1);
                [self addSubview:space];
            }
            top += height;
        }
        //身份证照片-反
        {
            float height = [MYTOOL getHeightWithIphone_six:147];
            float middle_top = top+25;
            float left = 10;
            //图标
            {
                UIImageView * icon = [UIImageView new];
                icon.image = [UIImage imageNamed:@"idpicobverse"];
                icon.frame = CGRectMake(10, top+15, 20, 20);
                [self addSubview:icon];
                left += 25;
            }
            //提示
            {
                UILabel * label = [UILabel new];
                label.text = @"身份证照片(反)";
                label.font = [UIFont systemFontOfSize:14];
                label.textColor = [MYTOOL RGBWithRed:51 green:51 blue:51 alpha:1];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(left, middle_top - size.height/2, size.width, size.height);
                [self addSubview:label];
            }
            //提示二
            {
                UILabel * label = [UILabel new];
                label.text = @"请上传本人身份证有效日期页";
                label.font = [UIFont systemFontOfSize:13];
                label.textColor = [MYTOOL RGBWithRed:154 green:154 blue:154 alpha:1];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(tf_left, middle_top - size.height/2, size.width, size.height);
                [self addSubview:label];
            }
            //图片
            {
                UIImageView * icon = [UIImageView new];
                [delegate setCard_down_icon:icon];
                //上部坐标
                float up = middle_top + 10;
                //下部坐标
                float down = top + height;
                //图片高度
                float icon_height = (down - up)*73/114.0;
                icon.frame = CGRectMake(left, up + (down - up)/2.0 - icon_height/2.0, icon_height, icon_height);
                icon.tag = 0;
                [self addSubview:icon];
                icon.image = [UIImage imageNamed:@"Rounded-Rectangle-34-copy-2"];
                
                [icon setUserInteractionEnabled:YES];
                UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:delegate action:@selector(clickImgOfCardDown:)];
                tapGesture.numberOfTapsRequired=1;
                [icon addGestureRecognizer:tapGesture];
            }
            
            
            //分割线
            {
                UIView * space = [UIView new];
                space.backgroundColor = MYCOLOR_240_240_240;
                space.frame = CGRectMake(10, top + height-1, WIDTH-10, 1);
                [self addSubview:space];
            }
            top += height;
        }
        //下一步按钮
        top += 20;
        {
            UIButton * btn = [UIButton new];
            btn.frame = CGRectMake(WIDTH/4, top, WIDTH/2, 40);
            btn.layer.masksToBounds = 1;
            btn.layer.cornerRadius = 20;
            btn.backgroundColor = [UIColor greenColor];
            [btn setTitle:@"下一步" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self addSubview:btn];
            [btn addTarget:delegate action:@selector(nextBtnCallback) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}

@end
