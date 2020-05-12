//
//  HHttpRequestConfig.m
//  BasisModule
//
//  Created by KT--stc08 on 2018/7/12.
//  Copyright © 2018年 huang. All rights reserved.
//

#import "HHttpRequestConfigManager.h"

@interface HHttpRequestConfigManager()
@property(nonatomic,strong)id<HHttpRequestConfigDelegate> delegate;
@end

@implementation HHttpRequestConfigManager

+(instancetype)shareInstance
{
    static HHttpRequestConfigManager *config = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [HHttpRequestConfigManager new];
    });
    
    return config;
}

+(void)addDelegate:(id<HHttpRequestConfigDelegate>)delegate
{
    [HHttpRequestConfigManager shareInstance].delegate =  delegate;
}
+(id<HHttpRequestConfigDelegate>)delegate
{
    return [HHttpRequestConfigManager shareInstance].delegate;
}

@end
