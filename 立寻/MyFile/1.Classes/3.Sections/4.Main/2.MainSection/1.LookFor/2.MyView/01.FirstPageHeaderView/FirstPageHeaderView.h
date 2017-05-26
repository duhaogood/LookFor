//
//  FirstPageHeaderView.h
//  立寻
//
//  Created by mac on 2017/5/26.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstPageHeaderView : UIView



/**
 初始化view

 @param frame CGRect
 @param delegate 代理控制器
 @param upBannerArray 上侧banner数组
 @param downBannerArray 下册banner数组
 @return view
 */
-(instancetype)initWithFrame:(CGRect)frame andDelegate:(id)delegate andUpBannerArray:(NSArray *)upBannerArray andDownBannerArray:(NSArray *)downBannerArray andBtnName_imgArray:(NSArray *)btnName_imgArray;

/**
 选择找寻服务后更新界面

 @param tag 被选中的按钮的tag
 */
-(void)selectServiceCallback:(NSInteger)tag;

@end
