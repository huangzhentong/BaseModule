//
//  NSString+ZLKStringTool.h
//  WeLove App Client
//
//  Created by 庄庄庄丶 on 14-1-26.
//  Copyright (c) 2014年 庄小先生丶. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (ZLKExtend)
- (NSString *)trimWhitespaceAndReaptAllTrim:(BOOL)reaptAllTrim;


/*
 *  时间戳对应的NSDate
 */
@property (nonatomic,strong,readonly) NSDate *timestamp;
/**
 *  32位MD5加密大写
 */
@property (nonatomic,copy,readonly) NSString *md5_32Upper;
/**
 *  32位MD5加密小写
 */
@property (nonatomic,copy,readonly) NSString *md5_32Lower;
/**
 *  AES加密
 */
@property (nonatomic,copy,readonly) NSString *aesEnrypt;
/**
 *  AES解密
 */
@property (nonatomic,copy,readonly) NSString *aesDerypt;
/**
 *  字符串Base64转字节流
 */
@property(nonatomic,copy,readonly) NSData *base64Decoding;
/**
 *  字符串转JSON
 */
@property(nonatomic,copy,readonly) id jsonEncoding;

/**
 *  SHA1加密大写
 */
@property (nonatomic,copy,readonly) NSString *sha1_Upper;

/**
 *  SHA1加密小写
 */
@property (nonatomic,copy,readonly) NSString *sha1_Lower;

+(NSString*)changeStringToLM:(NSString*)str;//将文字中打星号处理


//判断是否为纯数字
+(BOOL)isPureIntOrFloat:(NSString*)numStr;

/*
 *  document根文件夹
 */
+(NSString *)documentFolder;


/*
 *  caches根文件夹
 */
+(NSString *)cachesFolder;

/*
 计算字符串大小 单行
 */
-(CGSize)boundingRectWithSize:(CGSize)maxSize
                     fontSize:(CGFloat)fontSize
                     lineMode:(NSLineBreakMode)lineMode;

/*
 计算字符串大小 带行间距
 */
-(CGSize)boundingRectWithSize:(CGSize)maxSize
                     fontSize:(CGFloat)fontSize
                     lineMode:(NSLineBreakMode)lineMode
                    spaceSize:(CGFloat)spaceSize;
/*
 计算字符串大小 带行间距和字间距计算
 */
-(CGSize)boundingRectWithSpaceLabelSize:(CGSize)maxSize
                               fontSize:(CGFloat)fontSize
                               lineMode:(NSLineBreakMode)lineMode
                              spaceSize:(CGFloat)spaceSize
                          wordSpaceSize:(CGFloat)wordSpaceSize;


//从字符串中获取距离
+(NSString *)getDistanceFromString:(NSString*)str;
/**
 *  生成子文件夹
 *
 *  如果子文件夹不存在，则直接创建；如果已经存在，则直接返回
 *
 *  @param subFolder 子文件夹名
 *
 *  @return 文件夹路径
 */
-(NSString *)createSubFolder:(NSString *)subFolder;


-(NSString*)trim;


-(UIImage *)base64ToImage;

+(NSString *)generateGUID;

//设置小数点位数
+(NSString *)notRounding:(float)price
              afterPoint:(int)position
            roundingMode:(NSRoundingMode)roundingMode;

@end
