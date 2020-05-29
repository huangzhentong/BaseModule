//
//  ViewController.m
//  BasisModule
//
//  Created by huang on 2016/11/3.
//  Copyright © 2016年 huang. All rights reserved.
//

#import "ViewController.h"
#import "BaseClient.h"

#import "UploadClient.h"
#import "HHttpRequestManager.h"


#import "SVProgressHUD.h"

#import "DownloadClient.h"
#import "WebViewController.h"
#import "HttpEncryptTool.h"
#import "BaseClient+RAC.h"
#import "UploadClient.h"
#import "BaseRouterManager.h"
//#define DEBUG_URL @"http://test.starfans-ubuntu:8000/"
#define LocationCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
@interface ViewController ()<UITableViewDataSource>
{
    DownloadClient *downModel;
}
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *groupTF;
@property (weak, nonatomic) IBOutlet UITextField *friendID;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property(nonatomic,copy)NSString *userName;
@end

@implementation ViewController


- (BOOL) imageHasAlpha: (UIImage *) image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}
- (NSString *) imageToData64URL: (UIImage *) image
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha: image]) {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(image, 0.5f);
        mimeType = @"image/jpeg";
    }
    
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
            [imageData base64EncodedStringWithOptions: 0]];
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
//   http://ts.keytop.cn/wx_test_hmj/service/api/
//    [BaseClient setBaseURL:@"http://ts.keytop.cn/ksservice_test/service/api/"];
    [BaseClient setBaseURL:@"https://ts.keytop.cn/mercoupon"];
    {
        NSURL *url = [NSURL URLWithString:@"http://www.cyxzhtc.cn/roadparking/aps/spm.html?cityCode=360700&spaceNum=0001&phoneNumber=18120788756"];
        NSLog(@"parameterString1 = %@", url.query);
    }
    {
        NSURL *url = [NSURL URLWithString:@"http://www.cyxzhtc.cn/roadparking/aps/spm.html"];
        NSLog(@"parameterString2 = %@", url.query);
    }
    
}

//登陆
- (IBAction)signIn:(id)sender {
    
    BaseClient *client = [BaseClient new];
       client.url = @"/user/login";
       client.parameters = @{@"username":@"hzt",
                             @"password":@"123"
                               };
    client.generalLogic = false;
    client.serializer = HHttpRequestSerializerJSON;
    client.headers = @{@"header1":@"huang"};
    return [client request:^(id result) {
        NSLog(@"result = %@",result);
    } withFailure:^(NSError *error) {
         NSLog(@"error = %@",error);
    }];
    

    
}
- (IBAction)pauseDown:(id)sender {
    [downModel.downloadTask suspend];
}
- (IBAction)continueDown:(id)sender {
    [downModel.downloadTask resume];
}


- (IBAction)downLoad:(id)sender {
    DownloadClient *model = [DownloadClient new];
    model.baseUrl = @"";
    model.url=@"https://dldir1.qq.com/qqfile/QQforMac/QQ_6.6.5.dmg";
    [model request:^(NSProgress *progress) {
//        progress.totalUnitCount;
//        progress.completedUnitCount;
        NSLog(@"progress.fractionCompleted=%.2f",progress.fractionCompleted*100);
    } completion:^(id result) {
        NSLog(@"result=%@",result);
    }];
    downModel = model;
}




@end
