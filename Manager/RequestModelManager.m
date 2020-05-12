//
//  RequestModelManager.m
//  BasisModule
//
//  Created by KT--stc08 on 2018/7/11.
//  Copyright © 2018年 huang. All rights reserved.
//

#import "RequestModelManager.h"

@interface RequestModelManager()

@property(nonatomic,strong)id<RequestModelDelegate>delegate;
@end

@implementation RequestModelManager

+(instancetype)shareInstance
{
    static RequestModelManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RequestModelManager alloc] init];
    });
    return manager;
}

+(void)addDelegate:(id<RequestModelDelegate>)delegate
{
    [RequestModelManager shareInstance].delegate = delegate;
}

+(id<RequestModelDelegate>)delegate
{
    return  [RequestModelManager shareInstance].delegate;
}

@end
