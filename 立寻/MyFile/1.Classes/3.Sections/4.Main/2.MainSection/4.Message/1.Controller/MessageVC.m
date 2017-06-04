//
//  MessageVC.m
//  立寻
//
//  Created by mac_hao on 2017/5/23.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "MessageVC.h"

@interface MessageVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSArray * cellDateArray;//cell数据

@end

@implementation MessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellDateArray = @[
                           @{
                               @"url":@"http://scimg.jb51.net/touxiang/201705/2017050421535596.jpg",
                               @"nickName":@"水煮蛋小姐",
                               @"message":@"您订阅的是陪练，我会尽快给你回复的哦",
                               @"time":@"2个小时前"
                               },
                           @{
                               @"url":@"http://scimg.jb51.net/touxiang/201705/2017050421535596.jpg",
                               @"nickName":@"水煮蛋小姐",
                               @"message":@"您订阅的是陪练，我会尽快给你回复的哦，不要着急哈，亲。您订阅的是陪练，我会尽快给你回复的哦，不要着急哈，亲",
                               @"time":@"2个小时前"
                               },
                           @{
                               @"url":@"http://scimg.jb51.net/touxiang/201705/2017050421535596.jpg",
                               @"nickName":@"水煮蛋小姐",
                               @"message":@"您订阅的是陪练，我会尽快给你回复的哦，不要着急哈，亲。",
                               @"time":@"2个小时前"
                               },
                           @{
                               @"url":@"http://scimg.jb51.net/touxiang/201705/2017050421535596.jpg",
                               @"nickName":@"水煮蛋小姐",
                               @"message":@"您订阅的是陪练，我会尽快给你回复的哦，不要着急哈，亲。",
                               @"time":@"2个小时前"
                               },
                           @{
                               @"url":@"http://scimg.jb51.net/touxiang/201705/2017050421535596.jpg",
                               @"nickName":@"水煮蛋小姐",
                               @"message":@"您订阅的是陪练，我会尽快给你回复的哦，不要着急哈，亲。",
                               @"time":@"2个小时前"
                               },
                           @{
                               @"url":@"http://scimg.jb51.net/touxiang/201705/2017050421535596.jpg",
                               @"nickName":@"水煮蛋小姐",
                               @"message":@"您订阅的是陪练，我会尽快给你回复的哦，不要着急哈，亲。",
                               @"time":@"2个小时前"
                               }
                           ];
    //加载主界面
    [self loadMainView];
}
//加载主界面
-(void)loadMainView{
    self.view.backgroundColor = MYCOLOR_240_240_240;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search_btn"] style:UIBarButtonItemStyleDone target:self action:@selector(submitSearchBtn)];
    //tableView
    {
        UITableView * tableView = [UITableView new];
        tableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT - 64);
        self.automaticallyAdjustsScrollViewInsets = false;
        tableView.dataSource = self;
        tableView.delegate = self;
        [self.view addSubview:tableView];
        self.tableView = tableView;
        tableView.rowHeight = [MYTOOL getHeightWithIphone_six:75];
        tableView.backgroundColor = MYCOLOR_240_240_240;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellDateArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.cellDateArray[indexPath.row];
    UITableViewCell * cell = [UITableViewCell new];
    float left = 10;
    float top = tableView.rowHeight/6.0;
    //头像
    {
        UIImageView * icon = [UIImageView new];
        float img_width = tableView.rowHeight * 2 / 3.0;
        icon.frame = CGRectMake(left, top, img_width, img_width);
        icon.layer.masksToBounds = true;
        icon.layer.cornerRadius = img_width/2.0;
        NSString * url = dic[@"url"];
        [MYTOOL setImageIncludePrograssOfImageView:icon withUrlString:url];
        [cell addSubview:icon];
        left += img_width + 10;
    }
    float time_middle_top = 0;
    //昵称
    {
        NSString * nickName = dic[@"nickName"];
        UILabel * label = [UILabel new];
        label.text = nickName;
        label.textColor = MYCOLOR_48_48_48;
        label.font = [UIFont systemFontOfSize:13];
        CGSize size = [MYTOOL getSizeWithLabel:label];
        label.frame = CGRectMake(left, top, size.width, size.height);
        [cell addSubview:label];
        time_middle_top = top + size.height / 2.0;
    }
    //时间
    {
        NSString * time = dic[@"time"];
        UILabel * label = [UILabel new];
        label.text = time;
        label.textColor = [MYTOOL RGBWithRed:112 green:112 blue:112 alpha:1];
        label.font = [UIFont systemFontOfSize:10];
        CGSize size = [MYTOOL getSizeWithLabel:label];
        label.frame = CGRectMake(WIDTH - 10 - size.width, time_middle_top-size.height/2, size.width, size.height);
        [cell addSubview:label];
    }
    //消息文字
    {
        NSString * message = dic[@"message"];
        UILabel * label = [UILabel new];
        label.text = message;
        label.textColor = [MYTOOL RGBWithRed:112 green:112 blue:112 alpha:1];
        label.font = [UIFont systemFontOfSize:11];
        CGSize size = [MYTOOL getSizeWithLabel:label];
        label.frame = CGRectMake(left, tableView.rowHeight/2, WIDTH-10-left, size.height);
        if (size.width > WIDTH - 10 - left + label.font.pointSize) {
            label.frame = CGRectMake(left, tableView.rowHeight/2, WIDTH-10-left, size.height*2);
            label.numberOfLines = 0;
        }
        [cell addSubview:label];
    }
    
    
    //分割线
    {
        if (indexPath.row < self.cellDateArray.count - 1) {
            UIView * space = [UIView new];
            space.backgroundColor = MYCOLOR_240_240_240;
            space.frame = CGRectMake(0, tableView.rowHeight - 1, WIDTH, 1);
            [cell addSubview:space];
        }
    }
    return cell;
}

#pragma mark - 按钮事件
//搜索事件
-(void)submitSearchBtn{
    NSLog(@"搜索");
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.tabBarItem.badgeValue = @"6";
}

@end
