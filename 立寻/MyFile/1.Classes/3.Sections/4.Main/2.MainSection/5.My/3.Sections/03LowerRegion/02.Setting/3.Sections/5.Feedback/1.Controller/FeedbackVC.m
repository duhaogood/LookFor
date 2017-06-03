//
//  FeedbackVC.m
//  立寻
//
//  Created by mac on 2017/5/31.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "FeedbackVC.h"

@interface FeedbackVC ()<UIImagePickerControllerDelegate,UITextViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UIButton * selectTypeLeftBtn;//投诉举报按钮
@property(nonatomic,strong)UIButton * selectTypeRightBtn;//APP吐槽按钮
@property(nonatomic,strong)UIView * submitView;//按钮下侧提交view
@property(nonatomic,strong)UITextField * nickNameTF;//昵称tf
@property(nonatomic,strong)UITextView * contentTV;//举报原因
@property(nonatomic,strong)UILabel * contentCountLabel;//content字数
@property(nonatomic,strong)NSMutableArray * img_arr;//图片view数组
@property(nonatomic,strong)UILabel * num_label;//预览图片时显示的图片序号

@end

@implementation FeedbackVC
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
    //返回按钮
    self.view.backgroundColor = [MYTOOL RGBWithRed:242 green:242 blue:242 alpha:1];
    //返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(popUpViewController)];
    float top_all = 0;
    //选择种类
    {
        //背景图
        float height = [MYTOOL getHeightWithIphone_six:58];
        float left = 10;
        UIView * view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(0, 0, WIDTH, height);
        [self.view addSubview:view];
        //文字
        {
            UILabel * label = [UILabel new];
            label.text = @"选择种类:";
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = MYCOLOR_48_48_48;
            CGSize size = [MYTOOL getSizeWithLabel:label];
            label.frame = CGRectMake(left, height/2-size.height/2, size.width, size.height);
            [view addSubview:label];
            left += size.width + 16;
        }
        //两个按钮
        {
            float btn_width = [MYTOOL getHeightWithIphone_six:70];
            float btn_height = [MYTOOL getHeightWithIphone_six:24];
            //投诉举报
            {
                UIButton * btn = [UIButton new];
                btn.frame = CGRectMake(left, height/2 - btn_height/2, btn_width, btn_height);
                btn.titleLabel.font = [UIFont systemFontOfSize:12];
                [btn setTitle:@"投诉举报" forState:UIControlStateNormal];
                [btn setTitleColor:MYCOLOR_48_48_48 forState:UIControlStateNormal];
                [btn setTitleColor:MYCOLOR_40_199_0 forState:UIControlStateDisabled];
                [view addSubview:btn];
                self.selectTypeLeftBtn = btn;
                btn.enabled = false;
                left += btn_width + 7;
                [btn addTarget:self action:@selector(selectTypeLeftBtnCallback:) forControlEvents:UIControlEventTouchUpInside];
                [btn setBackgroundImage:[UIImage imageNamed:@"btn_select"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"btn_selected"] forState:UIControlStateDisabled];
            }
            //APP吐槽
            {
                UIButton * btn = [UIButton new];
                btn.frame = CGRectMake(left, height/2 - btn_height/2, btn_width, btn_height);
                btn.titleLabel.font = [UIFont systemFontOfSize:12];
                [btn setTitle:@"APP吐槽" forState:UIControlStateNormal];
                [btn setTitleColor:MYCOLOR_48_48_48 forState:UIControlStateNormal];
                [btn setTitleColor:MYCOLOR_40_199_0 forState:UIControlStateDisabled];
                [view addSubview:btn];
                self.selectTypeRightBtn = btn;
                [btn addTarget:self action:@selector(selectTypeRightBtnCallback:) forControlEvents:UIControlEventTouchUpInside];
                [btn setBackgroundImage:[UIImage imageNamed:@"btn_select"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"btn_selected"] forState:UIControlStateDisabled];
            }
        }
        
        
        top_all = height;
    }
    
    //加载投诉举报下侧view
    [self loadSelectTypeLeftBtnLowerView];
    
    
}
#pragma mark - 按钮事件
//投诉举报
-(void)selectTypeLeftBtnCallback:(UIButton *)btn{
    btn.enabled = false;
    self.selectTypeRightBtn.enabled = true;
    [self loadSelectTypeLeftBtnLowerView];
}
//APP吐槽
-(void)selectTypeRightBtnCallback:(UIButton *)btn{
    btn.enabled = false;
    self.selectTypeLeftBtn.enabled = true;
    [self loadSelectTypeRightBtnLowerView];
}
#pragma mark - 加载按钮下面view
//加载投诉举报下面view
-(void)loadSelectTypeLeftBtnLowerView{
    [self.submitView removeFromSuperview];//先将之前的view删除
    UIView * view = [UIView new];
    self.submitView = view;
    view.frame = CGRectMake(0, [MYTOOL getHeightWithIphone_six:58], WIDTH, HEIGHT-64-[MYTOOL getHeightWithIphone_six:58]);
    [self.view addSubview:view];
    float top = 10;
    //举报人昵称
    {
        float height = [MYTOOL getHeightWithIphone_six:50];
        UIView * bgView = [UIView new];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.frame = CGRectMake(0, top, WIDTH, height);
        [view addSubview:bgView];
        top += height;
        //文字提示
        float left = 10;
        {
            UILabel * label = [UILabel new];
            label.text = @"被举报人昵称:";
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = MYCOLOR_48_48_48;
            CGSize size = [MYTOOL getSizeWithLabel:label];
            label.frame = CGRectMake(left, height/2-size.height/2, size.width, size.height);
            left += size.width + 10;
            [bgView addSubview:label];
        }
        //昵称文本框
        {
            UITextField * tf = [UITextField new];
            tf.frame = CGRectMake(left, height/2-11.5, 135, 23);
            tf.layer.masksToBounds = true;
            tf.layer.borderWidth = 1;
            tf.delegate = self;
            self.nickNameTF = tf;
            tf.layer.borderColor = [MYCOLOR_240_240_240 CGColor];
            [bgView addSubview:tf];
            tf.font = [UIFont systemFontOfSize:15];
        }
    }
    //被举报原因
    {
        //文字
        {
            top += 10;
            UILabel * label = [UILabel new];
            label.text = @"举报原因";
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = MYCOLOR_48_48_48;
            label.frame = CGRectMake(10, top, WIDTH/2, 14);
            [view addSubview:label];
            top += 20;
        }
        //文本框
        {
            float height = [MYTOOL getHeightWithIphone_six:110];
            UITextView * tv = [UITextView new];
            tv.frame = CGRectMake(10, top, WIDTH-20, height);
            tv.layer.masksToBounds = true;
            tv.layer.borderWidth = 1;
            tv.delegate = self;
            tv.layer.borderColor = [MYCOLOR_240_240_240 CGColor];
            [view addSubview:tv];
            self.contentTV = tv;
            top += height;
        }
        //字数提示
        {
            UILabel * label = [UILabel new];
            label.textColor = [MYTOOL RGBWithRed:144 green:144 blue:144 alpha:1];
            label.font = [UIFont systemFontOfSize:10];
            label.text = @"100/100";
            CGSize size = [MYTOOL getSizeWithLabel:label];
            label.frame = CGRectMake(WIDTH - 15 - size.width, top+1, size.width, size.height);
            label.textAlignment = NSTextAlignmentRight;
            [view addSubview:label];
            label.text = @"10/100";
            self.contentCountLabel = label;
            top += size.height + 2;
        }
    }
    //图片
    {
        float width = (WIDTH - 50)/4.0;
        UIImageView * imgV = [UIImageView new];
        imgV.frame = CGRectMake(10, top, width, width);
        imgV.image = [UIImage imageNamed:@"Rounded-Rectangle-34-copy-2"];
        [view addSubview:imgV];
        self.img_arr = [NSMutableArray new];
        imgV.userInteractionEnabled = true;
        imgV.tag = 0;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(submitSelectImage:)];
        [imgV addGestureRecognizer:tapGesture];
        NSMutableDictionary * dic = [NSMutableDictionary new];
        [dic setObject:@"0" forKey:@"have_image"];
        [dic setObject:imgV forKey:@"imgV"];
        [self.img_arr addObject:dic];
    }
    //提交按钮
    {
        UIButton * btn = [UIButton new];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_red"] forState:UIControlStateNormal];
        [btn setTitle:@"提交" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake(10, top + 20 + (WIDTH - 50)/4.0 * 2, WIDTH-20, [MYTOOL getHeightWithIphone_six:40]);
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [view addSubview:btn];
        [btn addTarget:self action:@selector(submitSelectTypeLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    }
}
//加载APP吐槽下面view
-(void)loadSelectTypeRightBtnLowerView{
    [self.submitView removeFromSuperview];//先将之前的view删除
    UIView * view = [UIView new];
    self.submitView = view;
    view.frame = CGRectMake(0, [MYTOOL getHeightWithIphone_six:58], WIDTH, HEIGHT-64-[MYTOOL getHeightWithIphone_six:58]);
    [self.view addSubview:view];
    float top = 10;
    //内容
    {
        //文字
        {
            UILabel * label = [UILabel new];
            label.text = @"内容";
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = MYCOLOR_48_48_48;
            label.frame = CGRectMake(10, top, WIDTH/2, 14);
            [view addSubview:label];
            top += 20;
        }
        //文本框
        {
            float height = [MYTOOL getHeightWithIphone_six:110];
            UITextView * tv = [UITextView new];
            tv.frame = CGRectMake(10, top, WIDTH-20, height);
            tv.layer.masksToBounds = true;
            tv.layer.borderWidth = 1;
            tv.delegate = self;
            self.contentTV = tv;
            tv.layer.borderColor = [MYCOLOR_240_240_240 CGColor];
            [view addSubview:tv];
            top += height;
        }
        //字数提示
        {
            UILabel * label = [UILabel new];
            label.textColor = [MYTOOL RGBWithRed:144 green:144 blue:144 alpha:1];
            label.font = [UIFont systemFontOfSize:10];
            label.text = @"100/100";
            CGSize size = [MYTOOL getSizeWithLabel:label];
            label.frame = CGRectMake(WIDTH - 15 - size.width, top+1, size.width, size.height);
            label.textAlignment = NSTextAlignmentRight;
            [view addSubview:label];
            label.text = @"10/100";
            self.contentCountLabel = label;
            top += size.height + 2;
        }
    }
    //图片
    {
        float width = (WIDTH - 50)/4.0;
        UIImageView * imgV = [UIImageView new];
        imgV.frame = CGRectMake(10, top, width, width);
        imgV.image = [UIImage imageNamed:@"Rounded-Rectangle-34-copy-2"];
        [view addSubview:imgV];
        self.img_arr = [NSMutableArray new];
        imgV.userInteractionEnabled = true;
        imgV.tag = 0;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(submitSelectImage:)];
        [imgV addGestureRecognizer:tapGesture];
        NSMutableDictionary * dic = [NSMutableDictionary new];
        [dic setObject:@"0" forKey:@"have_image"];
        [dic setObject:imgV forKey:@"imgV"];
        [self.img_arr addObject:dic];
    }
    //提交按钮
    {
        UIButton * btn = [UIButton new];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_red"] forState:UIControlStateNormal];
        [btn setTitle:@"提交" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake(10, top + 20 + (WIDTH - 50)/4.0 * 2, WIDTH-20, [MYTOOL getHeightWithIphone_six:40]);
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [view addSubview:btn];
        [btn addTarget:self action:@selector(submitSelectTypeRightBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
//点击增加图片
-(void)submitSelectImage:(UITapGestureRecognizer *)tap{
    //    NSLog(@"目前数组:%@",self.img_arr);
    NSInteger tag = tap.view.tag;
    //判断当前点击的是否有图片
    if ([self.img_arr[tag][@"have_image"] boolValue]) {
        [self showZoomImageView2:(UIImageView *)tap.view];
        return;
    }
    UIImageView * imageV = (UIImageView *)tap.view;
    currentImgView = imageV;
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"增加图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //        NSLog(@"相册");
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self  presentViewController:imagePicker animated:YES completion:^{
        }];
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //        NSLog(@"拍照");
        // UIImagePickerControllerCameraDeviceRear 后置摄像头
        // UIImagePickerControllerCameraDeviceFront 前置摄像头
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            [SVProgressHUD showErrorWithStatus:@"无法打开摄像头" duration:2];
            return ;
        }
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        // 编辑模式
        imagePicker.allowsEditing = YES;
        
        [self  presentViewController:imagePicker animated:YES completion:^{
        }];
        
    }];
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [ac addAction:action1];
    [ac addAction:action2];
    [ac addAction:action3];
    
    [self presentViewController:ac animated:YES completion:nil];
    
}
//删除图片事件
-(void)deleteImgWithBtn:(UIButton *)btn{
    //    NSLog(@"delete:%ld",show_view.tag);
    /*
     1.
     */
    //清除要删除的图片框
    [self.img_arr[show_view.tag][@"imgV"] removeFromSuperview];
    [self.img_arr removeObjectAtIndex:show_view.tag];
    
    //需要添加空的图片view
    float top = 253/736.0*HEIGHT+ 22;
    float width_img = (WIDTH - 40)/3;
    //下边的type选择view往下移动
    
    
    //取消全屏
    {
        self.num_label = nil;
        [show_view removeFromSuperview];
    }
    //刷新
    [self refreshImgView];
}
//判断是否有空的图片框，如果没有，则新增
-(void)refreshImgView{
    
    BOOL have_nil_imgV = false;//是否还有空的图片框
    for (NSMutableDictionary * dic in self.img_arr) {
        NSString * have_image = dic[@"have_image"];
        if (![have_image boolValue]) {
            have_nil_imgV = true;
        }
    }
    //如果没有空的
    if (!have_nil_imgV) {
        //加一个
        [self addImgViewToImg_arr];
    }else{//有空的
        if (self.img_arr.count < 3) {
            [self addImgViewToImg_arr];
        }
    }
    //刷新所有图片框位置
    for(int i = 0; i < self.img_arr.count ; i ++){
        float top = [self.img_arr[0][@"imgV"] frame].origin.y;
        float width_img = [self.img_arr[0][@"imgV"] frame].size.width;
        UIImageView * imgV = self.img_arr[i][@"imgV"];
        imgV.tag = i;
        [UIView animateWithDuration:0.3 animations:^{
            imgV.frame = CGRectMake(10+(width_img+10)*(i%4), top+(i/4)*(width_img+10), width_img, width_img);
        }];
    }
    //    NSLog(@"---------------------");
    for (int i = 0; i < self.img_arr.count ; i ++) {
        NSDictionary * dic = self.img_arr[i];
        bool flag = [dic[@"have_image"] boolValue];
        UIImageView * imgV = dic[@"imgV"];
        //        NSLog(@"第%d个图片框是否有图片:%d,图片size:[%.2f,%.2f]",i+1,flag,imgV.image.size.width,imgV.image.size.height);
    }
    
    
    //
    
    
}
//缩放图片
-(void)showZoomImageView2:(UIImageView *)tap_view{
    if (![tap_view image]) {
        return;
    }
    UIView *bgView = [[UIView alloc] init];
    bgView.tag = tap_view.tag;
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
    
    UIImageView *tempImageView = tap_view;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:tempImageView.frame];
    imageView.image = tempImageView.image;
    show_img_view = imageView;
    imageView.tag = tap_view.tag;
    [bgView addSubview:imageView];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = imageView.frame;
        frame.size.width = bgView.frame.size.width;
        frame.size.height = frame.size.width * (imageView.image.size.height / imageView.image.size.width);
        frame.origin.x = 0;
        frame.origin.y = (bgView.frame.size.height - frame.size.height) * 0.5;
        imageView.frame = frame;
    }];
    
    //    NSLog(@"tag:%ld",tap_view.tag);
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
    
    self.num_label.text = [NSString stringWithFormat:@"%ld / %ld",tap_view.tag+1,[self getCountOfImgV_arr]];
    //删除按钮
    UIButton * btn = [UIButton new];
    [btn addTarget:self action:@selector(deleteImgWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(WIDTH-35-15, 34, 35, 18);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:btn];
    
}
//查看上一张
-(void)showUpImageView:(UISwipeGestureRecognizer *)tapBgRecognizer{
    NSInteger tag = tapBgRecognizer.view.tag;
    //    NSLog(@"上一张:%ld",tag);
    if (tag > 0) {//可以显示上一张
        UIImageView * imgV = [UIImageView new];
        [show_view insertSubview:imgV atIndex:0];
        UIImageView * img_view = self.img_arr[tag - 1][@"imgV"];
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
            self.num_label.text = [NSString stringWithFormat:@"%ld / %ld",show_view.tag+1,[self getCountOfImgV_arr]];
        }];
    }
}
//查看下一张
-(void)showNextImageView:(UISwipeGestureRecognizer *)tapBgRecognizer{
    NSInteger tag = tapBgRecognizer.view.tag;
    //    NSLog(@"下一张:%ld",tag);
    //总图片个数
    NSInteger count = [self getCountOfImgV_arr];
    if (tag < count - 1) {//可以显示下一张
        UIImageView * imgV = [UIImageView new];
        [show_view insertSubview:imgV atIndex:0];
        UIImageView * img_view = self.img_arr[tag + 1][@"imgV"];
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
            self.num_label.text = [NSString stringWithFormat:@"%ld / %ld",show_view.tag+1,[self getCountOfImgV_arr]];
        }];
    }
}
//再次点击取消全屏预览
-(void)tapBgView:(UITapGestureRecognizer *)tapBgRecognizer{
    self.num_label = nil;
    [tapBgRecognizer.view removeFromSuperview];
}
-(void)addImgViewToImg_arr{
    //需要添加空的图片view
    float top = [self.img_arr[0][@"imgV"] frame].origin.y;
    float width_img = [self.img_arr[0][@"imgV"] frame].size.width;
    if (self.img_arr.count < 8) {
        //动态增加
        UIImageView * imgV = [UIImageView new];
        imgV.frame = CGRectMake(10+(width_img+10)*(self.img_arr.count%4), top+(self.img_arr.count/4)*(width_img+10), width_img, width_img);
        imgV.image = [UIImage imageNamed:@"Rounded-Rectangle-34-copy-2"];
        [_submitView addSubview:imgV];
        imgV.userInteractionEnabled = true;
        imgV.tag = [self getCountOfImgV_arr];
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(submitSelectImage:)];
        [imgV addGestureRecognizer:tapGesture];
        NSMutableDictionary * dic = [NSMutableDictionary new];
        [dic setObject:@"0" forKey:@"have_image"];
        [dic setObject:imgV forKey:@"imgV"];
        [self.img_arr addObject:dic];
        
        //下边的type选择view往下移动
        
    }
}
-(NSInteger)getCountOfImgV_arr{
    NSInteger count = 0;
    for (NSDictionary * dic in self.img_arr) {
        bool flag = [dic[@"have_image"] boolValue];
        if (flag) {
            count ++;
        }
    }
    return count;
}
#pragma mark - UIImagePickerController代理
//确定选择图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    // UIImagePickerControllerOriginalImage 原始图片
    // UIImagePickerControllerEditedImage 编辑后图片
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    for (NSMutableDictionary * dic in self.img_arr) {
        NSString * have_image = dic[@"have_image"];
        if (![have_image boolValue]) {
            [dic setValue:@"1" forKey:@"have_image"];
            UIImageView * imgV = dic[@"imgV"];
            imgV.image = image;
            break;
        }
        
    }
    [self refreshImgView];//重新刷新界面
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//取消选择
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UITextFieldDelegate>代理
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //控制字数-6
    NSString * text = textField.text;
    if (string && string.length > 0) {
        if (text.length >= 6) {
            [SVProgressHUD showErrorWithStatus:@"最大6个字符" duration:2];
            return false;
        }
    }
    return true;
}
#pragma mark - UITextViewDelegate>代理
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //控制字数
    //控制字数-100
    NSString * string = textView.text;
    if (text && text.length > 0) {
        if (string.length >= 100) {
            [SVProgressHUD showErrorWithStatus:@"最大100个字符" duration:2];
            return false;
        }
    }
    return true;
}
-(void)textViewDidChange:(UITextView *)textView{
    NSInteger count = textView.text.length;
    if (count <= 10) {
        self.contentCountLabel.text = @"10/100";
    }else{
        self.contentCountLabel.text = [NSString stringWithFormat:@"%ld/100",count];
    }
}
#pragma mark - 提交事件
//提交投诉举报
-(void)submitSelectTypeLeftBtn{
    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"提交投诉图片\n数量:%ld",[self getCountOfImgV_arr]] duration:1];
}
//提交APP吐槽
-(void)submitSelectTypeRightBtn{
    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"APP吐槽图片\n数量:%ld",[self getCountOfImgV_arr]] duration:1];
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
