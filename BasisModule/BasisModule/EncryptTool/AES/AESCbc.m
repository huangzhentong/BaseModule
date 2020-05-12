//
//  AESCbc.m
//  MagicBabyAppClient
//
//  Created by 庄小先生丶 on 15/7/6.
//  Copyright (c) 2015年 庄小先生丶. All rights reserved.
//

#import "AESCbc.h"
#import "CommonCrypto/CommonCrypto.h"
#import "NSString+ZLKExtend.h"
#import "AESCbc.h"
#import "NSData+base64Encoding.h"
#import "PublicDefine.h"
#define aes128CbcCryptingKey APP_SYSTEM_NETWORK_REQUEST_AES_KEY  /// 同上
@implementation NSData(AES128CBC)


+(NSString*)encrypt:(NSString*)code
{
    NSString *key=aes128CbcCryptingKey.md5_32Lower;
    NSString *newKey=[key substringWithRange:NSMakeRange(0,16)];
    NSString *iv=[key substringWithRange:NSMakeRange(16,16)];
    
    NSData *data = [code dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encrypt = [NSData AES128EncryptWithKey:newKey withData:data iv:iv];
    return [encrypt base64EncodingWithSafeUrl];

    
}

+(NSString*)decrypt:(NSString*)code
{
    NSString *key=aes128CbcCryptingKey.md5_32Lower;
    NSString *newKey=[key substringWithRange:NSMakeRange(0,16)];
    NSString *iv=[key substringWithRange:NSMakeRange(16,16)];
    
    NSData* data=[NSData dataWithBase64EncodedWithSafeUrlString:code];
    NSData *decrypt = [NSData AES128DecryptWithKey:newKey withData:data iv:iv];
    return [[NSString alloc] initWithData:decrypt encoding:NSUTF8StringEncoding];
}



+ (NSData *)AES128EncryptWithKey:(NSString *)key withData:(NSData*)_data iv:(NSString *) iv
{
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof( keyPtr ) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [_data length];
    
    int diff = kCCKeySizeAES128 - (dataLength % kCCKeySizeAES128);
    unsigned long int newSize = 0;
    
    //    if(diff > 0)
    //    {
    newSize = dataLength + diff;
    //    }
    
    char dataPtr[newSize];
    memcpy(dataPtr, [_data bytes], [_data length]);
    for(int i = 0; i < diff; i++)
    {
        dataPtr[i + dataLength] = 0x00;
    }
    
    size_t bufferSize = newSize + kCCBlockSizeAES128;
    
    void *buffer = malloc( bufferSize );
    memset(buffer, 0, bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt( kCCEncrypt, kCCAlgorithmAES128, 0x0000,
                                          keyPtr, kCCKeySizeAES128,
                                          ivPtr,
                                          dataPtr,
                                          sizeof(dataPtr),
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted );
    if( cryptStatus == kCCSuccess )
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free( buffer ); //free the buffer
    return nil;
}

+ (NSData *)AES128DecryptWithKey:(NSString *)key withData:(NSData*)data iv:(NSString *) iv
{
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,  0x0000,
                                          keyPtr, kCCBlockSizeAES128,
                                          ivPtr,
                                          [data bytes],
                                          dataLength,
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}


@end
