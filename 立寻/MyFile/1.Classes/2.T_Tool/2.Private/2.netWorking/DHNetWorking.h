//
//  DHNetWorking.h
//  绿茵荟
//
//  Created by Mac on 17/3/28.
//  Copyright © 2017年 徐州野马软件. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHNetWorking : NSObject
/**
 *  获取单例网络工具类对象
 *
 *  @return 工具对象
 */
+(instancetype)sharedDHNetWorking;



-(void)getWithInterfaceName:(NSString *)interfaceName andDictionary:(NSDictionary *)send_dic andSuccess:(void(^)(NSDictionary * back_dic)) back_block;
-(void)getNoPopWithInterfaceName:(NSString *)interfaceName andDictionary:(NSDictionary *)send_dic andSuccess:(void(^)(NSDictionary * back_dic)) back_block;
//不管怎样都有回调
-(void)getDataWithInterfaceName:(NSString *)interfaceName andDictionary:(NSDictionary *)send_dic andSuccess:(void(^)(NSDictionary * back_dic)) back_block andNoSuccess:(void(^)(NSDictionary * back_dic)) no_block andFailure:(void(^)(NSURLSessionTask *operation, NSError *error)) failure_block;
@end
