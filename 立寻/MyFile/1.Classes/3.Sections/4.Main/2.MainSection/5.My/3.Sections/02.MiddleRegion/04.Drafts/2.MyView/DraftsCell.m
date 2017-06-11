//
//  DraftsCell.m
//  立寻
//
//  Created by mac on 2017/6/3.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "DraftsCell.h"
#import "DraftsVC.h"
@implementation DraftsCell


-(instancetype)initWithDictionary:(NSDictionary *)dictionary andHeight:(float)height andDelegate:(id)delegate andIndexPath:(NSIndexPath *)indexPath{
    if (self = [super init]) {
        //最新编辑时间
        {
            //图标
            {
                UIImageView * icon = [UIImageView new];
                icon.image = [UIImage imageNamed:@"time"];
                icon.frame = CGRectMake(10, 40/145.0*height/2-6, 12, 12);
                [self addSubview:icon];
            }
            //时间文本
            {
                UILabel * label = [UILabel new];
                label.text = [NSString stringWithFormat:@"最新编辑时间：%@",dictionary[@"UpdateTime"]];
                label.font = [UIFont systemFontOfSize:10];
                label.textColor = [MYTOOL RGBWithRed:144 green:144 blue:144 alpha:1];
                [self addSubview:label];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(27, 40/145.0*height/2 - size.height/2, size.width, size.height);
                [self addSubview:label];
            }
        }
        //分割线
        {
            UIView * space = [UIView new];
            space.frame = CGRectMake(10, 40/145.0*height, WIDTH-20, 0.5);
            space.backgroundColor = MYCOLOR_240_240_240;
            [self addSubview:space];
        }
        //分割线下方坐标
        float top = 40/145.0*height + 0.5;
        //悬赏金上方坐标
        float btn_top = height - 22;
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
                label.text = dictionary[@"Title"];
                label.font = [UIFont systemFontOfSize:14];
                label.textColor = MYCOLOR_48_48_48;
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(left, top, size.width, size.height);
                [self addSubview:label];
            }
            //内容
            {
                UILabel * label = [UILabel new];
                label.text = dictionary[@"Content"];
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
        }
        
        
        
        
        
        //悬赏金
        {
            //图标
            {
                UIImageView * icon = [UIImageView new];
                icon.image = [UIImage imageNamed:@"btn_xsj_xs"];
                icon.frame = CGRectMake(10, btn_top, 37, 13);
                [self addSubview:icon];
            }
            //悬赏金额
            {
                UILabel * label = [UILabel new];
                NSString * money = dictionary[@"Money"];
                label.font = [UIFont systemFontOfSize:12];
                label.text = [NSString stringWithFormat:@"%@元",money];
                label.textColor = [MYTOOL RGBWithRed:255 green:83 blue:95 alpha:1];
                [self addSubview:label];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(57, btn_top, size.width, size.height);
            }
        }
        //编辑按钮
        {
            UIButton * btn = [UIButton new];
            [btn setBackgroundImage:[UIImage imageNamed:@"list_opt"] forState:UIControlStateNormal];
            [btn setTitle:@"编辑" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn setTitleColor:[MYTOOL RGBWithRed:103 green:176 blue:250 alpha:1] forState:UIControlStateNormal];
            btn.frame = CGRectMake(WIDTH - 10 - 64, btn_top-4.5, 64, 22);
            btn.tag = indexPath.section;
            [self addSubview:btn];
            [btn addTarget:delegate action:@selector(cellEditCallback:) forControlEvents:UIControlEventTouchUpInside];
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
