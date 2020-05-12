//
//  BaseClient+RAC.m
//  BasisModule
//
//  Created by KT--stc08 on 2018/7/17.
//  Copyright © 2018年 huang. All rights reserved.
//

#import "BaseClient+RAC.h"
#import "BaseRouterManager.h"
#import "RequestModelManager.h"
@implementation BaseClient (RAC)
//-(RACSignal*)requestReturnSignal
//{
//    return  [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        NSDictionary *dic = [self dictionaryWithModel];
//        NSURLSessionDataTask* dataTask =  [BaseRouterManager requestWithDic:dic withBlock:^(id result) {
//            id nresult = result;
//            NSError *error = nil;
//            id<RequestModelDelegate> delegate = self.delegate ? :[RequestModelManager delegate];
//            if (delegate && [delegate respondsToSelector:@selector(requestLogicDispose: withClass:)]) {
//                nresult =  [delegate requestLogicDispose:result withClass:self.modelClass];
//            }
//            
//            
//            if (([nresult isKindOfClass:[NSError class]])) {
//                error = nresult;
//                nresult = nil;
//                [subscriber sendError:error];
//            }
//            else
//            {
//                error = nil;
//                
//                [subscriber sendNext:nresult];
//                
//            }
//            [self requestComplete:nresult withError:error];
//            [subscriber sendCompleted];
//        }];
//        return [RACDisposable disposableWithBlock:^{
//            if (dataTask) {
//                [dataTask cancel];
//            }
//        }];
//    }];
//    
//}
@end
