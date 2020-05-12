//
//  UploadModel.m
//  BasisModule
//
//  Created by huang on 2016/11/10.
//  Copyright © 2016年 huang. All rights reserved.
//

#import "UploadClient.h"

@implementation UploadClient

-(NSDictionary*)dictionaryWithModel
{
   NSMutableDictionary *dict =[NSMutableDictionary dictionaryWithDictionary:[super dictionaryWithModel]];
    
    if(self.files && self.files.count > 0)
        dict[UploadFiles] = self.files;
    dict[UploadFileName] = self.fileNames ? : @[@"file"];
    dict[UploadMimeType] = self.mimeTypes ? : @[@"image/jpg"];
 
    dict[UploadName] = self.names?:@[@"upload"];
    dict[ClientType]=@"upload";
    return dict;
}

@end
