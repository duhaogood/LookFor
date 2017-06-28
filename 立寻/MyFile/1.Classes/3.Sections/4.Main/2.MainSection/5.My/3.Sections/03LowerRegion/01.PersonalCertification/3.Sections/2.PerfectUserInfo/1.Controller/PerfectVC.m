//
//  PerfectVC.m
//  立寻
//
//  Created by mac on 2017/6/11.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "PerfectVC.h"
#import "PerfectView.h"
@interface PerfectVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSArray * areaArray;//地区数组
@end

@implementation PerfectVC
{
    UIImageView * currentImgView;//当前要选取图片的图片框
    UIView * show_view;//查看图片的辅助view
    UIImageView * show_img_view;//查看图片的view
    
    bool isChangeUserImg;//是否改变
    NSDictionary * uploadAreaDic;//需要上传的地区信息
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"area_code" ofType:@"plist"];
    self.areaArray = [NSArray arrayWithContentsOfFile:path];
    //加载主界面
    [self loadMainView];
    NSString * interface = @"/user/memberuser/getmemberuserinfo.html";
    NSString * userid = [MYTOOL getProjectPropertyWithKey:@"UserID"];
    if (!userid) {
        return;
    }
    NSDictionary * send = @{
                            @"userid": userid
                            };
    [MYNETWORKING getNoPopWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        MYTOOL.userInfo = back_dic[@"Data"];
        [self userInfoUpdate];
    }];
}
//加载主界面
-(void)loadMainView{
    PerfectView * view = [[PerfectView alloc]initWithFrame:self.view.bounds andDelegate:self];
    [self.view addSubview:view];
}
#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return false;
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
    }if (component == 1){
        return self.areaArray[[pickerView selectedRowInComponent:0]][@"cityArray"][row][@"cityName"];
    }
    return self.areaArray[[pickerView selectedRowInComponent:0]][@"cityArray"][[pickerView selectedRowInComponent:1]][@"countryArray"][row][@"countryName"];
}
//数据变动
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:true];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:true];
    }if (component == 1) {
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
    NSString * regionName = countryDic[@"countryName"];//区名字
    NSString * countryId = countryDic[@"countryId"];//区id
    uploadAreaDic = @{
                      @"provinceid":provinceId,
                      @"cityid":cityId,
                      @"countryid":countryId
                      };
    self.area_tf.text = [NSString stringWithFormat:@"%@%@%@",provinceName,cityName,regionName];
    [MYTOOL hideKeyboard];
}
//完成按钮
-(void)finishBtnCallback{
    if (isChangeUserImg) {
        //上传用户头像
        [self uploadUserImg];
    }else{
        //更新用户信息
        [self updateUserInfo];
    }
}
//更新用户信息
-(void)updateUserInfo{
    NSString * summary = self.love_tf.text;//兴趣爱好
    if (summary.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"兴趣不可为空" duration:2];
        return;
    }
    NSString * address = self.address_tf.text;//详细地址
    if (address.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"地址不可为空" duration:2];
        return;
    }
    if (self.area_tf.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先选择地区" duration:2];
        return;
    }
    NSMutableDictionary * send = [NSMutableDictionary dictionaryWithDictionary:@{
                            @"summary":summary,
                            @"address":address,
                            @"userid":USER_ID
                            }];
    for (NSString * key in uploadAreaDic) {
        [send setValue:uploadAreaDic[key] forKey:key];
    }
    
    NSLog(@"更新send:%@",send);
    [MYTOOL netWorkingWithTitle:@"更新用户信息"];
    NSString * interface = @"/user/memberuser/modifyuserinfo.html";
    [MYNETWORKING getWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        MainVC * main = (MainVC *)[[UIApplication sharedApplication].delegate window].rootViewController;
        UINavigationController * nc = main.selectedViewController;
        [nc popToRootViewControllerAnimated:true];
    }];
    
}
//上传用户头像
-(void)uploadUserImg{
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
    NSString *stringURL = [NSString stringWithFormat:@"%@%@",SERVER_URL,@"/user/memberuser/modifyuserheadportrait.html"];
    [manager POST:stringURL parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //截取图片
        float change = 1.0;
        [SVProgressHUD showWithStatus:@"上传头像\n上传进度:%0" maskType:SVProgressHUDMaskTypeClear];
        UIImage * img = self.user_imgV.image;
        NSData * imageData = UIImageJPEGRepresentation(img,change);
        while (imageData.length > 1.0 * 1024 * 1024) {
            change -= 0.1;
            imageData = UIImageJPEGRepresentation(img,change);
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat            = @"yyyyMMddHHmmss";
        NSString * str                         = [formatter stringFromDate:[NSDate date]];
        NSString * fileName               = [NSString stringWithFormat:@"%@_hao_0.jpg", str];
        
        [formData appendPartWithFileData:imageData name:@"filedata" fileName:fileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"上传头像\n上传进度:%.2f%%",uploadProgress.fractionCompleted*100] maskType:SVProgressHUDMaskTypeClear];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"Result"] boolValue]) {
            isChangeUserImg = false;
            [self updateUserInfo];
            [SVProgressHUD showSuccessWithStatus:responseObject[@"Message"] duration:1];
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"Message"] duration:2];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"上传失败" duration:2];
    }];
}
//点击头像
-(void)clickUserIconCallback2:(UITapGestureRecognizer *)tap{
    UIImageView * imgV = (UIImageView * )tap.view;
    currentImgView = imgV;
    NSInteger tag = imgV.tag;
    if (tag == 0) {
        //增加图片
        [self getPhoneImage];
    }else{
        //全屏预览
        [self showImageAllScreen:imgV];
    }
}
//调取图片
-(void)getPhoneImage{
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
#pragma mark - UIImagePickerController代理
//确定选择图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    // UIImagePickerControllerOriginalImage 原始图片
    // UIImagePickerControllerEditedImage 编辑后图片
    UIImage * img = [info objectForKey:UIImagePickerControllerOriginalImage];
    //处理拍照后旋转
    UIImage * image = [MYTOOL fixOrientationOfImage:img];
    currentImgView.image = image;
    currentImgView.tag = 1;
    isChangeUserImg = true;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//取消选择
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//全屏查看
-(void)showImageAllScreen:(UIImageView *)tap_view{
    UIView *bgView = [[UIView alloc] init];
    bgView.tag = tap_view.tag;
    show_view = bgView;
    bgView.frame = [UIScreen mainScreen].bounds;
    bgView.backgroundColor = [UIColor blackColor];
    [[[UIApplication sharedApplication] keyWindow] addSubview:bgView];
    UITapGestureRecognizer *tapBgView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView:)];
    [bgView addGestureRecognizer:tapBgView];
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
    //删除按钮
    UIButton * btn = [UIButton new];
    [btn addTarget:self action:@selector(deleteImgWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(WIDTH-35-15, 34, 35, 18);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:btn];
}
//删除图片事件
-(void)deleteImgWithBtn:(UIButton *)btn{
    currentImgView.image = [UIImage imageNamed:@"upload_hd"];
    currentImgView.tag = 0;
    isChangeUserImg = false;
    //取消全屏
    {
        [show_view removeFromSuperview];
    }
}
//再次点击取消全屏预览
-(void)tapBgView:(UITapGestureRecognizer *)tapBgRecognizer{
    [tapBgRecognizer.view removeFromSuperview];
}
//返回上个界面
-(void)popUpViewController{
    [self.navigationController popViewControllerAnimated:true];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [MYTOOL hideKeyboard];
}
//更新用户信息
-(void)userInfoUpdate{
    NSString * MySummary = MYTOOL.userInfo[@"MySummary"];
    NSString * Address = MYTOOL.userInfo[@"Address"];
    NSString * ProvinceName = MYTOOL.userInfo[@"ProvinceName"];
    NSString * CityName = MYTOOL.userInfo[@"CityName"];
    NSString * CountryName = MYTOOL.userInfo[@"CountryName"];
    NSString * url = MYTOOL.userInfo[@"ImgFilePath"];
    //更新用户头像
    if (url == nil || [url isKindOfClass:[NSNull class]]) {
        
    }else{
        [self.user_imgV sd_setImageWithURL:[NSURL URLWithString:url]];
    }
    self.love_tf.text = MySummary;
    self.address_tf.text = Address;
    self.area_tf.text = [NSString stringWithFormat:@"%@%@%@",ProvinceName,CityName,CountryName];
    uploadAreaDic = @{
                      @"provinceid":MYTOOL.userInfo[@"Province"],
                      @"cityid":MYTOOL.userInfo[@"Country"],
                      @"countryid":MYTOOL.userInfo[@"City"]
                      };
}

-(void)viewWillAppear:(BOOL)animated{
    [MYTOOL hiddenTabBar];
    [self.navigationController setNavigationBarHidden:true animated:true];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [MYTOOL showTabBar];
    [self.navigationController setNavigationBarHidden:false animated:true];
}
@end
