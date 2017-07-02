//
//  FindPasswordVC.m
//  立寻
//
//  Created by mac on 2017/6/10.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "FindPasswordVC.h"

@interface FindPasswordVC ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField * phoneTF;//手机号码
@property(nonatomic,strong)UITextField * codeTF;//验证码
@property(nonatomic,strong)UITextField * passwordTF;//密码
@property(nonatomic,strong)UIButton * sendCodeBtn;//发送验证码按钮
@property(nonatomic,strong)UILabel * checkLabel;//检测手机号

@end

@implementation FindPasswordVC
{
    NSTimer * codeTimer;//验证码定时器
    int timeSpace;//时间间隔
    NSString * codeid_id;//验证码id
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //加载主界面
    [self loadMainView];
}
//加载主界面
-(void)loadMainView{
    //返回按钮
    self.view.backgroundColor = [UIColor whiteColor];
    //返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(popUpViewController)];
    //手机号码
    float top = 30;
    float height = 40;
    float left1 = 30;
    float left2 = 55;
    {
        //背景view
        UIView * view = [UIView new];
        {
            view.frame = CGRectMake(20, top, WIDTH - 40, height);
            view.layer.masksToBounds = true;
            view.layer.borderWidth = 1;
            view.layer.borderColor = [MYCOLOR_240_240_240 CGColor];
            [self.view addSubview:view];
            view.layer.cornerRadius = height/2.0;
        }
        //图标
        {
            UIImageView * icon = [UIImageView new];
            icon.image = [UIImage imageNamed:@"phone"];
            [view addSubview:icon];
            icon.frame = CGRectMake(left1, 13, 10, 14);
        }
        //文本框
        {
            UITextField * tf = [UITextField new];
            tf.placeholder = @"手机号码";
            tf.font = [UIFont systemFontOfSize:14];
            tf.frame = CGRectMake(left2, 10, WIDTH/3.0, 20);
            tf.delegate = self;
            tf.tag = 100;
            tf.keyboardType = UIKeyboardTypeNumberPad;
            [view addSubview:tf];
            self.phoneTF = tf;
        }
        //手机号码检测
        {
            UILabel * label = [UILabel new];
            self.checkLabel = label;
            label.frame = CGRectMake(30, top + 45, WIDTH - 60, 15);
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [MYTOOL RGBWithRed:255 green:101 blue:101 alpha:1];
            [self.view addSubview:label];
            label.text = @"";
        }
        //发送验证码按钮
        {
            UIButton * btn = [UIButton new];
            btn.frame = CGRectMake(WIDTH-40-100, 0, 100, 40);
            [btn setBackgroundImage:[UIImage imageNamed:@"yzmbtn_blue_bj"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"yzmbtn_bj"] forState:UIControlStateDisabled];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:MYCOLOR_181_181_181 forState:UIControlStateDisabled];
            [btn setTitle:@"发送验证码" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(sendCode:) forControlEvents:UIControlEventTouchUpInside];
            self.sendCodeBtn = btn;
            [view addSubview:btn];
        }
        
        top += height + 40;
    }
    //数字验证码
    {
        //背景view
        UIView * view = [UIView new];
        {
            view.frame = CGRectMake(20, top, WIDTH - 40, height);
            view.layer.masksToBounds = true;
            view.layer.borderWidth = 1;
            view.layer.borderColor = [MYCOLOR_240_240_240 CGColor];
            [self.view addSubview:view];
            view.layer.cornerRadius = height/2.0;
        }
        //图标
        {
            UIImageView * icon = [UIImageView new];
            icon.image = [UIImage imageNamed:@"pwd"];
            [view addSubview:icon];
            icon.frame = CGRectMake(left1, 13, 10, 14);
        }
        //文本框
        {
            UITextField * tf = [UITextField new];
            tf.placeholder = @"请输入6位数字验证码";
            tf.font = [UIFont systemFontOfSize:14];
            tf.frame = CGRectMake(left2, 10, WIDTH/2.0, 20);
            [view addSubview:tf];
            tf.tag = 200;
            tf.keyboardType = UIKeyboardTypeNumberPad;
            self.codeTF = tf;
        }
        top += height + 28;
    }
    //密码
    {
        //背景view
        UIView * view = [UIView new];
        {
            view.frame = CGRectMake(20, top, WIDTH - 40, height);
            view.layer.masksToBounds = true;
            view.layer.borderWidth = 1;
            view.layer.borderColor = [MYCOLOR_240_240_240 CGColor];
            [self.view addSubview:view];
            view.layer.cornerRadius = height/2.0;
        }
        //图标
        {
            UIImageView * icon = [UIImageView new];
            icon.image = [UIImage imageNamed:@"yzma"];
            [view addSubview:icon];
            icon.frame = CGRectMake(left1, 20-11/2.0, 14, 11);
        }
        //文本框
        {
            UITextField * tf = [UITextField new];
            tf.placeholder = @"设置登录密码";
            tf.font = [UIFont systemFontOfSize:14];
            tf.frame = CGRectMake(left2, 10, WIDTH/2.0, 20);
            [view addSubview:tf];
            tf.tag = 400;
            tf.delegate = self;
            self.passwordTF = tf;
        }
        
        
        top += height;
    }
    //登录按钮
    {
        UIButton * btn = [UIButton new];
        btn.frame = CGRectMake(20, (HEIGHT-64)/2.0, WIDTH - 40, 40);
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_red"] forState:UIControlStateNormal];
        [btn setTitle:@"密码找回" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(findBackPasswordCallback) forControlEvents:UIControlEventTouchUpInside];
    }
}


//找回密码
-(void)findBackPasswordCallback{
    [SVProgressHUD showSuccessWithStatus:@"找回成功" duration:1];
    NSString * mobile = self.phoneTF.text;//手机号
    NSString * vaildcode = self.codeTF.text;//验证码
    NSString * codeid = codeid_id;//验证码编号
    NSString * password = self.passwordTF.text;//密码
    //验证
    {
        //手机号
        {
            //正则表达式匹配11位手机号码
            NSString *regex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            BOOL isMatch = [pred evaluateWithObject:mobile];
            if (!isMatch) {
                [SVProgressHUD showErrorWithStatus:@"手机号格式不正确" duration:2];
                return;
            }
        }
        //验证码
        {
            if (vaildcode.length != 6) {
                [SVProgressHUD showErrorWithStatus:@"验证码长度不正确" duration:2];
                return;
            }
        }
        //验证码id
        {
            if (codeid_id == nil || codeid.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请先发送验证码" duration:2];
                return;
            }
        }
        //密码
        {
            if (password.length < 6) {
                [SVProgressHUD showErrorWithStatus:@"密码不能少于6位" duration:2];
                return;
            }
        }
    }
    [MYTOOL netWorkingWithTitle:@"找回密码……"];
    NSString * interface = @"/user/memberuser/memberuserretrievepassword.html";
    NSDictionary * send = @{
                            @"mobile":mobile,
                            @"vaildcode":vaildcode,
                            @"codeid":codeid,
                            @"password":password
                            };
    [MYNETWORKING getWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        [SVProgressHUD showSuccessWithStatus:back_dic[@"Message"] duration:1];
        [self popUpViewController];
    }];
    
    
}
//发送验证码事件
-(void)sendCode:(UIButton *)btn{
    NSString * mobile = self.phoneTF.text;
    //正则表达式匹配11位手机号码
    NSString *regex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:mobile];
    if (!isMatch) {
        self.checkLabel.text = @"手机格式不正确";
        [SVProgressHUD showErrorWithStatus:@"手机格式不正确" duration:2];
        return;
    }
    [MYTOOL netWorkingWithTitle:@"发送验证码……"];
    //发送手机号码
    NSString * interface = @"/common/messages/sendsmscode.html";
    NSDictionary * send = @{@"mobile":mobile};
    [MYNETWORKING getWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        [SVProgressHUD showSuccessWithStatus:back_dic[@"Message"] duration:1];
        //发送成功后,按钮置为不可用
        self.sendCodeBtn.enabled = false;
        timeSpace = 10;
        [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"%d秒后可用",timeSpace] forState:UIControlStateDisabled];
        codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerWorkInHere) userInfo:nil repeats:true];
        codeid_id = back_dic[@"Data"];
    }];
}
//定时器任务
-(void)timerWorkInHere{
    timeSpace --;
    if (timeSpace <= 0) {//按钮置为可用
        [codeTimer invalidate];
        codeTimer = nil;
        self.sendCodeBtn.enabled = true;
        return;
    }
    [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"%d秒后可用",timeSpace] forState:UIControlStateDisabled];
}
#pragma mark - UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag != 100) {
        return;
    }
    NSString * mobile = textField.text;
    //正则表达式匹配11位手机号码
    NSString *regex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:mobile];
    if (!isMatch) {
        self.checkLabel.text = @"手机格式不正确";
        self.checkLabel.textColor = [MYTOOL RGBWithRed:255 green:101 blue:101 alpha:1];
    }else{
        self.checkLabel.text = @"手机格式正确";
        self.checkLabel.textColor = MYCOLOR_40_199_0;
    }
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
}
-(void)viewWillDisappear:(BOOL)animated{
    [MYTOOL showTabBar];
}
@end
