//
//  ExtensionCell.m
//  立寻
//
//  Created by mac on 2017/6/3.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "ExtensionCell.h"
#import "MyExtensionVC.h"
@implementation ExtensionCell
-(instancetype)initWithDictionary:(NSDictionary *)dictionary andHeight:(float)height andDelegate:(id)delegate andIndexPath:(NSIndexPath *)indexPath{
    if (self = [super init]) {
        //最新编辑时间
        {
            //图标
            {
                UIImageView * icon = [UIImageView new];
                icon.image = [UIImage imageNamed:@"time"];
                icon.frame = CGRectMake(10, 40/195.0*height/2-6, 12, 12);
                [self addSubview:icon];
            }
            //时间文本
            {
                UILabel * label = [UILabel new];
                label.text = [NSString stringWithFormat:@"发布时间：%@",dictionary[@"extensionTime"]];
                label.font = [UIFont systemFontOfSize:10];
                label.textColor = [MYTOOL RGBWithRed:144 green:144 blue:144 alpha:1];
                [self addSubview:label];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(27, 40/195.0*height/2 - size.height/2, size.width, size.height);
                [self addSubview:label];
            }
        }
        //右侧3个数字及图标
        {
            float top_height = 40/195.0*height;
            float left = WIDTH - 10;
            UIFont * font = [UIFont systemFontOfSize:9];
            UIColor * fontColor = MYCOLOR_144;
            CGSize size;
            //评论
            {
                //数字
                {
                    NSString * comment = dictionary[@"comment"];
                    UILabel * label = [UILabel new];
                    label.font = font;
                    label.textColor = fontColor;
                    label.text = comment;
                    size = [MYTOOL getSizeWithLabel:label];
                    left -= size.width;
                    label.frame = CGRectMake(left, top_height/2-size.height/2, size.width, size.height);
                    [self addSubview:label];
                }
                //图标
                {
                    left -= 15;
                    UIImageView * icon = [UIImageView new];
                    icon.image = [UIImage imageNamed:@"comments"];
                    icon.frame = CGRectMake(left, top_height/2-6, 12, 12);
                    [self addSubview:icon];
                }
            }
            //关注
            {
                //数字
                {
                    left -= 16;
                    NSString * comment = dictionary[@"follow"];
                    UILabel * label = [UILabel new];
                    label.font = font;
                    label.textColor = fontColor;
                    label.text = comment;
                    size = [MYTOOL getSizeWithLabel:label];
                    left -= size.width;
                    label.frame = CGRectMake(left, top_height/2-size.height/2, size.width, size.height);
                    [self addSubview:label];
                }
                //图标
                {
                    left -= 16;
                    UIImageView * icon = [UIImageView new];
                    icon.image = [UIImage imageNamed:@"guanzhu"];
                    icon.frame = CGRectMake(left, top_height/2-5.5, 13, 11);
                    [self addSubview:icon];
                }
            }
            //浏览
            {
                //数字
                {
                    left -= 16;
                    NSString * comment = dictionary[@"browse"];
                    UILabel * label = [UILabel new];
                    label.font = font;
                    label.textColor = fontColor;
                    label.text = comment;
                    size = [MYTOOL getSizeWithLabel:label];
                    left -= size.width;
                    label.frame = CGRectMake(left, top_height/2-size.height/2, size.width, size.height);
                    [self addSubview:label];
                }
                //图标
                {
                    left -= 18;
                    UIImageView * icon = [UIImageView new];
                    icon.image = [UIImage imageNamed:@"browse"];
                    icon.frame = CGRectMake(left, top_height/2-4.5, 15, 9);
                    [self addSubview:icon];
                }
            }
        }
        //分割线
        {
            UIView * space = [UIView new];
            space.frame = CGRectMake(10, 40/195.0*height, WIDTH-20, 1);
            space.backgroundColor = MYCOLOR_240_240_240;
            [self addSubview:space];
        }
        //分割线下方坐标
        float top = 40/195.0*height + 1;
        //悬赏金上方坐标
        float btn_top = 120/195.0*height;
        //图片
        float left = 10;
        //中间
        {
            //图片高度
            float imgHeight = btn_top - top - 16;
            //图片
            {
                UIImageView * imgV = [UIImageView new];
                imgV.frame = CGRectMake(left, top + 8, imgHeight, imgHeight);
                [MYTOOL setImageIncludePrograssOfImageView:imgV withUrlString:dictionary[@"url"]];
                [self addSubview:imgV];
                left += imgHeight + 10;
            }
            //标题
            {
                top += 8;
                UILabel * label = [UILabel new];
                label.text = dictionary[@"title"];
                label.font = [UIFont systemFontOfSize:14];
                label.textColor = MYCOLOR_48_48_48;
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(left, top, size.width, size.height);
                [self addSubview:label];
            }
            //内容
            {
                UILabel * label = [UILabel new];
                label.text = dictionary[@"content"];
                label.font = [UIFont systemFontOfSize:11];
                label.textColor = [MYTOOL RGBWithRed:136 green:136 blue:136 alpha:1];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                //宽度
                float label_width = WIDTH - 10 - left;
                label.frame = CGRectMake(left, top + imgHeight/2.0-3, label_width, size.height*2);
                [self addSubview:label];
                label.numberOfLines = 0;
                if (size.width > label_width * 2 + label.font.pointSize * 2) {
                    
                }
            }
            //图片下方坐标
            float img_lower_top = top + imgHeight;
            //推广区域
            {
                UIImageView * icon = [UIImageView new];
                icon.image = [UIImage imageNamed:@"xtb"];
                icon.frame = CGRectMake(10, img_lower_top + (146/195.0*height-img_lower_top)/2.0-6.5, 37, 13);
                [self addSubview:icon];
                //区域文字
                {
                    UILabel * label = [UILabel new];
                    label.font = [UIFont systemFontOfSize:9];
                    label.text = dictionary[@"scope"];
                    label.textColor = MYCOLOR_144;
                    label.frame = icon.bounds;
                    [icon addSubview:label];
                    label.textAlignment = NSTextAlignmentCenter;
                }
                //推广价格
                {
                    UILabel * label = [UILabel new];
                    label.text = dictionary[@"money"];
                    label.textColor = [MYTOOL RGBWithRed:255 green:83 blue:95 alpha:1];
                    label.font = [UIFont systemFontOfSize:12];
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(10+37+10, icon.frame.origin.y+icon.frame.size.height/2-size.height/2, size.width, size.height);
                    [self addSubview:label];
                }
            }
        }
        float space_top = 146/195.0*height;
        //下方分割线
        {
            UIView * space = [UIView new];
            space.frame = CGRectMake(10, space_top, WIDTH-20, 1);
            space.backgroundColor = MYCOLOR_240_240_240;
            [self addSubview:space];
        }
        //下方中线
        float lowerMiddleTop = space_top + (height - space_top - 1) / 2.0;
        //线索提示
        {
            UILabel * label = [UILabel new];
            label.text = [NSString stringWithFormat:@"线索提供(%@)",dictionary[@"extensionCount"]];
            label.font = [UIFont systemFontOfSize:11];
            label.textColor = [MYTOOL RGBWithRed:61 green:61 blue:61 alpha:1];
            CGSize size = [MYTOOL getSizeWithLabel:label];
            label.frame = CGRectMake(10, lowerMiddleTop-size.height/2, size.width, size.height);
            [self addSubview:label];
        }
        //右侧按钮标志-arrow_right
        {
            UIImageView * icon = [UIImageView new];
            icon.image = [UIImage imageNamed:@"arrow_right"];
            icon.frame = CGRectMake(WIDTH - 18, lowerMiddleTop - 6, 7, 12);
            [self addSubview:icon];
        }
        NSArray * arr = dictionary[@"extensionList"];
        float img_height = (height - space_top)/2.0;//头像高度
        float space = 5;
        for (int i = 0; i < arr.count && i < 6; i ++) {
            NSString * urlString = arr[i];
            UIImageView * imgV = [UIImageView new];
            imgV.frame = CGRectMake(WIDTH - 18 - (i+1)*(space+img_height), lowerMiddleTop - img_height/2, img_height, img_height);
            imgV.layer.masksToBounds = true;
            imgV.layer.cornerRadius = img_height/2.0;
            [MYTOOL setImageIncludePrograssOfImageView:imgV withUrlString:urlString];
            [self addSubview:imgV];
        }
        
        /*
         @"extensionList":@[
         @"http://img2.imgtn.bdimg.com/it/u=3841221431,3458856896&fm=214&gp=0.jpg",
         @"http://img3.duitang.com/uploads/item/201510/11/20151011153646_e4XUM.png",
         @"http://img.jgzyw.com:8000/d/img/touxiang/2015/01/08/2015010800064318805.jpg",
         @"http://img4.duitang.com/uploads/item/201507/08/20150708134509_KdAUC.thumb.224_0.png   ",
         @"http://scimg.jb51.net/touxiang/201705/2017050421535596.jpg",
         @"http://k2.jsqq.net/uploads/allimg/1705/7_170523150407_6.jpg"
         ],
         */
        //编辑按钮
        {
            UIButton * btn = [UIButton new];btn.frame = CGRectMake(0, space_top, WIDTH, height - space_top);
            btn.tag = indexPath.section;
            [self addSubview:btn];
            [btn addTarget:delegate action:@selector(cellBtnCallback:) forControlEvents:UIControlEventTouchUpInside];
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
