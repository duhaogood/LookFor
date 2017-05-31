//
//  MyVC.m
//  立寻
//
//  Created by mac_hao on 2017/5/23.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "MyVC.h"

@interface MyVC ()<UITextFieldDelegate>
@property(nonatomic,strong)UILabel * accountBalanceLabel;//账户余额
@property(nonatomic,strong)UILabel * rewardAmountLabel;//悬赏金额
@property(nonatomic,strong)UILabel * myPointsLabel;//我的积分
@property(nonatomic,strong)UILabel * progressLabel;//完善度label
@property(nonatomic,strong)UILabel * nameLabel;//名字label
@property(nonatomic,strong)UITextField * signTF;//签名textField
@property(nonatomic,strong)UIView * editView;//编辑按钮view
@property(nonatomic,strong)UILabel * authenticationLabel;//认证label
@end

@implementation MyVC
{
    NSArray * middle_data_array;//中间功能区数据
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //加载主界面
    [self loadMainView];
}
//加载主界面
-(void)loadMainView{
    self.view.backgroundColor = [MYTOOL RGBWithRed:240 green:240 blue:240 alpha:1];
    float top_all = 0;
    NSDictionary * userInfo = @{
                                @"url":@"http://imgtu.5011.net/uploads/content/20170421/8543101492743770.jpg",
                                @"name":@"呆哥哥",
                                @"sign":@"日复一日，年复一年，岁月就是杀猪刀",
                                @"progress":@"60%",
                                @"authentication":@"1",
                                @"3":@"",
                                @"4":@""
                                };
    //个人资料
    {
        float left = 0;
        float view_height = [MYTOOL getHeightWithIphone_six:98];
        UIView * view = [UIView new];
        {
            view.frame = CGRectMake(0, 0, WIDTH, view_height);
            view.backgroundColor = [MYTOOL RGBWithRed:239 green:223 blue:3 alpha:1];
            [self.view addSubview:view];
            top_all += view_height;
        }
        //头像
        float icon_r = view_height * 0.65;
        {
            UIImageView * userImgV = [UIImageView new];
            userImgV.frame = CGRectMake(10, view_height/2.0-icon_r/2.0, icon_r, icon_r);
            [view addSubview:userImgV];
            NSString * url = userInfo[@"url"];
            [MYTOOL setImageIncludePrograssOfImageView:userImgV withUrlString:url];
            userImgV.layer.masksToBounds = true;
            userImgV.layer.cornerRadius = icon_r/2;
            userImgV.backgroundColor = [UIColor greenColor];
            left = icon_r + 10 + 9;
        }
        //完善度
        float nameLabelRight = 0;
        {
            UILabel * label = [UILabel new];
            self.progressLabel = label;
            label.text = @"完善度100%";
            label.font = [UIFont systemFontOfSize:10];
            label.textColor = [MYTOOL RGBWithRed:112 green:112 blue:112 alpha:1];
            CGSize size = [MYTOOL getSizeWithLabel:label];
            label.textAlignment = NSTextAlignmentCenter;
            //背景view
            {
                UIView * bgView = [UIView new];
                bgView.backgroundColor = [UIColor whiteColor];
                bgView.frame = CGRectMake(WIDTH - size.width - 20 - 15, view_height * 0.16, size.width + 20, size.height + 10);
                nameLabelRight = WIDTH - size.width - 20 - 15;
                [view addSubview:bgView];
                bgView.layer.masksToBounds = true;
                bgView.layer.cornerRadius = (size.height + 10)/2.0;
                label.frame = CGRectMake(10, 5, size.width, size.height);
                [bgView addSubview:label];
                //按钮
                {
                    UIButton * btn = [UIButton new];
                    btn.frame = bgView.bounds;
                    [btn addTarget:self action:@selector(personalEditCallback) forControlEvents:UIControlEventTouchUpInside];
                    [bgView addSubview:btn];
                }
            }
            label.text = [NSString stringWithFormat:@"完善度%@",userInfo[@"progress"]];
        }
        //用户名
        {
            UILabel * label = [UILabel new];
            self.nameLabel = label;
            label.frame = CGRectMake(left, view_height/4.0, nameLabelRight - left - 5, 15);
            label.text = userInfo[@"name"];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [MYTOOL RGBWithRed:48 green:48 blue:48 alpha:1];
            [view addSubview:label];
        }
        //签名
        {
            UITextField * signTF = [UITextField new];
            signTF.text = userInfo[@"sign"];
            signTF.textColor = [MYTOOL RGBWithRed:112 green:112 blue:112 alpha:1];
            signTF.delegate = self;
            signTF.font = [UIFont systemFontOfSize:10];
            CGSize size = [MYTOOL getSizeWithLabel:(UILabel *)signTF];
            float width = size.width;
            if (width > WIDTH - left - 30) {
                width = WIDTH - left - 30;
            }
            signTF.frame = CGRectMake(left, view_height/2, width, size.height);
//            signTF.backgroundColor = [UIColor redColor];
            [view addSubview:signTF];
            self.signTF = signTF;
            //编辑view
            {
                UIView * editView = [UIView new];
                editView.frame = CGRectMake(left + signTF.frame.size.width+2, signTF.frame.origin.y+signTF.frame.size.height/2-10, 20, 20);
                [view addSubview:editView];
                self.editView = editView;
                //编辑图标
                {
                    UIImageView * editImgV = [UIImageView new];
                    editImgV.image = [UIImage imageNamed:@"edit"];
                    editImgV.frame = CGRectMake(5, 4.5, 10, 11);
                    [editView addSubview:editImgV];
                }
                //按钮
                {
                    UIButton * btn = [UIButton new];
                    btn.frame = editView.bounds;
                    [btn addTarget:self action:@selector(editSignCallback) forControlEvents:UIControlEventTouchUpInside];
                    [editView addSubview:btn];
                }
            }
        }
        //认证
        {
            UILabel * authenticationLabel = [UILabel new];
            bool state = [userInfo[@"authentication"] boolValue];
            authenticationLabel.text = state ? @"已认证" : @"未认证";
            authenticationLabel.textAlignment = NSTextAlignmentCenter;
            authenticationLabel.font = [UIFont systemFontOfSize:9];
            authenticationLabel.textColor = [UIColor whiteColor];
            CGSize size = [MYTOOL getSizeWithLabel:authenticationLabel];
            authenticationLabel.frame = CGRectMake(left+2, view_height/4*3-size.height/2, size.width+8, size.height);
            [view addSubview:authenticationLabel];
            authenticationLabel.backgroundColor = [MYTOOL RGBWithRed:150 green:215 blue:85 alpha:1];
        }
    }
    //余额
    {
        float view_height = [MYTOOL getHeightWithIphone_six:76];
        UIView * view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(0, top_all, WIDTH, view_height);
        [self.view addSubview:view];
        top_all += view_height + [MYTOOL getHeightWithIphone_six:10];
        //3个余额label、图片及文字
        {
            UIFont * font = [UIFont systemFontOfSize:12];
            UIFont * m_font = [UIFont systemFontOfSize:15];
            UIColor * color = [MYTOOL RGBWithRed:112 green:112 blue:112 alpha:1];
            UIColor * m_color = [MYTOOL RGBWithRed:255 green:101 blue:101 alpha:1];
            //账户余额
            {
                //图片、文字、label
                {
                    float w_img = 14;
                    float h_img = 15;
                    UILabel * label = [UILabel new];
                    label.font = font;
                    label.textColor = color;
                    label.text = @"账户余额";
                    [view addSubview:label];
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(WIDTH/3/2 - (w_img + 9 + size.width)/2.0 + w_img + 9, view_height - [MYTOOL getHeightWithIphone_six:17] - size.height, size.width, size.height);
                    UIImageView * icon = [UIImageView new];
                    icon.image = [UIImage imageNamed:@"balance"];
                    icon.frame = CGRectMake(label.frame.origin.x - 11-w_img, label.frame.origin.y+size.height/2-h_img/2, w_img, h_img);
                    [view addSubview:icon];
                    //分割线
                    {
                        UIView * space = [UIView new];
                        space.backgroundColor = [MYTOOL RGBWithRed:240 green:240 blue:240 alpha:1];
                        space.frame = CGRectMake(WIDTH/3.0-0.5, label.frame.origin.y-5, 1, size.height+10);
                        [view addSubview:space];
                    }
                    //钱
                    {
                        UILabel * m_label = [UILabel new];
                        m_label.text = @"0.00";
                        m_label.textColor = m_color;
                        m_label.font = m_font;
                        m_label.frame = CGRectMake(0, (view_height - label.frame.origin.y)/2.0 - 4, WIDTH/3, 16);
                        [view addSubview:m_label];
                        m_label.textAlignment = NSTextAlignmentCenter;
                        self.accountBalanceLabel = m_label;
                    }
                }
            }
            //悬赏金额
            {
                //图片、文字
                {
                    float w_img = 14;
                    float h_img = 15;
                    UILabel * label = [UILabel new];
                    label.font = font;
                    label.textColor = color;
                    label.text = @"悬赏金额";
                    [view addSubview:label];
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(WIDTH/2 - (w_img + 9 + size.width)/2.0 + w_img + 9, view_height - [MYTOOL getHeightWithIphone_six:17] - size.height, size.width, size.height);
                    UIImageView * icon = [UIImageView new];
                    icon.image = [UIImage imageNamed:@"bounty"];
                    icon.frame = CGRectMake(label.frame.origin.x - 11-w_img, label.frame.origin.y+size.height/2-h_img/2, w_img, h_img);
                    [view addSubview:icon];
                    //分割线
                    {
                        UIView * space = [UIView new];
                        space.backgroundColor = [MYTOOL RGBWithRed:240 green:240 blue:240 alpha:1];
                        space.frame = CGRectMake(WIDTH/3.0*2-0.5, label.frame.origin.y-5, 1, size.height+10);
                        [view addSubview:space];
                    }
                    //钱
                    {
                        UILabel * m_label = [UILabel new];
                        m_label.text = @"0.00";
                        m_label.textColor = m_color;
                        m_label.font = m_font;
                        m_label.frame = CGRectMake(WIDTH/3.0, (view_height - label.frame.origin.y)/2.0 - 4, WIDTH/3, 16);
                        [view addSubview:m_label];
                        m_label.textAlignment = NSTextAlignmentCenter;
                        self.rewardAmountLabel = m_label;
                    }
                }
            }
            //我的积分
            {
                //图片、文字
                {
                    float w_img = 15;
                    float h_img = 16;
                    UILabel * label = [UILabel new];
                    label.font = font;
                    label.textColor = color;
                    label.text = @"我的积分";
                    [view addSubview:label];
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(WIDTH/6.0*5 - (w_img + 9 + size.width)/2.0 + w_img + 9, view_height - [MYTOOL getHeightWithIphone_six:17] - size.height, size.width, size.height);
                    UIImageView * icon = [UIImageView new];
                    icon.image = [UIImage imageNamed:@"integral"];
                    icon.frame = CGRectMake(label.frame.origin.x - 11-w_img, label.frame.origin.y+size.height/2-h_img/2, w_img, h_img);
                    [view addSubview:icon];
                    //钱
                    {
                        UILabel * m_label = [UILabel new];
                        m_label.text = @"0.00";
                        m_label.textColor = m_color;
                        m_label.font = m_font;
                        m_label.frame = CGRectMake(WIDTH/3.0*2, (view_height - label.frame.origin.y)/2.0 - 4, WIDTH/3, 16);
                        [view addSubview:m_label];
                        m_label.textAlignment = NSTextAlignmentCenter;
                        self.myPointsLabel = m_label;
                    }
                }
            }
        }
        //按钮
        {
            UIButton * btn = [UIButton new];
            btn.frame = view.bounds;
            [view addSubview:btn];
            [btn addTarget:self action:@selector(accountBalanceCallback) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    //功能区-270
    {
        float view_height = HEIGHT - 64 - 49 - top_all - [MYTOOL getHeightWithIphone_six:80];
        UIView * view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(0, top_all, WIDTH, view_height);
        [self.view addSubview:view];
        top_all += view_height + [MYTOOL getHeightWithIphone_six:10];
        //8个按钮区域
        {
            //每一块区域的尺寸
            float width = (WIDTH - 2)/3.0;
            float height = (view_height - 2)/3.0;
            //4条分割线
            {
                UIColor * bgColor = [MYTOOL RGBWithRed:240 green:240 blue:240 alpha:1];
                //横
                {
                    UIView * space1 = [UIView new];
                    space1.backgroundColor = bgColor;
                    space1.frame = CGRectMake(0, height, WIDTH, 1);
                    [view addSubview:space1];
                    
                    UIView * space2 = [UIView new];
                    space2.backgroundColor = bgColor;
                    space2.frame = CGRectMake(0, height * 2 + 1, WIDTH, 1);
                    [view addSubview:space2];
                }
                //竖
                {
                    UIView * space1 = [UIView new];
                    space1.backgroundColor = bgColor;
                    space1.frame = CGRectMake(width, 0, 1, view_height);
                    [view addSubview:space1];
                    
                    UIView * space2 = [UIView new];
                    space2.backgroundColor = bgColor;
                    space2.frame = CGRectMake(width*2+1, 0, 1, view_height);
                    [view addSubview:space2];
                }
            }
            //图片、文字  数据
            middle_data_array = @[
                                  @[@"我的寻找",@"my_find",@"25",@"25",@"MyLookingVC"],
                                  @[@"招领认领",@"zlrl",@"29",@"25",@"Found_ClaimVC"],
                                  @[@"我的推广",@"my_tg",@"30",@"25",@"MyExtensionVC"],
                                  @[@"草稿箱",@"draftbox",@"25",@"25",@"DraftsVC"],
                                  @[@"网络社交",@"networking",@"25",@"25",@"NetworkSocialVC"],
                                  @[@"我的关注",@"guanzhu",@"29",@"25",@"MyFollowVC"],
                                  @[@"提供线索",@"xiansuo",@"33",@"25",@"ProvideClueVC"],
                                  @[@"好友邀请",@"yaoqing",@"23",@"25",@"InvitingFriendsVC"]
                                  ];
            //加载图片和文字
            {
                for (int i = 0; i < middle_data_array.count; i ++) {
                    int row = i / 3;//行
                    int col = i % 3;//列
                    int w = [middle_data_array[i][2] intValue];
                    int h = [middle_data_array[i][3] intValue];
                    //图片
                    UIImageView * icon = [UIImageView new];
                    {
                        icon.image = [UIImage imageNamed:middle_data_array[i][1]];
                        //                        icon.backgroundColor = [UIColor greenColor];
                        icon.frame = CGRectMake(width/2-w/2.0 + (width+1)*col, height/2.0-h+(height+1)*row, w, h);
                        [view addSubview:icon];
                    }
                    //文字
                    {
                        UILabel * label = [UILabel new];
                        label.text = middle_data_array[i][0];
                        label.font = [UIFont systemFontOfSize:12];
                        label.textColor = [MYTOOL RGBWithRed:112 green:112 blue:112 alpha:1];
                        CGSize size = [MYTOOL getSizeWithLabel:label];
                        label.frame = CGRectMake(width/2-size.width/2 + (width+1)*col, icon.frame.origin.y+icon.frame.size.height+11, size.width, size.height);
                        [view addSubview:label];
                    }
                    //按钮
                    {
                        UIButton * btn = [UIButton new];
                        btn.frame = CGRectMake((width+1)*col, (height+1)*row, width, height);
                        btn.backgroundColor = [UIColor clearColor];
                        [view addSubview:btn];
                        btn.tag = i;
                        [btn addTarget:self action:@selector(middleBtnCallback:) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
            }
        }
    }
    //设置
    {
        float view_height = HEIGHT - 64 - 49 - top_all;
        view_height = [MYTOOL getHeightWithIphone_six:80];
        UIView * view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(0, top_all, WIDTH, view_height);
        [self.view addSubview:view];
        top_all += view_height;
        //3个按钮
        {
            float top_up = view_height/2;
            float top_down = view_height/2 + 5;
            //个人认证
            {
                //图片-30*30
                {
                    UIImageView * icon = [UIImageView new];
                    icon.image = [UIImage imageNamed:@"renzheng"];
                    icon.frame = CGRectMake(WIDTH/6.0-12.5, top_up - 18, 25, 18);
                    [view addSubview:icon];
                }
                //文字
                {
                    UILabel * label = [UILabel new];
                    label.text = @"个人认证";
                    label.textColor = [MYTOOL RGBWithRed:112 green:112 blue:112 alpha:1];
                    label.font = [UIFont systemFontOfSize:12];
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(WIDTH/6.0 - size.width/2, top_down, size.width, size.height);
                    [view addSubview:label];
                }
                //按钮
                {
                    UIButton * btn = [UIButton new];
                    btn.frame = CGRectMake(0, 0, WIDTH/3, view_height);
                    [btn addTarget:self action:@selector(personalCertifyCallback) forControlEvents:UIControlEventTouchUpInside];
                    btn.backgroundColor = [UIColor clearColor];
                    [view addSubview:btn];
                }
            }
            //设置
            {
                //图片-30*30
                {
                    UIImageView * icon = [UIImageView new];
                    icon.image = [UIImage imageNamed:@"shezhi"];
                    icon.frame = CGRectMake(WIDTH/2.0-12.5, top_up - 25, 25, 25);
                    [view addSubview:icon];
                }
                //文字
                {
                    UILabel * label = [UILabel new];
                    label.text = @"设置";
                    label.textColor = [MYTOOL RGBWithRed:112 green:112 blue:112 alpha:1];
                    label.font = [UIFont systemFontOfSize:12];
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(WIDTH/2.0 - size.width/2, top_down, size.width, size.height);
                    [view addSubview:label];
                }
                //按钮
                {
                    UIButton * btn = [UIButton new];
                    btn.frame = CGRectMake(WIDTH/3.0, 0, WIDTH/3, view_height);
                    [btn addTarget:self action:@selector(settingCallback) forControlEvents:UIControlEventTouchUpInside];
                    btn.backgroundColor = [UIColor clearColor];
                    [view addSubview:btn];
                }
            }
            //投诉建议
            {
                //图片-30*30
                {
                    UIImageView * icon = [UIImageView new];
                    icon.image = [UIImage imageNamed:@"tousu"];
                    icon.frame = CGRectMake(WIDTH/6.0*5-12.5, top_up - 25, 25, 25);
                    [view addSubview:icon];
                }
                //文字
                {
                    UILabel * label = [UILabel new];
                    label.text = @"投诉建议";
                    label.textColor = [MYTOOL RGBWithRed:112 green:112 blue:112 alpha:1];
                    label.font = [UIFont systemFontOfSize:12];
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(WIDTH/6.0*5 - size.width/2, top_down, size.width, size.height);
                    [view addSubview:label];
                }
                //按钮
                {
                    UIButton * btn = [UIButton new];
                    btn.frame = CGRectMake(WIDTH/3.0*2, 0, WIDTH/3, view_height);
                    [btn addTarget:self action:@selector(complainProposeCallback) forControlEvents:UIControlEventTouchUpInside];
                    btn.backgroundColor = [UIColor clearColor];
                    [view addSubview:btn];
                }
            }
        }
    }
}
#pragma mark - 按钮
//编辑签名
-(void)editSignCallback{
    [self.signTF becomeFirstResponder];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [MYTOOL hideKeyboard];
}
#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    float max_width = WIDTH - ([MYTOOL getHeightWithIphone_six:98] * 0.65 + 10 + 9) - 30;
    if (range.length == 0) {//增加
        if ([string isEqualToString:@"\n"]) {
            [textField resignFirstResponder];
#warning 更新签名
            return false;
        }
        UILabel * label = [UILabel new];
        label.font = [UIFont systemFontOfSize:10];
        label.text = [NSString stringWithFormat:@"%@%@",textField.text,string];
        CGSize size = [MYTOOL getSizeWithLabel:label];
        if (size.width > max_width) {//按钮到边了
            self.signTF.frame = CGRectMake([MYTOOL getHeightWithIphone_six:98] * 0.65 + 10 + 9, [MYTOOL getHeightWithIphone_six:98]/2, max_width, size.height);
        }else{//按钮右边还有位置
            self.signTF.frame = CGRectMake([MYTOOL getHeightWithIphone_six:98] * 0.65 + 10 + 9, [MYTOOL getHeightWithIphone_six:98]/2, size.width, size.height);
        }
    }else{//减少
        UILabel * label = [UILabel new];
        label.font = [UIFont systemFontOfSize:10];
        label.text = [textField.text substringToIndex:textField.text.length-1];
        CGSize size = [MYTOOL getSizeWithLabel:label];
        self.signTF.frame = CGRectMake([MYTOOL getHeightWithIphone_six:98] * 0.65 + 10 + 9, [MYTOOL getHeightWithIphone_six:98]/2, size.width, size.height);
        if (size.width > max_width) {//按钮到边了
            self.signTF.frame = CGRectMake([MYTOOL getHeightWithIphone_six:98] * 0.65 + 10 + 9, [MYTOOL getHeightWithIphone_six:98]/2, max_width, size.height);
        }
    }
    self.editView.frame = CGRectMake([MYTOOL getHeightWithIphone_six:98] * 0.65 + 10 + 9 + self.signTF.frame.size.width+2, self.signTF.frame.origin.y+self.signTF.frame.size.height/2-10, 20, 20);
    return true;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"%@",textField.text);
    
}
#pragma mark - 上侧功能区按钮回调
//账户余额
-(void)accountBalanceCallback{
    AccountBalanceVC * vc = [AccountBalanceVC new];
    vc.title = @"账户余额";
    [self.navigationController pushViewController:vc animated:true];
}
//个人编辑
-(void)personalEditCallback{
    NSLog(@"个人编辑");
}
#pragma mark - 中间功能区按钮回调
//中间功能区按钮回调
-(void)middleBtnCallback:(UIButton *)btn{
    NSString * text = middle_data_array[btn.tag][0];
    NSString * className = middle_data_array[btn.tag][4];
    Class class = NSClassFromString(className);
    UIViewController * vc = [class new];
    vc.title = text;
    [self.navigationController pushViewController:vc animated:true];
}
#pragma mark - 下部功能区按钮回调
//个人认证
-(void)personalCertifyCallback{
    PersonalCertificationVC * vc = [PersonalCertificationVC new];
    vc.title = @"个人认证";
    [self.navigationController pushViewController:vc animated:true];
}
//设置回调
-(void)settingCallback{
    SettingVC * vc = [SettingVC new];
    vc.title = @"设置";
    [self.navigationController pushViewController:vc animated:true];
}
//投诉建议
-(void)complainProposeCallback{
    ComplaintSuggestionVC * vc = [ComplaintSuggestionVC new];
    vc.title = @"投诉建议";
    [self.navigationController pushViewController:vc animated:true];
}
@end
