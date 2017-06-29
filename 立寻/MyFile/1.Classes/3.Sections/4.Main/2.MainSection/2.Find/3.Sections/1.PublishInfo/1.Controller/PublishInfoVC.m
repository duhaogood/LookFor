//
//  PublishInfoVC.m
//  立寻
//
//  Created by mac on 2017/6/24.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "PublishInfoVC.h"
#import "PublishInfoView.h"
#import "LoginVC.h"
#import "LeaveMessageVC.h"
#import "HaveClueVC.h"
#import "WantToClaimVC.h"
#import "FeedbackVC.h"
#import "PersonalInfoVC.h"
@interface PublishInfoVC ()
@property(nonatomic,strong)NSMutableArray * commentList;//评论数据
@property(nonatomic,strong)PublishInfoView * publishView;
@end

@implementation PublishInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(popUpViewController)];
    self.view.backgroundColor = MYCOLOR_240_240_240;
    //加载主界面
    [self loadMainView];
//    NSLog(@"info:%@",self.publishDictionary);
}
//加载主界面
-(void)loadMainView{
    PublishInfoView * view = [[PublishInfoView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) andPublishDictionary:self.publishDictionary andDelegate:self];
    [self.view addSubview:view];
    self.publishView = view;
    self.automaticallyAdjustsScrollViewInsets = false;
    //加载评论数据
    [self headerRefresh];
    //加载是否关注状态
    [self loadIsAttention];
}


//加载是否关注状态
-(void)loadIsAttention{
    if (![MYTOOL isLogin]) {
        return;
    }
    NSString * interface = @"publish/publish/isexistsfollowpublishinfo.html";
    NSDictionary * send = @{
                            @"userid":USER_ID,
                            @"publishid":self.publishDictionary[@"PublishID"]
                            };
    [MYTOOL netWorkingWithTitle:@"加载中……"];
    [MYNETWORKING getDataWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        UIButton * btn = [UIButton new];
        btn.tag = 1;
        [self.publishView updateAttentionStatus:btn];
    } andNoSuccess:^(NSDictionary *back_dic) {
        UIButton * btn = [UIButton new];
        btn.tag = 0;
        [self.publishView updateAttentionStatus:btn];
    } andFailure:^(NSURLSessionTask *operation, NSError *error) {
        
    }];
    
    
}


#pragma mark - 用户按钮事件
//下拉事件
-(void)headerRefresh{
    [self loadAllCommentWithIsHeaderRefresh:true];
}
//上拉事件
-(void)footerRefresh{
    [self loadAllCommentWithIsHeaderRefresh:false];
}
//评论列表事件
-(void)submitCommentListBtn:(UIButton *)btn{
    [SVProgressHUD showSuccessWithStatus:@"评论列表事件" duration:1];
}
//举报事件
-(void)submitReportBtn:(UIButton *)btn{
    if (![MYTOOL isLogin]) {
        //跳转至登录页
        LoginVC * login = [LoginVC new];
        login.title = @"登录";
        [self.navigationController pushViewController:login animated:true];
        return;
    }
    FeedbackVC * vc = [FeedbackVC new];
    vc.title = @"投诉建议";
    [self.navigationController pushViewController:vc animated:true];
}
//个人详情事件
-(void)submitPersonalBtn:(UIButton *)btn{
    NSString * interface = @"user/memberuser/getmemberuserinfo.html";
    NSDictionary * send = @{
                            @"userid":self.publishDictionary[@"UserID"]
                            };
    [MYTOOL netWorkingWithTitle:@"加载中……"];
    [MYNETWORKING getWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        NSDictionary * info = back_dic[@"Data"];
        PersonalInfoVC * vc = [PersonalInfoVC new];
        vc.title = @"个人详情";
        vc.userInfo = info;
        [self.navigationController pushViewController:vc animated:true];
    }];
    
}
//关注事件
-(void)submitAttentionBtn:(UIButton *)btn{
    if (![MYTOOL isLogin]) {
        //跳转至登录页
        LoginVC * login = [LoginVC new];
        login.title = @"登录";
        [self.navigationController pushViewController:login animated:true];
        return;
    }
    NSInteger tag = btn.tag;
    NSString * interface = @"publish/publish/addfollowpublishinfo.html";
    if (tag) {
        interface = @"publish/publish/cancelfollowpublishinfo.html";
    }
    NSMutableDictionary * send_dic = [NSMutableDictionary new];
    [send_dic setValue:self.publishDictionary[@"PublishID"] forKey:@"publishid"];
    [send_dic setValue:USER_ID forKey:@"userid"];
    NSString * state = @"关注……";
    if (tag) {
        state = @"取消关注……";
    }
    [MYTOOL netWorkingWithTitle:state];
    [MYNETWORKING getWithInterfaceName:interface andDictionary:send_dic andSuccess:^(NSDictionary *back_dic) {
        btn.tag = !tag;
        [self.publishView updateAttentionStatus:btn];
    }];
    
    
}
//评论事件
-(void)submitCommentBtn:(UIButton *)btn{
    if (![MYTOOL isLogin]) {
        //跳转至登录页
        LoginVC * login = [LoginVC new];
        login.title = @"登录";
        [self.navigationController pushViewController:login animated:true];
        return;
    }
    //弹出的评论界面
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"请评论" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        [SVProgressHUD showWithStatus:@"评论中\n请稍等…" maskType:SVProgressHUDMaskTypeClear];
        NSString * msg = alert.textFields.firstObject.text;
        //拼接上传参数
        NSMutableDictionary * send_dic = [NSMutableDictionary new];
        [send_dic setValue:msg forKey:@"content"];
        [send_dic setValue:self.publishDictionary[@"PublishID"] forKey:@"publishid"];
        [send_dic setValue:USER_ID forKey:@"userid"];
        //开始上传
        [MYNETWORKING getWithInterfaceName:@"publish/publish/addcommentpublishinfo.html" andDictionary:send_dic andSuccess:^(NSDictionary * back_dic) {
            [self loadAllCommentWithIsHeaderRefresh:true];
        }];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alert addAction:action];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *tf){
        tf.placeholder = @"请输入评论消息";
    }];
    [alert addAction:cancel];
    [self showDetailViewController:alert sender:nil];
    
}
//留言事件
-(void)submitMessageBtn:(UIButton *)btn{
    if (![MYTOOL isLogin]) {
        //跳转至登录页
        LoginVC * login = [LoginVC new];
        login.title = @"登录";
        [self.navigationController pushViewController:login animated:true];
        return;
    }
    LeaveMessageVC * vc = [LeaveMessageVC new];
    vc.publishDictionary = self.publishDictionary;
    [self.navigationController pushViewController:vc animated:true];
}
//我有线索事件
-(void)submitMyClueBtn:(UIButton *)btn{
    if (![MYTOOL isLogin]) {
        //跳转至登录页
        LoginVC * login = [LoginVC new];
        login.title = @"登录";
        [self.navigationController pushViewController:login animated:true];
        return;
    }
    HaveClueVC * vc = [HaveClueVC new];
    vc.title = @"我有线索";
    vc.publishId = self.publishDictionary[@"PublishID"];
    [self.navigationController pushViewController:vc animated:true];
}
//我要认领事件
-(void)submitClaimBtn:(UIButton *)btn{
    if (![MYTOOL isLogin]) {
        //跳转至登录页
        LoginVC * login = [LoginVC new];
        login.title = @"登录";
        [self.navigationController pushViewController:login animated:true];
        return;
    }
    WantToClaimVC * vc = [WantToClaimVC new];
    vc.title = @"我要认领";
    vc.publishId = self.publishDictionary[@"PublishID"];
    [self.navigationController pushViewController:vc animated:true];
}
//重新加载所有评论
-(void)loadAllCommentWithIsHeaderRefresh:(BOOL)flag{
    NSString * interface = @"publish/publish/getpublishcommentpublishlist.html";
    NSDictionary * send = @{
                            @"publishid":self.publishDictionary[@"PublishID"]
                            };
    if (!flag) {
        send = @{
                 @"publishid":self.publishDictionary[@"PublishID"]
                 };
        if (self.commentList && self.commentList.count > 0) {
            send = @{
                     @"publishid":self.publishDictionary[@"PublishID"],
                     @"lastnumber":self.commentList[self.commentList.count - 1][@"CommentID"]
                     };
        }
    }
    [MYNETWORKING getNoPopWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        NSArray * list = back_dic[@"Data"];
        if (flag) {//下拉
            self.commentList = [NSMutableArray arrayWithArray:list];
        }else{//上拉
            if (list.count) {
                [self.commentList addObjectsFromArray:list];
            }
        }
        [self.publishView loadCommentViewWithArray:self.commentList andIsHeaderRefresh:flag];
    }];
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
