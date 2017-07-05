//
//  DHNetWorking.m
//  绿茵荟
//
//  Created by Mac on 17/3/28.
//  Copyright © 2017年 徐州野马软件. All rights reserved.
//

#import "DHNetWorking.h"
#import "AFNetworking.h"
static id instance;
@implementation DHNetWorking
+(instancetype)sharedDHNetWorking{
    if (!instance) {
        instance = [[self alloc]init];
    }
    return instance;
}
+(instancetype)alloc{
    if (!instance) {
        instance = [[super alloc]init];
    }
    return instance;
}
-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}
-(void)getWithInterfaceName:(NSString *)interfaceName andDictionary:(NSDictionary *)send_dic andSuccess:(void (^)(NSDictionary * back_dic))back_block{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@",SERVER_URL,interfaceName];
    if (![[interfaceName substringToIndex:1] isEqualToString:@"/"]) {
        urlString = [NSString stringWithFormat:@"%@/%@",SERVER_URL,interfaceName];
    }
    NSMutableDictionary * send = [NSMutableDictionary dictionaryWithDictionary:send_dic];
    //验证参数
    [send setValue:@"99999999" forKey:@"appid"];
    [manager GET:urlString parameters:send progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if (![[responseObject valueForKey:@"Result"] boolValue]) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"Message"] duration:2];
        }else{
//            [SVProgressHUD showSuccessWithStatus:responseObject[@"Message"] duration:1];
            back_block(responseObject);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络出错" duration:2];
    }];
}
-(void)getWithInterfaceName:(NSString *)interfaceName andDictionary:(NSDictionary *)send_dic andSuccess:(void (^)(NSDictionary * back_dic))back_block andFailure:(void(^)(NSError * error_failure)) failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@",SERVER_URL,interfaceName];
    if (![[interfaceName substringToIndex:1] isEqualToString:@"/"]) {
        urlString = [NSString stringWithFormat:@"%@/%@",SERVER_URL,interfaceName];
    }
    [manager GET:urlString parameters:send_dic progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if (![[responseObject valueForKey:@"Result"] boolValue]) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"Message"] duration:2];
        }else{
            back_block(responseObject);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        failure(error);
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络出错" duration:2];
    }];
}
-(void)getNoPopWithInterfaceName:(NSString *)interfaceName andDictionary:(NSDictionary *)send_dic andSuccess:(void(^)(NSDictionary * back_dic)) back_block{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@",SERVER_URL,interfaceName];
    if (![[interfaceName substringToIndex:1] isEqualToString:@"/"]) {
        urlString = [NSString stringWithFormat:@"%@/%@",SERVER_URL,interfaceName];
    }
    NSMutableDictionary * send = [NSMutableDictionary dictionaryWithDictionary:send_dic];
    //验证参数
    [send setValue:@"99999999" forKey:@"appid"];
    [manager GET:urlString parameters:send progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if (![[responseObject valueForKey:@"Result"] boolValue]) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"Message"] duration:2];
        }else{
            back_block(responseObject);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络出错" duration:2];
    }];
}
//不管怎样都有回调
-(void)getDataWithInterfaceName:(NSString *)interfaceName andDictionary:(NSDictionary *)send_dic andSuccess:(void(^)(NSDictionary * back_dic)) back_block andNoSuccess:(void(^)(NSDictionary * back_dic)) no_block andFailure:(void(^)(NSURLSessionTask *, NSError *)) failure_block{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@",SERVER_URL,interfaceName];
    if (![[interfaceName substringToIndex:1] isEqualToString:@"/"]) {
        urlString = [NSString stringWithFormat:@"%@/%@",SERVER_URL,interfaceName];
    }
    NSMutableDictionary * send = [NSMutableDictionary dictionaryWithDictionary:send_dic];
    //验证参数
    [send setValue:@"99999999" forKey:@"appid"];
    [manager GET:urlString parameters:send progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if (![[responseObject valueForKey:@"Result"] boolValue]) {
            no_block(responseObject);
        }else{
            back_block(responseObject);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络出错" duration:2];
        failure_block(operation,error);
    }];
    
}

@end
