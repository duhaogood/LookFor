//
//  WantToClaimVC.m
//  立寻
//
//  Created by Mac on 17/6/28.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "WantToClaimVC.h"

@interface WantToClaimVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>
@property(nonatomic,strong)NSMutableArray * img_arr;//图片view数组
@property(nonatomic,strong)UILabel * num_label;//预览图片时显示的图片序号
@property(nonatomic,strong)UIView * img_bg_view;//图片背景view
@property(nonatomic,strong)MyTextView * tv;//内容tv
@property(nonatomic,strong)UILabel * contentCountLabel;//内容文字数量label
@property(nonatomic,strong)UITextField * telTF;//手机号码

@end

@implementation WantToClaimVC
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
        float view_height = [MYTOOL getHeightWithIphone_six:162];
        UIView * view = [UIView new];
        view.frame = CGRectMake(0, 0, WIDTH, view_height);
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        top += view_height;
        //认领内容
        {
            float height = [MYTOOL getHeightWithIphone_six:75];
            MyTextView * tv = [[MyTextView alloc] initWithFrame:CGRectMake(10, 15, WIDTH - 20, height)];
            self.automaticallyAdjustsScrollViewInsets = false;
            tv.textColor = MYCOLOR_48_48_48;
            tv.placeholderLabel.text = @"   请描述下您发现的线索，好人终有好报";
            tv.placeholderLabel.font = [UIFont systemFontOfSize:10];
            tv.placeholderLabel.textColor = [MYTOOL RGBWithRed:180 green:180 blue:180 alpha:1];
            tv.font = [UIFont systemFontOfSize:13];
            [view addSubview:tv];
            tv.delegate = self;
            tv.layer.masksToBounds = true;
            tv.layer.borderWidth = 1;
            tv.layer.borderColor = [MYCOLOR_181_181_181 CGColor];
            self.tv = tv;
        }
        //详细信息字数
        {
            UILabel * label = [UILabel new];
            label.text = @"1234/500";
            label.textColor = [MYTOOL RGBWithRed:168 green:168 blue:168 alpha:1];
            label.font = [UIFont systemFontOfSize:10];
            [view addSubview:label];
            CGSize size = [MYTOOL getSizeWithLabel:label];
            label.frame = CGRectMake(WIDTH - 10 - size.width, [MYTOOL getHeightWithIphone_six:96] , size.width, size.height);
            self.contentCountLabel = label;
            label.text = @"0/500";
            label.textAlignment = NSTextAlignmentRight;
        }
        //详细地址
        {
            float left = 0;
            //左侧提示
            {
                UILabel * label = [UILabel new];
                label.text = @"联系电话:";
                label.font = [UIFont systemFontOfSize:12];
                label.textColor = MYCOLOR_48_48_48;
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(10, [MYTOOL getHeightWithIphone_six:122], size.width, size.height);
                [view addSubview:label];
                left = 10 + size.width + 10;
            }
            //右侧
            {
                UITextField * telTF = [UITextField new];
                telTF.placeholder = @" 请输入手机号码";
                telTF.frame = CGRectMake(left, [MYTOOL getHeightWithIphone_six:122], WIDTH - left - 10, 20);
                telTF.font = [UIFont systemFontOfSize:14];
                telTF.tag = 400;
                self.telTF = telTF;
                telTF.layer.masksToBounds = true;
                telTF.layer.borderWidth = 1;
                telTF.layer.borderColor = [MYCOLOR_181_181_181 CGColor];
                [view addSubview:telTF];
            }
        }
        
        
        
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
        [btn addTarget:self action:@selector(submitClainBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
//提交认领
-(void)submitClainBtn{
    /*参数检查*/
    //内容
    NSString * content = self.tv.text;
    if (content.length == 0 || content.length > 500) {
        [SVProgressHUD showErrorWithStatus:@"内容字数不合法" duration:2];
        return;
    }
    //电话
    NSString * tel = self.telTF.text;
    //正则表达式匹配11位手机号码
    NSString *regex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:tel];
    if (!isMatch) {
        [SVProgressHUD showErrorWithStatus:@"手机号不合法" duration:2];
        return;
    }
    //图片数量
    if ([self getCountOfImgV_arr] == 0) {
        [SVProgressHUD showErrorWithStatus:@"无图无真相" duration:2];
        return;
    }
    /*开始上传图片*/
    fileid_array = [NSMutableArray new];
    [self upLoadAllImage];
}
//开始认领
-(void)startClain{
    NSString * interface = @"publish/publish/addclaiminfo.html";
    //内容
    NSString * content = self.tv.text;
    //电话
    NSString * tel = self.telTF.text;
    NSString * picturelist = [MYTOOL getJsonFromDictionaryOrArray:fileid_array];//图片参数
    NSDictionary * send = @{
                            @"userid":USER_ID,
                            @"publishid":self.publishId,
                            @"content":content,
                            @"mobile":tel,
                            @"picturelist":picturelist
                            };
    [MYTOOL netWorkingWithTitle:@"认领中……"];
    [MYNETWORKING getDataWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        [SVProgressHUD showSuccessWithStatus:back_dic[@"Message"] duration:1];
        [self.navigationController popViewControllerAnimated:true];
    } andNoSuccess:^(NSDictionary *back_dic) {
        [SVProgressHUD showErrorWithStatus:back_dic[@"Message"] duration:2];
    } andFailure:^(NSURLSessionTask *operation, NSError *error) {
        
    }];
}
//上传所有图片
-(void)upLoadAllImage{
    int count_img = 0;
    for (int i =  0; i < self.img_arr.count ; i ++){
        NSDictionary * dic = self.img_arr[i];
        count_img += [dic[@"have_image"] boolValue];
    }
    if (count_img == 0) {
        [SVProgressHUD showErrorWithStatus:@"没有图片" duration:1];
        return;
    }
    NSDictionary * dic = self.img_arr[current_upload_img_index];
    if (![dic[@"have_image"] boolValue]) {
        current_upload_img_index ++;
        [self upLoadAllImage];
        return;
    }
    //上传图片
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    // 参数@"image":@"image",
    NSDictionary * parameter = @{
                                 @"imageType":@"posts",
                                 @"appid":@"99999999",
                                 @"userid":[MYTOOL getProjectPropertyWithKey:@"UserID"]
                                 };
    // 访问路径
    NSString *stringURL = [NSString stringWithFormat:@"%@%@",SERVER_URL,@"/common/filespace/uploadimg.html"];
    [manager POST:stringURL parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 上传文件
        NSDictionary * dic = self.img_arr[current_upload_img_index];
        UIImageView * imgV = dic[@"imgV"];
        //截取图片
        float change = 1.0;
        [SVProgressHUD showWithStatus:@"%d/%d\n上传进度:%0" maskType:SVProgressHUDMaskTypeClear];
        UIImage * img = imgV.image;
        NSData * imageData = UIImageJPEGRepresentation(img,change);
        while (imageData.length > 1.0 * 1024 * 1024) {
            change -= 0.1;
            imageData = UIImageJPEGRepresentation(img,change);
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat            = @"yyyyMMddHHmmss";
        NSString * str                         = [formatter stringFromDate:[NSDate date]];
        NSString * fileName               = [NSString stringWithFormat:@"%@_hao_%d.jpg", str,current_upload_img_index];
        
        [formData appendPartWithFileData:imageData name:@"filedata" fileName:fileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"%d/%d\n上传进度:%.2f%%",current_upload_img_index+1,count_img,uploadProgress.fractionCompleted*100] maskType:SVProgressHUDMaskTypeClear];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"Result"] boolValue]) {
            NSObject * fileid = responseObject[@"Data"][@"fileid"];
            [fileid_array addObject:@{@"PictureID":fileid}];
            current_upload_img_index ++;
            if (current_upload_img_index >= count_img) {
                [SVProgressHUD dismiss];
                //上传完毕--提交认领
                [self startClain];
            }else{
                [self upLoadAllImage];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"Message"] duration:2];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"上传失败" duration:2];
    }];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    NSInteger count = textView.text.length;
    self.contentCountLabel.text = [NSString stringWithFormat:@"%ld/500",count];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //字数控制-详情字数
    if (range.length == 0) {//字数增加
        NSInteger count = textView.text.length;
        if (count >= 500) {
            [SVProgressHUD showErrorWithStatus:@"字数不能超过500" duration:2];
            return false;
        }
    }
    return true;
}
#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger tag = textField.tag;
    if (tag == 100 || tag == 300) {
        return false;
    }
    return true;
}

//点击增加图片
-(void)submitSelectImage:(UITapGestureRecognizer *)tap{
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
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self  presentViewController:imagePicker animated:YES completion:^{
        }];
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
