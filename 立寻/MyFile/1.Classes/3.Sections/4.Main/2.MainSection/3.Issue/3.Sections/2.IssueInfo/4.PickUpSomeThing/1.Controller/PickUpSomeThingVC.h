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
@property(nonatomic,strong)NSArray * secondTypeList;//二级分类数据
@property(nonatomic,copy)NSString * typeTitle;//一级分类标题


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
#pragma mark - 服务支持
//推送地区
@property(nonatomic,strong)UIButton * areaSelectBtn;//选择地区按钮
@property(nonatomic,strong)UIButton * allCountryBtn;//全国按钮
@property(nonatomic,strong)UIView * areaMoneyView;//地区选择按钮下方view
@property(nonatomic,strong)UITextField * pushMoneyTF;//全国推送金额文本框
//地区置顶
@property(nonatomic,strong)UIButton * noHaveBtn;//不需要按钮
@property(nonatomic,strong)UIButton * haveBtn;//需要按钮
@property(nonatomic,strong)UIView * haveMoneyView;//是否需要选择按钮下方view
@property(nonatomic,strong)UITextField * haveMoneyTF;//地区置顶金额文本框


//推送地区按钮
-(void)pushAreaButtonCallback:(UIButton *)btn;
//地区置顶按钮
-(void)areaUpButtonCallback:(UIButton *)btn;

-(void)clickOkOfPickerView:(UIBarButtonItem*)btn;
//保存至草稿箱
-(void)saveBtnCallback;
//现在发布
-(void)issueBtnCallback;


@end
