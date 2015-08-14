//
//  SettingViewController.m
//  NPlantsNews
//
//  Created by 于　超 on 2015/03/25.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import "SettingViewController.h"
#import "ChangeMenuViewController.h"
#import "BrowserViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MenuManager.h"
#import "HelpViewController.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define iOS8 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UISwitch *pushSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *mailSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *sokuhouSwitch;
@property (weak, nonatomic) IBOutlet UIView *pushView;
@property (weak, nonatomic) IBOutlet UIView *versionView;
@property (weak, nonatomic) IBOutlet UILabel *version;
@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *appVersion;

- (IBAction)changeButtonPressed:(id)sender;
- (IBAction)twitterButtonPressed:(id)sender;
- (IBAction)facebokButtonPressed:(id)sender;
- (IBAction)helpButtonPressed:(id)sender;
- (IBAction)ruleButtonPressed:(id)sender;
- (IBAction)companyButtonPressed:(id)sender;
- (IBAction)contactButtonPressed:(id)sender;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    // スクロール
    CGRect screen = [[UIScreen mainScreen] bounds];
    if (545 > screen.size.height-145) {
        _contentHeight.constant = 545-(screen.size.height-145);
    }
    
    _version.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    // uuid取得
    _uuid = [self getUuid];
    NSLog(@"%@", _uuid);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSUserDefaults standardUserDefaults] setObject:@"9" forKey:@"index"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    // 角丸
    _pushView.frame = CGRectMake(_pushView.frame.origin.x, _pushView.frame.origin.y, screen.size.width-20, _pushView.frame.size.height);
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:_pushView.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _pushView.bounds;
    maskLayer.path = maskPath.CGPath;
    _pushView.layer.mask = maskLayer;
    
    _versionView.frame = CGRectMake(_versionView.frame.origin.x, _versionView.frame.origin.y, screen.size.width-20, _versionView.frame.size.height);
    UIBezierPath *maskPath2;
    maskPath2 = [UIBezierPath bezierPathWithRoundedRect:_versionView.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = _versionView.bounds;
    maskLayer2.path = maskPath2.CGPath;
    _versionView.layer.mask = maskLayer2;
    
    _pushSwitch.onTintColor = [UIColor colorWithRed:0.412 green:0.616 blue:0.831 alpha:1];
    _mailSwitch.onTintColor = [UIColor colorWithRed:0.412 green:0.616 blue:0.831 alpha:1];
    _sokuhouSwitch.onTintColor = [UIColor colorWithRed:0.412 green:0.616 blue:0.831 alpha:1];
    
    int type = [self getPush];
    if (type != 0 && [[NSUserDefaults standardUserDefaults] boolForKey:@"push"]) {
        _pushSwitch.on = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"push"];
    } else {
        _pushSwitch.on = NO;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"push"];
    }
    if (type != 0 && [[NSUserDefaults standardUserDefaults] boolForKey:@"mail"]) {
        _mailSwitch.on = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"mail"];
    } else {
        _mailSwitch.on = NO;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"mail"];
    }
    if (type != 0 && [[NSUserDefaults standardUserDefaults] boolForKey:@"sokuhou"]) {
        _sokuhouSwitch.on = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sokuhou"];
    } else {
        _sokuhouSwitch.on = NO;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sokuhou"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeSwitch:(id)sender {
    UISwitch *sw = (UISwitch *)sender;
    
    if (sw.tag == 1) {
        if(_pushSwitch.on) {
            // onの時の処理
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"push"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            int type = [self getPush];
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
            if (type == 0 || token == nil) {
                _pushSwitch.on = NO;
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"push"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"お使いの端末では、LC Newsアプリからのプッシュ通知が許可されていません。\nプッシュ通知を受け取るには、ホーム画面「設定」→「通知」→「LC News」の順にタップして、「通知を許可」をオンに設定してください。"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"OK", nil];
                [alertView show];
                return;
            }
            // サーバー送信
            AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
            NSDictionary* param = @{@"uuid" : _uuid, @"device_token" : token, @"app_version" : _appVersion, @"push_info_flag" : @"1"};
            [manager POST:TOKEN_API parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"通信失敗しました。"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"OK", nil];
                [alertView show];
                _pushSwitch.on = NO;
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"push"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }];
            
        } else {
            // offの時の処理
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"push"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
            if (token == nil) {
                _pushSwitch.on = YES;
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"push"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                return;
            }
            // サーバー送信
            AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
            NSDictionary* param = @{@"uuid" : _uuid, @"device_token" : token, @"app_version" : _appVersion, @"push_info_flag" : @"0"};
            [manager POST:TOKEN_API parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"通信失敗しました。"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"OK", nil];
                [alertView show];
                _pushSwitch.on = YES;
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"push"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }];
        }
    } else if (sw.tag == 2) {
        if(_mailSwitch.on) {
            // onの時の処理
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"mail"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            int type = [self getPush];
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
            if (type == 0 || token == nil) {
                _mailSwitch.on = NO;
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"mail"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"お使いの端末では、LC Newsアプリからのプッシュ通知が許可されていません。\nプッシュ通知を受け取るには、ホーム画面「設定」→「通知」→「LC News」の順にタップして、「通知を許可」をオンに設定してください。"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"OK", nil];
                [alertView show];
                return;
            }
            // サーバー送信
            AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
            NSDictionary* param = @{@"uuid" : _uuid, @"device_token" : token, @"app_version" : _appVersion, @"push_mail_flag" : @"1"};
            [manager POST:TOKEN_API parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"通信失敗しました。"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"OK", nil];
                [alertView show];
                _mailSwitch.on = NO;
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"mail"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }];
            
        } else {
            // offの時の処理
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"mail"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
            if (token == nil) {
                _mailSwitch.on = YES;
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"mail"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                return;
            }
            // サーバー送信
            AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
            NSDictionary* param = @{@"uuid" : _uuid, @"device_token" : token, @"app_version" : _appVersion, @"push_mail_flag" : @"0"};
            [manager POST:TOKEN_API parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"通信失敗しました。"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"OK", nil];
                [alertView show];
                _mailSwitch.on = YES;
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"mail"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }];
        }
    } else if (sw.tag == 3) {
        if(_sokuhouSwitch.on) {
            // onの時の処理
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sokuhou"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            int type = [self getPush];
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
            if (type == 0 || token == nil) {
                _sokuhouSwitch.on = NO;
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sokuhou"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"お使いの端末では、LC Newsアプリからのプッシュ通知が許可されていません。\nプッシュ通知を受け取るには、ホーム画面「設定」→「通知」→「LC News」の順にタップして、「通知を許可」をオンに設定してください。"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"OK", nil];
                [alertView show];
                return;
            }
            // サーバー送信
            AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
            NSDictionary* param = @{@"uuid" : _uuid, @"device_token" : token, @"app_version" : _appVersion, @"push_sokuhou_flag " : @"1"};
            [manager POST:TOKEN_API parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"通信失敗しました。"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"OK", nil];
                [alertView show];
                _sokuhouSwitch.on = NO;
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sokuhou"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }];
            
        } else {
            // offの時の処理
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sokuhou"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
            if (token == nil) {
                _sokuhouSwitch.on = YES;
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sokuhou"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                return;
            }
            // サーバー送信
            AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
            NSDictionary* param = @{@"uuid" : _uuid, @"device_token" : token, @"app_version" : _appVersion, @"push_sokuhou_flag" : @"0"};
            [manager POST:TOKEN_API parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"通信失敗しました。"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"OK", nil];
                [alertView show];
                _sokuhouSwitch.on = YES;
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sokuhou"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }];
        }
    }
}

- (IBAction)changeButtonPressed:(id)sender {
    ChangeMenuViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"change"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)twitterButtonPressed:(id)sender {
    BrowserViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"browser"];
    controller.url = @"http://secure.lovecosmetic.net/i/html/pageShw.php?id=2203";
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)facebokButtonPressed:(id)sender {
    BrowserViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"browser"];
    controller.url = @"http://secure.lovecosmetic.net/i/html/pageShw.php?id=623";
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)helpButtonPressed:(id)sender {
    HelpViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"help"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)ruleButtonPressed:(id)sender {
    BrowserViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"text"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)companyButtonPressed:(id)sender {
    BrowserViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"browser"];
    controller.url = @"http://www.lovecosmetic.jp/";
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)contactButtonPressed:(id)sender {
    BrowserViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"browser"];
    controller.url = @"https://secure.lovecosmetic.net/cs/others.html";
    [self.navigationController pushViewController:controller animated:YES];
}

- (int)getPush {
    if (iOS8) {
        UIUserNotificationType types = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
        return types;
    } else {
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        return types;
    }
}

-(NSString *) getUuid{
    NSString    *g_UUIDKey;
    // キーチェーンを検索
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [query setObject:@"uuid_news" forKey:(__bridge id)kSecAttrService];
    [query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [query setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
    
    CFTypeRef ref = nil;
    OSStatus res = SecItemCopyMatching((__bridge CFDictionaryRef)query, &ref);
    
    // ある場合、読み込み
    if( res == noErr )
    {
        NSMutableDictionary *item = [NSMutableDictionary dictionaryWithDictionary:(__bridge NSDictionary *)ref];
        [item setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        [item setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
        
        CFTypeRef pass = nil;
        res = SecItemCopyMatching((__bridge CFDictionaryRef)item, &pass);
        if( res == noErr )
        {
            NSData *data = (__bridge NSData *)pass;
            g_UUIDKey = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        }
    }
    return g_UUIDKey;
}

@end
