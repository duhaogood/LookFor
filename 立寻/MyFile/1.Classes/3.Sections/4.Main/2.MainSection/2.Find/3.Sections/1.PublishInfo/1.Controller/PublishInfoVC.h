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

//下拉事件
-(void)headerRefresh;
//上拉事件
-(void)footerRefresh;
//评论列表事件
-(void)submitCommentListBtn:(UIButton *)btn;
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
//我要认领事件
-(void)submitClaimBtn:(UIButton *)btn;

@end
