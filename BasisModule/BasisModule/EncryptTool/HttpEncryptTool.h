//
//  HttpEncryptTool.h
//  MagicBabyAppClient
//
//  Created by 庄小先生丶 on 16/9/13.
//  Copyright © 2016年 庄小先生丶. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HttpEncryptTool : NSObject

+(NSDictionary*)encodingJsonNetworkDataWithFunction:(NSString*)uniqueFunction
                                                uniqueToken:(NSString*)uniqueToken
                                                  inputData:(NSDictionary*)inputData
                                                     expand:(NSDictionary*)expand
                                                  timestamp:(NSString *)timestamp;
@end
