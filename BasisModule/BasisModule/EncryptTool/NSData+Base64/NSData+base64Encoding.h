//
//  NSData+base64Encoding.h
//  kukushop
//
//  Created by yyt on 13-8-28.
//  Copyright (c) 2013年 yyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  NSData(base64Encoding)
+ (id)dataWithBase64EncodedString:(NSString *)string;
- (NSString *)base64Encoding;

+ (id)dataWithBase64EncodedWithSafeUrlString:(NSString *)string;
- (NSString *)base64EncodingWithSafeUrl;
@end
