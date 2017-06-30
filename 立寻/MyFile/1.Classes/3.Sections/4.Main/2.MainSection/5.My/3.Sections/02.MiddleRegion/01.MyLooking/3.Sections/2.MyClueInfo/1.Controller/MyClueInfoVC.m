//
//  MyClueInfoVC.m
//  立寻
//
//  Created by Mac on 17/6/30.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "MyClueInfoVC.h"

@interface MyClueInfoVC ()<UIScrollViewDelegate>
@property(nonatomic,assign)UILabel * num_label;//预览图片显示第几张

@end

@implementation MyClueInfoVC
{
    UIView * show_view;//查看图片的辅助view
    UIImageView * show_img_view;//查看图片的view
    int review_pageNo;//评论数据分页数
    NSMutableArray * imgViewArray;//图片数组
    float offset;//
    NSArray * PictureList;//所有图片list
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(popUpViewController)];
    self.view.backgroundColor = [UIColor whiteColor];
    //加载主界面
    [self loadMainView];
}
//加载主界面
-(void)loadMainView{
    float top = 0;
    //用户信息
    {
        float left = 10;
        float top_middle = [MYTOOL getHeightWithIphone_six:60]/2;
        //用户头像
        {
            float height = top_middle * 2 * 35/60.0;
            UIImageView * icon = [UIImageView new];
            icon.frame = CGRectMake(left, top_middle - height/2, height, height);
            icon.layer.masksToBounds = true;
            icon.layer.cornerRadius = height/2.0;
            NSString * ImgFilePath = self.claimDictionary[@"ImgFilePath"];
            [icon sd_setImageWithURL:[NSURL URLWithString:ImgFilePath] placeholderImage:[UIImage imageNamed:@"morenhdpic"]];
            [self.view addSubview:icon];
            left += height + 10;
        }
        //用户名
        {
            NSString * UserName = self.claimDictionary[@"UserName"];
            UILabel * label = [UILabel new];
            label.text = UserName;
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = MYCOLOR_48_48_48;
            CGSize size = [MYTOOL getSizeWithLabel:label];
            label.frame = CGRectMake(left, top_middle - size.height/2, size.width, size.height);
            [self.view addSubview:label];
        }
        //审核状态(1:待审核，2：审核通过，3:审核不通过)-CheckState
        {
            int CheckState = [self.claimDictionary[@"CheckState"] intValue];
            UILabel * label = [UILabel new];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [MYTOOL RGBWithRed:255 green:101 blue:101 alpha:1];
            NSString * text = @"";
            switch (CheckState) {
                case 1:
                    text = @"待审核";
                    break;
                case 2:
                    text = @"审核通过";
                    break;
                default:
                    text = @"审核不通过";
                    break;
            }
            label.text = text;
            CGSize size = [MYTOOL getSizeWithLabel:label];
            label.frame = CGRectMake(WIDTH - 10 - size.width, top_middle - size.height/2, size.width, size.height);
            [self.view addSubview:label];
        }
    }
    //分割线
    {
        top = [MYTOOL getHeightWithIphone_six:60];
        UIView * space = [UIView new];
        space.frame = CGRectMake(10, top, WIDTH - 20, 1);
        space.backgroundColor = MYCOLOR_240_240_240;
        [self.view addSubview:space];
    }
    //帖子信息
    {
        //悬赏金上方坐标
        float btn_top = [MYTOOL getHeightWithIphone_six:136];
        //图片
        float left = 10;
        //图片高度
        float imgHeight = btn_top - top - 16;
        //图片
        {
            UIImageView * imgV = [UIImageView new];
            imgV.frame = CGRectMake(left, top + 8, imgHeight, imgHeight);
            [MYTOOL setImageIncludePrograssOfImageView:imgV withUrlString:self.claimDictionary[@"PublishPicturePath"]];
            [self.view addSubview:imgV];
            left += imgHeight + 10;
        }
        //标题
        float title_middle_top = 0;
        {
            top += 8;
            UILabel * label = [UILabel new];
            label.text = self.claimDictionary[@"PublishTitle"];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = MYCOLOR_48_48_48;
            CGSize size = [MYTOOL getSizeWithLabel:label];
            label.frame = CGRectMake(left, top, size.width, size.height);
            [self.view addSubview:label];
            title_middle_top = top + size.height/2;
        }
        //内容
        {
            UILabel * label = [UILabel new];
            label.text = self.claimDictionary[@"Content"];
            label.font = [UIFont systemFontOfSize:11];
            label.textColor = [MYTOOL RGBWithRed:136 green:136 blue:136 alpha:1];
            CGSize size = [MYTOOL getSizeWithLabel:label];
            //宽度
            float label_width = WIDTH - 10 - left;
            label.frame = CGRectMake(left, top + imgHeight/2.0-3, label_width, size.height*2);
            [self.view addSubview:label];
            label.numberOfLines = 0;
            if (size.width > label_width * 2 + label.font.pointSize * 2) {
                
            }
        }
        //图片下方坐标
        float img_lower_top = top + imgHeight;
        //认领金区域
        {
            UIImageView * icon = [UIImageView new];
            icon.image = [UIImage imageNamed:@"xtb"];
            icon.frame = CGRectMake(10, img_lower_top + ([MYTOOL getHeightWithIphone_six:162]-img_lower_top)/2.0-6.5, 37, 13);
            [self.view addSubview:icon];
            //区域文字
            {
                UILabel * label = [UILabel new];
                label.font = [UIFont systemFontOfSize:9];
                label.text = @"认领金";
                label.textColor = MYCOLOR_144;
                label.frame = icon.bounds;
                [icon addSubview:label];
                label.textAlignment = NSTextAlignmentCenter;
            }
            //推广价格
            {
                UILabel * label = [UILabel new];
                label.text = [NSString stringWithFormat:@"%@元", self.claimDictionary[@"PublishMoney"]];
                label.textColor = [MYTOOL RGBWithRed:255 green:83 blue:95 alpha:1];
                label.font = [UIFont systemFontOfSize:12];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(10+37+10, icon.frame.origin.y+icon.frame.size.height/2-size.height/2, size.width, size.height);
                [self.view addSubview:label];
            }
        }

        
    }
    //分割线
    {
        top = [MYTOOL getHeightWithIphone_six:162];
        UIView * space = [UIView new];
        space.frame = CGRectMake(0, top, WIDTH, 6);
        space.backgroundColor = MYCOLOR_240_240_240;
        [self.view addSubview:space];
    }
    //留言
    {
        top = [MYTOOL getHeightWithIphone_six:186];
        UILabel * label = [UILabel new];
        label.text = @"Ta的留言";
        if (self.isMine) {
            label.text = @"我的留言";
        }
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = MYCOLOR_48_48_48;
        CGSize size = [MYTOOL getSizeWithLabel:label];
        label.frame = CGRectMake(10, top, size.width, size.height);
        [self.view addSubview:label];
        //留言框
        {
            //背景
            {
                top += 10 + size.height;
                UIView * bgView = [UIView new];
                bgView.frame = CGRectMake(10, top, WIDTH - 20, [MYTOOL getHeightWithIphone_six:92]);
                bgView.backgroundColor = [MYTOOL RGBWithRed:250 green:250 blue:250 alpha:1];
                [self.view addSubview:bgView];
                //留言
                {
                    UILabel * label = [UILabel new];
                    NSString * Content = self.claimDictionary[@"Content"];
                    label.text = Content;
                    label.font = [UIFont systemFontOfSize:11];
                    label.textColor = MYCOLOR_144;
                    CGSize size = [MYTOOL getSizeWithLabel:label];
                    int row = size.width / (WIDTH - 40);
                    if ((WIDTH - 40) * row < size.width) {
                        row ++;
                    }
                    label.frame = CGRectMake(10, 10, WIDTH - 40, size.height*row);
                    [bgView addSubview:label];
                    label.numberOfLines = 0;
                    if (label.frame.size.height > bgView.frame.size.height - 20) {
                        bgView.frame = CGRectMake(10, top, WIDTH - 20, label.frame.size.height + 20);
                    }
                }
                top += bgView.frame.size.height + 20;
            }
        }
    }
    //上传的照片
    {
        UILabel * label = [UILabel new];
        label.text = @"Ta上传的照片";
        if (self.isMine) {
            label.text = @"我上传的照片";
        }
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = MYCOLOR_48_48_48;
        CGSize size = [MYTOOL getSizeWithLabel:label];
        label.frame = CGRectMake(10, top, size.width, size.height);
        [self.view addSubview:label];
        top += size.height + 10;
        //图片
        {
            float width = (WIDTH - 50)/4;
            PictureList = self.claimDictionary[@"PictureList"];
            imgViewArray = [NSMutableArray new];
            for (int i = 0; i < PictureList.count; i ++) {
                int row = i / 4;//行
                int col = i % 4;//列
                UIImageView * imgV = [UIImageView new];
                imgV.contentMode = UIViewContentModeScaleAspectFill;
                imgV.clipsToBounds=YES;//  是否剪切掉超出 UIImageView 范围的图片
                [imgV setContentScaleFactor:[[UIScreen mainScreen] scale]];
                imgV.frame = CGRectMake(10+col*(width+5), top+row*(width+5)+10, width, width);
                imgV.layer.masksToBounds = true;
                //            imgV.layer.cornerRadius = 12;
                imgV.tag = i;
                [imgViewArray addObject:imgV];
                [self.view addSubview:imgV];
                NSString * img_url = PictureList[i][@"ImgFilePath"];
                [imgV sd_setImageWithURL:[NSURL URLWithString:img_url] placeholderImage:[UIImage imageNamed:@"test_bg"]];
                [imgV setUserInteractionEnabled:YES];
                UITapGestureRecognizer * tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showZoomImageView1:)];
                tapGesture2.numberOfTapsRequired=1;
                [imgV addGestureRecognizer:tapGesture2];
            }
        }
    }
}
//缩放图片
-(void)showZoomImageView1:(UITapGestureRecognizer *)tap
{
    if (![(UIImageView *)tap.view image]) {
        return;
    }
    //    UIView *bgView = [[UIView alloc] init];
    [self deleteOtherImageView];
    //
    UIScrollView *bgView = [[UIScrollView alloc] init];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.contentSize = CGSizeMake(WIDTH, HEIGHT);
    bgView.delegate = self;
    bgView.minimumZoomScale = 1.0;
    bgView.maximumZoomScale = 3.0;
    [bgView setZoomScale:1.0];
    UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    //
    bgView.tag = tap.view.tag;
    show_view = bgView;
    bgView.frame = [UIScreen mainScreen].bounds;
    bgView.backgroundColor = [UIColor blackColor];
    [[[UIApplication sharedApplication] keyWindow] addSubview:bgView];
    UITapGestureRecognizer *tapBgView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView:)];
    [bgView addGestureRecognizer:tapBgView];
    //滑动事件-下一张
    UISwipeGestureRecognizer * swipeGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showNextImageView:)];
    swipeGest.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeGest.numberOfTouchesRequired = 1;
    [bgView addGestureRecognizer:swipeGest];
    //滑动事件-上一张
    UISwipeGestureRecognizer * swipeGest_up = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showUpImageView:)];
    swipeGest_up.direction = UISwipeGestureRecognizerDirectionRight;
    swipeGest_up.numberOfTouchesRequired = 1;
    [bgView addGestureRecognizer:swipeGest_up];
    //必不可少的一步，如果直接把点击获取的imageView拿来玩的话，返回的时候，原图片就完蛋了
    
    UIImageView *tempImageView = (UIImageView*)tap.view;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:tempImageView.frame];
    NSString * url_string = PictureList[tempImageView.tag][@"ImgFilePath"];
    [imageView sd_setImageWithURL:[NSURL URLWithString:url_string] placeholderImage:[UIImage imageNamed:@"logo"]];
    show_img_view = imageView;
    imageView.tag = tap.view.tag;
    [bgView addSubview:imageView];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = imageView.frame;
        frame.size.width = bgView.frame.size.width;
        frame.size.height = frame.size.width * (imageView.image.size.height / imageView.image.size.width);
        frame.origin.x = 0;
        frame.origin.y = (bgView.frame.size.height - frame.size.height) * 0.5;
        imageView.frame = frame;
    } completion:^(BOOL finished) {
        //
        [imageView addGestureRecognizer:doubleTap];
        [self deleteOtherImageView];
        //
    }];
    
    //    NSLog(@"tag:%ld",tap.view.tag);
    //增加-1/2-序号
    if (!self.num_label) {
        UILabel * label = [UILabel new];
        [bgView addSubview:label];
        self.num_label = label;
        self.num_label.frame = CGRectMake(WIDTH/4, 30, WIDTH/2, 20);
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
    }
    self.num_label.text = [NSString stringWithFormat:@"%ld / %ld",tap.view.tag+1,[PictureList count]];
    
}
#pragma mark -
-(void)handleDoubleTap:(UIGestureRecognizer *)gesture{
    
    float newScale = [(UIScrollView*)gesture.view.superview zoomScale] * 1.5;
    CGRect zoomRect = [self zoomRectForScale:newScale  inView:(UIScrollView*)gesture.view.superview withCenter:[gesture locationInView:gesture.view]];
    [(UIScrollView*)gesture.view.superview zoomToRect:zoomRect animated:YES];
}
#pragma mark - Utility methods

- (CGRect)zoomRectForScale:(float)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    zoomRect.size.width  = [scrollView frame].size.width  / scale;
    zoomRect.size.height = zoomRect.size.width/WIDTH*HEIGHT;
    
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}
#pragma mark - ScrollView delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    for (UIView *v in scrollView.subviews){
        return v;
    }
    return nil;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x;
    if (x==offset){
        
    }
    else {
        offset = x;
        for (UIScrollView *s in scrollView.subviews){
            if ([s isKindOfClass:[UIScrollView class]]){
                [s setZoomScale:1.0];
            }
        }
    }
}
//再次点击取消全屏预览
-(void)tapBgView:(UITapGestureRecognizer *)tapBgRecognizer{
    show_view = nil;
    show_img_view = nil;
    self.num_label = nil;
    [tapBgRecognizer.view removeFromSuperview];
}
//查看上一张
-(void)showUpImageView:(UISwipeGestureRecognizer *)tapBgRecognizer{
    NSInteger tag = tapBgRecognizer.view.tag;
    //    NSLog(@"上一张:%ld",tag);
    if (tag > 0) {//可以显示上一张[imgV sd_setImageWithURL:[NSURL URLWithString:self.post_dic[@"url"][tag-1][@"normalUrl"]]];
        [self deleteOtherImageView];
        UIImageView * imgV = [UIImageView new];
        [show_view insertSubview:imgV atIndex:0];
        UIImageView * img_view = imgViewArray[tag-1];
        [imgV sd_setImageWithURL:[NSURL URLWithString:PictureList[tag-1][@"ImgFilePath"]]];
        show_view.tag = tag - 1;
        CGRect frame1 = img_view.frame;
        frame1.size.width = WIDTH;
        frame1.size.height = WIDTH * (img_view.image.size.height / img_view.image.size.width);
        frame1.origin.x = -WIDTH;
        frame1.origin.y = (show_view.frame.size.height - frame1.size.height) * 0.5;
        imgV.frame = frame1;
        [UIView animateWithDuration:0.3 animations:^{
            show_img_view.frame = CGRectMake(WIDTH, show_img_view.frame.origin.y, WIDTH, show_img_view.frame.size.height);
            imgV.frame = CGRectMake(0, frame1.origin.y, frame1.size.width, frame1.size.height);
            show_img_view = imgV;
            self.num_label.text = [NSString stringWithFormat:@"%ld / %ld",show_view.tag+1,[PictureList count]];
        } completion:^(BOOL finished) {
            [self deleteOtherImageView];
        }];
    }
}
//查看下一张
-(void)showNextImageView:(UISwipeGestureRecognizer *)tapBgRecognizer{
    NSInteger tag = tapBgRecognizer.view.tag;
    //    NSLog(@"下一张:%ld",tag);
    //总图片个数
    NSInteger count = [PictureList count];
    if (tag < count - 1) {//可以显示下一张
        [self deleteOtherImageView];
        UIImageView * imgV = [UIImageView new];
        [show_view insertSubview:imgV atIndex:0];
        UIImageView * img_view = imgViewArray[tag+1];
        [imgV sd_setImageWithURL:[NSURL URLWithString:PictureList[tag+1][@"ImgFilePath"]]];
        show_view.tag = tag + 1;
        CGRect frame1 = img_view.frame;
        frame1.size.width = WIDTH;
        frame1.size.height = WIDTH * (img_view.image.size.height / img_view.image.size.width);
        frame1.origin.x = WIDTH;
        frame1.origin.y = (show_view.frame.size.height - frame1.size.height) * 0.5;
        imgV.frame = frame1;
        [UIView animateWithDuration:0.3 animations:^{
            show_img_view.frame = CGRectMake(-WIDTH, show_img_view.frame.origin.y, WIDTH, show_img_view.frame.size.height);
            imgV.frame = CGRectMake(0, frame1.origin.y, frame1.size.width, frame1.size.height);
            show_img_view = imgV;
            self.num_label.text = [NSString stringWithFormat:@"%ld / %ld",show_view.tag+1,[PictureList count]];
        } completion:^(BOOL finished) {
            [self deleteOtherImageView];
        }];
    }
}
//删掉其他多余的imageview
-(void)deleteOtherImageView{
    for (id v in show_view.subviews) {
        if (![v isEqual:show_img_view] & [v isKindOfClass:[UIImageView class]]) {
            [v removeFromSuperview];
        }
    }
}



//返回上个界面
-(void)popUpViewController{
    [self.navigationController popViewControllerAnimated:true];
}
-(void)viewWillAppear:(BOOL)animated{
    [MYTOOL hiddenTabBar];
}
-(void)viewWillDisappear:(BOOL)animated{
    [MYTOOL showTabBar];
}
@end
