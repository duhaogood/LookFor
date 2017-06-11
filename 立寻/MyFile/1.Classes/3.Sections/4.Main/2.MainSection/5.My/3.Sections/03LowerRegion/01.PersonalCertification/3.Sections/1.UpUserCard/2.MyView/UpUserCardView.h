//
//  UpUserCardView.h
//  立寻
//
//  Created by mac on 2017/6/11.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpUserCardView : UIView
@property(nonatomic,strong)UITextField * name_tf;//姓名文本框



-(instancetype)initWithFrame:(CGRect)frame andDelegate:(id)delegate;

@end
