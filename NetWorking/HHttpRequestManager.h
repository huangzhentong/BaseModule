//
//  HHttpRequestManager.h
//  BasisModule
//
//  Created by huang on 2016/10/27.
//  Copyright © 2016年 huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kTimeOutInterval 10 // 请求超时的时间
//#define kBaseURL @"http://192.168.1.20:8000"

#import <UIKit/UIKit.h>
//#import <AFNetworking.h>
#import "AFHTTPSessionManager.h"

typedef void (^AFNSuccessBlock)(NSDictionary * _Nonnull dict, BOOL success); // 访问成功block
typedef void (^AFNErrorBlock)(NSError * _Nonnull error); // 访问失败block


@interface HHttpRequestManager : NSObject
//添加header

+(AFHTTPSessionManager *_Nullable)manager;
+(AFHTTPRequestSerializer*_Nullable)httpRequestSerializer;
+(AFJSONRequestSerializer*_Nullable)jsonRequestSerializer;

//网络状态
+(NSInteger)networkReachabilityStatus;

//是否可连接
+(BOOL)isReachable;
//设置网络状态改变
+ (void)setReachabilityStatusChangeBlock:(nullable void (^)(NSInteger status))block;

//get 请求
+ (NSURLSessionDataTask*)GET:(nullable NSString *  )urlString
 parameters:(nullable id)parameters
headers:(nullable NSDictionary <NSString *, NSString *> *)headers
   progress:(nullable void (^)(NSProgress * _Nonnull downloadProgress))downloadProgress
    success:(nullable AFNSuccessBlock)success
    failure:(nullable AFNErrorBlock)failure;

+ (NSURLSessionDataTask*)GET:(nullable NSString *)urlString
 parameters:(nullable id)parameters
headers:(nullable NSDictionary <NSString *, NSString *> *)headers
    success:(nullable AFNSuccessBlock)success
    failure:(nullable AFNErrorBlock)failure;

//post 请求
+(NSURLSessionDataTask*)POST:(nullable NSString *)urlString
 parameters:(nullable id)parameters
headers:(nullable NSDictionary <NSString *, NSString *> *)headers
   progress:(nullable void (^)(NSProgress *_Nonnull downloadProgress))uploadProgress
    success:(nullable AFNSuccessBlock)success
    failure:(nullable AFNErrorBlock)failure;


+(NSURLSessionDataTask*)POST:(nullable NSString *)urlString
 parameters:(nullable id)parameters
headers:(nullable NSDictionary <NSString *, NSString *> *)headers
    success:(nullable AFNSuccessBlock)success
    failure:(nullable AFNErrorBlock)failure;

+(NSURLSessionDataTask*)PUT:(nullable NSString *)URLString
    parameters:(nullable id)parameters
headers:(nullable NSDictionary <NSString *, NSString *> *)headers
    success:(nullable AFNSuccessBlock)success
    failure:(nullable AFNErrorBlock)failure;

+(NSURLSessionDataTask*)PATCH:(nullable NSString *)URLString
parameters:(nullable id)parameters
headers:(nullable NSDictionary <NSString *, NSString *> *)headers
   success:(nullable AFNSuccessBlock)success
   failure:(nullable AFNErrorBlock)failure;

+(NSURLSessionDataTask*)DELETE:(nullable NSString *)URLString
parameters:(nullable id)parameters
headers:(nullable NSDictionary <NSString *, NSString *> *)headers
   success:(nullable AFNSuccessBlock)success
   failure:(nullable AFNErrorBlock)failure;


//取消请求
+(void)cancelRequest:(nullable NSString *)urlString;
//取消当前所有请求
+(void)cancelAllRequest;
//判断URL是否请求中
+(BOOL)urlIsRequest:(nullable NSString *)urlString;



#pragma mark -- 下载 （未完成）
//下载
+(void)downloadWithUrlSring:(nullable NSString *)urlString
                   savePath:(nullable NSString *)savePath
                   progress:(nullable void (^)(NSProgress * _Nonnull downloadProgress))downloadProgress
          completionHandler:(nullable void (^)(NSString * _Nonnull filePath , NSError * _Nonnull error))completion;

//暂停下载
+(void)pauseDownLoadWithURL:(nullable NSString*)urlString;
//恢复下载
+(void)reuseDownLoadWithURL:(nullable NSString *)urlString;


#pragma mark  -- 上传 （）

+(NSURLSessionDataTask *)uploadImageWithUrlString:(nullable NSString *)urlString
                                       parameters:(nullable id)parameters
                                            files:(nullable NSArray*)files
                                             name:(nullable NSArray*)names
                                         fileName:(nullable NSArray*)fileNames
                                         mimeType:(nullable NSArray*)mimeTypes
                                         progress:(nullable void (^)(NSProgress *_Nonnull downloadProgress))uploadProgress
                                          success:(nullable AFNSuccessBlock)success
                                          failure:(nullable AFNErrorBlock)failure;

@end
