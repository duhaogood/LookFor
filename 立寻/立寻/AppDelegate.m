//
//  AppDelegate.m
//  立寻
//
//  Created by mac_hao on 2017/5/23.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "AppDelegate.h"
#import "MainVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "DraftsVC.h"
@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    MainVC * main = [MainVC new];
    self.window.rootViewController = main;
    [self.window makeKeyAndVisible];
    
    //微信注册
    [WXApi registerApp:@"wx5ff1105426a8e8d9" enableMTA:YES];//注册微信
    
    
    
    
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    BOOL result = false;
    if (!result) {
        // 其他如支付等SDK的回调
        if(url != nil && [[url host] isEqualToString:@"pay"]){//微信支付
            //        NSLog(@"微信支付");
            
            
            return [WXApi handleOpenURL:url delegate:self];
        }
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                //            NSLog(@"result = %@",resultDic);
                int resultStatus = [resultDic[@"resultStatus"] intValue];
                if (resultStatus == 9000) {
                    [self paySuccess];
                }
            }];
            
            // 授权跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                // 解析 auth code
                NSString *result = resultDic[@"result"];
                NSString *authCode = nil;
                if (result.length>0) {
                    NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                    for (NSString *subResult in resultArr) {
                        if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                            authCode = [subResult substringFromIndex:10];
                            break;
                        }
                    }
                }
                NSLog(@"授权结果 authCode = %@", authCode?:@"");
            }];
        }
    }
    
    return result;
    
}
//支付成功后
-(void)paySuccess{
    [MYCENTER_NOTIFICATION postNotificationName:NOTIFICATION_PAY_SUCCESS object:nil];
    MainVC * main = (MainVC *)self.window.rootViewController;
    [main setSelectedIndex:4];
//    UINavigationController * nc = main.childViewControllers[4];
    
    
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    BOOL result = false;
    if (!result) {
        // 其他如支付等SDK的回调
        if(url != nil && [[url host] isEqualToString:@"pay"]){
            //微信支付
            return [WXApi handleOpenURL:url delegate:self];
        }
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result1 = %@",resultDic);
                int resultStatus = [resultDic[@"resultStatus"] intValue];
                if (resultStatus == 9000) {
                    [self paySuccess];
                }
            }];
            
            // 授权跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
                //            NSLog(@"result2 = %@",resultDic);
                // 解析 auth code
                NSString *result = resultDic[@"result"];
                NSString *authCode = nil;
                if (result.length>0) {
                    NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                    for (NSString *subResult in resultArr) {
                        if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                            authCode = [subResult substringFromIndex:10];
                            break;
                        }
                    }
                }
                NSLog(@"授权结果 authCode = %@", authCode?:@"");
            }];
        }
        if ([url.host isEqualToString:@"Myigreens"]) {
            [self receiveWebRequestWithUrl:url];
        }
    }
    return result;
}
//收到web端的请求
-(void)receiveWebRequestWithUrl:(NSURL *)url{
    NSLog(@"url:%@",url);
}
//收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
- (void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[PayResp class]])
    {
        PayResp *response = (PayResp *)resp;
        
        //        NSLog(@"支付结果 %d===%@",response.errCode,response.errStr);
        
        switch (response.errCode) {
            case WXSuccess: {
                
                NSLog(@"支付成功");
                
                //...支付成功相应的处理，跳转界面等
                [self paySuccess];
                break;
            }
            case WXErrCodeUserCancel: {
                
                 NSLog(@"用户取消支付");
                
                //...支付取消相应的处理
                [SVProgressHUD showErrorWithStatus:@"取消支付" duration:2];
                break;
            }
            default: {
                
                //                NSLog(@"支付失败");
                [self paySuccess];
                [SVProgressHUD showErrorWithStatus:@"支付失败" duration:2];
                //...做相应的处理，重新支付或删除支付
                
                break;
            }
        }
    }
    
}










- (void)applicationWillResignActive:(UIApplication *)application {
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        if (![window respondsToSelector:@selector(screen)] || window.screen == [UIScreen mainScreen]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
    }
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        if (![window respondsToSelector:@selector(screen)] || window.screen == [UIScreen mainScreen]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
    }
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}
- (void)applicationWillTerminate:(UIApplication *)application {
    
}


@end
