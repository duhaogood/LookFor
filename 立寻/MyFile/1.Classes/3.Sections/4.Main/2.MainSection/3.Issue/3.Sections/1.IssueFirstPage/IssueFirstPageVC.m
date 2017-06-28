//
//  IssueVC.m
//  立寻
//
//  Created by mac on 2017/6/4.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "IssueFirstPageVC.h"
#import "LookForCircleVC.h"
#import "NetShowHelpVC.h"
#import "LookManSomeThingVC.h"
#import "PickUpSomeThingVC.h"
@interface IssueFirstPageVC ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *backgroundTapView;
@end

@implementation IssueFirstPageVC
{
    NSArray * img_name_array;
}
- (void)show {
    UIWindow * window = ((AppDelegate*)[UIApplication sharedApplication].delegate).window;
    UIViewController *rootViewController = window.rootViewController;
    [rootViewController addChildViewController:self];
    [rootViewController.view addSubview:self.view];
    [self didMoveToParentViewController:rootViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSuperViewController:)];
    tap.delegate = self;
    tap.numberOfTapsRequired = 1;
    tap.delaysTouchesBegan = YES;
    [self.backgroundTapView addGestureRecognizer:tap];
    
    //加载主界面
    [self loadMainView];
}
//加载主界面
-(void)loadMainView{
    self.view.backgroundColor = [MYTOOL RGBWithRed:0 green:0 blue:0 alpha:0.7];
    //图片按钮数组
    img_name_array = @[
                       @[
                           @[@"fbbtn_baoguang",@"网络曝光",@"96",@"109",@"80",@"NetShowHelpVC"],
                           @[@"fbbtn_qiuzhu",@"网络求助",@"88",@"96",@"81",@"NetShowHelpVC"],
                           @[@"fbbtn_quanzi",@"立寻圈子",@"96",@"109",@"549",@"LookForCircleVC"]
                           ],//第一行
                       @[
                           @[@"fbbtn_xunren",@"委托寻人",@"96",@"109",@"83",@"LookManSomeThingVC"],
                           @[@"fbbtn_xw",@"委托寻物",@"88",@"96",@"82",@"LookManSomeThingVC"],
                           @[@"fbbtn_zlrl",@"招领认领",@"96",@"109",@"394",@"PickUpSomeThingVC"]
                           ]//第二行
                      ];
    //加载按钮
    {
        //第一行图片y坐标
        float top = HEIGHT - 30 - 33 - 20 - [DHTOOL getHeightWithIphone_six:109] * 2;
        for (int i = 0; i<img_name_array.count; i ++) {
            NSArray * arr = img_name_array[i];
            for (int j = 0; j < arr.count; j ++) {
                //图片数据
                NSArray * img_array = arr[j];
                //图片名称
                NSString * name = img_array[0];
                float img_width = [img_array[2] floatValue];//图片宽度
                float img_height = [img_array[3] floatValue];//图片高度
                //按钮位置
                float space_left = (WIDTH - [DHTOOL getHeightWithIphone_six:109] * 96 / 109.0 * 3)/2;
                float btn_height = [MYTOOL getHeightWithIphone_six:img_height];
                float btn_width = img_width/img_height*btn_height;
                float btn_x = space_left + [DHTOOL getHeightWithIphone_six:109] * 96 / 109.0 * j;
                float btn_y = top + ([DHTOOL getHeightWithIphone_six:109] + 20) * i;
                //按钮
                UIButton * btn = [UIButton new];
                [btn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
                btn.frame = CGRectMake(btn_x, btn_y, btn_width, btn_height);
                if (j == 1) {
                    btn.frame = CGRectMake(WIDTH/2-btn_width/2, btn_y, btn_width, btn_height);
                }
                [self.view addSubview:btn];
                btn.tag = i * 10 + j;
                [btn addTarget:self action:@selector(submitImgBtn:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    
    //关闭按钮
    {
        UIButton * btn = [UIButton new];
        [btn setImage:[UIImage imageNamed:@"fb_close"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(WIDTH/2-33/2.0, HEIGHT-20-33, 33, 33);
        [btn addTarget:self action:@selector(submitCloseBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
}
#pragma mark - 按钮事件
//图片按钮事件
-(void)submitImgBtn:(UIButton *)btn{
    [MYTOOL netWorkingWithTitle:@"获取分类列表……"];
    
    //一级分类的CategoryID------获取二级分类的依据
    NSString * parentid = img_name_array[btn.tag/10][btn.tag%10][4];
    NSString * interface = @"publish/publish/getcategorytwolist.html";
    NSDictionary * send = @{
                            @"appid":APPID_MINE,
                            @"parentid":parentid
                            };
    [MYNETWORKING getNoPopWithInterfaceName:interface andDictionary:send andSuccess:^(NSDictionary *back_dic) {
        NSString * className = img_name_array[btn.tag/10][btn.tag%10][5];
        NSString * title = img_name_array[btn.tag/10][btn.tag%10][1];
        Class class = NSClassFromString(className);
        UIViewController * vc = [class new];
        vc.title = title;
        ((PickUpSomeThingVC *)vc).secondTypeList = back_dic[@"Data"];
        //跳转
        [[self.delegate navigationController] pushViewController:vc animated:true];
        [self submitCloseBtn];
    }];
    
    
    
    
    
}
//关闭按钮事件
-(void)submitCloseBtn{
    [self removeFromSuperViewController:nil];
}

- (void)removeFromSuperViewController:(UIGestureRecognizer *)gr {
    [self didMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [self.backgroundTapView removeGestureRecognizer:gr];
}



@end
