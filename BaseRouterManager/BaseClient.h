//
//  BaseClient.h
//  BasisModule
//
//  Created by huang on 2016/11/4.
//  Copyright © 2016年 huang. All rights reserved.
//

#import <Foundation/Foundation.h>


#ifndef DEBUG_URL
#define DEBUG_URL @"http://test.star-fans.com:8000/"
#endif

#ifndef RELEASE_URL
#define RELEASE_URL @"http://test.star-fans.com:8000/"
#endif

#if DEBUG
#define BASE_URL DEBUG_URL
#else
#define BASE_URL RELEASE_URL
#endif

#import "RouterDefine.h"

typedef void(^ReqeustWillStart)();
typedef void(^ReqeustComplete)(id request,NSError *error);
typedef void(^RequestProgressBlock)(NSProgress *progress);
@protocol RequestModelDelegate;
typedef NS_ENUM(NSInteger, HttpRequestUrlType)
{
    HttpRequestUrlType_Post,
    HttpRequestUrlType_Get,
    HttpRequestUrlType_Put,
    HttpRequestUrlType_Delete,
    HttpRequestUrlType_Patch,
};


@interface BaseClient : NSObject
@property(nonatomic,copy)NSString *baseUrl;                     //基础URL.
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)id parameters;                         //参数
@property(nonatomic,copy)NSString *type;                        //默认post 总的为6类，post,get ,put,delete,patch,cancel
@property(nonatomic)HttpRequestUrlType requestType;             //请求类型，默认HttpRequestUrlType_Post
@property(nonatomic)BOOL isCache;                               //是否缓存
@property(nonatomic,copy)void(^progress)(NSProgress *progress); //进度
@property(nonatomic,copy)ReqeustWillStart startBlock;           //开始请求
@property(nonatomic,copy)ReqeustComplete completeBlock;           //开始请求
@property(nonatomic,weak)id<RequestModelDelegate> delegate;
@property(nonatomic)Class modelClass;                             //需要转换的模型
@property(nonatomic,copy)NSDictionary *headers;                   //请求头
@property(nonatomic,strong,readonly)NSURLSessionDataTask* dataTask;
@property(nonatomic,getter=isGeneralLogic)BOOL generalLogic;                             //是否使用通用逻辑 默认为true
-(NSDictionary*)dictionaryWithModel;
-(NSString*)requestURL;
//清求事件
-(void)request:(void(^)(id result))completion;
-(void)request:(void(^)(id result))completion withFailure:(void(^)(NSError *error))fail;
//判断是否请求中
-(BOOL)isRequesting;
-(void)requestStart;
-(void)requestComplete:(id)reslut withError:(NSError *)error;
/**
 判断是否请求中
 
 @param url 完整的URL
 @return YES表示请求中，NO表示未请求
 */
+(BOOL)isRequestingWithURL:(NSString*)url;




////请求完成后处理 （因不同后台对code定议不同）
////可用cagetory 来重写 自己处理里面的逻辑
//-(id )requestEndLogic:(id)dict;

/**
 设置最基础的URL
 
 @param url url
 */
+(void)setBaseURL:(NSString*)url;
//取消请求

+(void)cancelRequestURL:(NSString *)url;

@end

