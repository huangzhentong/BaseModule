//
//  AESCbc.h
//  MagicBabyAppClient
//
//  Created by 庄小先生丶 on 15/7/6.
//  Copyright (c) 2015年 庄小先生丶. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(AES128CBC)
+(NSString*)encrypt:(NSString*)code;

+(NSString*)decrypt:(NSString*)code;
@end
