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

-(void)setToken
{
    NSString *token =  [[NSUserDefaults standardUserDefaults] objectForKey:@"Token"];
//    token=@"Bearer 2c269ea4dbfd32dd9bd7a5c22677d18b";
    self.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
//    if (token.length>10)
    {
       
    }
   
    
}

//注册
- (IBAction)registered:(id)sender {
    BaseClient *model =[BaseClient new];
    model.url=@"user/register";
    model.parameters=@{@"ltype":@"3",@"openid":@"18650016423",@"nickname":@"huang",@"gender":@(1),@"headimg":[self imageToData64URL:[UIImage imageNamed:@"女"]]};
    
    [model request:^(id result) {
        NSLog(@"reslut=%@",result);
        
    }];

    
}
//是否重复
-(IBAction)check:(id)sender {
}
//获取用户信处
- (IBAction)getUserInfo:(id)sender {
    
    BaseClient*   model = [BaseClient new];
    model.url=@"/user/getuserinfo";
    model.type=@"get";
    [model request:^(id result) {
        
        NSLog(@"用户信息 | =%@",result);
    }];

    
}
//创建聊天室
- (IBAction)createGroup:(id)sender {
    BaseClient*   model = [BaseClient new];
    
    model.url=@"easemob/chatroom";
    model.parameters=@{@"room_name":@"我的话题",@"description":@"我就无聊",@"maxusers":@(20)};
    model.type=@"post";
    [model request:^(id result) {
        
        NSLog(@"创建聊天室 | =%@",result);
    }];
    
}
//获取聊天室信息
- (IBAction)getGroupInfo:(id)sender {
    BaseClient*  model = [BaseClient new];
    model.url=[NSString stringWithFormat:@"easemob/chatgroups/%@/users",self.groupTF.text];
    model.type=@"get";
    [model request:^(id result) {
        
        NSLog(@".获取聊天室成员和群主信息 | =%@",result);
        //        GroupDetailModel *model = [GroupDetailModel yy_modelWithDictionary:result[@"data"][0]];
        NSLog(@"model=%@",model);
        
    }];
    
}
//退出聊天室
- (IBAction)exitGroup:(id)sender {
    BaseClient * model = [BaseClient new];
    model.url=[NSString stringWithFormat:@"easemob/chatgroups/%@/users/%@",self.groupTF.text,self.userName];
    model.type=@"delete";
//    model.isShowFaildError=NO;
    [model request:^(id result) {
        
        NSLog(@"用户从环信聊天室删除 | =%@",result);
    }];
}
//添加到聊天室
- (IBAction)addGroup:(id)sender {
    
    
    //添加用户到环信聊天室
    BaseClient*   model = [BaseClient new];
    model.url=[NSString stringWithFormat:@"easemob/chatgroups/%@/users/%@",self.groupTF.text,self.userName];
    [model request:^(id result) {
        
        NSLog(@"添加用户到环信聊天室 | =%@",result);
    }];
}
//添加好友
- (IBAction)addFriend:(id)sender {
    
    
    BaseClient*   model = [BaseClient new];
    model.url=[NSString stringWithFormat:@"easemob/users/%@/contacts/users/%@",self.userName,self.friendID];
    
    model.type=@"post";
    [model request:^(id result) {
        
        NSLog(@"添加好友 | =%@",result);
    }];
}
//删除好友
- (IBAction)deleteFriend:(id)sender {
    BaseClient*   model = [BaseClient new];
    model.url=[NSString stringWithFormat:@"easemob/users/{%@/contacts/users/%@",self.userName,self.friendID];
    
    model.type=@"delete";
    [model request:^(id result) {
        
        NSLog(@"删除好友 | =%@",result);
    }];
    
}
//获取用户所在的群
- (IBAction)getUserGroup:(id)sender {
    BaseClient*   model = [BaseClient new];
    model.url=[NSString stringWithFormat:@"easemob/users/%@/joined_chatgroups",self.userName];
    
    model.type=@"get";
    [model request:^(id result) {
        
        NSLog(@"添获取用户所在的群 | =%@",result);
    }];
    
}
//跑马灯
- (IBAction)paomadeng:(id)sender {
    
    BaseClient* model = [BaseClient new];
    model.url =@"user/getmarquee";
    model.type=@"get";
    
    [model request:^(id result) {
        NSLog(@"跑马灯 =%@",result);
        
    }];
    
}
//推荐
- (IBAction)recommended:(id)sender {
    BaseClient* model = [BaseClient new];
    model.url =@"user/gettopiclist";
    model.type=@"get";
    [model request:^(id result) {
        NSLog(@"推荐话题和全部话题 =%@",result);
        
    }];
    
}
//随缘
- (IBAction)random:(id)sender {
    
    BaseClient* model = [BaseClient new];
    model.url =@"user/topic";
    model.type=@"post";
    [model request:^(id result) {
        NSLog(@"随缘聊 =%@",result);
        
    }];
}
//搜索
- (IBAction)search:(id)sender {
    
    BaseClient* model = [BaseClient new];
    model.url =@"user/searchtopic";
    model.type=@"post";
    model.parameters=@{@"topic_name":self.searchTF.text?:@"123"};
    [model request:^(id result) {
        NSLog(@"搜索 =%@",result);
        
    }];
}
//投诉
- (IBAction)complaints:(id)sender {
}
//好友
- (IBAction)userFriends:(id)sender {
    
    
    BaseClient* model = [BaseClient new];
    model.url =@"user/friendsinfo";
    model.type=@"get";
    [model request:^(id result) {
        NSLog(@"用户好友 =%@",result);
        
    }];
    
}
//作品
- (IBAction)works:(id)sender {
    BaseClient *model = [BaseClient new];
    model.url=@"user/getmysong";
    model.type=@"get";
    [model request:^(id result) {
        NSLog(@"作品=%@",result);
    }];
    
}
- (IBAction)downLoad:(id)sender {
    DownloadClient *model = [DownloadClient new];
    model.baseUrl = @"";
    model.url=@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1589260181483&di=99da2ebe143f6380239a617a041999fb&imgtype=0&src=http%3A%2F%2Fgss0.baidu.com%2F9fo3dSag_xI4khGko9WTAnF6hhy%2Fzhidao%2Fpic%2Fitem%2Fc2fdfc039245d6889ebcfb23acc27d1ed31b24fe.jpg";
    [model request:^(NSProgress *progress) {
        progress.totalUnitCount;
        progress.completedUnitCount;
        NSLog(@"progress=%@",progress);
    } completion:^(id result) {
        NSLog(@"result=%@",result);
    }];
}

- (IBAction)checkVerson:(id)sender {
    BaseClient *model = [BaseClient new];
    model.url=@"user/getverioncfg";
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

    model.parameters=@{@"version":app_Version};
    model.type=@"get";
    [model request:^(id result) {
        NSLog(@"检查版本更新 | result=%@",result);
        NSMutableArray *myMutableArr =  [NSMutableArray arrayWithArray: result[@"data"][@"live2dfile"]];
        

        
        NSMutableDictionary *downDic=[NSMutableDictionary new];
        int i =myMutableArr.count-1;
        for (i;i>=0;i--) {
            NSDictionary *dic = myMutableArr[i];
            NSString *name =dic[@"name"];
            if (downDic[name]==nil) {
                downDic[name]=dic;
            }
        }
        NSLog(@"downDic=%@",downDic);
        
    } withFailure:^(NSError *error) {
        NSLog(@"error=%@",error);
    }];
}
//对话
- (IBAction)dialogueEvent:(id)sender {
    BaseClient *model = [BaseClient new];
    model.baseUrl=@"http://114.55.26.178:8001/";
    model.url=@"aichat/";
    model.parameters=@{@"user_name":@"mg6i-zjlj-o1bs-142o",
                       @"character_id":@1,
                       @"content":[self imageToData64URL:[UIImage imageNamed:@"美女.jpg"]],
                       @"type":@(1),
                         };
    [model request:^(id result) {
        NSLog(@"result=%@",result);
        
    } withFailure:^(NSError *error) {
        NSLog(@"error=%@",error);
    }];
    
}
//调教
- (IBAction)tuningEvent:(id)sender {
    BaseClient *model = [BaseClient new];
    model.baseUrl=@"http://114.55.26.178:8001/";
    model.url=@"aiteach/";
    model.parameters=@{@"user_name":@"mg6i-zjlj-o1bs-142o",
                       @"character_id":@1,
                       @"content":@"你是谁",
                       @"type":@(0),
                       @"count_answer":@2,
                       @"answer1":@"我就是我",
                       @"type1":@(0),
                       @"answer2":@"不一样的花火",
                       @"type2":@(0),
                       
                       };
    [model request:^(id result) {
        NSLog(@"result=%@",result);
        
    } withFailure:^(NSError *error) {
        NSLog(@"error=%@",error);
    }];

}
- (IBAction)checkToken:(id)sender {
    BaseClient *model = [BaseClient new];
    model.url=@"user/checktoken";
    model.type=@"get";
    [model request:^(id result) {
        NSLog(@"result");
    } withFailure:^(NSError *error) {
        NSLog(@"error=%@",error);
    }];
}
- (IBAction)webView:(id)sender {
         NSString *url = [NSString stringWithFormat:@"http://192.168.1.199:8088/list.html?token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"Token2"]];
   WebViewController *vc = [[WebViewController alloc] initWithUrl:url];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)updateuserscore:(id)sender {
    BaseClient *model=[BaseClient new];
    model.url=@"user/updateuserscore";
    model.type=@"put";
    model.parameters=@{@"curstate":@"1",@"deltavalue":@(30),@"curvalue":@(4000)};
    [model request:^(id result) {
        NSLog(@"result=%@",result);
    } withFailure:^(NSError *error) {
        NSLog(@"error=%@",error);
    }];
}
- (IBAction)signOn:(id)sender {
}
//表白
- (IBAction)unburden:(id)sender {
    BaseClient *model=[BaseClient new];
    model.url=@"user/saylove";
    model.type=@"post";
    model.parameters=@{@"curstate":@"1",
                       @"deltavalue":@(30),
                       @"curvalue":@(999),
                       @"content":@"你滚"};
    [model request:^(id result) {
        NSLog(@"result=%@",result);
    } withFailure:^(NSError *error) {
        NSLog(@"error=%@",error);
    }];

}
//
- (IBAction)breakBtnEvent:(id)sender {
    BaseClient *model=[BaseClient new];
    model.url=@"user/saygoodbye";
    model.type=@"post";
    model.parameters=@{@"curstate":@"8",
                       @"deltavalue":@(30),
                       @"curvalue":@(99999),
                       @"content":@"你滚"};
    [model request:^(id result) {
        NSLog(@"result=%@",result);
    } withFailure:^(NSError *error) {
        NSLog(@"error=%@",error);
    }];
}
- (IBAction)changeolduser:(id)sender {
    BaseClient *model=[BaseClient new];
    model.url=@"user/changeolduser";
    model.type=@"post";
//    model.parameters=@{@"curstate":@"8",
//                       @"deltavalue":@(30),
//                       @"curvalue":@(99999),
//                       @"content":@"你滚"};
    [model request:^(id result) {
        NSLog(@"result=%@",result);
    } withFailure:^(NSError *error) {
        NSLog(@"error=%@",error);
    }];

}
- (IBAction)secretuser:(id)sender {
    BaseClient *model=[BaseClient new];
    model.parameters = @{@"puid":@"2c269ea4dbfd32dd9bd7a5c22677d18b"};
 
    model.url = @"user/lookbeautifulpic";
//    model.url=@"user/secretuser";
    model.type=@"get";
    [model request:^(id result) {
        NSLog(@"result=%@",result);
    } withFailure:^(NSError *error) {
        NSLog(@"error=%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
