//
//  FirstPageHeaderView.m
//  立寻
//
//  Created by mac on 2017/5/26.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "FirstPageHeaderView.h"
#import "LookForVC.h"
@interface FirstPageHeaderView()
@property(nonatomic,strong)UIButton * leftServiceBtn;//悬赏找寻
@property(nonatomic,strong)UIButton * rightServicBtn;//普通找寻
@property(nonatomic,strong)UIView * downBtnView;//找寻按钮下方view
@property(nonatomic,strong)UIButton * leftTypeBtn;//置顶
@property(nonatomic,strong)UIButton * rightTypeBtn;//最新
@property(nonatomic,strong)UIButton * signBtn;//签到按钮

@end
@implementation FirstPageHeaderView
-(instancetype)initWithFrame:(CGRect)frame andDelegate:(id)delegate andUpBannerArray:(NSArray *)upBannerArray andDownBannerArray:(NSArray *)downBannerArray andBtnName_imgArray:(NSArray *)btnName_imgArray{
    if (self = [super initWithFrame:frame]) {
        float all_height = 478;
        float height_all = frame.size.height;//头view的总高度
        self.backgroundColor = MYCOLOR_240_240_240;
        float top = 0;
        //上部banner
        {
            NSMutableArray * url_arr = [NSMutableArray new];
            for (NSDictionary * dic in upBannerArray) {
                [url_arr addObject:dic[@"imgpath"]];
            }
            SDCycleScrollView * cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, 125/all_height*height_all) imageURLStringsGroup:url_arr];
            cycleScrollView.delegate = delegate;
            [delegate setUpBannerView:cycleScrollView];
            [self addSubview:cycleScrollView];
            cycleScrollView.tag = 100;
            top = 125/all_height*height_all;
        }
        //中部按钮区
        {
            float height = 110/all_height*height_all;
            UIView * view = [UIView new];
            view.frame = CGRectMake(0, top, WIDTH, height);
            view.backgroundColor = [UIColor whiteColor];
            [self addSubview:view];
            for (int i = 0; i < btnName_imgArray.count; i ++) {
                int row = 0;//行
                int col = i % 5;//列
                float space_x = (WIDTH - 250) / 10.0;
                float space_y = (height - 80) / 2.0;
                float btn_width = space_x * 2 + 50;
                float btn_height = height;
                //图片
                {
                    UIButton * btn = [UIButton new];
                    [btn setImage:[UIImage imageNamed:btnName_imgArray[i][0]] forState:UIControlStateNormal];
                    btn.frame = CGRectMake(space_x + btn_width * col, space_y + btn_height * row, 50, 50);
                    if (row == 1) {
                        btn.frame = CGRectMake(space_x + btn_width * col, space_y + btn_height * row - 5, 50, 50);
                    }
                    [view addSubview:btn];
                    btn.tag = i;
                    [btn addTarget:delegate action:@selector(iconClick:) forControlEvents:UIControlEventTouchUpInside];
                }
                //文字
                {
                    UILabel * label = [UILabel new];
                    label.text = btnName_imgArray[i][1];
                    label.textColor = [MYTOOL RGBWithRed:16 green:16 blue:16 alpha:1];
                    label.font = [UIFont systemFontOfSize:14];
                    if (WIDTH < 360) {
                        label.font = [UIFont systemFontOfSize:13];
                    }
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.frame = CGRectMake(btn_width * col, 50 + space_y * 2 + btn_height * row - size.height / 2 + 5, btn_width, size.height);
                    if (row == 1) {
                        label.frame = CGRectMake(btn_width * col, 50 + space_y * 2 + btn_height * row - size.height / 2 - 5, btn_width, size.height);
                    }
                    [view addSubview:label];
                }
            }
            top += height;
        }
        //中间banner
        {
            float height = 170/all_height*height_all;
            UIView * view = [UIView new];
            view.frame = CGRectMake(0, top, WIDTH, height);
            view.backgroundColor = MYCOLOR_240_240_240;
            [self addSubview:view];
            UIView * view2 = [UIView new];
            view2.frame = CGRectMake(0, 5, WIDTH, height - 10);
            [view addSubview:view2];
            view2.backgroundColor = [UIColor whiteColor];
            float img_width = WIDTH*4/5.0;
            float img_height = height - 20;
            float scroll_width = 0;
            UIScrollView * scrollView = [UIScrollView new];
            scrollView.frame = view.bounds;
            [view2 addSubview:scrollView];
            [delegate setScrollView:scrollView];
            NSMutableArray * array = [NSMutableArray new];
            for (int i = 0; i < downBannerArray.count; i ++) {
                UIImageView * imgV = [UIImageView new];
                [array addObject:imgV];
                NSString * ss = downBannerArray[i][@"imgpath"];
                if ([ss isKindOfClass:[NSNull class]]) {
                    ss = @"";
                }
                [MYTOOL setImageIncludePrograssOfImageView:imgV withUrlString:ss];
                imgV.frame = CGRectMake(5 + (10 + img_width) * i, 5, img_width, img_height);
                [scrollView addSubview:imgV];
                imgV.tag = i;
                //添加点击事件
                [imgV setUserInteractionEnabled:YES];
                UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:delegate action:@selector(downBannerImageClick:)];
                tapGesture.numberOfTapsRequired=1;
                [imgV addGestureRecognizer:tapGesture];
                scroll_width += (10 + img_width);
            }
            [delegate setMiddle_img_array:array];
            scrollView.contentSize = CGSizeMake(scroll_width, 0);
            top += height;
        }
        //cell选择数据源view
        {
            float height = height_all - top;
            UIView * view = [UIView new];
            view.frame = CGRectMake(0, top, WIDTH, height);
            view.backgroundColor = [UIColor whiteColor];
            [self addSubview:view];
            //中间分割线
            {
                UIView * space = [UIView new];
                space.frame = CGRectMake(0, height/2 - 0.5, WIDTH, 1);
                space.backgroundColor = MYCOLOR_240_240_240;
                [view addSubview:space];
            }
            //两个服务选择按钮
            {
                //全国寻找服务
                {
                    UIButton * btn1 = [UIButton new];
                    [btn1 setTitle:@"全国找寻" forState:UIControlStateNormal];
                    btn1.titleLabel.font = [UIFont systemFontOfSize:15];
                    [btn1 setTitleColor:[MYTOOL RGBWithRed:40 green:199 blue:0 alpha:1] forState:UIControlStateNormal];
                    btn1.frame = CGRectMake(0, 0, WIDTH/2, height/2);
                    [view addSubview:btn1];
                    [btn1 addTarget:delegate action:@selector(selectServiceType:) forControlEvents:UIControlEventTouchUpInside];
                    self.leftServiceBtn = btn1;
                    btn1.enabled = false;
                    btn1.tag = 100;
                }
                //地区寻找服务
                {
                    UIButton * btn2 = [UIButton new];
                    [btn2 setTitle:@"地区寻找" forState:UIControlStateNormal];
                    btn2.titleLabel.font = [UIFont systemFontOfSize:15];
                    [btn2 setTitleColor:[MYTOOL RGBWithRed:49 green:49 blue:49 alpha:1] forState:UIControlStateNormal];
                    btn2.frame = CGRectMake(WIDTH/2, 0, WIDTH/2, height/2);
                    [view addSubview:btn2];
                    [btn2 addTarget:delegate action:@selector(selectServiceType:) forControlEvents:UIControlEventTouchUpInside];
                    self.rightServicBtn = btn2;
                    btn2.tag = 200;
                }
                //按钮下方状态view
                {
                    UIView * downBtnView = [UIView new];
                    self.downBtnView = downBtnView;
                    downBtnView.frame = CGRectMake(0, height/2-1.5, WIDTH/2, 3);
                    downBtnView.backgroundColor = [MYTOOL RGBWithRed:40 green:199 blue:0 alpha:1];
                    [view addSubview:downBtnView];
                    downBtnView.layer.masksToBounds = true;
                    downBtnView.layer.cornerRadius = 1.5;
                }
            }
            //置顶、最新按钮
            {
                //置顶-zhiding
                {
                    UIButton * btn = [UIButton new];
                    self.leftTypeBtn = btn;
                    btn.tag = 100;
                    [btn setTitle:@"置顶" forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:13];
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
                    [btn setTitleColor:[MYTOOL RGBWithRed:64 green:64 blue:64 alpha:1] forState:UIControlStateNormal];
                    [btn setBackgroundImage:[UIImage imageNamed:@"zuixin"] forState:UIControlStateNormal];
                    [btn setBackgroundImage:[UIImage imageNamed:@"zhiding"] forState:UIControlStateDisabled];
                    
                    btn.frame = CGRectMake(10, height/4.0*3-10, 50, 20);
                    [view addSubview:btn];
                    btn.enabled = false;
                    [btn addTarget:delegate action:@selector(up_newClick:) forControlEvents:UIControlEventTouchUpInside];
                }
                //最新-zuixin
                {
                    UIButton * btn = [UIButton new];
                    btn.tag = 200;
                    self.rightTypeBtn = btn;
                    [btn setTitle:@"最新" forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:13];
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
                    [btn setTitleColor:[MYTOOL RGBWithRed:64 green:64 blue:64 alpha:1] forState:UIControlStateNormal];
                    [btn setBackgroundImage:[UIImage imageNamed:@"zuixin"] forState:UIControlStateNormal];
                    [btn setBackgroundImage:[UIImage imageNamed:@"zhiding"] forState:UIControlStateDisabled];
                    btn.frame = CGRectMake(10+5+50, height/4.0*3-10, 50, 20);
                    [view addSubview:btn];
                    [btn addTarget:delegate action:@selector(up_newClick:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
        [delegate selectServiceType:self.leftServiceBtn];
        [delegate up_newClick:self.leftTypeBtn];
    }
    return self;
}
-(void)selectBtnForUpOrNew:(UIButton *)btn{
    if (btn.tag == 100) {//选中置顶
        self.leftTypeBtn.enabled = false;
        self.rightTypeBtn.enabled = true;
    }else{//选中最新
        self.rightTypeBtn.enabled = false;
        self.leftTypeBtn.enabled = true;
    }
}
-(void)selectServiceCallback:(NSInteger)tag{
    //默认选中置顶
    self.leftTypeBtn.enabled = false;
    self.rightTypeBtn.enabled = true;
    if (tag == 100) {
        //左按钮选中
        [self.leftServiceBtn setTitleColor:[MYTOOL RGBWithRed:40 green:199 blue:0 alpha:1] forState:UIControlStateNormal];
        //不可用
        self.leftServiceBtn.enabled = false;
        //状态view
        [UIView animateWithDuration:0.3 animations:^{
            self.downBtnView.frame = CGRectMake(0, self.downBtnView.frame.origin.y, WIDTH/2, 3);
        }];
        //右侧按钮非选中
        [self.rightServicBtn setTitleColor:[MYTOOL RGBWithRed:49 green:49 blue:49 alpha:1] forState:UIControlStateNormal];
        //右侧按钮可用
        self.rightServicBtn.enabled = true;
    }else{
        //右按钮选中
        [self.rightServicBtn setTitleColor:[MYTOOL RGBWithRed:40 green:199 blue:0 alpha:1] forState:UIControlStateNormal];
        //右按钮不可用
        self.rightServicBtn.enabled = false;
        //状态view
        [UIView animateWithDuration:0.3 animations:^{
            self.downBtnView.frame = CGRectMake(WIDTH/2, self.downBtnView.frame.origin.y, WIDTH/2, 3);
        }];
        //左侧按钮非选中
        [self.leftServiceBtn setTitleColor:[MYTOOL RGBWithRed:49 green:49 blue:49 alpha:1] forState:UIControlStateNormal];
        //左侧按钮可用
        self.leftServiceBtn.enabled = true;
    }
    
}
@end
