//
//  IssueVC.h
//  立寻
//
//  Created by mac on 2017/6/4.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssueFirstPageVC : UIViewController
@property(nonatomic,assign)id delegate;

- (void)show;
- (void)removeFromSuperViewController:(UIGestureRecognizer *)gr;
@end
