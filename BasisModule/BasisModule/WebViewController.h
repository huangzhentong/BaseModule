//
//  WebViewController.h
//  BasisModule
//
//  Created by huang on 2017/2/20.
//  Copyright © 2017年 huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property(nonatomic,copy)NSString *url;

- (instancetype)initWithUrl:(NSString*)url;
@end
