//
//  RouterManager.m
//  BasisModule
//
//  Created by huang on 2016/11/3.
//  Copyright © 2016年 huang. All rights reserved.
//

#import "HHttpRequestManager.h"
#import "BaseRouterManager.h"
#import "RouterDefine.h"
#import "HHttpRequestConfigManager.h"

@implementation BaseRouterManager

+(BOOL)isRequestingWithURL:(NSString*)url
{
    BOOL isRequest = [HHttpRequestManager urlIsRequest:url];
    return isRequest;
}

+(id)requestWithDic:(NSDictionary *)userInfo withBlock:(void(^)(id result))block
{
    
    //空格及中文处理
    NSString *url = userInfo[ClientUrl];
    
    NSDictionary *parameters = userInfo[ClientParameters];
    NSString *type =  [userInfo[ClientType] lowercaseString];
    
    //是否缓存
    BOOL isCache = false;
    void (^completion)(id result) = block;
    NSString * cacheUrl=nil;
    void (^uploadProgress)(NSProgress *downloadProgress)= userInfo[ClientProgress];
    
    id<HHttpRequestConfigDelegate> delegate = [HHttpRequestConfigManager delegate];
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    if (delegate) {
        [headers addEntriesFromDictionary:delegate.headerFile];
    }
    if(userInfo[ClientHeaders])
    {
        [headers addEntriesFromDictionary:userInfo[ClientHeaders]];
    }
    if([HHttpRequestManager networkReachabilityStatus]==0)
    {
        NSLog(@"无网络请");
        NSError *error = [NSError errorWithDomain:@"无网络请检查网络" code:10000 userInfo:nil];
        [self failureEvent:error withCompletion:completion];
        return nil;
    }
    NSNumber * serializer = userInfo[ClientRequestSerializer];
    switch ([serializer intValue]) {
        case HHttpRequestSerializerJSON:
        {
            if([HHttpRequestManager manager].requestSerializer != [HHttpRequestManager jsonRequestSerializer])
            {
                [HHttpRequestManager manager].requestSerializer = [HHttpRequestManager jsonRequestSerializer];
            }
        }
            break;
        default:{
            if([HHttpRequestManager manager].requestSerializer != [HHttpRequestManager httpRequestSerializer])
            {
                [HHttpRequestManager manager].requestSerializer = [HHttpRequestManager httpRequestSerializer];
            }
            
        }
            break;
    }
    NSUInteger timeOut = [userInfo[ClientTimeOutInterval] intValue];
    if (timeOut != kTimeOutInterval) {
        AFHTTPRequestSerializer *serializer = [HHttpRequestManager manager].requestSerializer;
        [serializer willChangeValueForKey:@"timeoutInterval"];
        serializer.timeoutInterval = timeOut;
        [serializer didChangeValueForKey:@"timeoutInterval"];
    }
    
    
    
    if ([type isEqualToString:@"post"]) {
        
        return [HHttpRequestManager POST:url parameters:parameters headers:headers progress:uploadProgress success:^(NSDictionary * _Nonnull dict, BOOL success) {
            [self successEvent:dict isCache:isCache withCacheKey:cacheUrl withCompletion:completion];
        } failure:^(NSError * _Nonnull error) {
            [self failureEvent:error withCompletion:completion];
        }];
        
    }
    else if([type isEqualToString:@"get"])
    {
        return [HHttpRequestManager GET:url parameters:parameters headers:headers success:^(NSDictionary * _Nonnull dict, BOOL success) {
            [self successEvent:dict isCache:isCache withCacheKey:cacheUrl withCompletion:completion];
            
        } failure:^(NSError * _Nonnull error) {
            [self failureEvent:error withCompletion:completion];
            
        }];
    }
    else if([type isEqualToString:@"cancel"])
    {
        [HHttpRequestManager cancelRequest:url];
    }
    else if([type isEqualToString:@"put"])
    {
        return [HHttpRequestManager PUT:url parameters:parameters headers:headers success:^(NSDictionary * _Nonnull dict, BOOL success) {
            [self successEvent:dict   withCompletion:completion];
            
        } failure:^(NSError * _Nonnull error) {
            [self failureEvent:error withCompletion:completion];
            
        }];
    }
    else if([type isEqualToString:@"patch"])
    {
        return [HHttpRequestManager PATCH:url parameters:parameters headers:headers success:^(NSDictionary * _Nonnull dict, BOOL success) {
            [self successEvent:dict  withCompletion:completion];
            
        } failure:^(NSError * _Nonnull error) {
            [self failureEvent:error withCompletion:completion];
            
        }];
        
    }
    else if([type isEqualToString:@"delete"])
    {
        return [HHttpRequestManager DELETE:url parameters:parameters headers:headers success:^(NSDictionary * _Nonnull dict, BOOL success) {
            [self successEvent:dict  withCompletion:completion];
            
        } failure:^(NSError * _Nonnull error) {
            [self failureEvent:error withCompletion:completion];
            
        }];
    }
    else if([type isEqualToString:@"download"])
    {
      return  [HHttpRequestManager downloadWithUrlSring:url withData: userInfo[DownCurrentLength]   savePath:userInfo[SavePath] progress:uploadProgress completionHandler:^(NSString *filePath, NSError *error) {
            
            if (error==nil) {
                [self successEvent:@{@"filePath":filePath,@"code":@(200)}  withCompletion:completion];
            }
            else
            {
                [self failureEvent:error withCompletion:completion];
            }
        }];
        
    }
    else if([type isEqualToString:@"upload"])
    {
        
        
        id files = userInfo[UploadFiles];
        NSArray *name = userInfo[UploadName];
        NSArray *fileName = userInfo[UploadFileName];
        NSArray *mimeType = userInfo[UploadMimeType];
        if (![files isKindOfClass:[NSArray class]]) {
            files = @[files];
        }
        return [HHttpRequestManager uploadImageWithUrlString:url parameters:parameters headers: headers files:files name:name fileName:fileName mimeType:mimeType progress:uploadProgress success:^(NSDictionary * _Nonnull dict, BOOL success) {
            [self successEvent:dict  withCompletion:completion];
        } failure:^(NSError * _Nonnull error) {
            [self failureEvent:error withCompletion:completion];
        }];
        
        
    }
    return nil;
}

/**
 *  拼接post请求的网址
 *
 *  @param urlStr     基础网址
 *  @param parameters 拼接参数
 *
 *  @return 拼接完成的网址
 */
+(NSString *)urlDictToStringWithUrlStr:(NSString *)urlStr WithDict:(NSDictionary *)parameters
{
    if (!parameters) {
        return urlStr;
    }
    
    
    NSMutableArray *parts = [NSMutableArray array];
    //enumerateKeysAndObjectsUsingBlock会遍历dictionary并把里面所有的key和value一组一组的展示给你，每组都会执行这个block 这其实就是传递一个block到另一个方法，在这个例子里它会带着特定参数被反复调用，直到找到一个ENOUGH的key，然后就会通过重新赋值那个BOOL *stop来停止运行，停止遍历同时停止调用block
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //接收key
        NSString *finalKey = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        //接收值
        NSString *finalValue = [obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        
        NSString *part =[NSString stringWithFormat:@"%@=%@",finalKey,finalValue];
        
        [parts addObject:part];
        
    }];
    
    NSString *queryString = [parts componentsJoinedByString:@"&"];
    
    queryString = queryString ? [NSString stringWithFormat:@"?%@",queryString] : @"";
    
    NSString *pathStr = [NSString stringWithFormat:@"%@?%@",urlStr,queryString];
    
    return pathStr;
    
    
    
}

#pragma mark --根据返回的数据进行统一的格式处理  ----requestData 网络或者是缓存的数据----
+ (void)returnDataWithRequestData:(id )requestData withCompletion: (void (^)(id result))completion{
    
    
    
    //判断是否为字典
    if ([requestData isKindOfClass:[NSError class]]) {
        [self failureEvent:requestData withCompletion:completion];
    }
    
    else
    {
        NSDictionary *  requestDic = (NSDictionary *)requestData;
        //根据返回的接口内容来变
        [self successEvent:requestDic  withCompletion:completion];
        
    }
    
}

// 网络状态改变
+(void)reachabilityStatusChange:(void(^)(NSInteger status))block
{
    [HHttpRequestManager setReachabilityStatusChangeBlock:^(NSInteger status) {
        if (block) {
            block(status);
        }
        
    }];
}
//获取网络状态
+(long)getReachabilityStatus
{
    
    return  [HHttpRequestManager networkReachabilityStatus];
    
}

+(void)successEvent:(NSDictionary*)dict  withCompletion:(void (^)(id result))completion
{
    [self successEvent:dict isCache:NO withCacheKey:nil  withCompletion:completion];
}
+(void)successEvent:(NSDictionary*)dict isCache:(BOOL)isCache withCacheKey:(NSString *)cacheKey withCompletion:(void (^)(id result))completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (completion) {
            completion(dict);
        }
        
    });
    
}
+(void)failureEvent:(NSError*)error withCompletion:(void (^)(id result))completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(error);
        
    });
    
}

@end

