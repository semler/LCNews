//
//  NewsViewController.m
//  NPlantsNews
//
//  Created by 于　超 on 2015/03/19.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsContentViewController.h"
#import "SearchViewController.h"
#import "SettingViewController.h"
#import "MenuManager.h"
#import "NewsContentViewController.h"
#import "LabelView.h"

@interface NewsViewController ()

@property (nonatomic) NSUInteger numberOfTabs;
@property (nonatomic) NewsContentViewController *controller;

@property (nonatomic) UIView *bodySubmenu;
@property (nonatomic) UIView *loveSubmenu;
@property (nonatomic) UIButton *clearButton;

@property (nonatomic) BOOL subOnFlg;

- (IBAction)searchButtonPressed:(id)sender;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    
    self.dataSource = self;
    self.delegate = self;
    
    _bodySubmenu.hidden = YES;
    _loveSubmenu.hidden = YES;
    _clearButton.hidden = YES;
    _subOnFlg = NO;
    
    [self loadContent];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"reload" object:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _clearButton.hidden = YES;
    _bodySubmenu.hidden = YES;
    _loveSubmenu.hidden = YES;
    _subOnFlg = NO;
}

- (void)reload {
    if ([MenuManager sharedManager].reloadFlg) {
        [MenuManager sharedManager].reloadFlg = NO;
        [self loadContent];
        //[self selectTabAtIndex:[MenuManager sharedManager].currentIndex];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadContent {
    [self setNumberOfTabs:[[MenuManager sharedManager].menuArray count]];
}

#pragma mark - Setters
- (void)setNumberOfTabs:(NSUInteger)numberOfTabs {
    // Set numberOfTabs
    _numberOfTabs = numberOfTabs;
    
    // Reload data
    [self reloadData];
}

#pragma mark - Interface Orientation Changes
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // Update changes after screen rotates
    [self performSelector:@selector(setNeedsReloadOptions) withObject:nil afterDelay:duration];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return _numberOfTabs;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    //UILabel *label = [[MenuManager sharedManager].menuArray objectAtIndex:index];
    UIView *view = [[MenuManager sharedManager].menuArray objectAtIndex:index];
    return view;
    //return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    if (index == [[MenuManager sharedManager].tabWidthArray count] - 1) {
        SettingViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"setting"];
        return controller;
    } else {
        _controller = [self.storyboard instantiateViewControllerWithIdentifier:@"content"];
        _controller.index = (int)index;
        return _controller;
    }
}

#pragma mark - ViewPagerDelegate
- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index {
    
    for (int i = 0; i < [[MenuManager sharedManager].tabWidthArray count]; i ++) {
        LabelView *view = [[MenuManager sharedManager].menuArray objectAtIndex:i];
        if (i == index) {
            UILabel *label1 = view.label1;
            label1.backgroundColor = [[MenuManager sharedManager].colorArray objectAtIndex:i];
            label1.textColor = [UIColor whiteColor];
            UILabel *label2 = view.label2;
            label2.backgroundColor = [[MenuManager sharedManager].colorArray objectAtIndex:i];
            label2.textColor = [UIColor whiteColor];
        } else {
            UILabel *label1 = view.label1;
            label1.backgroundColor = [UIColor clearColor];
            label1.textColor = [[MenuManager sharedManager].colorArray objectAtIndex:i];
            UILabel *label2 = view.label2;
            label2.backgroundColor = [UIColor clearColor];
            label2.textColor = [[MenuManager sharedManager].colorArray objectAtIndex:i];
        }
        
    }
}

- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
            break;
        case ViewPagerOptionTabLocation:
            return 1.0;
            break;
        default:
            break;
    }
    
    return value;
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [UIColor redColor];
            break;
        default:
            break;
    }
    
    return color;
}

- (void)showBodySubmenu {
    if (_subOnFlg) {
        return;
    }
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    _clearButton = [[UIButton alloc] initWithFrame:screen];
    _clearButton.backgroundColor = [UIColor blackColor];
    _clearButton.alpha = 0.5;
    [_clearButton addTarget:self action:@selector(clearButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    _bodySubmenu = [[UIView alloc] initWithFrame:CGRectMake(0, 85, 147, 290)];
    _bodySubmenu.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 147, 290)];
    imageView.image = [UIImage imageNamed:@"body_center.png"];
    
    CGRect frame = _bodySubmenu.frame;
    int screenWidth = screen.size.width;
    int tabCenter = [MenuManager sharedManager].nextTabframe.origin.x + [MenuManager sharedManager].nextTabframe.size.width/2;
    
    if (tabCenter < screenWidth/2) {
        frame.origin.x = tabCenter-[MenuManager sharedManager].subMenuWidth/2;
        if (frame.origin.x < 0) {
            frame.origin.x = 0;
            imageView.image = [UIImage imageNamed:@"body_left.png"];
        }
    } else if (tabCenter > 810-screenWidth/2) {
        frame.origin.x = screenWidth/2+tabCenter-(810-screenWidth/2)-[MenuManager sharedManager].subMenuWidth/2;
    }
    else {
        frame.origin.x = screenWidth/2-[MenuManager sharedManager].subMenuWidth/2;
    }
    
    _bodySubmenu.frame = frame;
    [_bodySubmenu addSubview:imageView];
    
    NSMutableArray *subArray = [NSMutableArray arrayWithObjects:@"全選択", @"カラダ" ,@"フェイス", @"ヘア", @"バスト", @"デリケート", nil];
    for (int i = 0; i < 6; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(3, 16+44*i, 138, 40)];
        [button setTitle:[subArray objectAtIndex:i] forState:UIControlStateNormal];
        
        if ([button.titleLabel.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"body"]]) {
            [button setTitleColor:[UIColor colorWithRed:0.318 green:0.604 blue:0.91 alpha:1] forState:UIControlStateNormal];
            button.titleLabel.font =  [UIFont fontWithName:@"HiraKakuProN-W6" size:15];
        } else {
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        }
        button.backgroundColor = [UIColor clearColor];
        [button setBackgroundImage:[UIImage imageNamed:@"submenu.png"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(bodyButtonPressed:)forControlEvents:UIControlEventTouchUpInside];
        
        [_bodySubmenu addSubview:button];
    }
    
    [self.view addSubview:_clearButton];
    [self.view addSubview:_bodySubmenu];
    _subOnFlg = YES;
    _controller.pageNo = 0;
}

- (void)showLoveSubmenu {
    if (_subOnFlg) {
        return;
    }
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    _clearButton = [[UIButton alloc] initWithFrame:screen];
    _clearButton.backgroundColor = [UIColor blackColor];
    _clearButton.alpha = 0.5;
    [_clearButton addTarget:self action:@selector(clearButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    _loveSubmenu = [[UIView alloc] initWithFrame:CGRectMake(0, 85, 147, 334)];
    _loveSubmenu.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 147, 334)];
    imageView.image = [UIImage imageNamed:@"love_center.png"];
    
    CGRect frame = _loveSubmenu.frame;
    int screenWidth = screen.size.width;
    int tabCenter = [MenuManager sharedManager].nextTabframe.origin.x + [MenuManager sharedManager].nextTabframe.size.width/2;
    
    if (tabCenter < screenWidth/2) {
        frame.origin.x = tabCenter-[MenuManager sharedManager].subMenuWidth/2;
        if (frame.origin.x < 0) {
            frame.origin.x = 0;
            imageView.image = [UIImage imageNamed:@"love_left.png"];
        }
    } else if (tabCenter > 810-screenWidth/2) {
        frame.origin.x = screenWidth/2+tabCenter-(810-screenWidth/2)-[MenuManager sharedManager].subMenuWidth/2;
    }
    else {
        frame.origin.x = screenWidth/2-[MenuManager sharedManager].subMenuWidth/2;
    }
    
    _loveSubmenu.frame = frame;
    [_loveSubmenu addSubview:imageView];
    
    NSMutableArray *subArray = [NSMutableArray arrayWithObjects:@"全選択", @"恋始める" ,@"想い叶う", @"デート準備", @"キスに夢中", @"彼に秘密", @"恋休憩", nil];
    for (int i = 0; i < 7; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(3, 16+44*i, 138, 44)];
        [button setTitle:[subArray objectAtIndex:i] forState:UIControlStateNormal];
        
        if ([button.titleLabel.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"love"]]) {
            [button setTitleColor:[UIColor colorWithRed:0.318 green:0.604 blue:0.91 alpha:1] forState:UIControlStateNormal];
            button.titleLabel.font =  [UIFont fontWithName:@"HiraKakuProN-W6" size:15];
        } else {
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        }
        button.backgroundColor = [UIColor clearColor];
        [button setBackgroundImage:[UIImage imageNamed:@"submenu.png"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(loveButtonPressed:)forControlEvents:UIControlEventTouchUpInside];
        
        [_loveSubmenu addSubview:button];
    }
    
    [self.view addSubview:_clearButton];
    [self.view addSubview:_loveSubmenu];
    _subOnFlg = YES;
    _controller.pageNo = 0;
}

- (IBAction)searchButtonPressed:(id)sender {
    SearchViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"search"];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)bodyButtonPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    [[NSUserDefaults standardUserDefaults] setObject:button.titleLabel.text forKey:@"body"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _bodySubmenu.hidden = YES;
    _clearButton.hidden = YES;
    _subOnFlg = NO;
    NSNotification *notification =[NSNotification notificationWithName:@"pullFromSub" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)loveButtonPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    [[NSUserDefaults standardUserDefaults] setObject:button.titleLabel.text forKey:@"love"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _loveSubmenu.hidden = YES;
    _clearButton.hidden = YES;
    _subOnFlg = NO;
    NSNotification *notification =[NSNotification notificationWithName:@"pullFromSub" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)clearButtonPressed{
    _clearButton.hidden = YES;
    _bodySubmenu.hidden = YES;
    _loveSubmenu.hidden = YES;
    _subOnFlg = NO;
}

@end
