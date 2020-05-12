//
//  NSString+ZLKStringTool.m
//  WeLove App Client
//
//  Created by 庄庄庄丶 on 14-1-26.
//  Copyright (c) 2014年 庄小先生丶. All rights reserved.
//

#import "NSString+ZLKExtend.h"
#import <CommonCrypto/CommonDigest.h>
#import "JSONKit.h"
#import "NSData+base64Encoding.h"
#import "AESCbc.h"

@implementation NSString (ZLKExtend)

- (NSString *)trimWhitespaceAndReaptAllTrim:(BOOL)reaptAllTrim
{
    NSString *str=[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(reaptAllTrim)
    [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    return str;
}
/*
 *  时间戳对应的NSDate
 */
-(NSDate *)timestamp{
    
    NSTimeInterval timeInterval=self.floatValue;
    
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

+(NSString *)getDistanceFromString:(NSString*)str
{
    NSString *strDis;
    double di=[str doubleValue];
    if(di<1000)
    {
        strDis=[NSString stringWithFormat:@"%.0fm",di];
    }else
    {
        
        strDis=[NSString stringWithFormat:@"%1.1fkm",di/1000];
    }
    
    return strDis;
}

/**
 *  32位MD5加密 大写
 */
-(NSString *)md5_32Upper{
    
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    NSString *mdfiveString = [result uppercaseString];
    return mdfiveString;
}


/**
 *  32位MD5加密 大写
 */
-(NSString *)md5_32Lower{
    
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    NSString *mdfiveString = [result lowercaseString];
    return mdfiveString;
}
/**
 *  AES加密
 */
-(NSString *)aesEnrypt
{
    return [NSData encrypt:self];
}

/**
 *  AES解密
 */
-(NSString *)aesDerypt
{
    return [NSData decrypt:self];
}

-(NSData*)base64Decoding
{
    
   return [NSData dataWithBase64EncodedString:self];
}


-(id)jsonEncoding
{
    NSError *error;
    NSString *json_string=[self stringByReplacingOccurrencesOfString:@"\'"withString:@"'"];
    json_string=[json_string stringByReplacingOccurrencesOfString:@"\\'"withString:@"'"];
    json_string=[json_string stringByReplacingOccurrencesOfString:@"\r"withString:@"\\r"];
    json_string=[json_string stringByReplacingOccurrencesOfString:@"\n"withString:@"\\n"];
    json_string=[json_string stringByReplacingOccurrencesOfString:@"\t"withString:@"\\t"];
    json_string=[json_string stringByReplacingOccurrencesOfString:@"\v"withString:@"\\v"];
    json_string=[json_string stringByReplacingOccurrencesOfString:@"\f"withString:@"\\f"];
    json_string=[json_string stringByReplacingOccurrencesOfString:@"\b"withString:@"\\b"];
    json_string=[json_string stringByReplacingOccurrencesOfString:@"\a"withString:@"\\a"];
    json_string=[json_string stringByReplacingOccurrencesOfString:@"\e"withString:@"\\e"];
    NSData* jsonData = [json_string dataUsingEncoding:NSUTF8StringEncoding];
    id _Json = [jsonData mutableObjectFromJSONDataWithParseOptions:JKParseOptionValidFlags error:&error ];
    
    if(error) return nil;
    
    return _Json;
}
/**
 *  SHA1加密
 */
-(NSString *)sha1_Upper
{
    
    const char *cStr = [self UTF8String];
    NSData *data = [NSData dataWithBytes:cStr length:self.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    NSString *sha1=[result uppercaseString];
    return sha1;
}
/**
 *  SHA1加密
 */
-(NSString *)sha1_Lower
{
    const char *cStr = [self UTF8String];
    NSData *data = [NSData dataWithBytes:cStr length:self.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    NSString *sha1=[result lowercaseString];
    return sha1;
}


+(NSString*)changeStringToLM:(NSString*)str;//将文字中打星号处理
{
    //    if([str isEqualToString:[UserRememberInfo getUserRememberInfo].Nickname])
    //    {
    //        return str;
    //    }
    NSMutableString *tmpName=[NSMutableString stringWithString:str];
    [tmpName insertString:@"***" atIndex:1];
    [tmpName deleteCharactersInRange: NSMakeRange(4, tmpName.length-4>3?3:1)];
    return  tmpName;
}

//判断是否为纯数字
+(BOOL)isPureIntOrFloat:(NSString*)numStr
{
    NSScanner* intScan = [NSScanner scannerWithString:numStr];
    int val1;
    BOOL intScanVal=[intScan scanInt:&val1] && [intScan isAtEnd];
    if(!intScanVal) return NO;
    
    float val2;
    NSScanner* floatScan = [NSScanner scannerWithString:numStr];
    BOOL floatScanVal=[floatScan scanFloat:&val2] && [floatScan isAtEnd];
    if(!floatScanVal) return NO;
    
    return YES;
}



/*
 *  document根文件夹
 */
+(NSString *)documentFolder{
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}



/*
 *  caches根文件夹
 */
+(NSString *)cachesFolder{
    
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}


-(CGSize)boundingRectWithSize:(CGSize)maxSize
                     fontSize:(CGFloat)fontSize
                     lineMode:(NSLineBreakMode)lineMode
{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode=lineMode;
    
    CGSize size =[self boundingRectWithSize:maxSize
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}
                                    context:nil].size;
    return size;
}

/*
 计算字符串大小
 */
-(CGSize)boundingRectWithSize:(CGSize)maxSize
                     fontSize:(CGFloat)fontSize
                     lineMode:(NSLineBreakMode)lineMode
                    spaceSize:(CGFloat)spaceSize
{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode=lineMode;
    if(spaceSize>0)
        paragraphStyle.lineSpacing=spaceSize;
    
    CGSize size =[self boundingRectWithSize:maxSize
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}
                                    context:nil].size;
    return size;
}
/*
 计算字符串大小 带行间距和字间距计算
 */
-(CGSize)boundingRectWithSpaceLabelSize:(CGSize)maxSize
                               fontSize:(CGFloat)fontSize
                               lineMode:(NSLineBreakMode)lineMode
                              spaceSize:(CGFloat)spaceSize
                          wordSpaceSize:(CGFloat)wordSpaceSize
{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode=lineMode;
    paragraphStyle.lineSpacing=spaceSize;
    
//    paragraphStyle.hyphenationFactor = 1.0;
//    paragraphStyle.firstLineHeadIndent = 0.0;
//    paragraphStyle.paragraphSpacingBefore = 0.0;
//    paragraphStyle.headIndent = 0;
//    paragraphStyle.tailIndent = 0;
    
    
    CGSize size =[self boundingRectWithSize:maxSize
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{
                                              NSParagraphStyleAttributeName:paragraphStyle,
                                              NSFontAttributeName: [UIFont systemFontOfSize:fontSize],
                                              NSKernAttributeName:[NSNumber numberWithFloat:wordSpaceSize]
                                              }
                                    context:nil].size;
    return size;
}



/**
 *  生成子文件夹
 *
 *  如果子文件夹不存在，则直接创建；如果已经存在，则直接返回
 *
 *  @param subFolder 子文件夹名
 *
 *  @return 文件夹路径
 */
-(NSString *)createSubFolder:(NSString *)subFolder{
    
    NSString *subFolderPath=[NSString stringWithFormat:@"%@/%@",self,subFolder];
    
    BOOL isDir = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL existed = [fileManager fileExistsAtPath:subFolderPath isDirectory:&isDir];
    
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:subFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return subFolderPath;
}

-(NSString*)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

}

-(UIImage *) base64ToImage{
    UIImage *image = [UIImage imageWithData:[NSData dataWithBase64EncodedString:self]];
    return image;
}


+(NSString *)generateGUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    
    return uuidString ;
}

+(NSString *)notRounding:(float)price
              afterPoint:(int)position
            roundingMode:(NSRoundingMode)roundingMode
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

@end
