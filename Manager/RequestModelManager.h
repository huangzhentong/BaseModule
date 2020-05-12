//
//  RequestModelManager.h
//  BasisModule
//
//  Created by KT--stc08 on 2018/7/11.
//  Copyright © 2018年 huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RequestModelDelegate <NSObject>
@optional
//请求将开始开始
-(void)requestWillStart;
//请求完成
-(void)requestComplete:(id)result withError:(NSError*)error;
//请求结束逻辑处理,返回数据处理结果
-(id)requestLogicDispose:(id)result withClass:(Class)class;

@end


//用于管理请求开始，及请求结束
@interface RequestModelManager : NSObject
+(void)addDelegate:(id<RequestModelDelegate>)delegate;
+(id<RequestModelDelegate>)delegate;
@end
