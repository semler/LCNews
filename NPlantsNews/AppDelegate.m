//
//  AppDelegate.m
//  NPlantsNews
//
//  Created by 于　超 on 2015/03/19.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import "AppDelegate.h"
#import "AFHTTPRequestOperationManager.h"
#import "TutorialViewController.h"
#import "MailData.h"
#import "FM.h"
#import "MenuManager.h"
#import <CoreLocation/CoreLocation.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define iOS8 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redOff) name:@"redOff" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redOn) name:@"redOn" object:nil];
    
    //メソッドの有無でOSを判別
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
        
        //iOS8
        //デバイストークの取得
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        //許可アラートの表示
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        
        //iOS7
        UIRemoteNotificationType types =UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert| UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
    
    // window初期化
    [self initWindow];
    
    // UITabBarController初期化
    [self initTabBarController];
    
    // 初回起動の場合
    if ([self isFirstRun]) {
//        int type = [self getPush];
//        if (type == 0) {
//            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"push"];
//            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"mail"];
//            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sokuhou"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        } else {
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"push"];
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"mail"];
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sokuhou"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"push"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"mail"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sokuhou"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"全選択" forKey:@"body"];
        [[NSUserDefaults standardUserDefaults] setObject:@"全選択" forKey:@"love"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [MenuManager sharedManager].lastIndex = -1;
        
        // チュートレアル
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _tutorial = [storyboard instantiateViewControllerWithIdentifier:@"tutorial"];
        [_tutorial showTutorial:self.window.rootViewController];
        
        // uuidをkeychainに保存
        [self getKeychain];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"index"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

// window初期化
- (void)initWindow
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    _window = [[UIWindow alloc] initWithFrame:bounds];
}

// UITabBarController初期化
- (void)initTabBarController
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, screen.size.height-49, screen.size.width, 49)];
    view.backgroundColor = [UIColor colorWithRed:0.412 green:0.616 blue:0.831 alpha:1];
    [_window addSubview:view];
    
    // 基点となる Controller生成
    tabBarController = [[UITabBarController alloc] init];
    
    // タブの背景画像と選択時の背景を設定
    [UITabBar appearance].barTintColor = [UIColor colorWithRed:0.412 green:0.616 blue:0.831 alpha:1];
    
    // タブメニュー選択時のビュー生成
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *newsController = [storyboard instantiateViewControllerWithIdentifier:@"news"];
    UINavigationController *columnController = [storyboard instantiateViewControllerWithIdentifier:@"column"];
    _mailController = [storyboard instantiateViewControllerWithIdentifier:@"mail"];
    UINavigationController *sokuhouController = [storyboard instantiateViewControllerWithIdentifier:@"sokuhou"];
    
    [newsController.navigationController.navigationBar setHidden:YES];
    [columnController.navigationController.navigationBar setHidden:YES];
    [_mailController.navigationController.navigationBar setHidden:YES];
    [sokuhouController.navigationController.navigationBar setHidden:YES];
   
    // iOS7以降用のタブバー生成
    if ([self isIOS7]) {
        // タブのアイコン指定
        newsController.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil
                                                                  image:[[UIImage imageNamed:@"news_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                          selectedImage:[[UIImage imageNamed:@"news_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
        columnController.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil
                                                                   image:[[UIImage imageNamed:@"column_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                           selectedImage:[[UIImage imageNamed:@"column_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        _mailController.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil
                                                                  image:[[UIImage imageNamed:@"mail_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                          selectedImage:[[UIImage imageNamed:@"mail_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        sokuhouController.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil
                                                                   image:[[UIImage imageNamed:@"sokuhou_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                           selectedImage:[[UIImage imageNamed:@"sokuhou_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        newsController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        columnController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        _mailController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        sokuhouController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        
    }
    
    // チェックメール
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"total_count"] == nil) {
        _mailController.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil
                                                                   image:[[UIImage imageNamed:@"icon_mail_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                           selectedImage:[[UIImage imageNamed:@"icon_mail_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        _mailController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    } else {
        _totalCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"total_count"] intValue];
        
        AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSDictionary* param = @{@"page_no" : @"0", @"page_count" : @"20", @"version" : version};
        [manager GET:MAIL_API parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // データ取得
            _totalCount = [responseObject[@"total_count"] intValue];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:_totalCount] forKey:@"total_count"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            FM *manager = [[FM alloc] init];
            NSMutableArray *array = [manager getMail];
            if ([array count] != _totalCount) {
                _mailController.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil
                                                                           image:[[UIImage imageNamed:@"icon_mail_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                   selectedImage:[[UIImage imageNamed:@"icon_mail_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                _mailController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            FM *manager = [[FM alloc] init];
            NSMutableArray *array = [manager getMail];
            if ([array count] != _totalCount) {
                _mailController.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil
                                                                           image:[[UIImage imageNamed:@"icon_mail_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                   selectedImage:[[UIImage imageNamed:@"icon_mail_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                _mailController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
            }
        }];
    }
    
    // タブのタイトル位置設定
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -2)];
    
    // ビューを Controllerに追加
    NSArray *controllers = [NSArray arrayWithObjects:newsController, columnController, _mailController, sokuhouController, nil];
    [(UITabBarController *) tabBarController setViewControllers:controllers animated:NO];
    
    // windowに Controllerのビュー追加
    [_window addSubview:tabBarController.view];
    _window.rootViewController = tabBarController;
    [_window makeKeyAndVisible];
}

// iOS7以降であるか
- (BOOL)isIOS7
{
    NSString *osversion = [UIDevice currentDevice].systemVersion;
    NSArray *a = [osversion componentsSeparatedByString:@"."];
    return ([(NSString*)[a objectAtIndex:0] intValue] >= 7);
}

// デバイストークン発行成功
- (void)application:(UIApplication*)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)devToken{
    
    NSString *device_id = [[[devToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:device_id forKey:@"token"];
    if (device_id != nil && ![@""isEqualToString:device_id]) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"push"];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"mail"];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sokuhou"];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"push"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"mail"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sokuhou"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // uuidをkeychainに保存
    [self getKeychain];
    
    // サーバー送信
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *pushFlag;
    NSString *mailFlag;
    NSString *sokuhouFlag;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"push"]) {
        pushFlag = @"1";
    } else {
        pushFlag = @"0";
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"mail"]) {
        mailFlag = @"1";
    } else {
        mailFlag = @"0";
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"sokuhou"]) {
        sokuhouFlag = @"1";
    } else {
        sokuhouFlag = @"0";
    }
    
    NSDictionary* param = @{@"uuid" : g_UUIDKey, @"device_token" : device_id, @"app_version" : version, @"push_info_flag" : pushFlag, @"push_mail_flag" : mailFlag, @"push_sokuhou_flag" : sokuhouFlag};
    [manager POST:TOKEN_API parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (BOOL)isFirstRun
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults objectForKey:@"firstStart"]) {
        // 日時が設定済みなら初回起動でない
        return NO;
    }
    
    // 初回起動日時を設定
    [userDefaults setObject:[NSDate date] forKey:@"firstStart"];
    
    // 保存
    [userDefaults synchronize];
    
    // 初回起動
    return YES;
}

// デバイストークン発行失敗
- (void)application:(UIApplication*)app didFailToRegisterForRemoteNotificationsWithError:(NSError*)err{
    //
}

// タブ切り替え
- (void)switchTabBarController:(NSInteger)selectedViewIndex
{
    UITabBarController *controller = (UITabBarController *)tabBarController;
    controller.selectedViewController = [controller.viewControllers objectAtIndex:selectedViewIndex];
}

- (void)redOff {
    _mailController.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil
                                                               image:[[UIImage imageNamed:@"mail_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                       selectedImage:[[UIImage imageNamed:@"mail_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    _mailController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
}

- (void)redOn {
    _mailController.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil
                                                               image:[[UIImage imageNamed:@"icon_mail_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                       selectedImage:[[UIImage imageNamed:@"icon_mail_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    _mailController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
}

// uuidをkeychainに保存
-(void) getKeychain {
    
    // キーチェーンを検索
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [query setObject:@"uuid_news" forKey:(__bridge id)kSecAttrService];
    [query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [query setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
    
    CFTypeRef ref = nil;
    OSStatus res = SecItemCopyMatching((__bridge CFDictionaryRef)query, &ref);
    
    // ない場合、新規作成
    if( res != noErr ) {
        // 新規作成
        CFUUIDRef uuidRef = CFUUIDCreate( kCFAllocatorDefault );
        CFStringRef uuidStr = CFUUIDCreateString( kCFAllocatorDefault, uuidRef );
        CFRelease( uuidRef );
        
        g_UUIDKey = [NSString stringWithFormat:@"%@", uuidStr];
        NSLog(@"%@", g_UUIDKey);
        
        // キーチェイン登録
        NSMutableDictionary *item = [NSMutableDictionary dictionary];
        [item setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        [item setObject:@"uuid_news" forKey:(__bridge id)kSecAttrService];
        [item setObject:[g_UUIDKey dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
        
        SecItemAdd((__bridge CFDictionaryRef)item, nil);
        CFRelease( uuidStr );
    } else {
        // 取得
        NSMutableDictionary *item = [NSMutableDictionary dictionaryWithDictionary:(__bridge NSDictionary *)ref];
        [item setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        [item setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
        
        CFTypeRef pass = nil;
        res = SecItemCopyMatching((__bridge CFDictionaryRef)item, &pass);
        if( res == noErr )
        {
            NSData *data = (__bridge NSData *)pass;
            g_UUIDKey = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            NSLog(@"%@", g_UUIDKey);
        }
    }
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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = -1;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
