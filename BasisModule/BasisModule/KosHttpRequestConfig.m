//
//  KosHttpRequestConfig.m
//  BasisModule
//
//  Created by KT--stc08 on 2018/7/12.
//  Copyright © 2018年 huang. All rights reserved.
//

#import "KosHttpRequestConfig.h"
#import <UIKit/UIKit.h>
#import "RSA.h"
static NSString * const  publicKeyBase64 = @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoZ7Z0ElA/FNVmy2eCcKQUyR7bGcgakVvqj/gv1Lyc2vgZGeWadcp7cS8Hr4M1zy0lYRSsZjC3N1Hj9g7eL5gi0kWiR3xJ6vcjtnmqiOrZqCIcIxIEDt51uHacdCqAqSh2N6rxRe9z3B4p9YhYlEIsdzXTBtLZxOdcbhKfH3bze2TOLGeMgxE1lkzY89NgUooGWACuEHJdS8zANogdtM+dCfeBj0YI4zJ3rOxVs6w7+yBM0a/eBP2pbhiSam19EjMjLA3YduIBXJg8nGKvVcJS8t70F/w7XC0L8esd27IW1TLf/DoVZGdT629QBZwYAJ0eCS2Ieb1LHi6oc8kmnh6CQIDAQAB";
#define UUID  [UIDevice currentDevice].identifierForVendor.UUIDString

#define publickEncryptedString  [RSA encryptString:UUID publicKey:publicKeyBase64];
@implementation KosHttpRequestConfig
-(NSMutableDictionary*)headerFile
{
NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"Content-type"]=@"application/json";

    NSString *session  = @"";
    if (session == nil) {
        session = @"";
    }
     dic[@"User-Agent"] = @"";
    NSString *UDIDValue=@"";
    dic[@"processCode"] = UDIDValue;
    dic[@"KosLang"] = @"";

     dic[@"Cookie"] = [NSString stringWithFormat:@"mer=%@;SESSION=%@",session,session];
    

    return dic;
}

+(void)load
{
    [HHttpRequestConfigManager addDelegate:[KosHttpRequestConfig new]];
}
@end
