//
//  DownloadFileCaheManager.h
//  BasisModule
//
//  Created by KT--stc08 on 2020/5/29.
//  Copyright © 2020 huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//下载缓存文件管理
@interface DownloadFileCacheManager : NSObject

+(instancetype)shareInstance;
//获取下载地址的临时文件
+(NSString*)tmpChchePathWithDownloadURL:(NSString*)downloadUrl;
//获取文件大小
+(NSInteger)fileSizeWithPath:(NSString*)path;
//获取临时文件大小
+(NSInteger)fileSizeWithTmpPathURL:(NSString*)downloadUrl;

+(void)saveDownLoadTaskData:(NSURLSessionDownloadTask*)downloadTask;

//获取临时文件数据
+(NSData*)tmpCacheDataWithDownloadURL:(NSString*)url;
@end

NS_ASSUME_NONNULL_END
