//
//  MyTextView.m
//  立寻
//
//  Created by Mac on 17/6/9.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "MyTextView.h"

@implementation MyTextView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.placeholderLabel = [UILabel new];
        self.placeholderLabel.frame = CGRectMake(0, 5, frame.size.width, 20);
        [self addSubview:self.placeholderLabel];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self]; //通知:监听文字的改变
    }
    return self;
}

#pragma mark -监听文字改变

- (void)textDidChange {
    
    self.placeholderLabel.hidden = self.hasText;
    
}

@end
