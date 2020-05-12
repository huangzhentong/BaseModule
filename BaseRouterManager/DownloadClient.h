//
//  DownloadModel.h
//  BasisModule
//
//  Created by huang on 2016/12/22.
//  Copyright © 2016年 huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseClient.h"


@interface DownloadClient : BaseClient

@property(nonatomic,copy)NSString *savePath;
@property(nonatomic,copy)NSString *fileName;



-(void)request:(RequestProgressBlock )progress completion:(void(^)(id result))complete;
-(void)request:(RequestProgressBlock )progress completion:(void(^)(id result))complete withFailure:(void(^)(NSError *error))fail;
@end
