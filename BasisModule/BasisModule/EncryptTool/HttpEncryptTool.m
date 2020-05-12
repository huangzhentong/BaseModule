//
//  HttpEncryptTool.m
//  MagicBabyAppClient
//
//  Created by 庄小先生丶 on 16/9/13.
//  Copyright © 2016年 庄小先生丶. All rights reserved.
//

#import "HttpEncryptTool.h"
#import "AESCbc.h"
#import "NSString+ZLKExtend.h"
#import "OpenUDID.h"
#import "JSONKit.h"
#import "PublicDefine.h"


@implementation HttpEncryptTool
+(NSDictionary*)encodingJsonNetworkDataWithFunction:(NSString*)uniqueFunction
                                                uniqueToken:(NSString*)uniqueToken
                                                  inputData:(NSDictionary*)inputData
                                                     expand:(NSDictionary*)expand
                                                  timestamp:(NSString *)timestamp
{
    if(expand==nil)
        expand=[NSMutableDictionary dictionary];
    else
        expand=[NSMutableDictionary dictionaryWithDictionary:expand];
    inputData=[NSMutableDictionary dictionaryWithDictionary:inputData];
    
    NSString *random=[[[NSString generateGUID] stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];;
    
    NSString* uniqueData=[self uniqueData:timestamp random:random];
    NSMutableDictionary *encryptBody=[NSMutableDictionary dictionary];
    [encryptBody setObject:uniqueFunction forKey:@"unique_function"];
    [encryptBody setObject:uniqueData forKey:@"unique_data"];
    [encryptBody setObject:uniqueToken forKey:@"unique_token"];
    if(inputData.allKeys.count>0){
        [encryptBody setObject:inputData forKey:@"input_data"];
    }
    NSError *error;
    NSString *encryptBodyJsonString=[encryptBody JSONStringWithOptions:JKSerializeOptionNone error:&error] ;
    NSString *encryptBodyEncrypt=[NSData encrypt:encryptBodyJsonString];
    NSString *expandJsonString=@"";
//    if(expand.allKeys.count>0)
    {
        expandJsonString= [expand JSONStringWithOptions:JKSerializeOptionNone error:nil] ;
    }
    
    
    NSLog(@"<==========Request Json Dara============>:%@\n%@\n=================================>",encryptBodyJsonString,expandJsonString);
    NSMutableString *uniqKeyStr=[NSMutableString stringWithFormat:@"%@&%@&%@",encryptBodyEncrypt,expandJsonString,APP_SYSTEM_NETWORK_REQUEST_PHONE_API_KEY];
    NSArray *base36CodeArray=[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z", nil];
    NSString *base36Code=@"";
    for(int x=0;x<15;x++){
        base36Code=[base36Code stringByAppendingString:base36CodeArray[arc4random_uniform(36)]];
    }
    uniqKeyStr= [NSMutableString stringWithString: uniqKeyStr.md5_32Lower] ;
    [uniqKeyStr insertString:[base36Code substringWithRange:NSMakeRange(0,5)] atIndex:10];
    [uniqKeyStr insertString:[base36Code substringWithRange:NSMakeRange(5,5)] atIndex:25];
    [uniqKeyStr insertString:[base36Code substringWithRange:NSMakeRange(10,5)] atIndex:40];
    NSMutableDictionary *body=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               encryptBodyEncrypt,
                               @"encrypt",
                               expandJsonString,
                               @"expand",
                               uniqKeyStr,
                               @"sign",
                               nil];

    return body;
    
}
+(NSString *)uniqueData:(NSString*)timestamp random:(NSString*)random //返回数据串
{
    return [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@",
            APP_SYSTEM_USER_ID.length>0?APP_SYSTEM_USER_ID:@"0" ,//用户编号
            APP_SYSTEM_APP_VERSIONSTRING,   //应用版本
            timestamp,       //时间戳
            [self openUDID],     //设备码
            APP_SYSTEM_REQUEST_ID,
            random];     //系统编号
}
//获取设备ID
+(NSString*)openUDID
{
    NSString *UDIDValue=[[OpenUDID value]stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return UDIDValue;
}


@end
