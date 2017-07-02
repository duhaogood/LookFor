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
        float height_all = frame.size.height;//头view的总高度
        self.backgroundColor = MYCOLOR_240_240_240;
        float top = 0;
        //上部banner
        {
            NSMutableArray * url_arr = [NSMutableArray new];
            for (NSDictionary * dic in upBannerArray) {
                [url_arr addObject:dic[@"imgpath"]];
            }
            SDCycleScrollView * cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, 125/550.0*height_all) imageURLStringsGroup:url_arr];
            cycleScrollView.delegate = delegate;
            [delegate setUpBannerView:cycleScrollView];
            [self addSubview:cycleScrollView];
            cycleScrollView.tag = 100;
            top = 125/550.0*height_all;
        }
        //中部按钮区
        {
            float height = 197/550.0*height_all;
            UIView * view = [UIView new];
            view.frame = CGRectMake(0, top, WIDTH, height);
            view.backgroundColor = [UIColor whiteColor];
            [self addSubview:view];
            for (int i = 0; i < 8; i ++) {
                int row = i / 4;//行
                int col = i % 4;//列
                float space_x = (WIDTH - 200) / 8.0;
                float space_y = (height / 2.0 - 50) / 3.0;
                float btn_width = space_x * 2 + 50;
                float btn_height = height / 2;
                //图片
                {
                    UIButton * btn = [UIButton new];
                    [btn setImage:[UIImage imageNamed:btnName_imgArray[i][0]] forState:UIControlStateNormal];
                    btn.frame = CGRectMake(space_x + btn_width * col, space_y + btn_height * row, 50, 50);
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
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.frame = CGRectMake(btn_width * col, 50 + space_y * 2 + btn_height * row - size.height / 2, btn_width, size.height);
                    [view addSubview:label];
                }
            }
            top += height;
        }
        //签到、积分
        {
            float height = 60/550.0*height_all;
            UIView * bgView = [UIView new];
            bgView.frame = CGRectMake(0, top, WIDTH, height);
            bgView.backgroundColor = [UIColor blueColor];
            [self addSubview:bgView];
            //分割线
            {
                UIView * space = [UIView new];
                space.frame = CGRectMake(0, 0, WIDTH, 1);
                space.backgroundColor = MYCOLOR_240_240_240;
                [bgView addSubview:space];
            }
            //主view
            {
                UIView * view = [UIView new];
                view.frame = CGRectMake(0, 1, WIDTH, height - 7);
                view.backgroundColor = [UIColor whiteColor];
                [bgView addSubview:view];
                //右侧签到按钮
                {
                    float btn_width = 80;
                    float btn_height = 28;
                    UIButton * btn = [UIButton new];
                    self.signBtn = btn;
                    btn.frame = CGRectMake(WIDTH - 80 - 15, (height - 35) / 2.0, btn_width, btn_height);
                    btn.layer.masksToBounds = true;
                    btn.layer.cornerRadius = btn_height/2;
                    [btn.layer setBorderWidth:1];
                    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0, 1, 0, 1 });
                    [btn.layer setBorderColor:colorref];
                    [btn setTitle:@"签到" forState:UIControlStateNormal];
                    [btn setTitleColor:MYCOLOR_40_199_0 forState:UIControlStateNormal];
                    [view addSubview:btn];
                    [btn addTarget:delegate action:@selector(signClick:) forControlEvents:UIControlEventTouchUpInside];
                    [delegate setSignBtn:btn];
                }
                //中间分割线
                {
                    UIView * space = [UIView new];
                    space.backgroundColor = MYCOLOR_240_240_240;
                    space.frame = CGRectMake(WIDTH - 80 - 30, (height - 35) / 2.0, 1, 28);
                    [view addSubview:space];
                }
                float sign_down = 0;
                //签到加积分
                {
                    UILabel * label = [UILabel new];
                    label.text = @"签到加积分";
                    label.textColor = [MYTOOL RGBWithRed:51 green:51 blue:51 alpha:1];
                    label.font = [UIFont systemFontOfSize:15];
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(14, (height - 7)/4-size.height/2, size.width, size.height);
                    [view addSubview:label];
                    sign_down = (height - 7)/4-size.height/2 + size.height;
                }
                //描述
                {
                    UILabel * label = [UILabel new];
                    label.text = @"可在积分商城直接退换商品，开发中";
                    label.textColor = [MYTOOL RGBWithRed:168 green:168 blue:168 alpha:1];
                    label.font = [UIFont systemFontOfSize:12];
                    if (WIDTH < 375) {
                        label.font = [UIFont systemFontOfSize:10];
                    }
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(14, sign_down + 7, size.width, size.height);
                    [view addSubview:label];
                }
            }
            //分割线
            {
                UIView * space = [UIView new];
                space.frame = CGRectMake(0, height-6, WIDTH, 6);
                space.backgroundColor = MYCOLOR_240_240_240;
                [bgView addSubview:space];
            }
            top += height;
        }
        //中间banner
        {
            float height = 95/550.0*height_all;
            UIView * view = [UIView new];
            view.frame = CGRectMake(0, top, WIDTH, height);
            view.backgroundColor = MYCOLOR_240_240_240;
            [self addSubview:view];
            //横向滑动scrollView
            UIScrollView * scrollView = [UIScrollView new];
            {
                scrollView.frame = CGRectMake(0, 0, WIDTH, height - 5);
                scrollView.backgroundColor = [UIColor whiteColor];
                [view addSubview:scrollView];
            }
            float img_width = WIDTH / 2.5;
            float img_height = height - 15;
            float scroll_width = 5;
            for (int i = 0; i < downBannerArray.count; i ++) {
                UIImageView * imgV = [UIImageView new];
                [MYTOOL setImageIncludePrograssOfImageView:imgV withUrlString:downBannerArray[i][@"imgpath"]];
                imgV.frame = CGRectMake(5 + (5 + img_width) * i, 5, img_width, img_height);
                [scrollView addSubview:imgV];
                imgV.tag = i;
                //添加点击事件
                [imgV setUserInteractionEnabled:YES];
                UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:delegate action:@selector(downBannerImageClick:)];
                tapGesture.numberOfTapsRequired=1;
                [imgV addGestureRecognizer:tapGesture];
                scroll_width += i * (5 + img_width);
            }
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
                //悬赏找寻服务
                {
                    UIButton * btn1 = [UIButton new];
                    [btn1 setTitle:@"悬赏找寻服务" forState:UIControlStateNormal];
                    btn1.titleLabel.font = [UIFont systemFontOfSize:13];
                    [btn1 setTitleColor:[MYTOOL RGBWithRed:40 green:199 blue:0 alpha:1] forState:UIControlStateNormal];
                    btn1.frame = CGRectMake(0, 0, WIDTH/2, height/2);
                    [view addSubview:btn1];
                    [btn1 addTarget:delegate action:@selector(selectServiceType:) forControlEvents:UIControlEventTouchUpInside];
                    self.leftServiceBtn = btn1;
                    btn1.enabled = false;
                    btn1.tag = 100;
                }
                //普通找寻服务
                {
                    UIButton * btn2 = [UIButton new];
                    [btn2 setTitle:@"普通找寻服务" forState:UIControlStateNormal];
                    btn2.titleLabel.font = [UIFont systemFontOfSize:13];
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
                    btn.titleLabel.font = [UIFont systemFontOfSize:11];
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
                    btn.titleLabel.font = [UIFont systemFontOfSize:11];
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
