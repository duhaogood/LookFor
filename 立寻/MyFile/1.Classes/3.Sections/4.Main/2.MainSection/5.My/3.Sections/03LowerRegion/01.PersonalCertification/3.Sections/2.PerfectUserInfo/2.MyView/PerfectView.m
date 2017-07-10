//
//  PerfectView.m
//  立寻
//
//  Created by mac on 2017/6/11.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "PerfectView.h"
#import "PerfectVC.h"
@implementation PerfectView

-(instancetype)initWithFrame:(CGRect)frame andDelegate:(id)delegate{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        float top = 0;
        //上部绿色
        {
            float height = [MYTOOL getHeightWithIphone_six:170];
            UIView * view = [UIView new];
            //背景
            {
                view.backgroundColor = [MYTOOL RGBWithRed:0 green:201 blue:25 alpha:1];
                view.frame = CGRectMake(0, 0, WIDTH, height);
                [self addSubview:view];
            }
            //下侧弧形
            {
                UIImageView * lower_icon = [UIImageView new];
                lower_icon.image = [UIImage imageNamed:@"arc"];
                [self addSubview:lower_icon];
                float icon_height = WIDTH / 375.0 * 21;
                lower_icon.frame = CGRectMake(0, top + height, WIDTH, icon_height);
                top += icon_height;
            }
            //返回按钮
            {
                UIButton * btn = [UIButton new];
                [btn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
                btn.frame = CGRectMake(10, 32, 11, 20);
                [view addSubview:btn];
                [btn addTarget:delegate action:@selector(popUpViewController) forControlEvents:UIControlEventTouchUpInside];
            }
            //标题
            {
                UILabel * label = [UILabel new];
                label.text = [delegate title];
                label.font = [UIFont systemFontOfSize:18];
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(WIDTH/2-size.width/2, 20+22-size.height/2, size.width, size.height);
                [view addSubview:label];
            }
            //用户头像
            {
                float height = [MYTOOL getHeightWithIphone_six:170];
                float r = [MYTOOL getHeightWithIphone_six:100];
                
                UIImageView * user_icon = [UIImageView new];
                user_icon.tag = 0;
                user_icon.frame = CGRectMake(WIDTH/2.0-r/2.0, height-r, r, r);
                user_icon.image = [UIImage imageNamed:@"upload_hd"];
                [view addSubview:user_icon];
                user_icon.backgroundColor = [UIColor whiteColor];
                user_icon.layer.masksToBounds = true;
                user_icon.layer.cornerRadius = r/2.0;
                [delegate setUser_imgV:user_icon];
                user_icon.contentMode = UIViewContentModeScaleAspectFill;
                user_icon.clipsToBounds=YES;//  是否剪切掉超出 UIImageView 范围的图片
                [user_icon setContentScaleFactor:[[UIScreen mainScreen] scale]];
                
                [user_icon setUserInteractionEnabled:YES];
                UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:delegate action:@selector(clickUserIconCallback2:)];
                tapGesture.numberOfTapsRequired=1;
                [user_icon addGestureRecognizer:tapGesture];
            }
            top += height + 20;
        }
        //分割线-10
        {
            UIView * space = [UIView new];
            space.backgroundColor = MYCOLOR_240_240_240;
            space.frame = CGRectMake(0, top, WIDTH, 10);
            [self addSubview:space];
            top += 10;
        }
        //兴趣爱好
        {
            float left = 14;
            float middle_top = top + 25;
            //图标
            {
                UIImageView * icon = [UIImageView new];
                icon.image = [UIImage imageNamed:@"savor"];
                icon.frame = CGRectMake(left, middle_top-16, 32, 32);
                [self addSubview:icon];
                left += 32 + 14;
            }
            //提示
            {
                UILabel * label = [UILabel new];
                label.text = @"兴趣爱好";
                label.font = [UIFont systemFontOfSize:16];
                label.textColor = [MYTOOL RGBWithRed:26 green:26 blue:26 alpha:1];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(left, middle_top-size.height/2, size.width, size.height);
                [self addSubview:label];
                left += size.width + 10;
            }
            //文本框
            {
                UITextField * tf = [UITextField new];
                tf.placeholder = @"请简介的描述您的主营业务";
                tf.frame = CGRectMake(left, middle_top - 10, WIDTH - 30-left, 20);
                tf.font = [UIFont systemFontOfSize:13];
                [self addSubview:tf];
                [delegate setLove_tf:tf];
            }
            
            top += 50;
        }
        //分割线-1
        {
            UIView * space = [UIView new];
            space.backgroundColor = MYCOLOR_240_240_240;
            space.frame = CGRectMake(14, top, WIDTH-14, 1);
            [self addSubview:space];
        }
        //所在区域
        {
            float left = 14;
            float middle_top = top + 25;
            //图标
            {
                UIImageView * icon = [UIImageView new];
                icon.image = [UIImage imageNamed:@"cityselect"];
                icon.frame = CGRectMake(left, middle_top-16, 32, 32);
                [self addSubview:icon];
                left += 32 + 14;
            }
            //提示
            {
                UILabel * label = [UILabel new];
                label.text = @"所在区域";
                label.font = [UIFont systemFontOfSize:16];
                label.textColor = [MYTOOL RGBWithRed:26 green:26 blue:26 alpha:1];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(left, middle_top-size.height/2, size.width, size.height);
                [self addSubview:label];
                left += size.width + 10;
            }
            //文本框
            {
                UITextField * tf = [UITextField new];
                tf.placeholder = @"请选择店铺所在城市";
                tf.frame = CGRectMake(left, middle_top - 10, WIDTH - 30-left, 20);
                tf.font = [UIFont systemFontOfSize:13];
                tf.delegate = delegate;
                [self addSubview:tf];
                [delegate setArea_tf:tf];
                //输入
                {
                    UIPickerView * pick = [UIPickerView new];
                    [delegate setPicker:pick];
                    pick.tag = 200;
                    UIView * v = [UIView new];
                    tf.inputView = v;
                    v.frame = CGRectMake(0, 500, WIDTH, 271);
                    pick.frame = CGRectMake(0, 44, WIDTH, 271-44);
                    pick.dataSource = delegate;
                    pick.delegate = delegate;
                    [v addSubview:pick];
                    [delegate setPicker:pick];
                    //toolbar
                    UIToolbar * bar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
                    [v addSubview:bar];
                    [bar setBarStyle:UIBarStyleDefault];
                    NSMutableArray *buttons = [[NSMutableArray alloc] init];
                    
                    UIBarButtonItem *myDoneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                                  target: delegate action: @selector(clickOkOfPickerView:)];
                    myDoneButton.tag = 200;
                    myDoneButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:delegate action:@selector(clickOkOfPickerView:)];
                    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
                    
                    [buttons addObject:flexibleSpace];
                    [buttons addObject: myDoneButton];
                    
                    
                    [bar setItems:buttons animated:TRUE];
                    
                    //toolbar加个label
                    UILabel * label = [UILabel new];
                    label.text = [NSString stringWithFormat:@"请选择相应的类型"];
                    label.frame = CGRectMake(WIDTH/2-70, 12, 140, 20);
                    label.textAlignment = NSTextAlignmentCenter;
                    [v addSubview:label];
                }
            }
            //右侧图标
            {
                UIImageView * icon = [UIImageView new];
                icon.image = [UIImage imageNamed:@"arrow_right_md"];
                [self addSubview:icon];
                icon.frame = CGRectMake(WIDTH - 20, middle_top - 6, 6, 12);
            }
            
            top += 50;
        }
        //分割线-1
        {
            UIView * space = [UIView new];
            space.backgroundColor = MYCOLOR_240_240_240;
            space.frame = CGRectMake(14, top, WIDTH-14, 1);
            [self addSubview:space];
        }
        //详细地址
        {float left = 14;
            float middle_top = top + 25;
            //图标
            {
                UIImageView * icon = [UIImageView new];
                icon.image = [UIImage imageNamed:@"xxadress"];
                icon.frame = CGRectMake(left, middle_top-16, 32, 32);
                [self addSubview:icon];
                left += 32 + 14;
            }
            //提示
            {
                UILabel * label = [UILabel new];
                label.text = @"详细地址";
                label.font = [UIFont systemFontOfSize:16];
                label.textColor = [MYTOOL RGBWithRed:26 green:26 blue:26 alpha:1];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(left, middle_top-size.height/2, size.width, size.height);
                [self addSubview:label];
                left += size.width + 10;
            }
            //文本框
            {
                UITextField * tf = [UITextField new];
                tf.placeholder = @"请填写店铺详细地址";
                tf.frame = CGRectMake(left, middle_top - 10, WIDTH - 30-left, 20);
                tf.font = [UIFont systemFontOfSize:13];
                [self addSubview:tf];
                [delegate setAddress_tf:tf];
            }
            
            
            
            top += 50;
        }
        //分割线-20
        {
            UIView * space = [UIView new];
            space.backgroundColor = MYCOLOR_240_240_240;
            space.frame = CGRectMake(0, top, WIDTH, 10);
            [self addSubview:space];
            top += 10;
        }
        
        //完成按钮
        {
            float lower_height = HEIGHT - top;
            float btn_top = top + lower_height/2-40;
            UIButton * btn = [UIButton new];
            btn.frame = CGRectMake(WIDTH/4, btn_top, WIDTH/2, 40);
            btn.layer.masksToBounds = true;
            btn.layer.cornerRadius = 20;
            btn.backgroundColor = [UIColor greenColor];
            [btn setTitle:@"完 成" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:17];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self addSubview:btn];
            [btn addTarget:delegate action:@selector(finishBtnCallback) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    return self;
}

@end
