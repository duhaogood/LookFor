//
//  NetworkSocialCell.m
//  立寻
//
//  Created by Mac on 17/6/17.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "NetworkSocialCell.h"
#import "NetworkSocialVC.h"
@implementation NetworkSocialCell


-(instancetype)initWithDictionary:(NSDictionary *)dictionary andHeight:(float)height andDelegate:(id)delegate andIndexPath:(NSIndexPath *)indexPath{
    if (self = [super init]) {
        //最新编辑时间
        {
            //图标
            {
                UIImageView * icon = [UIImageView new];
                icon.image = [UIImage imageNamed:@"time"];
                icon.frame = CGRectMake(10, 40/122.0*height/2-6, 12, 12);
                [self addSubview:icon];
            }
            //时间文本
            {
                UILabel * label = [UILabel new];
                label.text = [NSString stringWithFormat:@"发布时间：%@",dictionary[@"CreateTime"]];
                label.font = [UIFont systemFontOfSize:11];
                label.textColor = [MYTOOL RGBWithRed:144 green:144 blue:144 alpha:1];
                [self addSubview:label];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(27, 40/122.0*height/2 - size.height/2, size.width, size.height);
                [self addSubview:label];
            }
        }
        //右侧3个数字及图标
        {
            float top_height = 40/122.0*height;
            float left = WIDTH - 10;
            UIFont * font = [UIFont systemFontOfSize:10];
            UIColor * fontColor = MYCOLOR_144;
            CGSize size;
            //评论
            {
                //数字
                {
                    NSString * comment = [NSString stringWithFormat:@"%d", [dictionary[@"CommentCount"] intValue]];
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
                    NSString * comment = [NSString stringWithFormat:@"%d", [dictionary[@"FollowCount"] intValue]];
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
                    NSString * comment = [NSString stringWithFormat:@"%d", [dictionary[@"VisitCount"] intValue]];
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
            space.frame = CGRectMake(10, 40/122.0*height, WIDTH-20, 1);
            space.backgroundColor = MYCOLOR_240_240_240;
            [self addSubview:space];
        }
        //分割线下方坐标
        float top = 40/122.0*height + 1;
        //悬赏金上方坐标
        float btn_top = 120/122.0*height;
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
                [MYTOOL setImageIncludePrograssOfImageView:imgV withUrlString:dictionary[@"PicturePath"]];
                [self addSubview:imgV];
                left += imgHeight + 10;
            }
            //标题
            float title_middle_top = 0;
            {
                top += 8;
                UILabel * label = [UILabel new];
                label.text = dictionary[@"Title"];
                label.font = [UIFont systemFontOfSize:15];
                label.textColor = MYCOLOR_48_48_48;
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(left, top, size.width, size.height);
                [self addSubview:label];
                title_middle_top = top + size.height/2;
            }
            //状态
            {
                UILabel * label = [UILabel new];
                label.text = dictionary[@"state"];
                label.font = [UIFont systemFontOfSize:11];
                label.textColor = [MYTOOL RGBWithRed:255 green:101 blue:101 alpha:1];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(WIDTH - 15 - size.width, title_middle_top-size.height/2, size.width, size.height);
//                [self addSubview:label];
            }
            //内容
            {
                UILabel * label = [UILabel new];
                label.text = dictionary[@"Content"];
                label.font = [UIFont systemFontOfSize:12];
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
