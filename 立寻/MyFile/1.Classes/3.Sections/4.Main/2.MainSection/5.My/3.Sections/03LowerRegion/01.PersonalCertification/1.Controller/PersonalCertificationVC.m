//
//  PersonalCertificationVC.m
//  立寻
//
//  Created by mac on 2017/5/31.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "PersonalCertificationVC.h"
#import "CertificationView.h"
#import "UpUserCardVC.h"
@interface PersonalCertificationVC ()

@end

@implementation PersonalCertificationVC

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
    //view
    CertificationView * view = [[CertificationView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) andDelegate:self andUserInfo:MYTOOL.userInfo];
    [self.view addSubview:view];
}




//认证回调
-(void)goCertification_btnCallback{
    //认证状态  1未认证 2等待认证  3认证没通过 4认证通过
    int ApproveState = [MYTOOL.userInfo[@"ApproveState"] intValue];
    NSString * text = @"";
    switch (ApproveState) {
        case 1:
            text = @"未认证";
            break;
        case 2:
            text = @"等待认证";
            break;
        case 3:
            text = @"认证没通过";
            break;
        default:
            text = @"认证通过";
            break;
    }
    if (ApproveState == 2) {
        [SVProgressHUD showErrorWithStatus:@"您已申请个人认证\n资料正在审核中…" duration:2];
        [self.navigationController popViewControllerAnimated:true];
        return;
    }
    if (ApproveState == 4) {
        [SVProgressHUD showErrorWithStatus:@"已认证通过\n无需再认证" duration:2];
        return;
    }
    UpUserCardVC * vc = [UpUserCardVC new];
    vc.title = @"个人认证";
    [self.navigationController pushViewController:vc animated:true];
}
//以后再说
-(void)laterSay_btnCallback{
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MainVC * main = (MainVC *)app.window.rootViewController;
    UINavigationController * nc = main.selectedViewController;
    [nc popToRootViewControllerAnimated:true];
}
//用户图片点击事件
-(void)clickImgOfUser:(UITapGestureRecognizer *)tap{
    
    
    
    
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
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    NSString * url = DHTOOL.userInfo[@"ImgFilePath"];//用户头像
    [self.user_icon sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"morenhdpic"]];
}
-(void)viewWillDisappear:(BOOL)animated{
    [MYTOOL showTabBar];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
@end
