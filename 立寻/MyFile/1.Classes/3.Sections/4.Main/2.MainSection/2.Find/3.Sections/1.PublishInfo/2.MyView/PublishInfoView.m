//
//  PublishInfoView.m
//  立寻
//
//  Created by mac on 2017/6/25.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "PublishInfoView.h"
@interface PublishInfoView()
@property(nonatomic,strong)UILabel * commentCountLabel;//评论人数label
@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)UIView * commentView;//评论view
@property(nonatomic,assign)float commentTop;//评论view顶坐标
@property(nonatomic,strong)UIView * down_view;//下方view
@property(nonatomic,strong)UIView * img_bg_view;//图片背景view

//关注
@property(nonatomic,strong)UIButton * attentionBtn;//关注按钮
@property(nonatomic,strong)UIImageView * attentionIcon;//关注图标
@property(nonatomic,strong)NSMutableArray * img_array;//所有图片数组
@end
@implementation PublishInfoView
{
    float top_of_image;//图片上方top
}
-(instancetype)initWithFrame:(CGRect)frame andPublishDictionary:(NSDictionary*)publishDictionary andDelegate:(PublishInfoVC*)delegate{
    if (self = [super initWithFrame:frame]) {
        BOOL isMine = delegate.isMine;
        //主scrollview
        UIScrollView * scrollView = [UIScrollView new];
        self.scrollView = scrollView;
        scrollView.backgroundColor = MYCOLOR_240_240_240;
        scrollView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64-50);
        [self addSubview:scrollView];
        scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [delegate headerRefresh];
            // 结束刷新
            [scrollView.mj_header endRefreshing];
        }];
        
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        scrollView.mj_header.automaticallyChangeAlpha = YES;
        
        // 上拉刷新
        scrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [delegate footerRefresh];
            [scrollView.mj_footer endRefreshing];
        }];
        //用户信息view
        float top_all = 0;
        {
            UIView * view = [UIView new];
            float height = [MYTOOL getHeightWithIphone_six:75];
            top_all += height + 10;
            view.frame = CGRectMake(0, 0, WIDTH, height);
            view.backgroundColor = [UIColor whiteColor];
            [scrollView addSubview:view];
            float left = 10;
            //头像
            {
                float icon_height = 2/3.0*height;//图片高度
                UIImageView * icon = [UIImageView new];
                icon.frame = CGRectMake(left, height/2 - icon_height/2, icon_height, icon_height);
                left += icon_height + 10;
                icon.layer.masksToBounds = true;
                icon.layer.cornerRadius = icon_height/2.0;
                [view addSubview:icon];
                //用户头像
                NSString * url = publishDictionary[@"ImgFilePath"];
                if (url) {
                    [icon sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"morenhdpic"]];
                }
            }
            //用户名字
            {
                UILabel * label = [UILabel new];
                label.font = [UIFont systemFontOfSize:15];
                label.textColor = MYCOLOR_48_48_48;
                NSString * user_name = publishDictionary[@"UserName"];
                label.text = user_name;
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(left, height/2.0-size.height/2.0, size.width, size.height);
                [view addSubview:label];
            }
            //是否认证
            {
                
            }
            //个人详情按钮
            {
                UIButton * btn = [UIButton new];
                btn.frame = CGRectMake(WIDTH - 90, height/2 - 12, 80, 24);
                btn.layer.masksToBounds = true;
                btn.layer.cornerRadius = 12;
                btn.layer.borderWidth = 1;
                btn.layer.borderColor = [MYTOOL RGBWithRed:221 green:221 blue:221 alpha:1].CGColor;
                [btn setTitle:@"个人详情" forState:UIControlStateNormal];
                [btn setTitleColor:[MYTOOL RGBWithRed:112 green:112 blue:112 alpha:1] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:14];
                [view addSubview:btn];
                [btn addTarget:delegate action:@selector(submitPersonalBtn:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        //发布的信息
        {
            UIView * view = [UIView new];
            self.img_bg_view = view;
            float height = [MYTOOL getHeightWithIphone_six:675];
            view.frame = CGRectMake(0, top_all, WIDTH, height);
            view.backgroundColor = [UIColor whiteColor];
            [scrollView addSubview:view];
            float top = 19;
            float left = 10;
            //悬赏金额
            {
                //提示
                {
                    UILabel * label = [UILabel new];
                    label.text = @"悬赏金额";
                    label.font = [UIFont systemFontOfSize:15];
                    label.textColor = MYCOLOR_40_199_0;
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(left, top, size.width, size.height);
                    left += size.width + 18;
                    top += size.height;
                    [view addSubview:label];
                }
                //金额
                {
                    UILabel * label = [UILabel new];
                    label.font = [UIFont systemFontOfSize:24];
                    label.textColor = MYCOLOR_40_199_0;
                    float Money = [publishDictionary[@"Money"] floatValue];
                    NSString * text = [NSString stringWithFormat:@"￥%.2f",Money];
                    if (Money * 10 == (int)(Money * 10)) {
                        text = [NSString stringWithFormat:@"￥%.1f",Money];
                    }
                    if (Money == (int)Money) {
                        text = [NSString stringWithFormat:@"￥%d",(int)Money];
                    }
                    label.text = text;
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(left, top - size.height, size.width, size.height);
                    [view addSubview:label];
                }
            }
            //举报
            {
                UILabel * label = [UILabel new];
                label.text = @"举报";
                label.textColor = [MYTOOL RGBWithRed:144 green:144 blue:144 alpha:1];
                label.font = [UIFont systemFontOfSize:11];
                label.frame = CGRectMake(WIDTH - 45, top - 15, 30, 15);
                label.layer.masksToBounds = true;
                label.layer.cornerRadius = 3;
                label.textAlignment = NSTextAlignmentCenter;
                label.layer.borderWidth = 1;
                label.layer.borderColor = [[MYTOOL RGBWithRed:230 green:230 blue:230 alpha:1] CGColor];
                if (!isMine) {
                    [view addSubview:label];
                }
                //举报按钮
                {
                    UIButton * btn = [UIButton new];
                    btn.frame = CGRectMake(label.frame.origin.x - 5, label.frame.origin.y - 5, 40, 25);
                    [btn addTarget:delegate action:@selector(submitReportBtn:) forControlEvents:UIControlEventTouchUpInside];
                    if (!isMine) {
                        [view addSubview:btn];
                    }
                }
            }
            //发布信息位置
            {
                NSString * ProvinceName = publishDictionary[@"ProvinceName"];
                NSString * CityName = publishDictionary[@"CityName"];
                NSString * Address = publishDictionary[@"Address"];
                NSString * text = @"发布信息位置：暂无";
                if (ProvinceName && CityName && Address) {
                    text = [NSString stringWithFormat:@"发布信息位置：%@%@%@",ProvinceName,CityName,Address];
                }
                NSString * PublishAddress = publishDictionary[@"PublishAddress"];
                if (PublishAddress && PublishAddress.length) {
                    text = [NSString stringWithFormat:@"发布信息位置：%@",PublishAddress];
                }
                top += 12;
                UILabel * label = [UILabel new];
                label.font = [UIFont systemFontOfSize:14];
                label.text = text;
                label.textColor = [MYTOOL RGBWithRed:168 green:168 blue:168 alpha:1];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                int row = size.width / (WIDTH - 20);
                if (row * (WIDTH - 20) < size.width) {
                    row ++;
                }
                label.frame = CGRectMake(10, top, WIDTH - 20, size.height * row);
                [view addSubview:label];
                label.numberOfLines = 0;
                top += size.height * row + 15;
            }
            //发布信息的标题
            {
                left = 10;
                //类型
                {
                    UILabel * label = [UILabel new];
                    label.textColor = [UIColor whiteColor];
                    label.backgroundColor = [MYTOOL RGBWithRed:253 green:102 blue:105 alpha:1];
                    label.font = [UIFont systemFontOfSize:10];
                    label.textAlignment = NSTextAlignmentCenter;
                    NSString * CategoryName = publishDictionary[@"CategoryName"];
                    if (!CategoryName || CategoryName.length == 0) {
                        CategoryName = @"未知";
                    }
                    label.text = CategoryName;
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(left, top, size.width + 6, size.height + 6);
                    [view addSubview:label];
                    left += size.width + 6 + 7;
                }
                //标题
                {
                    UILabel * label = [UILabel new];
                    label.font = [UIFont systemFontOfSize:15];
                    label.textColor = MYCOLOR_48_48_48;
                    NSString * Title = publishDictionary[@"Title"];
                    label.text = Title;
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(left, top, size.width, size.height);
                    [view addSubview:label];
                    top += size.height + 18;
                }
            }
            //详细信息
            {
                UILabel * label = [UILabel new];
                label.font = [UIFont systemFontOfSize:12];
                label.textColor = [MYTOOL RGBWithRed:119 green:119 blue:119 alpha:1];
                NSString * Content = publishDictionary[@"Content"];
                label.text = Content;
                label.numberOfLines = 0;
                CGSize size = [MYTOOL getSizeWithLabel:label];
                int row = size.width / (WIDTH - 20);
                if (row * (WIDTH - 20) < size.width) {
                    row ++;
                }
                label.frame = CGRectMake(10, top, WIDTH - 20, size.height * row);
                [view addSubview:label];
                top += size.height * row + 18;
            }
            top_of_image = top;
            //图片
            {
                self.img_array = [NSMutableArray new];
                NSArray * PictureList = publishDictionary[@"PictureList"];
                __block float img_height = HEIGHT;//图片高度
                for (NSDictionary * pictureDic in PictureList) {
                    //图片链接
                    NSString * url = pictureDic[@"ImgFilePath"];
                    UIImageView * imgV = [UIImageView new];
                    [self.img_array addObject:imgV];
                    imgV.frame = CGRectMake(0, top, WIDTH, img_height);
                    [view addSubview:imgV];
                    [MYTOOL setImageIncludePrograssOfImageView:imgV withUrlString:url andCompleted:^(UIImage *image) {
                        CGSize size = image.size;
                        img_height = WIDTH / size.width * size.height;
                        imgV.frame = CGRectMake(0, imgV.frame.origin.y, WIDTH, img_height);
                        [self updateImageAndCommentLocation];
                    }];
                    top += HEIGHT + 5;
                }
            }
            //目标丢失地
            UIView * down_view = [UIView new];
            down_view.frame = CGRectMake(0, top, WIDTH, 65 + 64+15);
            self.down_view = down_view;
            down_view.backgroundColor = [UIColor whiteColor];
            [view addSubview:down_view];
            top = 15;
            {
                //图标
                {
                    UIImageView * icon = [UIImageView new];
                    icon.image = [UIImage imageNamed:@"address"];
                    icon.frame = CGRectMake(10, top, 9, 11);
                    [down_view addSubview:icon];
                }
                
                NSString * ProvinceName = publishDictionary[@"ProvinceName"];
                NSString * CityName = publishDictionary[@"CityName"];
                NSString * Address = publishDictionary[@"Address"];
                NSString * text = @"目标丢失地：暂无";
                if (ProvinceName && CityName && Address) {
                    text = [NSString stringWithFormat:@"目标丢失地：%@%@%@",ProvinceName,CityName,Address];
                }
                top += 5.5;
                UILabel * label = [UILabel new];
                label.font = [UIFont systemFontOfSize:11];
                label.text = text;
                label.textColor = [MYTOOL RGBWithRed:168 green:168 blue:168 alpha:1];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                int row = size.width / (WIDTH - 10-(10+9+14));
                if (row * (WIDTH - 10-(10+9+14)) < size.width) {
                    row ++;
                }
                label.frame = CGRectMake(10+9+14, top-size.height/2, WIDTH - 10-(10+9+14), size.height * row);
                [down_view addSubview:label];
                label.numberOfLines = 0;
                top += size.height * row + 15;
            }
            //评论人数
            {
                UIView * commentView = [UIView new];
                commentView.backgroundColor = [MYTOOL RGBWithRed:238 green:238 blue:238 alpha:1];
                commentView.frame = CGRectMake(0, top, WIDTH, 44);
                [down_view addSubview:commentView];
                //评论人数-CommentCount
                {
                    UILabel * label = [UILabel new];
                    self.commentCountLabel = label;
                    label.font = [UIFont systemFontOfSize:12];
                    label.textColor = [MYTOOL RGBWithRed:61 green:61 blue:61 alpha:1];
                    int CommentCount = [publishDictionary[@"CommentCount"] intValue];
                    NSString * text = [NSString stringWithFormat:@"评论（%d）",CommentCount];
                    label.text = text;
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    label.frame = CGRectMake(10, 22-size.height/2, size.width, size.height);
                    [commentView addSubview:label];
                }
                
                top += 64;
            }
            //评论区
            {
                //提示
                {
                    UILabel * label = [UILabel new];
                    label.text = @"评论区";
                    label.font = [UIFont systemFontOfSize:13];
                    label.textColor = [MYTOOL RGBWithRed:61 green:61 blue:61 alpha:1];
                    label.frame = CGRectMake(10, top, WIDTH-20, 15);
                    [down_view addSubview:label];
                }
                /*评论列表*/
                top += 20;
                //评论view
                {
                    UIView * commentView = [UIView new];
                    self.commentView = commentView;
                    commentView.frame = CGRectMake(0, top+self.commentTop, WIDTH, 0);
                    [view addSubview:commentView];
                    commentView.backgroundColor = [UIColor whiteColor];
                }
                
                
                top += 10;
            }
            view.frame = CGRectMake(0, view.frame.origin.y, view.frame.size.width+10, top+top_of_image);
            top_all += top + top_of_image;
            self.commentTop = top_all;
        }
        scrollView.contentSize = CGSizeMake(0, top_all);
        //底部按钮
        {
            UIView * view = [UIView new];
            view.backgroundColor = [UIColor whiteColor];
            view.frame = CGRectMake(0, HEIGHT-64-50, WIDTH, 50);
            [self addSubview:view];
            //分割线
            {
                UIView * space = [UIView new];
                space.frame = CGRectMake(0, 0, WIDTH, 1);
                space.backgroundColor = [MYTOOL RGBWithRed:221 green:221 blue:221 alpha:1];
                [view addSubview:space];
            }
            //关注-info_ft_gz
            //已关注-info_ft_gzed
            {
                //图标
                {
                    UIImageView * icon = [UIImageView new];
                    icon.frame = CGRectMake(WIDTH/8-9, 9, 18, 16);
                    [view addSubview:icon];
                    self.attentionIcon = icon;
                    icon.image = [UIImage imageNamed:@"info_ft_gz"];
                }
                //文字
                {
                    UILabel * label = [UILabel new];
                    label.text = @"关注";
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor = [MYTOOL RGBWithRed:112 green:112 blue:112 alpha:1];
                    label.font = [UIFont systemFontOfSize:12];
                    label.frame = CGRectMake(0, 27, WIDTH/4, 20);
                    [view addSubview:label];
                }
                //按钮
                {
                    UIButton * btn = [UIButton new];
                    btn.tag = 0;
                    self.attentionBtn = btn;
                    btn.frame = CGRectMake(0, 0, WIDTH/4, 50);
                    [btn addTarget:delegate action:@selector(submitAttentionBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:btn];
                }
            }
            //分割线
            {
                UIView * space = [UIView new];
                space.frame = CGRectMake(WIDTH/4-0.5, 7, 1, 36);
                space.backgroundColor = [MYTOOL RGBWithRed:221 green:221 blue:221 alpha:1];
                [view addSubview:space];
            }
            //评论
            {
                //图标
                {
                    UIImageView * icon = [UIImageView new];
                    icon.frame = CGRectMake(WIDTH/8*3-9, 9, 18, 16);
                    [view addSubview:icon];
                    icon.image = [UIImage imageNamed:@"comments_btn"];
                }
                //文字
                {
                    UILabel * label = [UILabel new];
                    label.text = @"评论";
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor = [MYTOOL RGBWithRed:112 green:112 blue:112 alpha:1];
                    label.font = [UIFont systemFontOfSize:12];
                    label.frame = CGRectMake(WIDTH/4, 27, WIDTH/4, 20);
                    [view addSubview:label];
                }
                //按钮
                {
                    UIButton * btn = [UIButton new];
                    btn.frame = CGRectMake(WIDTH/4, 0, WIDTH/4, 50);
                    [btn addTarget:delegate action:@selector(submitCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:btn];
                }
            }
            //我有线索
            if (!isMine) {
                UIButton * btn = [UIButton new];
                btn.backgroundColor = [MYTOOL RGBWithRed:250 green:101 blue:104 alpha:1];
                btn.titleLabel.font = [UIFont systemFontOfSize:15];
                btn.frame = CGRectMake(WIDTH/2, 0, WIDTH/2, 50);
                [view addSubview:btn];
                //一级分类id
                int ParentCategoryID = [publishDictionary[@"ParentCategoryID"] intValue];
                if (ParentCategoryID == 394) {
                    [btn setTitle:@"我要认领" forState:UIControlStateNormal];
                    [btn addTarget:delegate action:@selector(submitClaimBtn:) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    [btn addTarget:delegate action:@selector(submitMyClueBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [btn setTitle:@"我有线索" forState:UIControlStateNormal];
                }
            }else{//我的界面过来
                UIButton * btn = [UIButton new];
                btn.backgroundColor = [MYTOOL RGBWithRed:250 green:101 blue:104 alpha:1];
                btn.titleLabel.font = [UIFont systemFontOfSize:15];
                btn.frame = CGRectMake(WIDTH/3*2, 0, WIDTH/3, 50);
                [view addSubview:btn];
                //一级分类id
                int ParentCategoryID = [publishDictionary[@"ParentCategoryID"] intValue];
                if (ParentCategoryID == 394) {
                    [btn setTitle:@"查看认领" forState:UIControlStateNormal];
                    [btn addTarget:delegate action:@selector(submitLookClain) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    [btn addTarget:delegate action:@selector(submitLookClue) forControlEvents:UIControlEventTouchUpInside];
                    [btn setTitle:@"查看线索" forState:UIControlStateNormal];
                }
            }
        }
        
    }
    return self;
}
//刷新图片下方图片位置和评论相关
-(void)updateImageAndCommentLocation{
    float top = top_of_image;
    for (UIImageView * imgV in self.img_array) {
        imgV.frame = CGRectMake(0, top, WIDTH, imgV.frame.size.height);
        top += imgV.frame.size.height + 5;
    }
    self.img_bg_view.frame = CGRectMake(0, self.img_bg_view.frame.origin.y, WIDTH, top);
    self.down_view.frame = CGRectMake(0, top, WIDTH, self.down_view.frame.size.height);
    top += self.down_view.frame.size.height;
    self.commentTop = top;
    self.commentView.frame = CGRectMake(0, top, WIDTH, self.commentView.frame.size.height);
    self.scrollView.contentSize = CGSizeMake(0, 10 + [MYTOOL getHeightWithIphone_six:75] + top + self.commentView.frame.size.height);
}
//更新关注状态
-(void)updateAttentionStatus:(UIButton *)btn{
    //关注-info_ft_gz
    //已关注-info_ft_gzed
    NSInteger tag = btn.tag;
    if (tag) {//已关注
        self.attentionBtn.tag = 1;
        self.attentionIcon.image = [UIImage imageNamed:@"info_ft_gzed"];
    }else{//未关注
        self.attentionBtn.tag = 0;
        self.attentionIcon.image = [UIImage imageNamed:@"info_ft_gz"];
    }
    
}
//设置评论人数
-(void)setCommentCount:(int)count{
    UILabel * label = self.commentCountLabel;
    NSString * text = [NSString stringWithFormat:@"评论（%d）",count];
    label.text = text;
    CGSize size = [MYTOOL getSizeWithLabel:label];
    label.frame = CGRectMake(10, 22-size.height/2, size.width, size.height);
}
//重新加载评论界面
-(void)loadCommentViewWithArray:(NSArray *)commentList andIsHeaderRefresh:(BOOL)flag{
    int count = (int)commentList.count;
    [self setCommentCount:count];
    self.commentView.frame = CGRectMake(0, self.commentView.frame.origin.y, WIDTH, 45*count);
    self.scrollView.contentSize = CGSizeMake(0, self.commentTop + 45*count);
    //清除所有子控件
    for (id v in self.commentView.subviews) {
        [v removeFromSuperview];
    }
    float top = 0;
    //加载所有评论
    for(int i = 0; i < commentList.count ; i ++){
        NSDictionary * dictionary = commentList[i];
        //头像
        {
            NSString * url = dictionary[@"ImgFilePath"];
            UIImageView * icon = [UIImageView new];
            icon.frame = CGRectMake(10, 22.5 - 15 + top, 30, 30);
            icon.layer.masksToBounds = true;
            icon.layer.cornerRadius = 15;
            [self.commentView addSubview:icon];
            //默认头像
            icon.image = [UIImage imageNamed:@"morenhdpic"];
            if (url) {
                [icon sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"morenhdpic"]];
            }
        }
        //用户名字
        {
            NSString * name = dictionary[@"UserName"];
            UILabel * label = [UILabel new];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [MYTOOL RGBWithRed:61 green:61 blue:61 alpha:1];
            label.text = name;
            CGSize size = [MYTOOL getSizeWithLabel:label];
            label.frame = CGRectMake(45, top + 22.5 - size.height-1, size.width, size.height);
            [self.commentView addSubview:label];
        }
        //评论时间
        {
            NSString * time = dictionary[@"CreateTime"];
            UILabel * label = [UILabel new];
            label.font = [UIFont systemFontOfSize:10];
            label.text = time;
            label.textColor = [MYTOOL RGBWithRed:144 green:144 blue:144 alpha:1];
            CGSize size = [MYTOOL getSizeWithLabel:label];
            label.frame = CGRectMake(WIDTH - 10 - size.width, top + 22.5 - size.height-2, size.width, size.height);
            [self.commentView addSubview:label];
        }
        //评论内容
        {
            NSString * content = dictionary[@"Content"];
            UILabel * label = [UILabel new];
            label.text = content;
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = MYCOLOR_144;
            CGSize size = [MYTOOL getSizeWithLabel:label];
            label.frame = CGRectMake(45, top + 22.5 + 2, WIDTH - 45 - 10, size.height);
            [self.commentView addSubview:label];
        }
        
        //分割线
        {
            UIView * space = [UIView new];
            space.frame = CGRectMake(45, top + 44, WIDTH-10-45, 1);
            space.backgroundColor = MYCOLOR_240_240_240;
            [self.commentView addSubview:space];
        }
        top += 45;
    }
    
    [self updateImageAndCommentLocation];
}
@end
