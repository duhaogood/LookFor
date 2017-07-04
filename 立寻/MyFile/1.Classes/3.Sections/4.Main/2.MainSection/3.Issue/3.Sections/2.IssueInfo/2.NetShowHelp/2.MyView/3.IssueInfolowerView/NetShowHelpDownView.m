//
//  NetShowHelpDownView.m
//  立寻
//
//  Created by Mac on 17/6/14.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "NetShowHelpDownView.h"
#import "NetShowHelpVC.h"
@implementation NetShowHelpDownView

-(instancetype)initWithFrame:(CGRect)frame andDelegate:(id)delegate{
    if (self = [super initWithFrame:frame]) {
        float top = 0;
        
        //底部还剩总高度
        float lower_height = frame.size.height - top;
        //按钮间隔
        float space = (lower_height - 80)/3.0;
        top += space;
        //保存至草稿箱按钮
        {
            UIButton * btn = [UIButton new];
            btn.frame = CGRectMake(10, top, WIDTH-20, 40);
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_green"] forState:UIControlStateNormal];
            [btn setTitle:@"保存至草稿箱" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [self addSubview:btn];
            [btn addTarget:delegate action:@selector(saveBtnCallback) forControlEvents:UIControlEventTouchUpInside];
        }
        //现在发布按钮
        top += space + 40;
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
