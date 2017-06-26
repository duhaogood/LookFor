//
//  PublishInfoVC.h
//  立寻
//
//  Created by mac on 2017/6/24.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishInfoVC : UIViewController
@property(nonatomic,strong)NSDictionary * publishDictionary;//发布详细信息



//举报事件
-(void)submitReportBtn:(UIButton *)btn;
//个人详情事件
-(void)submitPersonalBtn:(UIButton *)btn;
//关注事件
-(void)submitAttentionBtn:(UIButton *)btn;
//评论事件
-(void)submitCommentBtn:(UIButton *)btn;
//留言事件
-(void)submitMessageBtn:(UIButton *)btn;
//我有线索事件
-(void)submitMyClueBtn:(UIButton *)btn;
@end
