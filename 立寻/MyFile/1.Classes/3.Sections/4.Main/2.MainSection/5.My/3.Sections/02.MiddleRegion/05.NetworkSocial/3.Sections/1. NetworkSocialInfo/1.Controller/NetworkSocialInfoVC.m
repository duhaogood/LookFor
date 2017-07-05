//
//  NetworkSocialInfoVC.m
//  立寻
//
//  Created by Mac on 17/6/18.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "NetworkSocialInfoVC.h"

@interface NetworkSocialInfoVC ()
@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)UILabel * num_label;//预览图片时显示的图片序号
@property(nonatomic,strong)NSMutableArray * img_arr;//图片view数组
@end

@implementation NetworkSocialInfoVC
{
    UIView * show_view;//查看图片的辅助view
    UIImageView * currentImgView;//当前编辑的图片框
    UIImageView * show_img_view;//查看图片的view
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //加载主界面
    [self loadMainView];
}
//加载主界面
-(void)loadMainView{
    //背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(popUpViewController)];
    //背景view
    UIScrollView * scrollView = [UIScrollView new];
    {
        scrollView.frame = self.view.bounds;
        [self.view addSubview:scrollView];
    }
    float top = 12;
    float left = 10;
    //用户头像
    {
        UIImageView * icon = [UIImageView new];
        icon.frame = CGRectMake(left, top, 35, 35);
        [MYTOOL setImageIncludePrograssOfImageView:icon withUrlString:self.publishDictionary[@"ImgFilePath"]];
        icon.layer.masksToBounds = true;
        icon.layer.cornerRadius = 35/2.0;
        [scrollView addSubview:icon];
    }
    //用户名字
    left += 35 + 10;
    {
        NSString * userName = self.publishDictionary[@"UserName"];
        UILabel * label = [UILabel new];
        label.text = userName;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = MYCOLOR_48_48_48;
        CGSize size = [MYTOOL getSizeWithLabel:label];
        label.frame = CGRectMake(left, top + 35/2.0-size.height/2, size.width, size.height);
        [scrollView addSubview:label];
    }
    //状态-审核状态(1.待审核，2.审核通过，3.审核不通过)
    {
      
        UILabel * label = [UILabel new];
        int CheckState = [self.publishDictionary[@"CheckState"] intValue];
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
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [MYTOOL RGBWithRed:255 green:101 blue:101 alpha:1];
        CGSize size = [MYTOOL getSizeWithLabel:label];
        label.frame = CGRectMake(WIDTH - 10-size.width, top + 35/2.0-size.height/2, size.width, size.height);
        [scrollView addSubview:label];
    }
    top += 35 + 12;
    //分割线
    {
        UIView * space = [UIView new];
        space.frame = CGRectMake(10, top, WIDTH - 20, 1);
        space.backgroundColor = MYCOLOR_240_240_240;
        [scrollView addSubview:space];
    }
    //
    
    //图片高度
    float imgHeight = 60;
    left = 10;
    //图片
    {
        UIImageView * imgV = [UIImageView new];
        imgV.frame = CGRectMake(left, top + 8, imgHeight, imgHeight);
        [MYTOOL setImageIncludePrograssOfImageView:imgV withUrlString:self.publishDictionary[@"PicturePath"]];
        [scrollView addSubview:imgV];
        left += imgHeight + 10;
    }
    //标题
    float title_middle_top = 0;
    {
        top += 8;
        UILabel * label = [UILabel new];
        label.text = self.publishDictionary[@"Title"];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = MYCOLOR_48_48_48;
        CGSize size = [MYTOOL getSizeWithLabel:label];
        label.frame = CGRectMake(left, top, size.width, size.height);
        [scrollView addSubview:label];
        title_middle_top = top + size.height/2;
    }
    //内容
    {
        UILabel * label = [UILabel new];
        label.text = self.publishDictionary[@"Content"];
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = [MYTOOL RGBWithRed:136 green:136 blue:136 alpha:1];
        CGSize size = [MYTOOL getSizeWithLabel:label];
        //宽度
        float label_width = WIDTH - 10 - left;
        label.frame = CGRectMake(left, top + imgHeight/2.0-3, label_width, size.height*2);
        [scrollView addSubview:label];
        label.numberOfLines = 0;
        if (size.width > label_width * 2 + label.font.pointSize * 2) {
            
        }
    }
    top += 60 + 16;
    
    //
    top += 10;
    //我上传的照片
    {
        //提示
        {
            UILabel * label = [UILabel new];
            label.text = @"我上传的照片";
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = MYCOLOR_48_48_48;
            label.frame = CGRectMake(10, top, WIDTH-20, 15);
            [scrollView addSubview:label];
        }
        top += 20;
        //图片
        {
            float img_width = (WIDTH -50)/4;//图片的宽和高
            //图片imageView
            self.img_arr = [NSMutableArray new];
            //图片数组
            NSArray * array = self.publishDictionary[@"PictureList"];
            for (int i = 0; i < array.count; i ++) {
                int row = i / 4;//行
                int col = i % 4;//列
                UIImageView * icon = [UIImageView new];
                icon.frame = CGRectMake(10 + (10 + img_width)*col, top + row * (10+img_width), img_width, img_width);
                [MYTOOL setImageIncludePrograssOfImageView:icon withUrlString:array[i][@"ImgFilePath"]];
                [scrollView addSubview:icon];
                icon.userInteractionEnabled = true;
                icon.tag = i;
                [self.img_arr addObject:icon];
                UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showZoomImageView2:)];
                [icon addGestureRecognizer:tapGesture];
            }
            top += (array.count - 1)/4 + 1;
        }
    }
    
    
    
    
    
    
    
}




//缩放图片
-(void)showZoomImageView2:(UITapGestureRecognizer *)tap{
    if (![tap view]) {
        return;
    }
    UIView *bgView = [[UIView alloc] init];
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
    
    UIImageView *tempImageView = (UIImageView *)tap.view;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:tempImageView.frame];
    imageView.image = tempImageView.image;
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
    }];
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
    
    self.num_label.text = [NSString stringWithFormat:@"%ld / %ld",tap.view.tag+1,[self.publishDictionary[@"PictureList"] count]];
}
//查看上一张
-(void)showUpImageView:(UISwipeGestureRecognizer *)tapBgRecognizer{
    NSInteger tag = tapBgRecognizer.view.tag;
    if (tag > 0) {//可以显示上一张
        UIImageView * imgV = [UIImageView new];
        [show_view insertSubview:imgV atIndex:0];
        UIImageView * img_view = self.img_arr[tag - 1];
        imgV.image = img_view.image;
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
            self.num_label.text = [NSString stringWithFormat:@"%ld / %ld",show_view.tag+1,self.img_arr.count];
        }];
    }
}
//查看下一张
-(void)showNextImageView:(UISwipeGestureRecognizer *)tapBgRecognizer{
    NSInteger tag = tapBgRecognizer.view.tag;
    //总图片个数
    NSInteger count = self.img_arr.count;
    if (tag < count - 1) {//可以显示下一张
        UIImageView * imgV = [UIImageView new];
        [show_view insertSubview:imgV atIndex:0];
        UIImageView * img_view = self.img_arr[tag + 1];
        imgV.image = img_view.image;
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
            self.num_label.text = [NSString stringWithFormat:@"%ld / %ld",show_view.tag+1,self.img_arr.count];
        }];
    }
}
//再次点击取消全屏预览
-(void)tapBgView:(UITapGestureRecognizer *)tapBgRecognizer{
    self.num_label = nil;
    [tapBgRecognizer.view removeFromSuperview];
}



//返回上个界面
-(void)popUpViewController{
    [self.navigationController popViewControllerAnimated:true];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [MYTOOL hideKeyboard];
}
-(void)viewWillAppear:(BOOL)animated{
    [MYTOOL hiddenTabBar];
}
-(void)viewWillDisappear:(BOOL)animated{
    [MYTOOL showTabBar];
}
@end
