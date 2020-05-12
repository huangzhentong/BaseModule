//
//  DownloadModel.m
//  BasisModule
//
//  Created by huang on 2016/12/22.
//  Copyright © 2016年 huang. All rights reserved.
//

#import "DownloadClient.h"
#import "BaseRouterManager.h"


@interface DownloadClient ()

@end

@implementation DownloadClient
-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(NSDictionary*)dictionaryWithModel{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary: [super dictionaryWithModel]];
    
    dic[SavePath]=self.savePath?:@"";
    dic[ClientType]=@"download";
    
    return dic;
    
}
-(void)request:(RequestProgressBlock )progress completion:(void(^)(id result))complete
{
    [self request:progress completion:complete withFailure:nil];
}
-(void)request:(RequestProgressBlock )progress completion:(void(^)(id result))complete withFailure:(void(^)(NSError *error))fail
{
    self.progress = progress;
    NSDictionary *dic = [self dictionaryWithModel];
    [BaseRouterManager requestWithDic:dic withBlock:^(id result) {
     
        if (([result isKindOfClass:[NSError class]])) {
            NSLog(@"error =%@",result);

            if (fail) {
                fail(result);
            }
        }
        else
        {
      
            NSString *string = result[@"filePath"];
            //从路径中获得完整的文件名 （带后缀）
            NSString *fileName = [string lastPathComponent];
            
            NSString *pathExtension=[string pathExtension];
            if (self.fileName!=nil) {
                //修改名字
                fileName = [string stringByReplacingOccurrencesOfString:fileName withString:[NSString stringWithFormat:@"%@.%@",self.fileName,pathExtension]];
                
                NSError *error=nil;
                //判断文件是否存在，存在删除文件
                if([[NSFileManager defaultManager] fileExistsAtPath:[fileName stringByReplacingOccurrencesOfString:@"file://" withString:@""]])
                {
                    [[NSFileManager defaultManager] removeItemAtURL:[NSURL URLWithString:fileName] error:&error];
                }
                //修改文件名
                if ([[NSFileManager defaultManager] moveItemAtURL:[NSURL URLWithString:string] toURL:[NSURL URLWithString:fileName] error:&error]==YES)
                {
                    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:result];
                    dic[@"filePath"]=fileName;
                    result=dic;
                    
                }
            }
            complete(result);
        }
    }];
     
    
}
@end
