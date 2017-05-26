//
//  LookForVC.h
//  立寻
//
//  Created by mac_hao on 2017/5/23.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LookForVC : UIViewController








//tableview数据源选择
-(void)selectServiceType:(UIButton *)btn;
//中部图标点击事件
-(void)iconClick:(UIButton *)tap;
//签到事件
-(void)signClick:(UIButton *)btn;
@end
