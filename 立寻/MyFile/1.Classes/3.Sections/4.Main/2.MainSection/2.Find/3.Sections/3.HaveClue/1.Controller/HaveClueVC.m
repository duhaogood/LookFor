//
//  HaveClueVC.m
//  立寻
//
//  Created by Mac on 17/6/28.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "HaveClueVC.h"

@interface HaveClueVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSMutableArray * img_arr;//图片view数组
@property(nonatomic,strong)UILabel * num_label;//预览图片时显示的图片序号
@property(nonatomic,strong)UIView * img_bg_view;//图片背景view
@property(nonatomic,strong)NSArray * areaArray;//地区数组
@property(nonatomic,strong)UILabel * contentCountLabel;//内容文字数量label
@property(nonatomic,strong)UITextField * cityTF;//城市文本
@property(nonatomic,strong)UITextField * addressTF;//地址文本
@property(nonatomic,strong)UIPickerView * picker;//地区选择器
@property(nonatomic,strong)MyTextView * tv;//内容tv

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
    //初始化省市区数据
    NSString * path = [[NSBundle mainBundle] pathForResource:@"area_code" ofType:@"plist"];
    self.areaArray = [NSArray arrayWithContentsOfFile:path];
    //加载主界面
    [self loadMainView];
}
//加载主界面
-(void)loadMainView{
    float top = 0;
    self.automaticallyAdjustsScrollViewInsets = false;
    //上部view
    {
        float view_height = [MYTOOL getHeightWithIphone_six:244];
        UIView * view = [UIView new];
        view.frame = CGRectMake(0, 0, WIDTH, view_height);
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        top += view_height;
        //线索内容
        {
            float height = [MYTOOL getHeightWithIphone_six:75];
            MyTextView * tv = [[MyTextView alloc] initWithFrame:CGRectMake(10, 15, WIDTH - 20, height)];
            tv.textColor = MYCOLOR_48_48_48;
            tv.placeholderLabel.text = @"   请描述下您发现的线索，好人终有好报";
            tv.placeholderLabel.font = [UIFont systemFontOfSize:10];
            tv.placeholderLabel.textColor = [MYTOOL RGBWithRed:180 green:180 blue:180 alpha:1];
            tv.font = [UIFont systemFontOfSize:13];
            [view addSubview:tv];
            tv.layoutManager.allowsNonContiguousLayout = NO;
            tv.delegate = self;
            tv.layer.masksToBounds = true;
            tv.layer.borderWidth = 1;
            tv.layer.borderColor = [MYCOLOR_181_181_181 CGColor];
            self.tv = tv;
        }
        //详细信息字数
        {
            UILabel * label = [UILabel new];
            label.text = @"10000/500";
            label.textColor = [MYTOOL RGBWithRed:168 green:168 blue:168 alpha:1];
            label.font = [UIFont systemFontOfSize:10];
            [view addSubview:label];
            CGSize size = [MYTOOL getSizeWithLabel:label];
            label.frame = CGRectMake(WIDTH - 10 - size.width, [MYTOOL getHeightWithIphone_six:96] , size.width, size.height);
            self.contentCountLabel = label;
            label.text = @"0/500";
            label.textAlignment = NSTextAlignmentRight;
        }
        float height_tf = [MYTOOL getHeightWithIphone_six:35];
        float middle_top = 0;
        //选择城市
        {
            float left = 0;
            //左侧提示
            {
                UILabel * label = [UILabel new];
                label.text = @"发现城市:";
                label.font = [UIFont systemFontOfSize:13];
                label.textColor = MYCOLOR_48_48_48;
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(10, [MYTOOL getHeightWithIphone_six:138], size.width, size.height);
                [view addSubview:label];
                middle_top = [MYTOOL getHeightWithIphone_six:138] + size.height/2;
                left = 10 + size.width + 10;
            }
            //右侧
            {
                UITextField * cityTF = [UITextField new];
                cityTF.placeholder = @"  请选择城市";
                cityTF.frame = CGRectMake(left, middle_top - height_tf/2, WIDTH/2.0, height_tf);
                cityTF.font = [UIFont systemFontOfSize:14];
                cityTF.tag = 300;
                cityTF.delegate = self;
                self.cityTF = cityTF;
                cityTF.layer.masksToBounds = true;
                cityTF.layer.borderWidth = 1;
                cityTF.layer.borderColor = [MYCOLOR_181_181_181 CGColor];
                [view addSubview:cityTF];
                //输入
                {
                    UIPickerView * pick = [UIPickerView new];
                    self.picker = pick;
                    pick.tag = 100;
                    UIView * v = [UIView new];
                    cityTF.inputView = v;
                    v.frame = CGRectMake(0, 500, WIDTH, 271);
                    pick.frame = CGRectMake(0, 44, WIDTH, 271-44);
                    pick.dataSource = self;
                    pick.delegate = self;
                    [v addSubview:pick];
                    //toolbar
                    UIToolbar * bar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
                    [v addSubview:bar];
                    [bar setBarStyle:UIBarStyleDefault];
                    NSMutableArray *buttons = [[NSMutableArray alloc] init];
                    
                    UIBarButtonItem *myDoneButton = [[ UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                                   target: self action: @selector(clickOkOfPickerView:)];
                    myDoneButton.tag = 100;
                    myDoneButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(clickOkOfPickerView:)];
                    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
                    
                    [buttons addObject:flexibleSpace];
                    [buttons addObject: myDoneButton];
                    
                    
                    [bar setItems:buttons animated:TRUE];
                    
                    //toolbar加个label
                    UILabel * label = [UILabel new];
                    label.text = [NSString stringWithFormat:@"请选择省、市"];
                    label.frame = CGRectMake(WIDTH/2-70, 12, 140, 20);
                    label.textAlignment = NSTextAlignmentCenter;
                    [v addSubview:label];
                }
            }
        
        
    }
        //详细地址
        {
            float left = 0;
            //左侧提示
            {
                UILabel * label = [UILabel new];
                label.text = @"发现城市:";
                label.font = [UIFont systemFontOfSize:13];
                label.textColor = MYCOLOR_48_48_48;
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(10, [MYTOOL getHeightWithIphone_six:187], size.width, size.height);
                middle_top = [MYTOOL getHeightWithIphone_six:187] + size.height/2;
                [view addSubview:label];
                left = 10 + size.width + 10;
            }
            //右侧
            {
                UITextField * cityTF = [UITextField new];
                cityTF.placeholder = @" 请输入走失地详细地址";
                cityTF.frame = CGRectMake(left, middle_top - height_tf/2, WIDTH - left - 10, height_tf);
                cityTF.font = [UIFont systemFontOfSize:14];
                cityTF.tag = 400;
                self.addressTF = cityTF;
                cityTF.layer.masksToBounds = true;
                cityTF.layer.borderWidth = 1;
                cityTF.layer.borderColor = [MYCOLOR_181_181_181 CGColor];
                [view addSubview:cityTF];
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
        [btn addTarget:self action:@selector(submitSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
//提交
-(void)submitSubmitBtn:(UIButton *)btn{
    //先检查参数是否有空
    //内容
    NSString * content = self.tv.text;
    if (content.length == 0 || content.length > 500) {
        [SVProgressHUD showErrorWithStatus:@"内容字数不合法" duration:2];
        return;
    }
    //城市
    NSString * city = self.cityTF.text;
    if (city.length < 2) {
        [SVProgressHUD showErrorWithStatus:@"请选择城市" duration:2];
        return;
    }
    //地址
    NSString * address = self.addressTF.text;
    if (address.length < 2) {
        [SVProgressHUD showErrorWithStatus:@"请填写详细地址" duration:2];
        return;
    }
    //图片
    if ([self getCountOfImgV_arr] == 0) {
        [SVProgressHUD showErrorWithStatus:@"无图无真相" duration:2];
        return;
    }
    fileid_array = [NSMutableArray new];
    //上传所有图片
    [self upLoadAllImage];
}
//提交线索
-(void)startSubmit{
    NSString * state = @"提交中……";
    [MYTOOL netWorkingWithTitle:state];
        //正式拼装
    NSString * picturelist = [MYTOOL getJsonFromDictionaryOrArray:fileid_array];//图片参数
    NSString * provinceid = uploadAreaDic[@"provinceid"];
    NSString * cityid = uploadAreaDic[@"cityid"];
    NSString * countryid = uploadAreaDic[@"countryid"];
    
    
    NSDictionary * send = @{
                            @"userid":USER_ID,
                            @"picturelist":picturelist,
                            @"provinceid":provinceid,
                            @"cityid":cityid,
                            @"countryid":countryid,
                            @"publishid":self.publishId,
                            @"content":self.tv.text,
                            @"address":self.addressTF.text
                            };
    NSString * interface = @"publish/publish/addclueinfo.html";
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
    [MYTOOL netWorkingWithTitle:@"上传中……"];
    [manager POST:stringURL parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 上传文件
        NSDictionary * dic = self.img_arr[current_upload_img_index];
        UIImageView * imgV = dic[@"imgV"];
        //截取图片
        float change = 1.0;
        UIImage * img = imgV.image;
        NSData * imageData = UIImageJPEGRepresentation(img,change);
        while (imageData.length > 300 * 1024) {
            change -= 0.2;
            imageData = UIImageJPEGRepresentation(img,change);
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat            = @"yyyyMMddHHmmss";
        NSString * str                         = [formatter stringFromDate:[NSDate date]];
        NSString * fileName               = [NSString stringWithFormat:@"%@_hao_%d.jpg", str,current_upload_img_index];
        
        [formData appendPartWithFileData:imageData name:@"filedata" fileName:fileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"%d/%d\n上传进度:%.2f%%",current_upload_img_index+1,count_img,uploadProgress.fractionCompleted*100] maskType:SVProgressHUDMaskTypeClear];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"Result"] boolValue]) {
            NSObject * fileid = responseObject[@"Data"][@"fileid"];
            [fileid_array addObject:@{@"PictureID":fileid}];
            current_upload_img_index ++;
            if (current_upload_img_index >= count_img) {
                [SVProgressHUD dismiss];
                //上传完毕
                [self startSubmit];
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
#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.areaArray.count;
    }else if (component == 1){
        NSArray * cityArray = self.areaArray[[pickerView selectedRowInComponent:0]][@"cityArray"];
        return cityArray.count;
    }else{
        NSArray * countryArray = self.areaArray[[pickerView selectedRowInComponent:0]][@"cityArray"][[pickerView selectedRowInComponent:1]][@"countryArray"];
        return countryArray.count;
    }
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        NSString * title = self.areaArray[row][@"provinceName"];
        return title;
    }else if (component == 1){
        NSString * string = self.areaArray[[pickerView selectedRowInComponent:0]][@"cityArray"][row][@"cityName"];
        return string;
    }else{
        NSString * string = self.areaArray[[pickerView selectedRowInComponent:0]][@"cityArray"][[pickerView selectedRowInComponent:1]][@"countryArray"][row][@"countryName"];
        return string;
    }
}
//数据变动
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:true];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:true];
    }
    if (component == 1) {
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:true];
    }
}
//pickerView中事件-确定
-(void)clickOkOfPickerView:(UIBarButtonItem*)btn{
    NSInteger row0 = [self.picker selectedRowInComponent:0];
    NSInteger row1 = [self.picker selectedRowInComponent:1];
    NSInteger row2 = [self.picker selectedRowInComponent:2];
    
    NSDictionary * provinceDic = self.areaArray[row0];
    NSArray * cityArray = provinceDic[@"cityArray"];
    NSDictionary * cityDic = cityArray[row1];
    NSArray * countryArray = cityDic[@"countryArray"];
    NSDictionary * countryDic = countryArray[row2];
    
    
    NSString * provinceId = provinceDic[@"provinceId"];//省id
    NSString * provinceName = provinceDic[@"provinceName"];//省名字
    NSString * cityId = cityDic[@"cityId"];//城市id
    NSString * cityName = cityDic[@"cityName"];//城市名字
    NSString * countryId = countryDic[@"countryId"];//县id
    NSString * countryName = countryDic[@"countryName"];//县名字
    uploadAreaDic = @{
                      @"provinceid":provinceId,
                      @"cityid":cityId,
                      @"countryid":countryId
                      };
    self.cityTF.text = [NSString stringWithFormat:@"%@%@%@",provinceName,cityName,countryName];
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
