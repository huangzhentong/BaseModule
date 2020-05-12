//
//  BasisModuleTests.m
//  BasisModuleTests
//
//  Created by huang on 2016/11/3.
//  Copyright © 2016年 huang. All rights reserved.
//

#import <XCTest/XCTest.h>
//#import "BaseClient.h"

@interface BasisModuleTests : XCTestCase

@end

@implementation BasisModuleTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
-(void)login
{
//    BaseClient *model = [BaseClient new];
//    model.url=@"/user/applogin";
//    model.parameters=@{@"ltype":@"3",@"identity":@"12045678920"};
//    [MGJRouter openURL:@"yanxi://GeneralRequest" withUserInfo:[model dictionaryWithModel] completion:^(id result) {
//            NSLog(@"/user/applogin | result =%@",result);
//            NSLog(@"model=%@",model);
//        }];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    [self login];

    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
