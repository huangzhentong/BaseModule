//
//  BaseClient.m
//  BasisModule
//
//  Created by huang on 2016/11/4.
//  Copyright © 2016年 huang. All rights reserved.
//

#import "BaseClient.h"

#import "RequestModelManager.h"
#import "BaseRouterManager.h"
@interface BaseClient ()
{
    NSURLSessionDataTask* _dataTask;
}
@property(nonatomic,copy)NSString *requestURL;

@end

@implementation BaseClient

static NSString *baseURL=nil;

static HHttpRequestSerializer generalSerializer = HHttpRequestSerializerJSON;

static NSInteger commonTimeOut = 30;

+(void)setBaseURL:(NSString*)url
{
    baseURL = [url copy];
}
//设置通用serializer
+(void)setGeneralSerializer:(HHttpRequestSerializer)serializer
{
    generalSerializer = serializer;
}
//设置通用的超时时间
+(void)setClientTimeOutInterval:(NSInteger)timeOut
{
    if (timeOut <= 0) {
        commonTimeOut = 30;
    }
    else if (timeOut > 60)
    {
        commonTimeOut = 60;
    }
    else {
        commonTimeOut = timeOut;
    }
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        self.baseUrl = baseURL?:BASE_URL;
        self.requestType=HttpRequestUrlType_Post;
        self.generalLogic = true;
        self.serializer = generalSerializer;
        self.timeOutInterval = commonTimeOut;
    }
    return self;
}
-(NSString*)requestURL
{
    return [NSString stringWithFormat:@"%@%@",self.baseUrl,self.url?:@""];
}
-(void)dealloc
{
    
}

-(NSDictionary*)dictionaryWithModel{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (self.baseUrl) {
        dic[ClientUrl]=self.requestURL;
    }
    else
    {
        dic[ClientUrl]=self.url?:@"";
    }
    
    dic[ClientParameters] = self.parameters?:@{};
    if (self.type==nil) {
        switch (self.requestType) {
            case HttpRequestUrlType_Post:
            {
                self.type=@"post";
            }
                break;
            case HttpRequestUrlType_Get:
            {
                self.type=@"get";
            }
                break;
            case HttpRequestUrlType_Put:
            {
                self.type=@"put";
            }
                break;
            case HttpRequestUrlType_Patch:
            {
                self.type=@"patch";
            }
                break;
            case HttpRequestUrlType_Delete:
            {
                self.type=@"delete";
            }
                break;
                
            default:
            {
                self.type=@"post";
            }
                break;
        }
    }
    dic[ClientRequestSerializer] = @(self.serializer);
    dic[ClientType] = self.type?:@"post";
    dic[ClientTimeOutInterval] = @(self.timeOutInterval);
    if (self.progress) {
        dic[ClientProgress] = self.progress;
    }
    if (self.headers) {
        dic[ClientHeaders] = self.headers;
    }
    return dic;
    
}
-(NSString*)description
{
    return  [NSString stringWithFormat:@"%@",[self dictionaryWithModel] ];
}
//发起请求
-(void)request:(void(^)(id result))completion
{
    
    [self request:completion withFailure:nil];
}
-(void)request:(void(^)(id result))completion withFailure:(void(^)(NSError *error))failure
{
    
    [self requestStart];
    NSDictionary *dic = [self dictionaryWithModel];
    _dataTask =  [BaseRouterManager requestWithDic:dic withBlock:^(id result) {
        
        id nresult = result;
        NSError *error = nil;
        if(self.isGeneralLogic)
        {
            id<RequestModelDelegate> delegate = self.delegate ? :[RequestModelManager delegate];
            if (delegate && [delegate respondsToSelector:@selector(requestLogicDispose: withClass:)]) {
                nresult =  [delegate requestLogicDispose:result withClass:self.modelClass];
            }
        }
        
        
        if (([nresult isKindOfClass:[NSError class]])) {
            error = nresult;
            nresult = nil;
            if (failure) {
                failure(error);
            }
        }
        else
        {
            error = nil;
            
            if (completion) {
                completion(nresult);
            }
        }
        [self requestComplete:nresult withError:error];
    }];
    
}



-(void)requestStart
{
    if(self.startBlock)
    {
        self.startBlock();
    }
    if (self.isGeneralLogic) {
        id<RequestModelDelegate> delegate = self.delegate ? :[RequestModelManager delegate];
        if (delegate && [delegate respondsToSelector:@selector(requestWillStart)]) {
            [delegate requestWillStart];
        }
    }
  
}
-(void)requestComplete:(id)reslut withError:(NSError *)error;
{
    if (self.completeBlock) {
        self.completeBlock(reslut, error);
    }
    if (self.isGeneralLogic) {
        
        
        id<RequestModelDelegate> delegate = self.delegate ? :[RequestModelManager delegate];
        if (delegate && [delegate respondsToSelector:@selector(requestComplete:withError:)]) {
            [delegate requestComplete:reslut withError:error];
        }
    }
}

-(NSURLSessionDataTask*)dataTask
{
    return _dataTask;
}

-(BOOL)isRequesting
{
    if (self.dataTask.state == NSURLSessionTaskStateRunning)
        return true;
    return false;
}


/**
 判断是否请求中
 
 @param url 完整的URL
 @return YES表示请求中，NO表示未请求
 */
+(BOOL)isRequestingWithURL:(NSString*)url
{
    if ([url rangeOfString:@"http"].location !=NSNotFound) {
        url = [NSString stringWithFormat:@"%@%@",baseURL,url];
    }
    return [BaseRouterManager isRequestingWithURL:url];
    
    
}
//取消请法庭
+(void)cancelRequestURL:(NSString *)url
{
    BaseClient *base=[BaseClient new];
    if ([url rangeOfString:@"http"].location !=NSNotFound) {
        base.baseUrl=@"";
    }
    base.url=url;
    base.type=@"cancel";
    [base request:nil];
    
}
@end

