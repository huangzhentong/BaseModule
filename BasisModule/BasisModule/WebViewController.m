//
//  WebViewController.m
//  BasisModule
//
//  Created by huang on 2017/2/20.
//  Copyright © 2017年 huang. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
@interface WebViewController ()
@property(nonatomic,strong)WKWebView *webView;
@end

@implementation WebViewController
-(instancetype)initWithUrl:(NSString*)url
{
    self = [super init];
    if (self) {
        self.url=url;
    }
    return self;
}
- (WKWebView*)webView
{
    if (!_webView) {
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 设置偏好设置
        config.preferences = [[WKPreferences alloc] init];
        // 默认为0
        config.preferences.minimumFontSize = 10;
        // 默认认为YES
        config.preferences.javaScriptEnabled = YES;
        // 允许网页内嵌视频播放器
        config.allowsInlineMediaPlayback = YES;
        config.allowsAirPlayForMediaPlayback = YES;
        config.selectionGranularity = YES;
        // 记忆读取
        config.suppressesIncrementalRendering = YES;
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        config.processPool = [[WKProcessPool alloc] init];
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
        //        _webView.UIDelegate = self;
        //        _webView.scalesPageToFit = YES;
        CGRect rect = _webView.frame;
        rect.size.height -= 64;
        _webView.frame = rect;
        _webView.navigationDelegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.allowsBackForwardNavigationGestures = YES;
//        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        //        self.bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
        
    }
    return _webView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    NSLog(@"url=%@",self.url);
    if (self.url!=nil) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
