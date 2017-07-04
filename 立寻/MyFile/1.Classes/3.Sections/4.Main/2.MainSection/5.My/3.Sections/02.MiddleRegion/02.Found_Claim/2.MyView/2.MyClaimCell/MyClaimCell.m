//
//  MyClaimCell.m
//  立寻
//
//  Created by mac on 2017/6/3.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "MyClaimCell.h"
#import "Found_ClaimVC.h"
@implementation MyClaimCell


-(instancetype)initWithDictionary:(NSDictionary *)dictionary andHeight:(float)height andDelegate:(id)delegate andIndexPath:(NSIndexPath *)indexPath{
    if (self = [super init]) {
        float left = 0;
        //头像
        {
            float top_height = 40/146.0*height;//第一个分割线y坐标
            float imgHeight = top_height*0.7;//图片高度
            UIImageView * imgV = [UIImageView new];
            imgV.frame = CGRectMake(10, top_height*0.15, imgHeight, imgHeight);
            imgV.layer.masksToBounds = true;
            imgV.layer.cornerRadius = imgHeight/2.0;
            [self addSubview:imgV];
            [imgV sd_setImageWithURL:[NSURL URLWithString:dictionary[@"ImgFilePath"]] placeholderImage:[UIImage imageNamed:@"morenhdpic"]];
            left = 10 + imgHeight + 10;
        }
        //用户昵称
        {
            UILabel * label = [UILabel new];
            label.text = dictionary[@"UserName"];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = MYCOLOR_48_48_48;
            CGSize size = [MYTOOL getSizeWithLabel:label];
            label.frame = CGRectMake(left, 40/146.0*height/2.0 - size.height/2, size.width, size.height);
            [self addSubview:label];
        }
        //认领时间
        {
            left = 0;
            //时间文本
            {
                UILabel * label = [UILabel new];
                label.text = [NSString stringWithFormat:@"认领时间：%@",dictionary[@"CheckTime"]];
                label.font = [UIFont systemFontOfSize:11];
                label.textColor = [MYTOOL RGBWithRed:144 green:144 blue:144 alpha:1];
                [self addSubview:label];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(WIDTH-10-size.width, 40/146.0*height/2 - size.height/2, size.width, size.height);
                [self addSubview:label];
                left = WIDTH-10-size.width;
            }
            //图标
            {
                UIImageView * icon = [UIImageView new];
                icon.image = [UIImage imageNamed:@"time"];
                icon.frame = CGRectMake(left-12-5, 40/146.0*height/2-6, 12, 12);
                [self addSubview:icon];
            }
            
        }
        
        //分割线
        {
            UIView * space = [UIView new];
            space.frame = CGRectMake(10, 40/146.0*height, WIDTH-20, 1);
            space.backgroundColor = MYCOLOR_240_240_240;
            [self addSubview:space];
        }
        //分割线下方坐标
        float top = 40/146.0*height + 1;
        //悬赏金上方坐标
        float btn_top = 120/146.0*height;
        //图片
        left = 10;
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
                label.text = dictionary[@"PublishTitle"];
                label.font = [UIFont systemFontOfSize:15];
                label.textColor = MYCOLOR_48_48_48;
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(left, top, size.width, size.height);
                [self addSubview:label];
                title_middle_top = top + size.height/2;
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
            //图片下方坐标
            float img_lower_top = top + imgHeight;
            //认领金区域
            {
                UIImageView * icon = [UIImageView new];
                icon.image = [UIImage imageNamed:@"xtb"];
                icon.frame = CGRectMake(10, img_lower_top + (146/146.0*height-img_lower_top)/2.0-6.5, 37, 13);
                [self addSubview:icon];
                //区域文字
                {
                    UILabel * label = [UILabel new];
                    label.font = [UIFont systemFontOfSize:10];
                    label.text = @"认领金";
                    label.textColor = MYCOLOR_144;
                    label.frame = icon.bounds;
                    [icon addSubview:label];
                    label.textAlignment = NSTextAlignmentCenter;
                }
                //认领价格
                {
                    UILabel * label = [UILabel new];
                    label.text = [NSString stringWithFormat:@"%@元", dictionary[@"PublishMoney"]];
                    label.textColor = [MYTOOL RGBWithRed:255 green:83 blue:95 alpha:1];
                    label.font = [UIFont systemFontOfSize:13];
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(10+37+10, icon.frame.origin.y+icon.frame.size.height/2-size.height/2, size.width, size.height);
                    [self addSubview:label];
                }
                //状态
                {
                    UILabel * label = [UILabel new];
                    int CheckState = [dictionary[@"CheckState"] intValue];
                    NSString * text = @"";
                    switch (CheckState) {
                        case 1:
                            text = @"待审核";
                            break;
                        case 2:
                            text = @"审核通过";
                            break;
                        case 3:
                            text = @"审核不通过";
                            break;
                    }
                    label.text = text;
                    label.font = [UIFont systemFontOfSize:9];
                    label.textColor = [UIColor whiteColor];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.backgroundColor = MYCOLOR_40_199_0;
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.layer.masksToBounds = true;
                    label.layer.cornerRadius = (size.height + 4)/2.0;
                    label.frame = CGRectMake(WIDTH - 15 - size.width, icon.frame.origin.y+icon.frame.size.height/2-size.height/2, size.width + 10, size.height+4);
                    [self addSubview:label];
                }
            }
        }
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
