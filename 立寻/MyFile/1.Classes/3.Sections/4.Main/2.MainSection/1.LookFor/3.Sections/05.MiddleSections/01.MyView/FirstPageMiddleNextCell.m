//
//  FirstPageMiddleNextCell.m
//  立寻
//
//  Created by mac on 2017/6/22.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "FirstPageMiddleNextCell.h"

@implementation FirstPageMiddleNextCell

-(instancetype)initWithDictionary:(NSDictionary *)dictionary isFirstPage:(BOOL)firstPage{
    if (self = [super init]) {
        float height = [MYTOOL getHeightWithIphone_six:200];
        //上分割线
        {
            UIView * space = [UIView new];
            space.frame = CGRectMake(0, 3, WIDTH, 1);
            space.backgroundColor = MYCOLOR_240_240_240;
            [self addSubview:space];
            if (!firstPage) {
                space.frame = CGRectMake(0, 0, WIDTH, 5);
            }
        }
        //头像
        {
            NSString * user_url = dictionary[@"ImgFilePath"];
            UIImageView * icon = [UIImageView new];
            icon.frame = CGRectMake(13, 13, 40, 40);
            if (user_url) {
                [icon sd_setImageWithURL:[NSURL URLWithString:user_url] placeholderImage:[UIImage imageNamed:@"morenhdpic"]];
            }
            [self addSubview:icon];
            icon.contentMode = UIViewContentModeScaleAspectFill;
            icon.clipsToBounds=YES;//  是否剪切掉超出 UIImageView 范围的图片
            [icon setContentScaleFactor:[[UIScreen mainScreen] scale]];
            icon.layer.masksToBounds = true;
            icon.layer.cornerRadius = 20;
        }
        //用户名字
        {
            NSString * user_name = dictionary[@"UserName"];
            if (user_name.length > 4) {
                user_name = [NSString stringWithFormat:@"%@**%@",[user_name substringToIndex:1],[user_name substringFromIndex:user_name.length-1]];
            }
            UILabel * label = [UILabel new];
            label.text = user_name;
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [MYTOOL RGBWithRed:48 green:48 blue:48 alpha:1];
            label.font = [UIFont systemFontOfSize:13];
            float label_width = 40+13+13;
            CGSize size = [MYTOOL getSizeWithLabel:label];
            while (size.width > label_width + label.font.pointSize) {
                label.font = [UIFont systemFontOfSize:label.font.pointSize-0.1];
                size = [MYTOOL getSizeWithLabel:label];
            }
            label.frame = CGRectMake(0, 60, label_width, size.height);
            [self addSubview:label];
        }
        //认证
        {
            bool state = [dictionary[@"user_state"] boolValue];
            if (state) {
                UILabel * label = [UILabel new];
                label.text = @"已认证";
                label.font = [UIFont systemFontOfSize:9];
                label.backgroundColor = [MYTOOL RGBWithRed:162 green:211 blue:87 alpha:1];
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                [self addSubview:label];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(33-size.width/2-3, 80, size.width+6, size.height);
            }
        }
        //标题
        float top_all = 0;
        float left = 70;
        float icon_left = 0;
        UILabel * title_label = nil;
        {
            NSString * title = dictionary[@"Title"];
            UILabel * label = [UILabel new];
            title_label = label;
            label.text = title;
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [MYTOOL RGBWithRed:48 green:48 blue:48 alpha:1];
            CGSize size = [MYTOOL getSizeWithLabel:label];
            float max_width = WIDTH - left - 10 - 24 - 14 - 14 - 40;
            while (size.width > max_width + label.font.pointSize) {
                label.font = [UIFont systemFontOfSize:label.font.pointSize-0.1];
                size = [MYTOOL getSizeWithLabel:label];
            }
            label.frame = CGRectMake(left, 16, size.width, size.height);
            [self addSubview:label];
            icon_left = left + size.width + 10;
            top_all = 16 + size.height + 5;
        }
        //类型
        {
//            NSString * type = dictionary[@"type"];
//            UILabel * label = [UILabel new];
//            label.text = type;
//            label.textColor = [UIColor whiteColor];
//            NSRange range = [type rangeOfString:@"找"];
//            if (range.location == NSNotFound) {
//                label.backgroundColor = [MYTOOL RGBWithRed:107 green:178 blue:248 alpha:1];
//            }else{
//                label.backgroundColor = [MYTOOL RGBWithRed:253 green:102 blue:105 alpha:1];
//            }
//            label.font = [UIFont systemFontOfSize:8];
//            label.textAlignment = NSTextAlignmentCenter;
//            [self addSubview:label];
//            //            CGSize size = [MYTOOL getSizeWithLabel:label];
//            label.frame = CGRectMake(icon_left, 17, 24, title_label.font.pointSize);
//            icon_left += 24 + 14;
        }
        //全国推广
        {
            int PushType = [dictionary[@"PushType"] intValue];
            if (PushType == 1) {
                NSString * range = @"全国推广";
                UILabel * label = [UILabel new];
                label.text = range;
                label.font = [UIFont systemFontOfSize:8];
                label.textColor = [UIColor whiteColor];
                label.backgroundColor = [MYTOOL RGBWithRed:216 green:216 blue:216 alpha:1];
                label.frame = CGRectMake(icon_left, 17, 40, title_label.font.pointSize);
                [self addSubview:label];
                label.textAlignment = NSTextAlignmentCenter;
            }
            
        }
        //丢失地
        {
            //图标
            {
                UIImageView * icon = [UIImageView new];
                icon.image = [UIImage imageNamed:@"address"];
                icon.frame = CGRectMake(left, top_all, 9, 11);
                [self addSubview:icon];
            }
            //地点
            {
                NSString * CityName = dictionary[@"CityName"];
                NSString * ProvinceName = dictionary[@"ProvinceName"];
                NSString * lost_place = [NSString stringWithFormat:@"%@  %@",ProvinceName,CityName];
                NSString * text = [NSString stringWithFormat:@"丢失地：%@",lost_place];
                UILabel * label = [UILabel new];
                label.text = text;
                label.textColor = [MYTOOL RGBWithRed:144 green:144 blue:144 alpha:1];
                label.font = [UIFont systemFontOfSize:10];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(left + 13, top_all, size.width, size.height);
                [self addSubview:label];
            }
        }
        //悬赏金
        {
            float right = 0;
            float money_height = 0;
            //金钱
            {
                NSString * money = dictionary[@"Money"];
                UILabel * label = [UILabel new];
                NSString * text = [NSString stringWithFormat:@"%@元",money];
                label.text = text;
                label.font = [UIFont systemFontOfSize:12];
                label.textColor = [MYTOOL RGBWithRed:255 green:83 blue:95 alpha:1];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(WIDTH - 14 - size.width, top_all, size.width, size.height);
                right = WIDTH - 14 - size.width - 12;
                money_height = size.height;
                [self addSubview:label];
            }
            //悬赏标志
            {
                UIImageView * icon = [UIImageView new];
                icon.image = [UIImage imageNamed:@"btn_xsj_xs"];
                icon.frame = CGRectMake(right - 37, top_all, 37, money_height);
                [self addSubview:icon];
            }
            top_all += money_height + 5;
        }
        //具体内容
        {
            float label_width = WIDTH - 13 - left;
            NSString * content = dictionary[@"Content"];
            UILabel * label = [UILabel new];
            label.textColor = [MYTOOL RGBWithRed:64 green:64 blue:64 alpha:1];
            label.font = [UIFont systemFontOfSize:13];
            label.text = content;
            [self addSubview:label];
            CGSize size = [MYTOOL getSizeWithLabel:label];
            label.lineBreakMode = NSLineBreakByCharWrapping;
            label.numberOfLines = 0;
            float height_content = size.width > label_width ? 30 : 15;
            label.frame = CGRectMake(left, top_all, label_width, height_content);
            top_all += height_content + 10;
//            if (size.width < label_width) {
//                label.frame = CGRectMake(left, top_all, label_width, size.height );
//                top_all += size.height + 10;
//            }else{
//                if (size.width > label_width * 2 + label.font.pointSize * 3) {
//                    float row = size.width / label_width;
//                    NSInteger length = content.length * 1.8 / row;
//                    NSString * text = [content substringToIndex:length];
//                    text = [NSString stringWithFormat:@"%@…",text];
//                    label.text = text;
//                    size = [MYTOOL getSizeWithLabel:label];
//                }
//                label.frame = CGRectMake(left, top_all, label_width, size.height * 2);
//                label.numberOfLines = 0;
//                top_all += size.height * 2 + 10;
//            }
        }
        //发布时间
        float top_down = height - 24;
        {
            //图标
            {
                UIImageView * icon = [UIImageView new];
                icon.image = [UIImage imageNamed:@"time"];
                icon.frame = CGRectMake(left, top_down, 12, 12);
                [self addSubview:icon];
            }
            //时间提示
            {
                NSString * time = dictionary[@"CreateTime"];
                UILabel * label = [UILabel new];
                label.text = time;
                label.font = [UIFont systemFontOfSize:10];
                label.textColor = [MYTOOL RGBWithRed:144 green:144 blue:144 alpha:1];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(left + 20, top_down, size.width, size.height);
                [self addSubview:label];
                top_down += size.height/2;
            }
        }
        float num_left = 0;
        //评论-comments
        {
            NSString * number = dictionary[@"CommentCount"];
            //数字
            {
                UILabel * label = [UILabel new];
                label.text = [NSString stringWithFormat:@"%@",number];
                label.font = [UIFont systemFontOfSize:10];
                label.textColor = [MYTOOL RGBWithRed:144 green:144 blue:144 alpha:1];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                num_left = WIDTH - size.width - 14;
                label.frame = CGRectMake(num_left, top_down-size.height/2, size.width, size.height);
                [self addSubview:label];
            }
            //图标
            {
                UIImageView * icon = [UIImageView new];
                num_left -= (5+13);
                icon.frame = CGRectMake(num_left, top_down-13.0/2, 13, 13);
                [self addSubview:icon];
                icon.image = [UIImage imageNamed:@"comments"];
            }
        }
        //关注-guanzhu
        {
            NSString * number = dictionary[@"FollowCount"];
            //数字
            {
                UILabel * label = [UILabel new];
                label.text = [NSString stringWithFormat:@"%@",number];
                label.font = [UIFont systemFontOfSize:10];
                label.textColor = [MYTOOL RGBWithRed:144 green:144 blue:144 alpha:1];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                num_left -= size.width + 10;
                label.frame = CGRectMake(num_left, top_down-size.height/2, size.width, size.height);
                [self addSubview:label];
            }
            //图标
            {
                UIImageView * icon = [UIImageView new];
                num_left -= (5+13);
                icon.frame = CGRectMake(num_left, top_down-5.5, 13, 11);
                [self addSubview:icon];
                icon.image = [UIImage imageNamed:@"guanzhu"];
            }
        }
        //浏览-browse
        {
            NSString * number = dictionary[@"VisitCount"];
            //数字
            {
                UILabel * label = [UILabel new];
                label.text = [NSString stringWithFormat:@"%@",number];
                label.font = [UIFont systemFontOfSize:10];
                label.textColor = [MYTOOL RGBWithRed:144 green:144 blue:144 alpha:1];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                num_left -= size.width + 10;
                label.frame = CGRectMake(num_left, top_down-size.height/2, size.width, size.height);
                [self addSubview:label];
            }
            //图标
            {
                UIImageView * icon = [UIImageView new];
                num_left -= (5+13);
                icon.frame = CGRectMake(num_left, top_down-4.5, 15, 9);
                [self addSubview:icon];
                icon.image = [UIImage imageNamed:@"browse"];
            }
        }
        /*
         @"n1":@"123",
         @"n2":@"222",
         @"n3":@"441"
         */
        top_down -= 10;
        //图片
        {
            NSArray * url_array = dictionary[@"PictureList"];
            float img_width = top_down - top_all - 10;
            for (int i = 0; i < 3 && i < url_array.count; i ++) {
                UIImageView * icon = [UIImageView new];
                icon.frame = CGRectMake(left + i * (img_width + 10), top_all, img_width, img_width);
                NSString * url = url_array[i][@"ImgFilePath"];
                if (url) {
                    [MYTOOL setImageIncludePrograssOfImageView:icon withUrlString:url];
                }
                icon.contentMode = UIViewContentModeScaleAspectFill;
                icon.clipsToBounds=YES;//  是否剪切掉超出 UIImageView 范围的图片
                [icon setContentScaleFactor:[[UIScreen mainScreen] scale]];
                [self addSubview:icon];
            }
        }
        //下分割线
        {
            UIView * space = [UIView new];
            space.frame = CGRectMake(0, height - 4, WIDTH, 1);
            space.backgroundColor = MYCOLOR_240_240_240;
            [self addSubview:space];
            if (!firstPage) {
                space.frame = CGRectMake(0, height-3, WIDTH, 3);
            }
        }
    }
    return self;
}





- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
