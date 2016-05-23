//
//  ViewController.m
//  MMWKWebView
//
//  Created by xinruan on 16/5/23.
//  Copyright © 2016年 xinruan. All rights reserved.
//

#import <WebKit/WebKit.h>

#import "ViewController.h"

@interface ViewController ()<WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView * wkWebView;
@property (nonatomic, strong) UIProgressView * progressView;


@end

@implementation ViewController



/*
 想用UIWebVeiw做的，但是突然想起来在iOS8中出了一个新的WKWebView，算是UIWebVeiw的升级版。本着对新事物的好奇，就上网查了一下，但是找了好多个都没说的多了详细，于是就问谷歌，找文档，看看使用方法，试用了一下，果然不错，记录下来，大家分享！
 WKWebView的特点：
 性能高，稳定性好，占用的内存比较小，
 支持JS交互
 支持HTML5 新特性
 可以添加进度条（然并卵，不好用，还是习惯第三方的）。
 支持内建手势，
 据说高达60fps的刷新频率（不卡）
 

 */



- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, 1)];
        _progressView.tintColor = [UIColor redColor];
        _progressView.trackTintColor = [UIColor clearColor];
        [_progressView setProgress:0.0 animated:YES];
        // [self.view addSubview:_progressView];
    }
    return _progressView;
}

- (WKWebView *)wkWebView
{
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds ];
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [_wkWebView loadRequest:request];
 
    }
    return _wkWebView;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.navigationController.navigationBar addSubview:self.progressView];
    
    [self.view addSubview:self.wkWebView];
    
    
    
    [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [_wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    // Do any additional setup after loading the view, typically from a nib.
}



# pragma mark - - 处理监听方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        if (object == _wkWebView) {
            [self.progressView setAlpha:1.0f];
            [self.progressView setProgress:self.wkWebView.estimatedProgress animated:YES];
            
            if(self.wkWebView.estimatedProgress >= 1.0f) {
                
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [self.progressView setProgress:0.0f animated:NO];
                }];
                
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    }
    else if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.wkWebView) {
            self.title = self.wkWebView.title;
            
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
            
        }
    }
    else {
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
     
    
}




# pragma mark - - navigationDelegate

# pragma mark - - 追踪加载过程



// 开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"开始加载");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}




//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    
}

// 内容开始返回
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
      NSLog(@"开始返回数据");
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"完成");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

}


//页面加载失败
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    
}

/*
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler
{
    
}
 */


- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView NS_AVAILABLE(10_11, 9_0)
{
    
}


# pragma mark - - 追踪页面跳转


//接受到服务器跳转请求后再执行
/*
 - (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation
 {
 
 }
 */
/*
 //发送请求前，决定是否跳转。
 - (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
 {
 
 }
 */


/*
 //收到响应后，决定是否跳转
 - (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
 {
 
 }
 */


# pragma mark - - UIDelegate

//创建新的webview
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    return nil;
}

/*  关闭
 */

- (void)webViewDidClose:(WKWebView *)webView NS_AVAILABLE(10_11, 9_0)
{
    
}

// 显示一个js的alert （与js交互）
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    
}

//显示一个确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
    
}

//弹出一个输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
