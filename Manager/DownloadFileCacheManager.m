//
//  DownloadFileCaheManager.m
//  BasisModule
//
//  Created by KT--stc08 on 2020/5/29.
//  Copyright © 2020 huang. All rights reserved.
//

#import "DownloadFileCacheManager.h"
#include <objc/runtime.h>

NSString * const DownloadResumeDataLength = @"bytes=%ld-";
NSString * const DownloadHttpFieldRange = @"Range";
NSString * const DownloadKeyDownloadURL = @"NSURLSessionDownloadURL";
NSString * const DownloadTempFilePath = @"NSURLSessionResumeInfoLocalPath";
NSString * const DownloadKeyBytesReceived = @"NSURLSessionResumeBytesReceived";
NSString * const DownloadKeyCurrentRequest = @"NSURLSessionResumeCurrentRequest";
NSString * const DownloadKeyTempFileName = @"NSURLSessionResumeInfoTempFileName";

@interface DownloadFileCacheManager ()
{
    
}
@property(nonatomic,strong)NSFileManager *fileManager;
@property(nonatomic,strong)NSMutableDictionary *cacheDic;
@end

@implementation DownloadFileCacheManager
+(instancetype)shareInstance
{
    static DownloadFileCacheManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [DownloadFileCacheManager new];
    });
    return manager;
}

-(NSMutableDictionary*)cacheDic
{
    if (!_cacheDic) {
        _cacheDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _cacheDic;
}

-(NSFileManager*)fileManager
{
    if (!_fileManager) {
        _fileManager = [[NSFileManager alloc] init];
    }
    return _fileManager;
}

-(NSString*)tmpChchePathWithDownloadURL:(NSString*)url
{
    return  self.cacheDic[url];
}

+(NSString*)tmpChchePathWithDownloadURL:(NSString*)url
{
    return [[self shareInstance] tmpChchePathWithDownloadURL:url];
}

+(NSInteger)fileSizeWithTmpPathURL:(NSString*)downloadUrl
{
    NSString *tmpPath =  [self tmpChchePathWithDownloadURL:downloadUrl];
    if (tmpPath == nil) {
        return 0;
    }
    tmpPath =  [NSTemporaryDirectory() stringByAppendingPathComponent:tmpPath];
    return [[self shareInstance] fileSizeWithPath:tmpPath];
}
//获取文件大小

-(NSInteger)fileSizeWithPath:(NSString *)path {
    NSInteger fileLength = 0;
   
    if ([self.fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [self.fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileLength = [fileDict fileSize];
        }
    }
    return fileLength;
}


//获取临时文件数据
+(NSData*)tmpCacheDataWithDownloadURL:(NSString*)downloadUrl
{
    NSString *tmpName =  [self tmpChchePathWithDownloadURL:downloadUrl];
    if (tmpName == nil) {
        return nil;
    }
    NSString* tmpPath =  [NSTemporaryDirectory() stringByAppendingPathComponent:tmpName];
    
    NSData *resultData = nil;
  
    NSData *tempCacheData = [NSData dataWithContentsOfFile:tmpPath];
        
        if (tempCacheData && tempCacheData.length > 0) {
            NSMutableDictionary *resumeDataDict = [NSMutableDictionary dictionaryWithCapacity:0];
            NSMutableURLRequest *newResumeRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:downloadUrl]];
            [newResumeRequest addValue:[NSString stringWithFormat:DownloadResumeDataLength,(long)(tempCacheData.length)] forHTTPHeaderField:DownloadHttpFieldRange];
            NSData *newResumeRequestData = [NSKeyedArchiver archivedDataWithRootObject:newResumeRequest];
            [resumeDataDict setObject:@(tempCacheData.length) forKey:DownloadKeyBytesReceived];
            [resumeDataDict setObject:newResumeRequestData forKey:DownloadKeyCurrentRequest];
            [resumeDataDict setObject:tmpName forKey:DownloadKeyTempFileName];
            [resumeDataDict setObject:downloadUrl forKey:DownloadKeyDownloadURL];
            [resumeDataDict setObject:tmpPath forKey:DownloadTempFilePath];
            resultData = [NSPropertyListSerialization dataWithPropertyList:resumeDataDict format:NSPropertyListBinaryFormat_v1_0 options:NSPropertyListImmutable error:nil];
        }

    return resultData;
}

+(void)saveDownLoadTaskData:(NSURLSessionDownloadTask*)downloadTask
{
    if(downloadTask == nil)
    {
        return;
    }
    else{
        NSString *tmpPath = [self tempCacheFileNameForTask:downloadTask];
        
        NSString *downloadURL = [[[downloadTask currentRequest] URL] absoluteString];
        //保存数据
        NSLog(@"tmpPath =%@,downloadURL=%@",tmpPath,downloadURL);
        [[[self shareInstance] cacheDic] setValue:tmpPath forKey:downloadURL];

    }
}

NSString * const DownloadFileProperty = @"downloadFile";
NSString * const DownloadPathProperty = @"path";
+ (NSString *)tempCacheFileNameForTask:(NSURLSessionDownloadTask *)downloadTask
{
    NSString *resultFileName = nil;
    //拉取属性
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([downloadTask class], &outCount);
    for (i = 0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        
        NSLog(@"proertyName : %@", propertyName);
        
        if ([DownloadFileProperty isEqualToString:propertyName]) {
            id propertyValue = [downloadTask valueForKey:(NSString *)propertyName];
            unsigned int downloadFileoutCount, downloadFileIndex;
            objc_property_t *downloadFileproperties = class_copyPropertyList([propertyValue class], &downloadFileoutCount);
            for (downloadFileIndex = 0; downloadFileIndex < downloadFileoutCount; downloadFileIndex++) {
                objc_property_t downloadFileproperty = downloadFileproperties[downloadFileIndex];
                const char* downloadFilechar_f = property_getName(downloadFileproperty);
                NSString *downloadFilepropertyName = [NSString stringWithUTF8String:downloadFilechar_f];
                
                NSLog(@"downloadFilepropertyName : %@", downloadFilepropertyName);
                
                if([DownloadPathProperty isEqualToString:downloadFilepropertyName]){
                    id downloadFilepropertyValue = [propertyValue valueForKey:(NSString *)downloadFilepropertyName];
                    if(downloadFilepropertyValue){
                        resultFileName = [downloadFilepropertyValue lastPathComponent];
                        //应在此处存储缓存文件名
                        //......
                        NSLog(@"broken down temp cache path : %@", resultFileName);
                    }
                    break;
                }
            }
            free(downloadFileproperties);
        }else {
            continue;
        }
    }
    free(properties);
    
    return resultFileName;
}


@end
