//
//  UploadModel.h
//  BasisModule
//
//  Created by huang on 2016/11/10.
//  Copyright © 2016年 huang. All rights reserved.
//

#import "BaseClient.h"
#import <UIKit/UIKit.h>
@interface UploadClient : BaseClient
@property(nonatomic,copy) NSArray *files;                  //上传数据
@property(nonatomic,copy) NSArray *fileNames;               //文件保存名
@property(nonatomic,copy) NSArray *mimeTypes;               //上传类型  （默认image/jpg）
@property(nonatomic,copy) NSArray *names;                   //服务器文件名  （默认为upload）
@end
