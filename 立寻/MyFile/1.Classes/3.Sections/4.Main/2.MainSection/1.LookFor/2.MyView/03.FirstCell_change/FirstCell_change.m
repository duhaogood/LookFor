//
//  FirstCell_change.m
//  立寻
//
//  Created by Mac on 17/8/10.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "FirstCell_change.h"

@implementation FirstCell_change

-(instancetype)initWithLeft:(NSDictionary *)leftDic andRight:(NSDictionary *)rightDic andArray:(NSArray *)array andDelegate:(id)delegate{
    if (self = [super init]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //高度
        float height = (WIDTH - 30)/2.0 + 70;
        //左侧
        {
            float top = 5;
            float left = 10;
            //图片
            {
                float img_height = (WIDTH - 30)/2.0;
                NSString * ImgFilePath = leftDic[@"PictureList"][0][@"ImgFilePath"];
                UIImageView * imgV = [UIImageView new];
                imgV.frame = CGRectMake(10, top, (WIDTH - 30)/2.0,img_height) ;
                [self addSubview:imgV];
                imgV.contentMode = UIViewContentModeScaleAspectFill;
                imgV.clipsToBounds=YES;//  是否剪切掉超出 UIImageView 范围的图片
                [imgV setContentScaleFactor:[[UIScreen mainScreen] scale]];
                [MYTOOL setImageIncludePrograssOfImageView:imgV withUrlString:ImgFilePath];
                top += img_height + 10;
                NSInteger index = [array indexOfObject:leftDic];
                imgV.tag = index;
                //添加点击事件
                imgV.userInteractionEnabled = true;
                UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:delegate action:@selector(cellImageClick:)];
                tapGesture.numberOfTapsRequired=1;
                [imgV addGestureRecognizer:tapGesture];
                //浏览和关注
                {
                    //背景
                    UIView * view = [UIView new];
                    view.frame = CGRectMake((WIDTH - 30)/4.0, img_height - 25, (WIDTH - 30)/4.0-5, 20);
                    view.backgroundColor = [MYTOOL RGBWithRed:10 green:10 blue:10 alpha:0.45];
                    [imgV addSubview:view];
                    view.layer.masksToBounds = true;
                    view.layer.cornerRadius = 10;
                    float img_left = 10;
                    /**/
                    //浏览
                    {
                        UIImageView * icon = [UIImageView new];
                        icon.image = [UIImage imageNamed:@"yuedu_white"];
                        icon.frame = CGRectMake(img_left, 3, 14, 14);
                        [view addSubview:icon];
                        img_left = 24 + 5;
                    }
                    //浏览数
                    {
                        NSNumber * number = leftDic[@"VisitCount"];
                        UILabel * label = [UILabel new];
                        label.font = [UIFont systemFontOfSize:10];
                        label.text = [NSString stringWithFormat:@"%ld",[number longValue]];
                        label.textColor = [UIColor whiteColor];
                        CGSize size = [MYTOOL getSizeWithLabel:label];
                        label.frame = CGRectMake(img_left, (20 - size.height)/2.0, size.width, size.height);
                        [view addSubview:label];
                        img_left += size.width + 10;
                    }
                    //关注
                    {
                        UIImageView * icon = [UIImageView new];
                        icon.image = [UIImage imageNamed:@"gz_white"];
                        icon.frame = CGRectMake(img_left, 3, 14, 14);
                        [view addSubview:icon];
                        img_left += 14 + 5;
                    }
                    //关注数
                    {
                        NSNumber * number = leftDic[@"FollowCount"];
                        UILabel * label = [UILabel new];
                        label.font = [UIFont systemFontOfSize:10];
                        label.text = [NSString stringWithFormat:@"%ld",[number longValue]];
                        label.textColor = [UIColor whiteColor];
                        CGSize size = [MYTOOL getSizeWithLabel:label];
                        label.frame = CGRectMake(img_left, (20 - size.height)/2.0, size.width, size.height);
                        [view addSubview:label];
                        img_left += size.width + 10;
                    }
                    if (img_left > view.frame.size.width) {
                        view.frame = CGRectMake((WIDTH - 30)/2.0 - 5 - img_left, img_height - 35, img_left, 30);
                    }
                }
            }
            //省份
            {
                NSString * ProvinceName = leftDic[@"ProvinceName"];
                UILabel * label = [UILabel new];
                label.font = [UIFont systemFontOfSize:14];
                label.text = ProvinceName;
                label.textColor = [MYTOOL RGBWithRed:51 green:51 blue:51 alpha:1];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(left, top, size.width, size.height);
                [self addSubview:label];
                left += size.width + 5;
            }
            //距离
            {
                NSString * Latitude = leftDic[@"Latitude"];
                NSString * Longitude = leftDic[@"Longitude"];
                double lat = [Latitude doubleValue];
                double lon = [Longitude doubleValue];
                NSString * distance = @"(距离您1100KM)";
                UILabel * label = [UILabel new];
                label.font = [UIFont systemFontOfSize:14];
                label.text = distance;
                label.textColor = [MYTOOL RGBWithRed:187 green:187 blue:187 alpha:1];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(left, top, (WIDTH - 30)/2.0 - left - 10, size.height);
                if (lat && lon && DHTOOL.appLocation) {
                    [self addSubview:label];
                    CLLocation * location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
                    float distance_float = [MYTOOL distanceBetweenBMKuserLocationA:location andLocationB:MYTOOL.appLocation];
                    distance = [NSString stringWithFormat:@"(距离您%dKM)",(int)(distance_float / 1000)];
                    label.text = distance;
                }
                top += size.height + 5;
                left += size.width + 5;
            }
            //日期
            {
                NSString * CreateTime = leftDic[@"CreateTime"];
                top += 5;
                UILabel * label = [UILabel new];
                label.font = [UIFont systemFontOfSize:10];
                label.textColor = [MYTOOL RGBWithRed:187 green:187 blue:187 alpha:1];
                NSInteger index = [CreateTime rangeOfString:@"T"].location;
                NSString * time = @"";
                if (index > 0 && index < CreateTime.length) {
                    time = [CreateTime substringToIndex:index];
                }
                label.text = time;
                CGSize size = [MYTOOL getSizeWithLabel:label];
                left = 10;
                label.frame = CGRectMake(left, top, size.width, size.height);
                [self addSubview:label];
                left += size.width + 10;
                top += size.height;
            }
            //感谢金-提示
            {
                UILabel * label = [UILabel new];
                label.text = @"感谢金";
                label.textColor = [MYTOOL RGBWithRed:187 green:187 blue:187 alpha:1];
                label.font = [UIFont systemFontOfSize:13];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(left, top - size.height, size.width, size.height);
                [self addSubview:label];
                left += size.width;
            }
            //感谢金
            {
                NSInteger Money = [leftDic[@"Money"] longValue];
                NSString * money = [NSString stringWithFormat:@"￥%ld",Money];
                UILabel * label = [UILabel new];
                label.text = money;
                label.textColor = [MYTOOL RGBWithRed:255 green:74 blue:74 alpha:1];
                label.font = [UIFont systemFontOfSize:13];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(left, top - size.height, size.width, size.height);
                [self addSubview:label];
            }
            
            
            
        }
        //右侧
        {
            if (rightDic) {
                float top = 5;
                float left = WIDTH / 2.0 + 10;
                //图片
                {
                    float img_height = (WIDTH - 30)/2.0;
                    NSString * ImgFilePath = rightDic[@"PictureList"][0][@"ImgFilePath"];
                    UIImageView * imgV = [UIImageView new];
                    imgV.frame = CGRectMake(WIDTH/2.0+5, 5, (WIDTH - 30)/2.0, img_height);
                    [self addSubview:imgV];
                    imgV.contentMode = UIViewContentModeScaleAspectFill;
                    imgV.clipsToBounds=YES;//  是否剪切掉超出 UIImageView 范围的图片
                    [imgV setContentScaleFactor:[[UIScreen mainScreen] scale]];
                    [MYTOOL setImageIncludePrograssOfImageView:imgV withUrlString:ImgFilePath];
                    top += img_height + 10;
                    NSInteger index = [array indexOfObject:rightDic];
                    imgV.tag = index;
                    //添加点击事件
                    imgV.userInteractionEnabled = true;
                    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:delegate action:@selector(cellImageClick:)];
                    tapGesture.numberOfTapsRequired=1;
                    [imgV addGestureRecognizer:tapGesture];
                    //浏览和关注
                    {
                        //背景
                        UIView * view = [UIView new];
                        view.frame = CGRectMake((WIDTH - 30)/4.0, img_height - 25, (WIDTH - 30)/4.0-5, 20);
                        view.backgroundColor = [MYTOOL RGBWithRed:10 green:10 blue:10 alpha:0.45];
                        [imgV addSubview:view];
                        view.layer.masksToBounds = true;
                        view.layer.cornerRadius = 10;
                        float img_left = 10;
                        /**/
                        //浏览
                        {
                            UIImageView * icon = [UIImageView new];
                            icon.image = [UIImage imageNamed:@"yuedu_white"];
                            icon.frame = CGRectMake(img_left, 3, 14, 14);
                            [view addSubview:icon];
                            img_left = 24 + 5;
                        }
                        //浏览数
                        {
                            NSNumber * number = rightDic[@"VisitCount"];
                            UILabel * label = [UILabel new];
                            label.font = [UIFont systemFontOfSize:10];
                            label.text = [NSString stringWithFormat:@"%ld",[number longValue]];
                            label.textColor = [UIColor whiteColor];
                            CGSize size = [MYTOOL getSizeWithLabel:label];
                            label.frame = CGRectMake(img_left, (20 - size.height)/2.0, size.width, size.height);
                            [view addSubview:label];
                            img_left += size.width + 10;
                        }
                        //关注
                        {
                            UIImageView * icon = [UIImageView new];
                            icon.image = [UIImage imageNamed:@"gz_white"];
                            icon.frame = CGRectMake(img_left, 3, 14, 14);
                            [view addSubview:icon];
                            img_left += 14 + 5;
                        }
                        //关注数
                        {
                            NSNumber * number = rightDic[@"FollowCount"];
                            UILabel * label = [UILabel new];
                            label.font = [UIFont systemFontOfSize:10];
                            label.text = [NSString stringWithFormat:@"%ld",[number longValue]];
                            label.textColor = [UIColor whiteColor];
                            CGSize size = [MYTOOL getSizeWithLabel:label];
                            label.frame = CGRectMake(img_left, (20 - size.height)/2.0, size.width, size.height);
                            [view addSubview:label];
                            img_left += size.width + 10;
                        }
                        if (img_left > view.frame.size.width) {
                            view.frame = CGRectMake((WIDTH - 30)/2.0 - 5 - img_left, img_height - 35, img_left, 30);
                        }
                    }
                }
                //省份
                {
                    NSString * ProvinceName = rightDic[@"ProvinceName"];
                    UILabel * label = [UILabel new];
                    label.font = [UIFont systemFontOfSize:14];
                    label.text = ProvinceName;
                    label.textColor = [MYTOOL RGBWithRed:51 green:51 blue:51 alpha:1];
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(left, top, size.width, size.height);
                    [self addSubview:label];
                    left += size.width + 5;
                }
                //距离
                {
                    NSString * Latitude = rightDic[@"Latitude"];
                    NSString * Longitude = rightDic[@"Longitude"];
                    double lat = [Latitude doubleValue];
                    double lon = [Longitude doubleValue];
                    NSString * distance = @"(距离您1100KM)";
                    UILabel * label = [UILabel new];
                    label.font = [UIFont systemFontOfSize:14];
                    label.text = distance;
                    label.textColor = [MYTOOL RGBWithRed:187 green:187 blue:187 alpha:1];
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(left, top, (WIDTH - 30)/2.0 - left - 10, size.height);
                    if (lat && lon && DHTOOL.appLocation) {
                        [self addSubview:label];
                        CLLocation * location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
                        float distance_float = [MYTOOL distanceBetweenBMKuserLocationA:location andLocationB:MYTOOL.appLocation];
                        distance = [NSString stringWithFormat:@"(距离您%dKM)",(int)(distance_float / 1000)];
                        label.text = distance;
                    }
                    top += size.height + 5;
                    left += size.width + 5;
                }
                //日期
                {
                    NSString * CreateTime = rightDic[@"CreateTime"];
                    top += 5;
                    UILabel * label = [UILabel new];
                    label.font = [UIFont systemFontOfSize:10];
                    label.textColor = [MYTOOL RGBWithRed:187 green:187 blue:187 alpha:1];
                    NSInteger index = [CreateTime rangeOfString:@"T"].location;
                    NSString * time = @"";
                    if (index > 0 && index < CreateTime.length) {
                        time = [CreateTime substringToIndex:index];
                    }
                    label.text = time;
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    left = WIDTH/2 + 10;
                    label.frame = CGRectMake(left, top, size.width, size.height);
                    [self addSubview:label];
                    left += size.width + 10;
                    top += size.height;
                }
                //感谢金-提示
                {
                    UILabel * label = [UILabel new];
                    label.text = @"感谢金";
                    label.textColor = [MYTOOL RGBWithRed:187 green:187 blue:187 alpha:1];
                    label.font = [UIFont systemFontOfSize:13];
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(left, top - size.height, size.width, size.height);
                    [self addSubview:label];
                    left += size.width;
                }
                //感谢金
                {
                    NSInteger Money = [rightDic[@"Money"] longValue];
                    NSString * money = [NSString stringWithFormat:@"￥%ld",Money];
                    UILabel * label = [UILabel new];
                    label.text = money;
                    label.textColor = [MYTOOL RGBWithRed:255 green:74 blue:74 alpha:1];
                    label.font = [UIFont systemFontOfSize:13];
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(left, top - size.height, size.width, size.height);
                    [self addSubview:label];
                }
                
                
            }
        }
        
        //分割线
        UIView * space = [UIView new];
        space.frame = CGRectMake(0, height-1, WIDTH, 1);
        space.backgroundColor = MYCOLOR_240_240_240;
        [self addSubview:space];
    }
    return self;
}







- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
