//
//  HHttpRequestConfig.h
//  BasisModule
//
//  Created by KT--stc08 on 2018/7/12.
//  Copyright © 2018年 huang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,HHttpRequestSerializer){
    HHttpRequestSerializerNoromal,
    HHttpRequestSerializerJSON,
    
};


@protocol HHttpRequestConfigDelegate <NSObject>
@property(nonatomic,strong)NSMutableDictionary * headerFile;
//@property(nonatomic)HHttpRequestSerializer type;
@end

@interface HHttpRequestConfigManager : NSObject

+(void)addDelegate:(id<HHttpRequestConfigDelegate>)delegate;
+(id<HHttpRequestConfigDelegate>)delegate;
@end
