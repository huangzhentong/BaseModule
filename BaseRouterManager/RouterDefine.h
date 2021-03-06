//
//  RouterDefine.h
//  BasisModule
//
//  Created by 送爱到家 on 2017/12/19.
//  Copyright © 2017年 huang. All rights reserved.
//

#ifndef RouterDefine_h
#define RouterDefine_h


#endif /* RouterDefine_h */

#define  BaseGeneralRequest  @"BaseClient://GeneralRequest"
#define  HRequestUrlIsRequest @"BaseClient://UrlIsRequesting"
#define  HReachabilityStatusChange @"ReachabilityStatusChange"
#define  HGetReachabilityStatus @"BaseClient://getReachabilityStatus"



typedef NS_ENUM(NSInteger, HttpRequestUrlType)
{
    HttpRequestUrlType_Post,
    HttpRequestUrlType_Get,
    HttpRequestUrlType_Put,
    HttpRequestUrlType_Delete,
    HttpRequestUrlType_Patch,
};
typedef NS_ENUM(NSInteger,HHttpRequestSerializer){
    HHttpRequestSerializerNoromal,
    HHttpRequestSerializerJSON,
    
};


#pragma mark - BaseClient
static NSString * const ClientUrl = @"url";
static NSString * const ClientType = @"type";
static NSString * const ClientProgress = @"progress";
static NSString * const ClientParameters = @"parameters";

static NSString * const ClientHeaders = @"headers";
static NSString * const ClientRequestSerializer = @"requestSerializer";
static NSString * const ClientTimeOutInterval = @"timeOutInterval";
#pragma mark - DownLoadClient
static NSString * const SavePath = @"savePath";
//static NSString * const DownloadProgress = @"DownloadProgress";



#pragma mark -UploadClient
static NSString * const UploadFiles = @"file";
static NSString * const UploadName = @"name";
static NSString * const UploadFileName = @"fileName";
static NSString * const UploadMimeType = @"mimeType";


static NSString * const DownCurrentLength = @"DownCurrentLength";
