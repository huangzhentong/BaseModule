//
//  HttpRequestDisponse.m
//  BasisModule
//
//  Created by KT--stc08 on 2018/7/12.
//  Copyright © 2018年 huang. All rights reserved.
//

#import "HttpRequestDisponse.h"

@implementation HttpRequestDisponse

//请求将开始开始
-(void)requestWillStart
{
    NSLog(@"开始请求啦");
}
//请求完成
-(void)requestComplete:(id)result withError:(NSError*)error
{
    NSLog(@"请求结束啦！！");
}
//请求结束逻辑处理,返回数据处理结果
-(id)requestLogicDispose:(id)dict withClass:(__unsafe_unretained Class)class
{
    if ([dict isKindOfClass:[NSError class]])
    {
        NSError *error = dict;
        //取消请求
        if (error.code==NSURLErrorCancelled) {
            return nil;
            
        }
        NSError *newError = [NSError errorWithDomain:@"服务器请求失败" code:error.code userInfo:error.userInfo];
        return newError;
        
    }
    else if(dict[@"code"]==nil)
    {
        NSError *error  = [NSError errorWithDomain:@"未知错误" code:99999 userInfo:nil];
        return error;
    }
    else if([dict[@"code"] intValue]!=2000)
    {
        NSError *error  = [NSError errorWithDomain:dict[@"message"] code:[dict[@"code"] intValue] userInfo:nil];
        return error;
        
    }
    else
    {
        return dict;
    }
    return dict;
}

+(void)load{
    [RequestModelManager addDelegate:[HttpRequestDisponse new]];
}

@end
