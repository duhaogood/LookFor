//
//  LookForCircleLowerView.m
//  立寻
//
//  Created by Mac on 17/6/14.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "LookForCircleLowerView.h"
#import "LookForCircleVC.h"
@implementation LookForCircleLowerView


-(instancetype)initWithFrame:(CGRect)frame andDelegate:(id)delegate{
    if (self = [super initWithFrame:frame]) {
        float top = (frame.size.height-40)/2.0;
        //发布按钮
        {
            UIButton * btn = [UIButton new];
            btn.frame = CGRectMake(10, top, WIDTH-20, 40);
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_red"] forState:UIControlStateNormal];
            [btn setTitle:@"现在发布" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [self addSubview:btn];
            [btn addTarget:delegate action:@selector(issueBtnCallback) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [MYTOOL hideKeyboard];
}

@end
