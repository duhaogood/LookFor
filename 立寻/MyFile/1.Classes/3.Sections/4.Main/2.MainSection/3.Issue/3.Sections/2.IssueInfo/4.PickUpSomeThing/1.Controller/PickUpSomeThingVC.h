//
//  IssueInfoVC.h
//  立寻
//
//  Created by Mac on 17/6/9.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IssueInfoUpView.h"
#import "IssueInfoMiddleView.h"
#import "IssueInfoLowerView.h"
#import "AFNetworking.h"
@interface PickUpSomeThingVC : UIViewController
@property(nonatomic,strong)NSDictionary * publishDic;//草稿箱进来的数据
@property(nonatomic,strong)NSArray * secondTypeList;//二级分类数据
@property(nonatomic,copy)NSString * typeTitle;//一级分类标题
@property(nonatomic,copy)NSString * parentid;//一级分类id


@property(nonatomic,strong)UILabel * titleNumberLabel;//标题数字label
@property(nonatomic,strong)UILabel * contentNumberLabel;//详细内容字数label
@property(nonatomic,strong)UITextField * titleTF;//标题文本
@property(nonatomic,strong)MyTextView * contentTV;//详细内容文本
@property(nonatomic,strong)UITextField * typeTF;//类型文本
@property(nonatomic,strong)UITextField * moneyTF;//悬赏金额文本
@property(nonatomic,strong)UITextField * cityTF;//城市文本
@property(nonatomic,strong)UITextField * addressTF;//详细地址文本
@property(nonatomic,strong)UIPickerView * picker;//地区选择器
@property(nonatomic,strong)UIPickerView * typePicker;//类型选择器

-(void)clickOkOfPickerView:(UIBarButtonItem*)btn;
//保存至草稿箱
-(void)saveBtnCallback;
//现在发布
-(void)issueBtnCallback;


@end
