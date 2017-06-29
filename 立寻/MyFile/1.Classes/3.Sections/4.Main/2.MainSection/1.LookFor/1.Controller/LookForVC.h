//
//  LookForVC.h
//  立寻
//
//  Created by mac_hao on 2017/5/23.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LookForVC : UIViewController
@property(nonatomic,strong)UIButton * current_money_type_btn;//当前悬赏类型按钮
@property(nonatomic,strong)UIButton * current_toptype_btn;//当前置顶类型
@property(nonatomic,strong)UIButton * leftTypeBtn;//置顶
@property(nonatomic,strong)UIButton * rightTypeBtn;//最新
@property(nonatomic,strong)UIButton * signBtn;//签到按钮





//tableview数据源选择
-(void)selectServiceType:(UIButton *)btn;
//中部图标点击事件
-(void)iconClick:(UIButton *)tap;
//签到事件
-(void)signClick:(UIButton *)btn;
//置顶、最新事件
-(void)up_newClick:(UIButton *)btn;
@end
