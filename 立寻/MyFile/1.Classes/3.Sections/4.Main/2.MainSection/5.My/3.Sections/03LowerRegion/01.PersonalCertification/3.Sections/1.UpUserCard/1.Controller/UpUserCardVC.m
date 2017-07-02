//
//  UpUserCardVC.m
//  立寻
//
//  Created by mac on 2017/6/11.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "UpUserCardVC.h"
#import "UpUserCardView.h"
#import "PerfectVC.h"
@interface UpUserCardVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation UpUserCardVC
{
    UIImageView * currentImgView;//当前要选取图片的图片框
    UIView * show_view;//查看图片的辅助view
    UIImageView * show_img_view;//查看图片的view
    NSObject * cardid;//正面身份证id
    NSObject * cardbackid;//反面身份证id
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
    UpUserCardView * view = [[UpUserCardView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT -64) andDelegate:self];
    [self.view addSubview:view];
}


//身份证正面
-(void)clickImgOfCardUp:(UITapGestureRecognizer *)tap{
    UIImageView * imgV = (UIImageView *)tap.view;
    currentImgView = imgV;
    NSInteger tag = imgV.tag;
    if (tag == 0) {
        //增加图片
        [self getPhoneImage:imgV];
    }else{
        //全屏预览
        [self showImageAllScreen:imgV];
    }
    
    
}
//身份证反面
-(void)clickImgOfCardDown:(UITapGestureRecognizer *)tap{
    UIImageView * imgV = (UIImageView *)tap.view;
    currentImgView = imgV;
    NSInteger tag = imgV.tag;
    if (tag == 0) {
        //增加图片
        [self getPhoneImage:imgV];
    }else{
        //全屏预览
        [self showImageAllScreen:imgV];
    }
}
//删除图片事件
-(void)deleteImgWithBtn:(UIButton *)btn{
    currentImgView.image = [UIImage imageNamed:@"Rounded-Rectangle-34-copy-2"];
    currentImgView.tag = 0;
    //取消全屏
    {
        [show_view removeFromSuperview];
    }
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
//再次点击取消全屏预览
-(void)tapBgView:(UITapGestureRecognizer *)tapBgRecognizer{
    [tapBgRecognizer.view removeFromSuperview];
}
//调取图片
-(void)getPhoneImage:(UIImageView *)imageV{
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"增加图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//取消选择
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//下一步按钮
-(void)nextBtnCallback{
    NSString * realname = self.nameTF.text;//姓名
    if (realname.length < 1) {
        [SVProgressHUD showErrorWithStatus:@"请输入姓名" duration:2];
        return;
    }
    if (self.card_up_icon.tag == 0) {
        [SVProgressHUD showErrorWithStatus:@"请上传身份证(正)" duration:2];
        return;
    }
    if (self.card_down_icon.tag == 0) {
        [SVProgressHUD showErrorWithStatus:@"请上传身份证(反)" duration:2];
        return;
    }
    //上传图片
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
        //截取图片
        float change = 1.0;
        [SVProgressHUD showWithStatus:@"上传身份证(正)\n上传进度:%0" maskType:SVProgressHUDMaskTypeClear];
        UIImage * img = self.card_up_icon.image;
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
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"上传身份证(正)\n上传进度:%.2f%%",uploadProgress.fractionCompleted*100] maskType:SVProgressHUDMaskTypeClear];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"Result"] boolValue]) {
            NSObject * fileid = responseObject[@"Data"][@"fileid"];
            cardid = fileid;
            [manager POST:stringURL parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                //截取图片
                float change = 1.0;
                [SVProgressHUD showWithStatus:@"上传身份证(正)\n上传进度:%0" maskType:SVProgressHUDMaskTypeClear];
                UIImage * img = self.card_up_icon.image;
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
                [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"上传身份证(反)\n上传进度:%.2f%%",uploadProgress.fractionCompleted*100] maskType:SVProgressHUDMaskTypeClear];
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ([responseObject[@"Result"] boolValue]) {
                    NSObject * fileid = responseObject[@"Data"][@"fileid"];
                    cardbackid = fileid;
                    NSString * interface = @"/user/memberuser/editmemberusercertificate.html";
                    NSDictionary * send = @{
                                            @"realname":realname,
                                            @"cardid":cardid,
                                            @"cardbackid":cardbackid,
                                            @"userid":USER_ID
                                            };
                    [MYTOOL netWorkingWithTitle:@"提交认证……"];
                    [MYNETWORKING getWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
                        PerfectVC * vc = [PerfectVC new];
                        vc.title = @"完善个人信息";
                        [self.navigationController pushViewController:vc animated:true];
                    }];
                    
                }else{
                    [SVProgressHUD showErrorWithStatus:responseObject[@"Message"] duration:2];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [SVProgressHUD showErrorWithStatus:@"上传失败" duration:2];
            }];
            
            
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"Message"] duration:2];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"上传失败" duration:2];
    }];
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
