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
                              @"api_key":@"ps321323198711182537lixunappmima",
                              @"app_id":@"wx5ff1105426a8e8d9",
                              @"app_secret":@"a0cb8aee9361220290c2370e657e4186",
                              @"mch_id":@"1484366962",
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
