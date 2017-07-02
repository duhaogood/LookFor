//
//  PayTopUpVC.m
//  立寻
//
//  Created by mac on 2017/6/15.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "PayTopUpVC.h"
#import "AliPayTool.h"
#import "WXPayTool.h"
@interface PayTopUpVC ()
@property(nonatomic,strong)UITextField * moneyTF;//充值金额
@property(nonatomic,strong)UIImageView * aliIcon;//阿里选择标志
@property(nonatomic,strong)UIImageView * wxIcon;//微信选择标志
@property(nonatomic,strong)UIButton * aliBtn;//阿里选择按钮
@property(nonatomic,strong)UIButton * wxBtn;//微信选择按钮

@end

@implementation PayTopUpVC
{
    NSString * orderId;//订单号
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //加载主界面
    [self loadMainView];
}
//加载主界面
-(void)loadMainView{
    //返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(popUpViewController)];
    self.view.backgroundColor = MYCOLOR_240_240_240;
    //充值金额
    {
        //背景
        UIView * bgView = [UIView new];
        {
            bgView.frame = CGRectMake(0, 15, WIDTH, 50);
            bgView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:bgView];
        }
        float left = 15;
        //提示
        {
            UILabel * label = [UILabel new];
            label.text = @"充值金额";
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = MYCOLOR_48_48_48;
            CGSize size = [MYTOOL getSizeWithLabel:label];
            label.frame = CGRectMake(left, 25-size.height/2, size.width, size.height);
            [bgView addSubview:label];
            left += size.width + 10;
        }
        //金额文本框
        {
            UITextField * moneyTF = [UITextField new];
            moneyTF.placeholder = @"清输入充值金额";
            moneyTF.font = [UIFont systemFontOfSize:14];
            moneyTF.frame = CGRectMake(left, 10, WIDTH-10-left, 30);
            [bgView addSubview:moneyTF];
            moneyTF.keyboardType = UIKeyboardTypeDecimalPad;
            moneyTF.textColor = [MYTOOL RGBWithRed:144 green:144 blue:144 alpha:1];
            self.moneyTF = moneyTF;
        }
    }
    //支付方式
    {
        //支付方式-文字
        {
            UILabel * label = [UILabel new];
            label.text = @"支付方式";
            label.font = [UIFont systemFontOfSize:12];
            label.frame = CGRectMake(15, 80, 80, 15);
            label.textColor = [MYTOOL RGBWithRed:144 green:144 blue:144 alpha:1];
            [self.view addSubview:label];
        }
        //支付方式选择
        {
            //背景
            UIView * bgView = [UIView new];
            {
                bgView.frame = CGRectMake(0, 103, WIDTH, 100);
                bgView.backgroundColor = [UIColor whiteColor];
                [self.view addSubview:bgView];
            }
            //分割线
            {
                UIView * space = [UIView new];
                space.backgroundColor = [MYTOOL RGBWithRed:220 green:220 blue:220 alpha:1];
                space.frame = CGRectMake(10, 49.5, WIDTH-20, 1);
                [bgView addSubview:space];
            }
            //支付宝-zfblogo
            {
                //图标
                {
                    UIImageView * icon = [UIImageView new];
                    icon.image = [UIImage imageNamed:@"zfblogo"];
                    icon.frame = CGRectMake(15, 10, 30, 30);
                    [bgView addSubview:icon];
                }
                //文字描述
                {
                    UILabel * label = [UILabel new];
                    label.text = @"支付宝支付";
                    label.font = [UIFont systemFontOfSize:14];
                    label.textColor = MYCOLOR_48_48_48;
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(65, 25-size.height/2, size.width, size.height);
                    [bgView addSubview:label];
                }
                //选择标志
                {
                    UIImageView * icon = [UIImageView new];
                    icon.image = [UIImage imageNamed:@"pay_selected"];
                    icon.frame = CGRectMake(WIDTH-20-14, 25-6, 14, 12);
                    [bgView addSubview:icon];
                    self.aliIcon = icon;
                }
                //选择按钮
                {
                    UIButton * btn = [UIButton new];
                    btn.frame = CGRectMake(0, 0, WIDTH, 50);
                    btn.tag = 100;
                    btn.enabled = false;
                    self.aliBtn = btn;
                    [btn addTarget:self action:@selector(selectPayType:) forControlEvents:UIControlEventTouchUpInside];
                    [bgView addSubview:btn];
                }
            }
            //微信-weixinlogo
            {
                //图标
                {
                    UIImageView * icon = [UIImageView new];
                    icon.image = [UIImage imageNamed:@"weixinlogo"];
                    icon.frame = CGRectMake(15, 60, 30, 30);
                    [bgView addSubview:icon];
                }
                //文字描述
                {
                    UILabel * label = [UILabel new];
                    label.text = @"微信支付";
                    label.font = [UIFont systemFontOfSize:14];
                    label.textColor = MYCOLOR_48_48_48;
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(65, 75-size.height/2, size.width, size.height);
                    [bgView addSubview:label];
                }
                //选择标志
                {
                    UIImageView * icon = [UIImageView new];
                    icon.image = [UIImage imageNamed:@"pay_selected"];
                    icon.frame = CGRectMake(WIDTH-20-14, 75-6, 14, 12);
                    icon.hidden = true;
                    [bgView addSubview:icon];
                    self.wxIcon = icon;
                }
                //选择按钮
                {
                    UIButton * btn = [UIButton new];
                    btn.frame = CGRectMake(0, 50, WIDTH, 50);
                    btn.tag = 200;
                    self.wxBtn = btn;
                    [btn addTarget:self action:@selector(selectPayType:) forControlEvents:UIControlEventTouchUpInside];
                    [bgView addSubview:btn];
                }
            }
            
        }
    }
    //立即支付按钮
    {
        UIButton * btn = [UIButton new];
        btn.frame = CGRectMake(15, (HEIGHT-64)/2, WIDTH-30, 40);
        [btn setTitle:@"立即支付" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_red"] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(payRightNow) forControlEvents:UIControlEventTouchUpInside];
    }
}
//立即支付事件
-(void)payRightNow{
    //充值金额
    NSString * money = self.moneyTF.text;
    if (money.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入金额" duration:2];
        return;
    }
    //获取订单号
    NSString * interface = @"/user/memberuser/userbalancerecharge.html";
    NSDictionary * send = @{
                        @"userid":USER_ID,
                        @"amount":self.moneyTF.text
                        };
    [MYTOOL netWorkingWithTitle:@"获取订单号…"];
    [MYNETWORKING getWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        orderId = back_dic[@"Data"];
        [SVProgressHUD dismiss];
        [self startPay];
    }];
}

//准备开始支付
-(void)startPay{
    if (self.aliIcon.hidden) {//微信支付
        NSDictionary * payInfo = @{
                                   @"orderId":orderId,
                                   @"money":self.moneyTF.text
                                   };
        [[WXPayTool new] wxPayWithGoodsDictionary:payInfo];
    }else{//支付宝支付
        NSDictionary * payInfo = @{
                                   @"orderId":orderId,
                                   @"money":self.moneyTF.text
                                   };
        [[AliPayTool new] aliPayWithGoodsDictionary:payInfo];
    }
}

//选择支付方式事件
-(void)selectPayType:(UIButton *)btn{
    NSInteger tag = btn.tag;
    if (tag == 100) {//选择支付宝
        btn.enabled = false;
        self.wxBtn.enabled = true;
        self.aliIcon.hidden = false;
        self.wxIcon.hidden = true;
    }else{//选择微信
        btn.enabled = false;
        self.aliBtn.enabled = true;
        self.aliIcon.hidden = true;
        self.wxIcon.hidden = false;
    }
}






//接收到支付成功通知
-(void)receivePaySuccess:(NSNotification *)notification{
    [self.navigationController popViewControllerAnimated:true];
    [SVProgressHUD showSuccessWithStatus:@"充值成功喽" duration:1];
    
}

//返回上个界面
-(void)popUpViewController{
    [self.navigationController popViewControllerAnimated:true];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [MYTOOL hideKeyboard];
}
-(void)viewWillAppear:(BOOL)animated{
    [MYTOOL hiddenTabBar];
    [MYCENTER_NOTIFICATION addObserver:self selector:@selector(receivePaySuccess:) name:NOTIFICATION_PAY_SUCCESS object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [MYTOOL showTabBar];
    [MYCENTER_NOTIFICATION removeObserver:self name:NOTIFICATION_PAY_SUCCESS object:nil];
}
@end
