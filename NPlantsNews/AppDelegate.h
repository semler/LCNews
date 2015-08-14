//
//  AppDelegate.h
//  NPlantsNews
//
//  Created by 于　超 on 2015/03/19.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TutorialViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UITabBarController *tabBarController;
    NSString    *g_UUIDKey;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TutorialViewController *tutorial;
@property (strong, nonatomic) UINavigationController *mailController;
@property (nonatomic) int totalCount;

#pragma mark method prototype
- (void)switchTabBarController:(NSInteger)selectedViewIndex;

@end

