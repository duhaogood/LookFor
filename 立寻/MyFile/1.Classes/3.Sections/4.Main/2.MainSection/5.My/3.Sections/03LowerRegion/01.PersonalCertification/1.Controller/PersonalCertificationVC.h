//
//  PersonalCertificationVC.h
//  立寻
//
//  Created by mac on 2017/5/31.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalCertificationVC : UIViewController
@property(nonatomic,strong) UIImageView * user_icon;//用户头像
@property(nonatomic,strong) UILabel * phone_label;//手机号码
@property(nonatomic,strong) UILabel * state_label;//认证状态
@property(nonatomic,strong) UIButton * goCertification_btn;//去认证按钮
@property(nonatomic,strong) UIButton * laterSay_btn;//以后再说按钮



//用户图片点击事件
-(void)clickImgOfUser:(UITapGestureRecognizer *)tap;
-(void)goCertification_btnCallback;

-(void)laterSay_btnCallback;

@end
