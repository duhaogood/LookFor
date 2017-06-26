//
//  PublishInfoView.m
//  立寻
//
//  Created by mac on 2017/6/25.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "PublishInfoView.h"

@implementation PublishInfoView

-(instancetype)initWithFrame:(CGRect)frame andPublishDictionary:(NSDictionary*)publishDictionary andDelegate:(PublishInfoVC*)delegate{
    if (self = [super initWithFrame:frame]) {
        
        //主scrollview
        UIScrollView * scrollView = [UIScrollView new];
        scrollView.backgroundColor = MYCOLOR_240_240_240;
        scrollView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64-50);
        [self addSubview:scrollView];
        //用户信息view
        float top_all = 0;
        {
            UIView * view = [UIView new];
            float height = [MYTOOL getHeightWithIphone_six:75];
            top_all += height + 10;
            view.frame = CGRectMake(0, 0, WIDTH, height);
            view.backgroundColor = [UIColor whiteColor];
            [scrollView addSubview:view];
            float left = 10;
            //头像
            {
                float icon_height = 2/3.0*height;//图片高度
                UIImageView * icon = [UIImageView new];
                icon.frame = CGRectMake(left, height/2 - icon_height/2, icon_height, icon_height);
                left += icon_height + 10;
                icon.layer.masksToBounds = true;
                icon.layer.cornerRadius = icon_height/2.0;
                [view addSubview:icon];
                //用户头像
                NSString * url = publishDictionary[@"ImgFilePath"];
                if (url) {
                    [MYTOOL setImageIncludePrograssOfImageView:icon withUrlString:url];
                }
            }
            //用户名字
            {
                UILabel * label = [UILabel new];
                label.font = [UIFont systemFontOfSize:14];
                label.textColor = MYCOLOR_48_48_48;
                NSString * user_name = publishDictionary[@"UserName"];
                label.text = user_name;
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(left, height/2.0-size.height, size.width, size.height);
                [view addSubview:label];
            }
            //是否认证
            {
                
            }
            //个人详情按钮
            {
                UIButton * btn = [UIButton new];
                btn.frame = CGRectMake(WIDTH - 82, height/2 - 10, 72, 20);
                btn.layer.masksToBounds = true;
                btn.layer.cornerRadius = 10;
                btn.layer.borderWidth = 1;
                btn.layer.borderColor = [MYTOOL RGBWithRed:221 green:221 blue:221 alpha:1].CGColor;
                [btn setTitle:@"个人详情" forState:UIControlStateNormal];
                [btn setTitleColor:[MYTOOL RGBWithRed:112 green:112 blue:112 alpha:1] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:12];
                [view addSubview:btn];
                [btn addTarget:delegate action:@selector(submitPersonalBtn:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        //发布的信息
        {
            UIView * view = [UIView new];
            float height = [MYTOOL getHeightWithIphone_six:675];
            view.frame = CGRectMake(0, top_all, WIDTH, height);
            view.backgroundColor = [UIColor whiteColor];
            [scrollView addSubview:view];
            float top = 19;
            float left = 10;
            //悬赏金额
            {
                //提示
                {
                    UILabel * label = [UILabel new];
                    label.text = @"悬赏金额";
                    label.font = [UIFont systemFontOfSize:15];
                    label.textColor = MYCOLOR_40_199_0;
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(left, top, size.width, size.height);
                    left += size.width + 18;
                    top += size.height;
                    [view addSubview:label];
                }
                //金额
                {
                    UILabel * label = [UILabel new];
                    label.font = [UIFont systemFontOfSize:24];
                    label.textColor = MYCOLOR_40_199_0;
                    float Money = [publishDictionary[@"Money"] floatValue];
                    NSString * text = [NSString stringWithFormat:@"￥%.2f",Money];
                    if (Money * 10 == (int)(Money * 10)) {
                        text = [NSString stringWithFormat:@"￥%.1f",Money];
                    }
                    if (Money == (int)Money) {
                        text = [NSString stringWithFormat:@"￥%d",(int)Money];
                    }
                    label.text = text;
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(left, top - size.height, size.width, size.height);
                    [view addSubview:label];
                }
            }
            //举报
            {
                UILabel * label = [UILabel new];
                label.text = @"举报";
                label.textColor = [MYTOOL RGBWithRed:144 green:144 blue:144 alpha:1];
                label.font = [UIFont systemFontOfSize:11];
                label.frame = CGRectMake(WIDTH - 45, top - 15, 30, 15);
                [view addSubview:label];
                label.layer.masksToBounds = true;
                label.layer.cornerRadius = 3;
                label.textAlignment = NSTextAlignmentCenter;
                label.layer.borderWidth = 1;
                label.layer.borderColor = [[MYTOOL RGBWithRed:230 green:230 blue:230 alpha:1] CGColor];
                [view addSubview:label];
                //举报按钮
                {
                    UIButton * btn = [UIButton new];
                    btn.frame = CGRectMake(label.frame.origin.x - 5, label.frame.origin.y - 5, 40, 25);
                    [btn addTarget:delegate action:@selector(submitReportBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:btn];
                }
            }
            //发布信息位置
            {
                NSString * ProvinceName = publishDictionary[@"ProvinceName"];
                NSString * CityName = publishDictionary[@"CityName"];
                NSString * Address = publishDictionary[@"Address"];
                NSString * text = @"发布信息位置：暂无";
                if (ProvinceName && CityName && Address) {
                    text = [NSString stringWithFormat:@"发布信息位置：%@%@%@",ProvinceName,CityName,Address];
                }
                top += 12;
                UILabel * label = [UILabel new];
                label.font = [UIFont systemFontOfSize:11];
                label.text = text;
                label.textColor = [MYTOOL RGBWithRed:168 green:168 blue:168 alpha:1];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                int row = size.width / (WIDTH - 20);
                if (row * (WIDTH - 20) < size.width) {
                    row ++;
                }
                label.frame = CGRectMake(10, top, WIDTH - 20, size.height * row);
                [view addSubview:label];
                label.numberOfLines = 0;
                top += size.height * row + 15;
            }
            //发布信息的标题
            {
                left = 10;
                //类型
                {
                    UILabel * label = [UILabel new];
                    label.textColor = [UIColor whiteColor];
                    label.backgroundColor = [MYTOOL RGBWithRed:253 green:102 blue:105 alpha:1];
                    label.font = [UIFont systemFontOfSize:10];
                    label.textAlignment = NSTextAlignmentCenter;
                    NSString * CategoryName = publishDictionary[@"CategoryName"];
                    if (!CategoryName || CategoryName.length == 0) {
                        CategoryName = @"未知";
                    }
                    label.text = CategoryName;
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(left, top, size.width + 6, size.height + 6);
                    [view addSubview:label];
                    left += size.width + 6 + 7;
                }
                //标题
                {
                    UILabel * label = [UILabel new];
                    label.font = [UIFont systemFontOfSize:15];
                    label.textColor = MYCOLOR_48_48_48;
                    NSString * Title = publishDictionary[@"Title"];
                    label.text = Title;
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(left, top, size.width, size.height);
                    [view addSubview:label];
                    top += size.height + 18;
                }
            }
            //详细信息
            {
                UILabel * label = [UILabel new];
                label.font = [UIFont systemFontOfSize:12];
                label.textColor = [MYTOOL RGBWithRed:119 green:119 blue:119 alpha:1];
                NSString * Content = publishDictionary[@"Content"];
                label.text = Content;
                label.numberOfLines = 0;
                CGSize size = [MYTOOL getSizeWithLabel:label];
                int row = size.width / (WIDTH - 20);
                if (row * (WIDTH - 20) < size.width) {
                    row ++;
                }
                label.frame = CGRectMake(10, top, WIDTH - 20, size.height * row);
                [view addSubview:label];
                top += size.height * row + 18;
            }
            //图片
            {
                NSArray * PictureList = publishDictionary[@"PictureList"];
                float img_height = [MYTOOL getHeightWithIphone_six:234];//图片高度
                for (NSDictionary * pictureDic in PictureList) {
                    //图片链接
                    NSString * url = pictureDic[@"ImgFilePath"];
                    UIImageView * imgV = [UIImageView new];
                    imgV.frame = CGRectMake(0, top, WIDTH, img_height);
                    [view addSubview:imgV];
                    [MYTOOL setImageIncludePrograssOfImageView:imgV withUrlString:url andCompleted:^(UIImage *image) {
                        CGSize size = image.size;
//                        NSLog(@"%.2f,%.2f",size.width,size.height);
                        float real_width = img_height / size.height * size.width;
                        if (real_width > WIDTH) {
                            real_width = WIDTH;
                        }
                        imgV.frame = CGRectMake(0, imgV.frame.origin.y, real_width, img_height);
                    }];
                    top += img_height + 5;
                }
            }
            //目标丢失地
            top += 15;
            {
                //图标
                {
                    UIImageView * icon = [UIImageView new];
                    icon.image = [UIImage imageNamed:@"address"];
                    icon.frame = CGRectMake(10, top, 9, 11);
                    [view addSubview:icon];
                }
                
                NSString * ProvinceName = publishDictionary[@"ProvinceName"];
                NSString * CityName = publishDictionary[@"CityName"];
                NSString * Address = publishDictionary[@"Address"];
                NSString * text = @"目标丢失地：暂无";
                if (ProvinceName && CityName && Address) {
                    text = [NSString stringWithFormat:@"目标丢失地：%@%@%@",ProvinceName,CityName,Address];
                }
                top += 5.5;
                UILabel * label = [UILabel new];
                label.font = [UIFont systemFontOfSize:11];
                label.text = text;
                label.textColor = [MYTOOL RGBWithRed:168 green:168 blue:168 alpha:1];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                int row = size.width / (WIDTH - 10-(10+9+14));
                if (row * (WIDTH - 10-(10+9+14)) < size.width) {
                    row ++;
                }
                label.frame = CGRectMake(10+9+14, top-size.height/2, WIDTH - 10-(10+9+14), size.height * row);
                [view addSubview:label];
                label.numberOfLines = 0;
                top += size.height * row + 15;
            }
            //评论--按钮
            {
                UIView * commentView = [UIView new];
                commentView.backgroundColor = [MYTOOL RGBWithRed:238 green:238 blue:238 alpha:1];
                commentView.frame = CGRectMake(0, top, WIDTH, 44);
                [view addSubview:commentView];
                //评论人数-CommentCount
                {
                    UILabel * label = [UILabel new];
                    label.font = [UIFont systemFontOfSize:12];
                    label.textColor = [MYTOOL RGBWithRed:61 green:61 blue:61 alpha:1];
                    int CommentCount = [publishDictionary[@"CommentCount"] intValue];
                    NSString * text = [NSString stringWithFormat:@"评论（%d）",CommentCount];
                    label.text = text;
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(10, 22-size.height/2, size.width, size.height);
                    [commentView addSubview:label];
                }
                /*评论人头像*/
                
                
                //右侧小图标
                {
                    UIImageView * icon = [UIImageView new];
                    icon.image = [UIImage imageNamed:@"arrow_right_md"];
                    [commentView addSubview:icon];
                    icon.frame = CGRectMake(commentView.frame.size.width - 23, 16, 6, 12);
                }
                //评论列表按钮
                {
                    UIButton * btn = [UIButton new];
                    btn.frame = commentView.bounds;
                    [commentView addSubview:btn];
                    [btn addTarget:delegate action:@selector(submitCommentListBtn:) forControlEvents:UIControlEventTouchUpInside];
                }
                top += 64;
            }
            //评论区
            {
                //提示
                {
                    UILabel * label = [UILabel new];
                    label.text = @"评论区";
                    label.font = [UIFont systemFontOfSize:13];
                    label.textColor = [MYTOOL RGBWithRed:61 green:61 blue:61 alpha:1];
                    label.frame = CGRectMake(10, top, WIDTH-20, 15);
                    [view addSubview:label];
                }
                /*评论列表*/
                
                
                
                top += 50;
            }
            
            /*待加*/
            
            view.frame = CGRectMake(0, view.frame.origin.y, view.frame.size.width, top);
            top_all += top;
        }
        scrollView.contentSize = CGSizeMake(0, top_all);
        //底部按钮
        {
            UIView * view = [UIView new];
            view.backgroundColor = [UIColor whiteColor];
            view.frame = CGRectMake(0, HEIGHT-64-50, WIDTH, 50);
            [self addSubview:view];
            //分割线
            {
                UIView * space = [UIView new];
                space.frame = CGRectMake(0, 0, WIDTH, 1);
                space.backgroundColor = [MYTOOL RGBWithRed:221 green:221 blue:221 alpha:1];
                [view addSubview:space];
            }
            //关注
            {
                //图标
                {
                    UIImageView * icon = [UIImageView new];
                    icon.frame = CGRectMake(WIDTH/12-9, 9, 18, 16);
                    icon.backgroundColor = [UIColor greenColor];
                    [view addSubview:icon];
                    icon.image = [UIImage imageNamed:@""];
                }
                //文字
                {
                    UILabel * label = [UILabel new];
                    label.text = @"关注";
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor = [MYTOOL RGBWithRed:112 green:112 blue:112 alpha:1];
                    label.font = [UIFont systemFontOfSize:12];
                    label.frame = CGRectMake(0, 27, WIDTH/6, 20);
                    [view addSubview:label];
                }
                //按钮
                {
                    UIButton * btn = [UIButton new];
                    btn.frame = CGRectMake(0, 0, WIDTH/6, 50);
                    [btn addTarget:delegate action:@selector(submitAttentionBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:btn];
                }
            }
            //分割线
            {
                UIView * space = [UIView new];
                space.frame = CGRectMake(WIDTH/6-0.5, 7, 1, 36);
                space.backgroundColor = [MYTOOL RGBWithRed:221 green:221 blue:221 alpha:1];
                [view addSubview:space];
            }
            //评论
            {
                //图标
                {
                    UIImageView * icon = [UIImageView new];
                    icon.frame = CGRectMake(WIDTH/12*3-9, 9, 18, 16);
                    icon.backgroundColor = [UIColor greenColor];
                    [view addSubview:icon];
                    icon.image = [UIImage imageNamed:@""];
                }
                //文字
                {
                    UILabel * label = [UILabel new];
                    label.text = @"评论";
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor = [MYTOOL RGBWithRed:112 green:112 blue:112 alpha:1];
                    label.font = [UIFont systemFontOfSize:12];
                    label.frame = CGRectMake(WIDTH/6, 27, WIDTH/6, 20);
                    [view addSubview:label];
                }
                //按钮
                {
                    UIButton * btn = [UIButton new];
                    btn.frame = CGRectMake(WIDTH/6, 0, WIDTH/6, 50);
                    [btn addTarget:delegate action:@selector(submitCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:btn];
                }
            }
            //留言
            {
                UIButton * btn = [UIButton new];
                btn.backgroundColor = [MYTOOL RGBWithRed:34 green:204 blue:203 alpha:1];
                btn.titleLabel.font = [UIFont systemFontOfSize:15];
                [btn setTitle:@"留言" forState:UIControlStateNormal];
                btn.frame = CGRectMake(WIDTH/3, 0, WIDTH/3, 50);
                [view addSubview:btn];
                [btn addTarget:delegate action:@selector(submitMessageBtn:) forControlEvents:UIControlEventTouchUpInside];
            }
            //我有线索
            {
                UIButton * btn = [UIButton new];
                btn.backgroundColor = [MYTOOL RGBWithRed:250 green:101 blue:104 alpha:1];
                btn.titleLabel.font = [UIFont systemFontOfSize:15];
                [btn setTitle:@"我有线索" forState:UIControlStateNormal];
                btn.frame = CGRectMake(WIDTH/3*2, 0, WIDTH/3, 50);
                [view addSubview:btn];
                [btn addTarget:delegate action:@selector(submitMyClueBtn:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
    }
    return self;
}

@end
