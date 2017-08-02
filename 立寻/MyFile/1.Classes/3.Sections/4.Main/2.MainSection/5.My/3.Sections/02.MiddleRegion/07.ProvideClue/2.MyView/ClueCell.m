//
//  ClueCell.m
//  立寻
//
//  Created by mac on 2017/6/3.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "ClueCell.h"

@implementation ClueCell
-(instancetype)initWithDictionary:(NSDictionary *)dictionary andHeight:(float)height{
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
                label.text = [NSString stringWithFormat:@"提供线索时间：%@",dictionary[@"CreateTime"]];
                label.font = [UIFont systemFontOfSize:11];
                label.textColor = [MYTOOL RGBWithRed:144 green:144 blue:144 alpha:1];
                [self addSubview:label];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(27, 40/122.0*height/2 - size.height/2, size.width, size.height);
                [self addSubview:label];
            }
            //状态
            {
                UILabel * label = [UILabel new];
                int PublishStatus = [dictionary[@"PublishStatus"] intValue];
                NSString * text = @"";
                switch (PublishStatus) {
                    case 1:
                        text = @"待发布";
                        break;
                    case 2:
                        text = @"已发布";
                        break;
                    case 3:
                        text = @"已结束";
                        break;
                    default:
                        text = @"已完成";
                        break;
                }
                label.text = text;
                label.font = [UIFont systemFontOfSize:11];
                label.textColor = [MYTOOL RGBWithRed:255 green:101 blue:101 alpha:1];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(WIDTH - 10 - size.width, 40/122.0*height/2 - size.height/2, size.width, size.height);
                [self addSubview:label];
            }
        }
        //分割线
        {
            UIView * space = [UIView new];
            space.frame = CGRectMake(10, 40/122.0*height, WIDTH-20, 0.5);
            space.backgroundColor = MYCOLOR_240_240_240;
            [self addSubview:space];
        }
        //分割线下方坐标
        float top = 40/122.0*height + 0.5;
        //悬赏金上方坐标
        float btn_top = height;
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
            {
                top += 8;
                UILabel * label = [UILabel new];
                label.text = dictionary[@"PublishTitle"];
                label.font = [UIFont systemFontOfSize:15];
                label.textColor = MYCOLOR_48_48_48;
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(left, top, size.width, size.height);
                [self addSubview:label];
            }
            //内容
            {
                UILabel * label = [UILabel new];
                NSString * string = dictionary[@"PublishContent"];
                label.text = string;
                label.font = [UIFont systemFontOfSize:12];
                label.textColor = [MYTOOL RGBWithRed:136 green:136 blue:136 alpha:1];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                //宽度
                float label_width = WIDTH - 10 - left;
                label.frame = CGRectMake(left, top + imgHeight/2.0-3, label_width, 30);
                [self addSubview:label];
                label.numberOfLines = 0;
                NSMutableString * text = [NSMutableString new];
                for(int i = 0; i < string.length ; i ++){
                    NSString * sub = [string substringWithRange:NSMakeRange(i, 1)];
                    if (![sub isEqualToString:@"\n"] ) {
                        [text appendString:sub];
                    }
                    label.text = text;
                    size = [MYTOOL getSizeWithLabel:label];
                    if (size.width >= label_width * 1.8) {
                        NSLog(@"text:%@",text);
                        break;
                    }
                }
            }
        }
        
        /*
         @"url":@"",
         @"title":@"寻找我家狗狗",
         @"content":@""
         */
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
