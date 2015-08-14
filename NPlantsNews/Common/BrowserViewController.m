//
//  BrowserViewController.m
//  NPlantsNews
//
//  Created by 于　超 on 2015/04/02.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import "BrowserViewController.h"
#import "MenuManager.h"

@interface BrowserViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *backButon;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *label;

- (IBAction)returnButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)forwardButtonPressed:(id)sender;
- (IBAction)reloadButtonPressed:(id)sender;

@end

@implementation BrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _backButon.enabled = NO;
    _forwardButton.enabled = NO;
    _reloadButton.enabled = NO;
    
    NSURL *url = [[NSURL alloc]initWithString:_url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlRequest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    CGRect screen = [[UIScreen mainScreen] bounds];
    self.view.frame = CGRectMake(0, 0, screen.size.width, screen.size.height);
    
    [MenuManager sharedManager].backFromWebFlg = YES;
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [_indicator startAnimating];
    _indicator.hidden = NO;
    _label.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    _reloadButton.enabled = YES;
    if (webView.canGoBack)
    {
        _backButon.enabled = YES;
    } else {
        _backButon.enabled = NO;
    }
    
    if (webView.canGoForward)
    {
        _forwardButton.enabled = YES;
    } else {
        _forwardButton.enabled = NO;
    }
    [_indicator stopAnimating];
    _indicator.hidden = YES;
    _label.hidden = YES;
}

- (IBAction)returnButtonPressed:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backButtonPressed:(id)sender {
    if (_webView.canGoBack)
    {
        [_webView goBack];
    }
}

- (IBAction)forwardButtonPressed:(id)sender {
    if (_webView.canGoForward)
    {
        [_webView goForward];
    }
}

- (IBAction)reloadButtonPressed:(id)sender {
    [_webView reload];
}
@end
