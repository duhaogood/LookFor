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

@interface IssueInfoVC : UIViewController
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
@end
