//
//  PerfectVC.h
//  立寻
//
//  Created by mac on 2017/6/11.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PerfectVC : UIViewController
@property(nonatomic,assign)UIImageView * user_imgV;//头像
@property(nonatomic,assign)UITextField * love_tf;
@property(nonatomic,assign)UITextField * area_tf;
@property(nonatomic,assign)UITextField * address_tf;
@property(nonatomic,assign)UIPickerView * picker;//地区选择



//点击头像
-(void)clickUserIconCallback2:(UITapGestureRecognizer *)tap;
//返回上个界面
-(void)popUpViewController;

//完成按钮
-(void)finishBtnCallback;
//pickerView中事件-确定
-(void)clickOkOfPickerView:(UIBarButtonItem*)btn;




@end
