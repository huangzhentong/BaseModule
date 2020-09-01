//
//  HHttpRequestManager.m
//  BasisModule
//
//  Created by huang on 2016/10/27.
//  Copyright © 2016年 huang. All rights reserved.
//

#import "HHttpRequestManager.h"
//#import "AFHTTPSessionManager.h"
#import "HHttpRequestConfigManager.h"

static NSMutableDictionary *dataTaskManager;

static NSString *authorizationToken = nil;
static NSString *httpHeaderField = nil;

@implementation HHttpRequestManager

+(NSInteger)networkReachabilityStatus
{
    
    return [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
}

+(BOOL)isReachable
{
   return  [[AFNetworkReachabilityManager sharedManager] isReachable];
}

+ (void)setReachabilityStatusChangeBlock:(nullable void (^)(NSInteger status))block
{
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        block(status);
    }];
}



+(void)load
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (NSMutableDictionary*)dataTaskManager{
    if (!dataTaskManager) {
        dataTaskManager = [[NSMutableDictionary alloc] init];
       
    }
    return dataTaskManager;
}

+(AFHTTPSessionManager *)manager
{
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc] init];
       
        // 声明上传的是json格式的参数，需要你和后台约定好，不然会出现后台无法获取到你上传的参数问题
        
        manager.requestSerializer = [HHttpRequestManager jsonRequestSerializer]; // 上传JSON格式
        manager.responseSerializer = [AFJSONResponseSerializer serializer]; // AFN会JSON解析返回的数据
        // 个人建议还是自己解析的比较好，有时接口返回的数据不合格会报3840错误，大致是AFN无法解析返回来的数据
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];;
        [manager.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];

    

    });
    
    return manager;
}

+(AFHTTPRequestSerializer*)httpRequestSerializer{
    static AFHTTPRequestSerializer * serializer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         serializer = [AFHTTPRequestSerializer serializer];
        [serializer willChangeValueForKey:@"timeoutInterval"];
        serializer.timeoutInterval = kTimeOutInterval;
        [serializer didChangeValueForKey:@"timeoutInterval"];
    });
    return serializer;
}

+(AFJSONRequestSerializer*)jsonRequestSerializer
{
    static AFJSONRequestSerializer * serializer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serializer = [AFJSONRequestSerializer serializer];
        [serializer willChangeValueForKey:@"timeoutInterval"];
        serializer.timeoutInterval = kTimeOutInterval;
        [serializer didChangeValueForKey:@"timeoutInterval"];
    });
    return serializer;
}


+ (NSURLSessionDataTask*)GET:(NSString *)urlString
                            parameters:(nullable id)parameters
                            headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                              progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                               success:(AFNSuccessBlock)success
                               failure:(AFNErrorBlock)failure
{
    AFHTTPSessionManager *manager = [self manager];
    
    
    NSURLSessionDataTask *dataTask = [manager GET:urlString parameters:parameters headers:headers progress:downloadProgress success:^(NSURLSessionDataTask *  task, id   responseObject) {
       
       success(responseObject,YES);
       [[self dataTaskManager] removeObjectForKey:urlString];
       
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        
        failure(error);
        
        [[self dataTaskManager] removeObjectForKey:urlString];
        
    }];
    
    [[self dataTaskManager] setValue:dataTask forKey:urlString];
    return dataTask;
    
}

+ (NSURLSessionDataTask*)GET:(NSString *)urlString
 parameters:(nullable id)parameters
headers:(nullable NSDictionary <NSString *, NSString *> *)headers
    success:(AFNSuccessBlock)success
    failure:(AFNErrorBlock)failure
{
    return [self GET:urlString parameters:parameters headers:headers progress:nil success:success failure:failure];
}



+(NSURLSessionDataTask*)POST:(NSString *)urlString
 parameters:(nullable id)parameters
headers:(nullable NSDictionary <NSString *, NSString *> *)headers
   progress:(nullable void (^)(NSProgress *downloadProgress))uploadProgress
    success:(AFNSuccessBlock)success
    failure:(AFNErrorBlock)failure
{
    AFHTTPSessionManager *manager = [self manager];

   NSURLSessionDataTask *dataTask = [manager POST:urlString parameters:parameters headers:headers progress:uploadProgress success:^(NSURLSessionDataTask *  task, id   responseObject) {
        
    
       success(responseObject,YES);
        [[self dataTaskManager] removeObjectForKey:urlString];
        
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
    
        failure(error);
        [[self dataTaskManager] removeObjectForKey:urlString];
        
    }];
    [[self dataTaskManager] setValue:dataTask forKey:urlString];
    return dataTask;

}
+(NSURLSessionDataTask*)POST:(NSString *)urlString parameters:(id)parameters
                     headers:(nullable NSDictionary <NSString *, NSString *> *)headers success:(AFNSuccessBlock)success failure:(AFNErrorBlock)failure
{
    return [self POST:urlString parameters:parameters headers:headers progress:nil success:success failure:failure];
}

+(NSURLSessionDataTask*)PUT:(nullable NSString *)urlString
parameters:(nullable id)parameters
headers:(nullable NSDictionary <NSString *, NSString *> *)headers
   success:(nullable AFNSuccessBlock)success
   failure:(nullable AFNErrorBlock)failure
{
     AFHTTPSessionManager *manager = [self manager];
    NSURLSessionDataTask *dataTask =  [manager PUT:urlString parameters:parameters headers:headers success:^(NSURLSessionDataTask *  task, id   responseObject) {
        success(responseObject,YES);
        [[self dataTaskManager] removeObjectForKey:urlString];
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        failure(error);
        [[self dataTaskManager] removeObjectForKey:urlString];
    }];
    [[self dataTaskManager] setValue:dataTask forKey:urlString];
    return dataTask;
}

+(NSURLSessionDataTask*)PATCH:(nullable NSString *)urlString
  parameters:(nullable id)parameters
headers:(nullable NSDictionary <NSString *, NSString *> *)headers
     success:(nullable AFNSuccessBlock)success
     failure:(nullable AFNErrorBlock)failure{
    
    AFHTTPSessionManager *manager = [self manager];
    NSURLSessionDataTask *dataTask = [manager PATCH:urlString parameters:parameters headers:headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject,YES);
        [[self dataTaskManager] removeObjectForKey:urlString];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [[self dataTaskManager] removeObjectForKey:urlString];
    }];
    
    
    [[self dataTaskManager] setValue:dataTask forKey:urlString];
    return dataTask;
    
}

+(NSURLSessionDataTask*)DELETE:(nullable NSString *)urlString
   parameters:(nullable id)parameters
headers:(nullable NSDictionary <NSString *, NSString *> *)headers
      success:(nullable AFNSuccessBlock)success
      failure:(nullable AFNErrorBlock)failure
{
    AFHTTPSessionManager *manager = [self manager];
    NSURLSessionDataTask *dataTask =  [manager DELETE:urlString parameters:parameters headers:headers success:^(NSURLSessionDataTask *  task, id   responseObject) {
        success(responseObject,YES);
        [[self dataTaskManager] removeObjectForKey:urlString];
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        failure(error);
        [[self dataTaskManager] removeObjectForKey:urlString];
    }];
    [[self dataTaskManager] setValue:dataTask forKey:urlString];
    return dataTask;
}


+(NSURLSessionDownloadTask*)downloadWithUrlSring:(nullable NSString *)urlString
                         withData:(NSData*)tmpData
         savePath:(nullable NSString *)savePath
         progress:(nullable void (^)(NSProgress * _Nonnull downloadProgress))downloadProgress
                               completionHandler:(nullable void (^)(NSString * _Nonnull filePath , NSError * _Nonnull error))completion
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];

    NSURLSessionDownloadTask *downloadTask = nil;
    if(tmpData != nil)
    {
        //断点续传
       downloadTask = [manager downloadTaskWithResumeData:tmpData progress:downloadProgress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            NSURL *documentsDirectoryURL;
             if (savePath==nil||savePath.length<2) {
                 documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
             }
             else
             {
                 documentsDirectoryURL = [NSURL fileURLWithPath:savePath];
             }
            
             return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
             completion([filePath relativeString],error);
        }];
    }
    else
    {
        
        downloadTask = [manager downloadTaskWithRequest:request progress:downloadProgress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL;
        if (savePath==nil||savePath.length<2) {
            documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        }
        else
        {
            documentsDirectoryURL = [NSURL fileURLWithPath:savePath];
        }
       
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        completion([filePath relativeString],error);
        NSLog(@"File downloaded to: %@", filePath);
        }];
    }

    [downloadTask resume];
    return  downloadTask;
}

+(void)cancelRequest:(NSString *)urlString
{
   id object = [[self dataTaskManager] objectForKey:urlString];
    if ([object isKindOfClass:[NSURLSessionDataTask class]]) {
        [object cancel];
    }
}

+(void)cancelAllRequest
{
    [[[self manager] operationQueue] cancelAllOperations];
}

+(BOOL)urlIsRequest:(nullable NSString *)urlString
{
    id object =  [[self dataTaskManager] objectForKey:urlString];
    if (object) {
        return YES;
    }
    else
        return NO;
}

+(void)pauseDownLoadWithURL:(NSString*)urlString
{
    
}
//恢复下载
+(void)reuseDownLoadWithURL:(nullable NSString *)urlString
{
    
}

+(NSURLSessionDataTask *)uploadImageWithUrlString:(nullable NSString *)urlString
                     parameters:(nullable id)parameters
                        headers:(NSDictionary *)headerDic
                          files:(nullable NSArray*)files
                        name:(nullable NSArray*)names
                        fileName:(nullable NSArray*)fileNames
                        mimeType:(nullable NSArray*)mimeTypes
                       progress:(nullable void (^)(NSProgress *_Nonnull downloadProgress))uploadProgress
                        success:(nullable AFNSuccessBlock)success
                        failure:(nullable AFNErrorBlock)failure
{
    
    
    
    AFHTTPSessionManager *manager = [self manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                                    @"application/json",
                                                                    @"text/html"       ,
                                                                    @"image/jpeg"      ,
                                                                    @"image/png"       ,
                                                                    @"image/jpg"       ,
                                                                    @"application/octet-stream",
                                                                    @"multipart/form-data",
                                                                    @"text/json"      ,
                                                                                                     nil] ;

    
    return  [manager POST:urlString parameters:parameters headers:headerDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
      
        
        for (int i = 0; i < files.count; i++)
        {
            
            id file = files[i];
            NSString *fileName;
            NSString *name;
            NSString *mimeType;
            if (i >= fileNames.count) {
                fileName = [fileNames lastObject];
            }
            else
            {
                fileName = fileNames[i];
            }
            if (i >= names.count) {
                name = [names lastObject];
            }
            else
            {
                name = names[i];
            }
            if (i >= mimeTypes.count) {
                mimeType = [mimeTypes lastObject];
            }
            else
            {
                mimeType = mimeTypes[i];
            }
            
            NSData *fileData = nil;
            if ([file isKindOfClass:[UIImage class]]) {
                 fileData = UIImageJPEGRepresentation(file, 0.5);
                
            }
            else if([file isKindOfClass:[NSData class]])
            {
                fileData = (NSData*)file;
            }else if([file isKindOfClass:[NSString class]])
            {

                [formData appendPartWithFileURL:[NSURL fileURLWithPath:file] name:name fileName:fileName mimeType:mimeType error:nil]; //
            }
            
            NSAssert(fileData != nil, @"文件数据不能为空");
            if(fileData)
            {
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
                
//                NSString * newFileName = fileNames[i];
//
//                if (fileNames[i] == nil || fileNames[i].length == 0) {
//                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//                    // 设置时间格式
//                    [formatter setDateFormat:@"yyyyMMddHHmmss"];
//                    NSString *dateString = [formatter stringFromDate:[NSDate date]];
//                    newFileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
//                }
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType]; //
            }
        }
           
        
      
    } progress:^(NSProgress * _Nonnull uploadProgress) {
         NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask *  task, id   responseObject) {
        if (success) {
            success(responseObject,YES);
        }
        
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
