//
//  UpUserCardVC.h
//  立寻
//
//  Created by mac on 2017/6/11.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpUserCardVC : UIViewController
@property(nonatomic,strong) UITextField * nameTF;//姓名
@property(nonatomic,strong) UIImageView * card_up_icon;//身份证正面
@property(nonatomic,strong) UIImageView * card_down_icon;//身份证反面





//身份证正面
-(void)clickImgOfCardUp:(UITapGestureRecognizer *)tap;
//身份证反面
-(void)clickImgOfCardDown:(UITapGestureRecognizer *)tap;
//下一步回调
-(void)nextBtnCallback;

@end
