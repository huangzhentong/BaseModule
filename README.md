#BaseModuel

1.1.1版本添加了两上管理类
1。RequestModelManager 用于管理请求开始，结束，请求后数据处理。
2。HHttpRequestConfigManager 用于管理请求头部及请求的数据类型

用法如下

-----------------------------------------------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "HHttpRequestConfigManager.h"
@interface KosHttpRequestConfig : NSObject<HHttpRequestConfigDelegate>

@end

-----------------------------------------------------------------------------------------------------
#import "KosHttpRequestConfig.h"
#import <UIKit/UIKit.h>
#import "RSA.h"
static NSString * const  publicKeyBase64 = @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoZ7Z0ElA/FNVmy2eCcKQUyR7bGcgakVvqj/gv1Lyc2vgZGeWadcp7cS8Hr4M1zy0lYRSsZjC3N1Hj9g7eL5gi0kWiR3xJ6vcjtnmqiOrZqCIcIxIEDt51uHacdCqAqSh2N6rxRe9z3B4p9YhYlEIsdzXTBtLZxOdcbhKfH3bze2TOLGeMgxE1lkzY89NgUooGWACuEHJdS8zANogdtM+dCfeBj0YI4zJ3rOxVs6w7+yBM0a/eBP2pbhiSam19EjMjLA3YduIBXJg8nGKvVcJS8t70F/w7XC0L8esd27IW1TLf/DoVZGdT629QBZwYAJ0eCS2Ieb1LHi6oc8kmnh6CQIDAQAB";
#define UUID  [UIDevice currentDevice].identifierForVendor.UUIDString

#define publickEncryptedString  [RSA encryptString:UUID publicKey:publicKeyBase64];
@implementation KosHttpRequestConfig
//设置请求头
-(NSMutableDictionary*)headerFile
{
NSMutableDictionary *dic = [NSMutableDictionary dictionary];
dic[@"Content-type"]=@"application/json";
dic[@"processCode"]= publickEncryptedString;
dic[@"Cookie"] = [NSString stringWithFormat:@"SESSION=%@",@""];
return dic;
}
//设置请求类型
-(HHttpRequestSerializer)type
{
return HHttpRequestSerializerJSON;
}
//添加到管理器中使用
+(void)load
{
[HHttpRequestConfigManager setDelegate:[KosHttpRequestConfig new]];
}
@end

-----------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "RequestModelManager.h"
@interface HttpRequestDisponse : NSObject<RequestModelDelegate>

@end

-----------------------------------------------------------------------------------------------------
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
NSLog(@"result = %@ | Error =%@",result,error);
}
//请求结束逻辑处理,返回数据处理结果
-(id)requestLogicDispose:(id)dict
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
else if([dict[@"code"] intValue]!=300)
{
NSError *error  = [NSError errorWithDomain:dict[@"msg"] code:[dict[@"code"] intValue] userInfo:nil];
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
