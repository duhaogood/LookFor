//
//  PayMoneyVC.m
//  立寻
//
//  Created by Mac on 17/7/18.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "PayMoneyVC.h"
#import "AliPayTool.h"
#import "WXPayTool.h"
@interface PayMoneyVC ()
@property(nonatomic,strong)UITextField * moneyTF;//充值金额
@property(nonatomic,strong)UIImageView * moneyIcon;//余额选择标志
@property(nonatomic,strong)UIImageView * aliIcon;//阿里选择标志
@property(nonatomic,strong)UIImageView * wxIcon;//微信选择标志
@property(nonatomic,strong)UIButton * moneyBtn;//余额选择按钮
@property(nonatomic,strong)UIButton * aliBtn;//阿里选择按钮
@property(nonatomic,strong)UIButton * wxBtn;//微信选择按钮
@end

@implementation PayMoneyVC
{
    NSString * orderId;//订单号
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"赏金支付";
    NSLog(@"支付赏金:%.2f",self.waittingPayNumber);
    NSLog(@"发布id:%@",self.publishId);
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
            label.text = @"待支付奖赏保证金:";
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = MYCOLOR_48_48_48;
            CGSize size = [MYTOOL getSizeWithLabel:label];
            label.frame = CGRectMake(left, 25-size.height/2, size.width, size.height);
            [bgView addSubview:label];
            left += size.width + 10;
        }
        //金额文本框
        {
            UITextField * moneyTF = [UITextField new];
            moneyTF.text = [NSString stringWithFormat:@"%.2f元",self.waittingPayNumber];
            moneyTF.font = [UIFont systemFontOfSize:20];
            moneyTF.enabled = false;
            moneyTF.frame = CGRectMake(left, 10, WIDTH-10-left, 30);
            [bgView addSubview:moneyTF];
            moneyTF.textColor = MYCOLOR_40_199_0;
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
                bgView.frame = CGRectMake(0, 103, WIDTH, 150);
                bgView.backgroundColor = [UIColor whiteColor];
                [self.view addSubview:bgView];
            }
            //分割线1
            {
                UIView * space = [UIView new];
                space.backgroundColor = [MYTOOL RGBWithRed:220 green:220 blue:220 alpha:1];
                space.frame = CGRectMake(10, 49.5, WIDTH-20, 1);
                [bgView addSubview:space];
            }//分割线2
            {
                UIView * space = [UIView new];
                space.backgroundColor = [MYTOOL RGBWithRed:220 green:220 blue:220 alpha:1];
                space.frame = CGRectMake(10, 49.5+50, WIDTH-20, 1);
                [bgView addSubview:space];
            }
            //余额支付
            {
                float left = 0;
                //图标
                {
                    UIImageView * icon = [UIImageView new];
                    icon.image = [UIImage imageNamed:@"yue"];
                    icon.frame = CGRectMake(15, 10, 30, 30);
                    [bgView addSubview:icon];
                }
                //文字描述
                {
                    UILabel * label = [UILabel new];
                    label.text = @"余额支付";
                    label.font = [UIFont systemFontOfSize:14];
                    label.textColor = MYCOLOR_48_48_48;
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(65, 25-size.height/2, size.width, size.height);
                    [bgView addSubview:label];
                    left = 65 + size.width + 2;
                }
                //可用金额提示
                {
                    //余额
                    NSString * Balance = [NSString stringWithFormat:@"可用金额 %.2f",[MYTOOL.userInfo[@"Balance"] floatValue]];
                    UILabel * label = [UILabel new];
                    label.text = Balance;
                    label.font = [UIFont systemFontOfSize:13];
                    label.textColor = [MYTOOL RGBWithRed:144 green:144 blue:144 alpha:1];
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(left, 25-size.height/2, size.width, size.height);
                    [bgView addSubview:label];
                }
                //选择标志
                {
                    UIImageView * icon = [UIImageView new];
                    icon.image = [UIImage imageNamed:@"pay_selected"];
                    icon.frame = CGRectMake(WIDTH-20-14, 25-6, 14, 12);
                    [bgView addSubview:icon];
                    icon.hidden = true;
                    self.moneyIcon = icon;
                }
                //选择按钮
                {
                    UIButton * btn = [UIButton new];
                    btn.frame = CGRectMake(0, 0, WIDTH, 50);
                    btn.tag = 300;
                    btn.enabled = true;
                    self.moneyBtn = btn;
                    [btn addTarget:self action:@selector(selectPayType:) forControlEvents:UIControlEventTouchUpInside];
                    [bgView addSubview:btn];
                }
            }
            //支付宝-zfblogo
            {
                //图标
                {
                    UIImageView * icon = [UIImageView new];
                    icon.image = [UIImage imageNamed:@"zfblogo"];
                    icon.frame = CGRectMake(15, 60, 30, 30);
                    [bgView addSubview:icon];
                }
                //文字描述
                {
                    UILabel * label = [UILabel new];
                    label.text = @"支付宝支付";
                    label.font = [UIFont systemFontOfSize:14];
                    label.textColor = MYCOLOR_48_48_48;
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(65, 25-size.height/2+50, size.width, size.height);
                    [bgView addSubview:label];
                }
                //选择标志
                {
                    UIImageView * icon = [UIImageView new];
                    icon.image = [UIImage imageNamed:@"pay_selected"];
                    icon.frame = CGRectMake(WIDTH-20-14, 25-6+50, 14, 12);
                    [bgView addSubview:icon];
                    self.aliIcon = icon;
                }
                //选择按钮
                {
                    UIButton * btn = [UIButton new];
                    btn.frame = CGRectMake(0, 0+50, WIDTH, 50);
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
                    icon.frame = CGRectMake(15, 60+50, 30, 30);
                    [bgView addSubview:icon];
                }
                //文字描述
                {
                    UILabel * label = [UILabel new];
                    label.text = @"微信支付";
                    label.font = [UIFont systemFontOfSize:14];
                    label.textColor = MYCOLOR_48_48_48;
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(65, 75-size.height/2+50, size.width, size.height);
                    [bgView addSubview:label];
                }
                //选择标志
                {
                    UIImageView * icon = [UIImageView new];
                    icon.image = [UIImage imageNamed:@"pay_selected"];
                    icon.frame = CGRectMake(WIDTH-20-14, 75-6+50, 14, 12);
                    icon.hidden = true;
                    [bgView addSubview:icon];
                    self.wxIcon = icon;
                }
                //选择按钮
                {
                    UIButton * btn = [UIButton new];
                    btn.frame = CGRectMake(0, 50+50, WIDTH, 50);
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
        btn.frame = CGRectMake(15, (HEIGHT-64)/2+30, WIDTH-30, 40);
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
    if(!self.moneyIcon.hidden){//余额支付
        NSString * interface = @"/publish/publish/paypublishinfo.html";
        [MYTOOL netWorkingWithTitle:@"支付中……"];
        NSDictionary * send = @{
                                @"publishid":self.publishId
                                };
        [MYNETWORKING getWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
            [SVProgressHUD showSuccessWithStatus:@"发布成功" duration:2];
            [self performSelector:@selector(paySuccess) withObject:nil afterDelay:1];
        }];
        return;
    }
//    if (![self.wxIcon isHidden]) {//微信支付
//        [SVProgressHUD showErrorWithStatus:@"微信支付暂不支持\n请使用余额或支付宝" duration:2];
//        return;
//    }
    NSString * paytypeid = @"9";
    if (![self.wxIcon isHidden]) {//微信支付
        paytypeid = @"12";
    }
    //获取订单号
    NSString * interface = @"/publish/publish/addpublishpayrecord.html";
    NSDictionary * send = @{
                            @"publishid":self.publishId,
                            @"paytypeid":paytypeid
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
    if (![self.wxIcon isHidden]) {//微信支付
        NSDictionary * payInfo = @{
                                   @"orderId":orderId,
                                   @"money":self.moneyTF.text
                                   };
        [[WXPayTool new] wxPayWithGoodsDictionary:payInfo];
    }else if(![self.aliIcon isHidden]){//支付宝支付
        NSDictionary * payInfo = @{
                                   @"orderId":orderId,
                                   @"money":[NSString stringWithFormat:@"%.2f",self.waittingPayNumber]
                                   };
        [[AliPayTool new] aliPayWithGoodsDictionary:payInfo];
    }else{//余额支付
        NSString * interface = @"/publish/publish/paypublishinfo.html";
        [MYTOOL netWorkingWithTitle:@"支付中……"];
        NSDictionary * send = @{
                                @"publishid":self.publishId
                                };
        [MYNETWORKING getWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
            [SVProgressHUD showSuccessWithStatus:@"发布成功" duration:1];
            [self performSelector:@selector(paySuccess) withObject:nil afterDelay:1];
        }];
        
    }
}

//选择支付方式事件
-(void)selectPayType:(UIButton *)btn{
    NSInteger tag = btn.tag;
    if (tag == 100) {//选择支付宝
        btn.enabled = false;
        self.wxBtn.enabled = true;
        self.moneyBtn.enabled = true;
        self.aliIcon.hidden = false;
        self.moneyIcon.hidden = true;
        self.wxIcon.hidden = true;
    }else if(tag == 200){//选择微信
        btn.enabled = false;
        self.moneyBtn.enabled = true;
        self.aliBtn.enabled = true;
        self.aliIcon.hidden = true;
        self.moneyIcon.hidden = true;
        self.wxIcon.hidden = false;
    }else{//余额支付
        float Balance = [MYTOOL.userInfo[@"Balance"] floatValue];
        if (Balance < self.waittingPayNumber) {
            [SVProgressHUD showErrorWithStatus:@"余额不足\n无法使用余额支付" duration:2];
            return;
        }
        btn.enabled = false;
        self.aliBtn.enabled = true;
        self.wxBtn.enabled = true;
        self.aliIcon.hidden = true;
        self.moneyIcon.hidden = false;
        self.wxIcon.hidden = true;
    }
}


//支付成功
-(void)paySuccess{
    [self.navigationController popToRootViewControllerAnimated:false];
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MainVC * main = (MainVC *)app.window.rootViewController;
    [main setSelectedIndex:4];
}



//接收到支付成功通知
-(void)receivePaySuccess:(NSNotification *)notification{
    [SVProgressHUD showSuccessWithStatus:@"支付成功" duration:2];
    [self performSelector:@selector(paySuccess) withObject:nil afterDelay:1];
}

//返回上个界面
-(void)popUpViewController{
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"确定放弃支付?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:true];
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:sure];
    [ac addAction:cancel];
    [self presentViewController:ac animated:true completion:nil];
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
