//
//  WXPayTool.m
//  绿茵荟
//
//  Created by Mac on 17/5/12.
//  Copyright © 2017年 徐州野马软件. All rights reserved.
//

#import "WXPayTool.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "lhSharePay.h"
@implementation WXPayTool

//支付
-(void)wxPayWithGoodsDictionary:(NSDictionary*)payDictionary{
    NSString * orderId = payDictionary[@"orderId"];
    //payDic和orderDic请求实例
    NSDictionary * payDic = @{
                              @"api_key":@"zhaomandewangzhanlixun110henniub",
                              @"app_id":@"wx7074ea72756fdfbc",
                              @"app_secret":@"db305d6d99746433564ec3c13330bc44",
                              @"mch_id":@"1480542612",
                              @"notify_url":@"http://user.lixun110.com/payment/WxPay/ResultNotifyPage.aspx"
                              };
    NSString * price = payDictionary[@"money"];
    price = [NSString stringWithFormat:@"%d",(int)(price.doubleValue*100)];
    NSString * subject = @"立寻网余额充值";
    NSDictionary * orderDic = @{
                                @"enable":@"1",
                                @"id":@"df2b38795ccd40cea71c2e859aec7e5c",
                                @"money":price,
                                @"orderCode":orderId,
                                @"rechargeRule_id":@"1",
                                @"remark":@"",
                                @"status":@"",
                                @"successTime":@"",
                                @"time":@"1436766784625",
                                @"users_id":@"a38d4da064054e99840efdd91280ee35",
                                @"way":@"2",
                                @"productName":subject,
                                @"productDescription":subject
                                };
    
    //下单成功，调用微信支付
    [[lhSharePay sharePay]wxPayWithPayDic:payDic OrderDic:orderDic];
}




@end
