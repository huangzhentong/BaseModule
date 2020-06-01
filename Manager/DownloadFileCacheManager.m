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

NSString * const DownloadFileURLKey = @"downloadCache.plist";

@interface DownloadFileCacheManager ()
{
    
}
@property(nonatomic,strong)NSFileManager *fileManager;
@property(nonatomic,strong)NSMutableDictionary *cacheDic;
@property(nonatomic,copy)NSString *downloadFileURL;                     //缓存文件地址
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
-(NSString*)downloadFileURL
{
    if (!_downloadFileURL) {
        NSString *cachePath =  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        _downloadFileURL = [cachePath stringByAppendingPathComponent:DownloadFileURLKey];
    }
    return _downloadFileURL;
}

-(NSMutableDictionary*)cacheDic
{
    if (!_cacheDic) {
        _cacheDic =  [NSMutableDictionary dictionaryWithContentsOfFile:self.downloadFileURL];
        if (_cacheDic == nil) {
            _cacheDic = [NSMutableDictionary dictionaryWithCapacity:0];
        }
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
//获取tmp文件名
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


//获取缓存列表


-(NSArray<NSString*>*)getTmpCacheList{
    NSString *path =NSTemporaryDirectory();
    if([self.fileManager fileExistsAtPath:path])
    {
        NSError *error = nil;
        NSArray *filesList = [self.fileManager contentsOfDirectoryAtPath:path error:&error];
        NSLog(@"filesList=%@",filesList);
    }
    return nil;
}

+(NSArray<NSString*>*)getTmpCacheList
{
    return [[self shareInstance] getTmpCacheList];
}
//移除临时文件
-(BOOL)removeTmpCacheWithTmpName:(NSString*)tmpName
{
    
    {
        NSArray * array = [self getTmpCacheList];
        if([array containsObject:tmpName])
        {
            NSString *path =NSTemporaryDirectory();
            BOOL success = [self.fileManager removeItemAtPath:[path stringByAppendingPathComponent:tmpName] error:nil];
            NSLog(@"success=%i",success);
            return success;
        }
    }
    return false;
}
//移除临时文件
+(BOOL)removeTmpCacheWithTmpName:(NSString*)tmpName
{
    return  [[self shareInstance] removeTmpCacheWithTmpName:tmpName];
}
-(BOOL)removeTmpCacheWithDownLoadURL:(NSString *)url
{
    NSString *tmpName = self.cacheDic[url];
    if (tmpName) {
        BOOL success = [self removeTmpCacheWithTmpName:tmpName];
        if (success) {
            [self.cacheDic removeObjectForKey:url];
        }
        return success;
    }
    return false;
}
+(BOOL)removeTmpCacheWithDownLoadURL:(NSString *)url
{
    return  [[self shareInstance] removeTmpCacheWithDownLoadURL:url];
}

//下载完成删除缓存数据
+(void)removeTmpValueWithDownloadURL:(NSString*)url
{
    [[[self shareInstance] cacheDic] removeObjectForKey:url];
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
-(void)saveDownLoadTaskData:(NSURLSessionDownloadTask*)downloadTask
{
    if(downloadTask == nil)
    {
        return;
    }
    else{
        NSString *tmpPath = [[self class] tempCacheFileNameForTask:downloadTask];
        
        NSString *downloadURL = [[[downloadTask currentRequest] URL] absoluteString];
        //保存数据
        NSLog(@"tmpPath =%@,downloadURL=%@",tmpPath,downloadURL);
        [self.cacheDic setValue:tmpPath forKey:downloadURL];
        
        
        BOOL success = [self.cacheDic writeToFile:self.downloadFileURL atomically:true];
        if (success) {
            NSLog(@"写入成功");
        }
        
    }
}


+(void)saveDownLoadTaskData:(NSURLSessionDownloadTask*)downloadTask
{
    [[self shareInstance] saveDownLoadTaskData:downloadTask];
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
