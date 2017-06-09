//
//  IssueInfoVC.m
//  立寻
//
//  Created by Mac on 17/6/9.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "IssueInfoVC.h"

@interface IssueInfoVC ()<UITextFieldDelegate,UITextViewDelegate>
@property(nonatomic,strong)UIScrollView * scrollView;//背景view




@end

@implementation IssueInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(popUpViewController)];
    self.view.backgroundColor = MYCOLOR_240_240_240;
    NSLog(@"list:%@",self.secondTypeList);
    //加载主界面
    [self loadMainView];
}
//加载主界面
-(void)loadMainView{
    //背景scrollView
    UIScrollView * scrollView = [UIScrollView new];
    {
        scrollView.frame = self.view.bounds;
        [self.view addSubview:scrollView];
        self.scrollView = scrollView;
    }
    float top = 0;
    //发布上册view
    {
        float height = [MYTOOL getHeightWithIphone_six:323];
        IssueInfoUpView * view = [[IssueInfoUpView alloc] initWithFrame:CGRectMake(0, top, WIDTH, height) andUserUrl:@"http://img.woyaogexing.com/touxiang/katong/20140110/864ea8353fe3edd3.jpg%21200X200.jpg" andTypeTitle:self.typeTitle andTypeArray:self.secondTypeList andDelegate:self];
        view.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:view];
        top += height + 10;
    }
    //发布中部view
    {
        float height = [MYTOOL getHeightWithIphone_six:273];
        UIView * view = [UIView new];
        view.frame = CGRectMake(0, top, WIDTH, height);
        view.backgroundColor = [UIColor greenColor];
        [scrollView addSubview:view];
        top += height + 10;
    }
    //发布底部view
    {
        float height = [MYTOOL getHeightWithIphone_six:273];
        UIView * view = [UIView new];
        view.frame = CGRectMake(0, top, WIDTH, height);
        view.backgroundColor = [UIColor greenColor];
        [scrollView addSubview:view];
        top += height;
    }
    scrollView.contentSize = CGSizeMake(0, top);
    
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
    //字数控制
    if (range.length == 0) {//字数增加
        NSInteger count = textView.text.length;
        if (count >= 10) {
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
