//
//  LookForCircleVC.m
//  立寻
//
//  Created by mac on 2017/6/13.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "LookForCircleVC.h"
#import "LookForCircleUpView.h"
#import "LookForCircleLowerView.h"
#import "PayTopUpVC.h"
#import "NetworkSocialVC.h"
@interface LookForCircleVC ()<UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong)UIScrollView * scrollView;//背景view
@property(nonatomic,strong)NSMutableArray * img_arr;//图片view数组
@property(nonatomic,strong)UILabel * num_label;//预览图片时显示的图片序号
@property(nonatomic,strong)UIView * img_bg_view;//图片背景view
@property(nonatomic,strong)NSArray * areaArray;//地区数组
@property(nonatomic,strong)NSString * PublishAddress;//定位地址

@end

@implementation LookForCircleVC
{
    NSArray * cityList;//当前省的市数组
    NSArray * regionList;//当前市的区数组
    NSInteger provinceRow;//省的行
    NSInteger regionRow;//市的行
    
    UIView * show_view;//查看图片的辅助view
    UIImageView * currentImgView;//当前编辑的图片框
    UIImageView * show_img_view;//查看图片的view
    int current_upload_img_index;//当前上传图片序号
    NSMutableArray * fileid_array;//上传图片的id数组
    BOOL isIssue;//是否发布，还是保存草稿箱
    NSDictionary * uploadAreaDic;//需要上传的地区信息
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(popUpViewController)];
    self.view.backgroundColor = MYCOLOR_240_240_240;
    //初始化省市区数据
    NSString * path = [[NSBundle mainBundle] pathForResource:@"area_code" ofType:@"plist"];
    self.areaArray = [NSArray arrayWithContentsOfFile:path];
    //加载主界面
    [self loadMainView];
    //定位开启
    [[MyLocationManager sharedLocationManager] startLocation];
}
//加载主界面
-(void)loadMainView{
    //背景scrollView
    UIScrollView * scrollView = [UIScrollView new];
    {
        scrollView.frame = CGRectMake(0, 0, WIDTH, HEIGHT - 64);
        [self.view addSubview:scrollView];
        scrollView.delegate = self;
        self.scrollView = scrollView;
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    float top = 0;
    //发布上册view
    {
        float height = [MYTOOL getHeightWithIphone_six:270];
        LookForCircleUpView * view = [[LookForCircleUpView alloc] initWithFrame:CGRectMake(0, top, WIDTH, height) andUserUrl:@"http://img.woyaogexing.com/touxiang/katong/20140110/864ea8353fe3edd3.jpg%21200X200.jpg" andTypeTitle:self.typeTitle andTypeArray:self.secondTypeList andDelegate:self];
        view.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:view];
        top += height + 10;
    }
    //发布中部view
    {
        float height = [MYTOOL getHeightWithIphone_six:273];
        UIView * view = [UIView new];
        self.img_bg_view = view;
        view.frame = CGRectMake(0, top, WIDTH, height);
        view.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:view];
        top += height + 10;
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
                label.font = [UIFont systemFontOfSize:12];
                label.textColor = [MYTOOL RGBWithRed:255 green:75 blue:75 alpha:1];
                label.text = @"请上传清晰图片";
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
    //发布底部view
    {
        float height = [MYTOOL getHeightWithIphone_six:100];
        LookForCircleLowerView * view = [[LookForCircleLowerView alloc] initWithFrame:CGRectMake(0, top, WIDTH, height) andDelegate:self];
        view.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:view];
        top += height;
    }
    scrollView.contentSize = CGSizeMake(0, top);
    
}
//判断是否有信息不全
-(BOOL)checkInfoOfIssue{
    
    if (1) {
        PayTopUpVC * pay = [PayTopUpVC new];
        pay.title = @"余额充值";
        [self.navigationController pushViewController:pay animated:true];
        return false;
    }
    
    
    /*检查所有参数是否合法*/
    //标题
    if (self.titleTF.text.length == 0 || self.titleTF.text.length > 20) {
        [SVProgressHUD showErrorWithStatus:@"标题字数不合法" duration:2];
        return false;
    }
    //内容
    if (self.contentTV.text.length == 0 || self.contentTV.text.length > 500) {
        [SVProgressHUD showErrorWithStatus:@"内容字数不合法" duration:2];
        return false;
    }
    //城市
    if (self.cityTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择城市" duration:2];
        return false;
    }
    //图片
    if ([self getCountOfImgV_arr] == 0) {
        [SVProgressHUD showErrorWithStatus:@"请上传图片" duration:2];
        return false;
    }
    
    
    
    return true;
}
#pragma mark - 按钮回调
//现在发布
-(void)issueBtnCallback{
    //先判断是否有空
    if (![self checkInfoOfIssue]) {
        return;
    }
    isIssue = true;//现在发布
    //上传图片
    current_upload_img_index = 0;
    fileid_array = [NSMutableArray new];
    [self upLoadAllImage];
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
                //上传完毕
                [self startIssue];
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
//准备发布信息
-(void)startIssue{
    NSString * state = isIssue ? @"发布中……" : @"保存中……";
    [MYTOOL netWorkingWithTitle:state];
    //拼装发布信息
    NSMutableDictionary * publishinfo_dictionary = [NSMutableDictionary new];
    NSString * Title = self.titleTF.text;//标题
    NSString * Content = self.contentTV.text;//发布详情
    NSObject * CategoryID = nil;//分类ID
    NSString * type = self.typeTF.text;
    for (NSDictionary * dic in self.secondTypeList) {
        NSString * CategoryTitle = dic[@"CategoryTitle"];
        if ([CategoryTitle isEqualToString:type]) {
            CategoryID = dic[@"CategoryID"];
            break;
        }
    }
    //    NSString * PublishStatus = self.addressTF.text;//发布状态（1.待发布，2.已发布，3.已结束，4.已完成）
    //拼装
    [publishinfo_dictionary setValue:Title forKey:@"Title"];
    [publishinfo_dictionary setValue:Content forKey:@"Content"];
    [publishinfo_dictionary setValue:CategoryID forKey:@"CategoryID"];
    [publishinfo_dictionary setValue:uploadAreaDic[@"provinceid"] forKey:@"Province"];
    [publishinfo_dictionary setValue:uploadAreaDic[@"cityid"] forKey:@"City"];
    if (self.PublishAddress && self.PublishAddress.length) {
        [publishinfo_dictionary setValue:_PublishAddress forKey:@"PublishAddress"];
    }
    //正式拼装
    NSString * userid = [MYTOOL getProjectPropertyWithKey:@"UserID"];//用户id
    NSString * picturelist = [MYTOOL getJsonFromDictionaryOrArray:fileid_array];//图片参数
    NSString * publishinfo = [MYTOOL getJsonFromDictionaryOrArray:publishinfo_dictionary];//发布参数
    NSDictionary * send = @{
                            @"userid":userid,
                            @"picturelist":picturelist,
                            @"publishinfo":publishinfo
                            };
    NSString * interface = @"/publish/publish/addsubmitpublishinfo.html";
    [MYNETWORKING getWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        [self.navigationController popViewControllerAnimated:false];
        
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        MainVC * main = (MainVC *)app.window.rootViewController;
        [main setSelectedIndex:4];
        UINavigationController * nc = main.selectedViewController;
        //跳转网络社交
        NetworkSocialVC * vc = [NetworkSocialVC new];
        vc.title = @"网络社交";
        [nc pushViewController:vc animated:true];
    }];
    
    
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [MYTOOL hideKeyboard];
}
#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger tag = textField.tag;
    if (tag == 100 || tag == 300) {
        return false;
    }
    //字数控制
    if (tag == 50 ) {//标题
        NSInteger count = textField.text.length;
        if (range.length == 0) {//增加
            if (count >= 20) {
                [SVProgressHUD showErrorWithStatus:@"字数不能超过20" duration:2];
                return false;
            }
            count ++;
        }else{
            count --;
        }
        self.titleNumberLabel.text = [NSString stringWithFormat:@"%ld/20",count];
    }
    return true;
}
#pragma mark - UITextViewDelegate
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
-(void)textViewDidChange:(UITextView *)textView{
    NSInteger count = textView.text.length;
    self.contentNumberLabel.text = [NSString stringWithFormat:@"%ld/500",count];
}
#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger tag = pickerView.tag;
    if (tag == 200) {
        return self.secondTypeList.count;
    }
    if (component == 0) {
        return self.areaArray.count;
    }else{
        NSArray * cityArray = self.areaArray[[pickerView selectedRowInComponent:0]][@"cityArray"];
        return cityArray.count;
    }
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    NSInteger tag = pickerView.tag;
    if (tag == 200) {
        return 1;
    }
    return 2;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSInteger tag = pickerView.tag;
    if (tag == 200) {
        return self.secondTypeList[row][@"CategoryTitle"];
    }
    if (component == 0) {
        NSString * title = self.areaArray[row][@"provinceName"];
        return title;
    }else{
        NSString * string = self.areaArray[[pickerView selectedRowInComponent:0]][@"cityArray"][row][@"cityName"];
        return string;
    }
}
//数据变动
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSInteger tag = pickerView.tag;
    if (tag == 200) {
        return;
    }
    if (component == 0) {
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:true];
    }
    
}
//pickerView中事件-确定
-(void)clickOkOfPickerView:(UIBarButtonItem*)btn{
    if ([self.typeTF isFirstResponder]) {
        NSInteger row0 = [self.typePicker selectedRowInComponent:0];
        NSString * title = self.secondTypeList[row0][@"CategoryTitle"];
        self.typeTF.text = title;
        [MYTOOL hideKeyboard];
        return;
    }
    NSInteger row0 = [self.picker selectedRowInComponent:0];
    NSInteger row1 = [self.picker selectedRowInComponent:1];
    
    NSDictionary * provinceDic = self.areaArray[row0];
    NSArray * cityArray = provinceDic[@"cityArray"];
    NSDictionary * cityDic = cityArray[row1];
    
    NSString * provinceId = provinceDic[@"provinceId"];//省id
    NSString * provinceName = provinceDic[@"provinceName"];//省名字
    NSString * cityId = cityDic[@"cityId"];//城市id
    NSString * cityName = cityDic[@"cityName"];//城市名字
    uploadAreaDic = @{
                      @"provinceid":provinceId,
                      @"cityid":cityId
                      };
    self.cityTF.text = [NSString stringWithFormat:@"%@%@",provinceName,cityName];
    [MYTOOL hideKeyboard];
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
        if (self.img_arr.count < 1) {
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
    if (self.img_arr.count < 8) {
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
    //处理图片旋转问题
    UIImage * img = [MYTOOL fixOrientationOfImage:image];
    
    for (NSMutableDictionary * dic in self.img_arr) {
        NSString * have_image = dic[@"have_image"];
        if (![have_image boolValue]) {
            [dic setValue:@"1" forKey:@"have_image"];
            UIImageView * imgV = dic[@"imgV"];
            imgV.image = img;
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


#pragma mark - 键盘出现和隐藏事件
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSArray * array = @[self.cityTF];
    UITextField * tf = nil;
    for (UITextField * tt in array) {
        if ([tt isFirstResponder]) {
            tf = tt;
            break;
        }
    }
    //键盘高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    //UITextField相对屏幕上侧位置
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[tf convertRect: [tf bounds] toView:window];
    //UITextField底部坐标
    float tf_y = rect.origin.y + tf.frame.size.height;
    if (height + tf_y > HEIGHT) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, 64+(HEIGHT - height - tf_y), self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
}

//返回上个界面
-(void)popUpViewController{
    [self.navigationController popViewControllerAnimated:true];
}
//接收到定位成功通知
-(void)receiveUpdateLocationSuccessNotification:(NSNotification *)notification{
    NSDictionary * obj = notification.object;
    self.PublishAddress = obj[@"addressInfo"];
    return;
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"定位成功-此信息将在详情中作为发布位置显示" message:obj[@"addressInfo"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [ac addAction:sure];
    [self presentViewController:ac animated:true completion:nil];
    
}
//接收到定位失败通知
-(void)receiveUpdateLocationFailedNotification:(NSNotification *)notification{
    return;
    [SVProgressHUD showErrorWithStatus:@"定位失败\n无法发布信息哦" duration:2];
}
-(void)viewWillAppear:(BOOL)animated{
    [MYTOOL hiddenTabBar];
    
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [MYCENTER_NOTIFICATION addObserver:self selector:@selector(receiveUpdateLocationSuccessNotification:) name:NOTIFICATION_UPDATELOCATION_SUCCESS object:nil];
    [MYCENTER_NOTIFICATION addObserver:self selector:@selector(receiveUpdateLocationFailedNotification:) name:NOTIFICATION_UPDATELOCATION_FAILED object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [MYTOOL showTabBar];
    //删除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [MYCENTER_NOTIFICATION removeObserver:self name:NOTIFICATION_UPDATELOCATION_SUCCESS object:nil];
    [MYCENTER_NOTIFICATION removeObserver:self name:NOTIFICATION_UPDATELOCATION_FAILED object:nil];
    
}


@end
