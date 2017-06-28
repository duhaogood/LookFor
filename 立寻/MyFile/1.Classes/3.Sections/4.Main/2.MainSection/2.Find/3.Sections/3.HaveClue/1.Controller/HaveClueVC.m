//
//  HaveClueVC.m
//  立寻
//
//  Created by Mac on 17/6/28.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "HaveClueVC.h"

@interface HaveClueVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)NSMutableArray * img_arr;//图片view数组
@property(nonatomic,strong)UILabel * num_label;//预览图片时显示的图片序号
@property(nonatomic,strong)UIView * img_bg_view;//图片背景view
@property(nonatomic,strong)NSArray * areaArray;//地区数组



@end

@implementation HaveClueVC
{
    UIView * show_view;//查看图片的辅助view
    UIImageView * currentImgView;//当前编辑的图片框
    UIImageView * show_img_view;//查看图片的view
    int current_upload_img_index;//当前上传图片序号
    NSMutableArray * fileid_array;//上传图片的id数组
    BOOL isIssue;//是否发布，还是保存草稿箱
    NSDictionary * uploadAreaDic;//需要上传的地区信息
    int uploadImgCount;//已经上传的图片张数
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(popUpViewController)];
    self.view.backgroundColor = MYCOLOR_240_240_240;
    //加载主界面
    [self loadMainView];
}
//加载主界面
-(void)loadMainView{
    float top = 0;
    //上部view
    {
        float view_height = [MYTOOL getHeightWithIphone_six:204];
        UIView * view = [UIView new];
        view.frame = CGRectMake(0, 0, WIDTH, view_height);
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        top += view_height;
        
        
        
        
        
    }
    top += 10;
    //中部图片view
    {
        float view_height = [MYTOOL getHeightWithIphone_six:147];
        UIView * view = [UIView new];
        view.frame = CGRectMake(0, top, WIDTH, view_height);
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        self.img_bg_view = view;
        top += view_height;
        //提示
        {
            float left = 0;
            float middle_top = 0;
            //图标
            {
                UIImageView * icon = [UIImageView new];
                icon.image = [UIImage imageNamed:@"uploadimg_tit"];
                icon.frame = CGRectMake(10, 17, 15, 15);
                [view addSubview:icon];
                left += 35;
                middle_top = 17 + 15 / 2.0;
            }
            float lower_top = 0;
            //提示文字
            {
                UILabel * label = [UILabel new];
                label.font = [UIFont systemFontOfSize:14];
                label.textColor = MYCOLOR_48_48_48;
                label.text = @"上传图片";
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(left, middle_top - size.height/2, size.width, size.height);
                [view addSubview:label];
                left += size.width + 10;
                lower_top = middle_top - size.height/2 + size.height;
            }
            //提示文字2
            {
                UILabel * label = [UILabel new];
                label.font = [UIFont systemFontOfSize:11];
                label.textColor = [MYTOOL RGBWithRed:168 green:168 blue:168 alpha:1];
                label.text = @"清晰的图片更能方便寻找者确认";
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(left, lower_top - size.height, size.width, size.height);
                [view addSubview:label];
            }
        }
        //图片
        {
            float width = (WIDTH - 50)/4.0;
            UIImageView * imgV = [UIImageView new];
            imgV.frame = CGRectMake(10, 50, width, width);
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
        
    }
    top += 30;
    //按钮
    {
        UIButton * btn = [UIButton new];
        btn.frame = CGRectMake(10, top, WIDTH-20, 40);
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_red"] forState:UIControlStateNormal];
        [btn setTitle:@"提交" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:btn];
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
    if (self.img_arr.count < 4) {
        //动态增加
        UIImageView * imgV = [UIImageView new];
        imgV.frame = CGRectMake(10+(width_img+10)*(self.img_arr.count%4), top+(self.img_arr.count/4)*(width_img+10), width_img, width_img);
        imgV.image = [UIImage imageNamed:@"Rounded-Rectangle-34-copy-2"];
        [self.img_bg_view addSubview:imgV];
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


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [MYTOOL hideKeyboard];
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
