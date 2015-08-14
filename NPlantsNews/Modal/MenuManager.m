//
//  MenuManager.m
//  NPlantsNews
//
//  Created by 于　超 on 2015/03/19.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import "MenuManager.h"
#import "LabelView.h"

@implementation MenuManager

static MenuManager *menuManager = nil;

+ (MenuManager *)sharedManager{
    if (!menuManager) {
        menuManager = [[MenuManager alloc] init];
    }
    return menuManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        if (!_menuSortFlg) {
            [self initTabFrame];
            [self initColor];
            [self initText];
            [self initLabel];
            [self initSubMenu];
            [self initImage];
            [self initNewsArray];
            _touchMenuFlg = NO;
        }
    }
    
    NSMutableArray *menu = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"menu"]];
    NSMutableArray *tabWidth = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"tabWidth"]];
    NSMutableArray *menuText = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"menuText"]];
    NSMutableArray *color = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"bodyIndex"] != nil) {
        _bodyMenuIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:@"bodyIndex"] intValue];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"loveIndex"] != nil) {
        _loveMenuIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:@"loveIndex"] intValue];
    }
    
    if (menu != nil && [menu count] != 0) {
        _menuArray = menu;
    }
    if (tabWidth != nil && [tabWidth count] != 0) {
        _tabWidthArray = tabWidth;
    }
    if (menuText != nil && [menuText count] != 0) {
        _menuTextArray = menuText;
    }
    if (color != nil && [color count] != 0) {
        _colorArray = color;
    }
    [self initLabel];
    
    return self;
}

- (void)initTabFrame {
    CGRect screen = [[UIScreen mainScreen] bounds];
    int screenWidth = screen.size.width;
    _tabMoveSet = screenWidth/2-40;
    _subMenuWidth = 140.0;
    _tabWidthArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:79.0], [NSNumber numberWithFloat:65.0], [NSNumber numberWithFloat:79.0], [NSNumber numberWithFloat:79.0], [NSNumber numberWithFloat:79.0], [NSNumber numberWithFloat:79.0], [NSNumber numberWithFloat:79.0], [NSNumber numberWithFloat:79.0], [NSNumber numberWithFloat:79.0], [NSNumber numberWithFloat:110.0], nil];
}

- (void)initColor {
    
    _colorArray = [NSMutableArray arrayWithObjects:[UIColor colorWithRed:0.49 green:0.49 blue:0.773 alpha:1], [UIColor colorWithRed:0.863 green:0.627 blue:0.949 alpha:1], [UIColor colorWithRed:1 green:0.6 blue:0.769 alpha:1], [UIColor colorWithRed:0.996 green:0.522 blue:0.522 alpha:1], [UIColor colorWithRed:1 green:0.698 blue:0.4 alpha:1], [UIColor colorWithRed:0.569 green:0.871 blue:0.384 alpha:1], [UIColor colorWithRed:0.384 green:0.871 blue:0.6 alpha:1], [UIColor colorWithRed:0.463 green:0.831 blue:0.886 alpha:1], [UIColor colorWithRed:0.561 green:0.624 blue:0.937 alpha:1], [UIColor colorWithRed:0.439 green:0.439 blue:0.443 alpha:1], nil];
}

- (void)initText {
    
    _menuTextArray = [NSMutableArray arrayWithObjects:@"TOP", @"磨く", @"恋する" ,@"楽しむ", @"旅する", @"暮らす", @"食べる", @"はまる", @"のぞく", @"設定・希望", nil];
}

- (void)initLabel {
    
    _menuArray = [NSMutableArray array];
    
    UILabel *label;
    UILabel *label2;
    for (int i = 0; i < [_tabWidthArray count]; i ++) {
        NSNumber *number = [self.tabWidthArray objectAtIndex:i];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [number intValue]-14, 26.0)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:14.0];
        label.text = [_menuTextArray objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [_colorArray objectAtIndex:0];
        
        LabelView *view = [[LabelView alloc] initWithFrame:CGRectMake(0, 0, [number intValue]-14, 26.0)];
        view.backgroundColor = [UIColor clearColor];
        
        label2 = [[UILabel alloc] initWithFrame:CGRectMake([number intValue]-14-20, 0, 20, 26.0)];
        label2.backgroundColor = [UIColor clearColor];
        label2.font = [UIFont boldSystemFontOfSize:7.0];
        label2.text = @"▼";
        label2.textAlignment = NSTextAlignmentCenter;
        label2.textColor = [_colorArray objectAtIndex:0];
        if ([[_menuTextArray objectAtIndex:i] isEqualToString:@"磨く"] || [[_menuTextArray objectAtIndex:i] isEqualToString:@"恋する"]) {
            label.frame = CGRectMake(0, 0, [number intValue]-14-15, 26.0);
            label.textAlignment = NSTextAlignmentRight;
            
            // 角丸
            UIBezierPath *maskPath;
            maskPath = [UIBezierPath bezierPathWithRoundedRect:label.bounds
                                             byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft)
                                                   cornerRadii:CGSizeMake(13.0, 13.0)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = label.bounds;
            maskLayer.path = maskPath.CGPath;
            label.layer.mask = maskLayer;
            
            UIBezierPath *maskPath2;
            maskPath2 = [UIBezierPath bezierPathWithRoundedRect:label2.bounds
                                             byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight)
                                                   cornerRadii:CGSizeMake(13.0, 13.0)];
            CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
            maskLayer2.frame = label2.bounds;
            maskLayer2.path = maskPath2.CGPath;
            label2.layer.mask = maskLayer2;
            
            [view addSubview:label2];
            [view addSubview:label];
            view.label1 = label;
            view.label2 = label2;
        } else {
            // 角丸
            label.layer.cornerRadius = 13;
            [label setClipsToBounds:YES];
            label2.frame = CGRectMake(0, 0, 0, 0);
            [view addSubview:label];
            view.label1 = label;
            view.label2 = label2;
        }
        
        [_menuArray addObject:view];
    }
}

- (void)initSubMenu {
    _bodyMenuIndex = 1;
    _loveMenuIndex = 2;
}

- (void)initImage {
    _imageArray = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"cell_migaku.png"], [UIImage imageNamed:@"cell_love.png"], [UIImage imageNamed:@"cell_enjoy.png"], [UIImage imageNamed:@"cell_travel.png"], [UIImage imageNamed:@"cell_live.png"], [UIImage imageNamed:@"cell_eat.png"], [UIImage imageNamed:@"cell_hamaru.png"], [UIImage imageNamed:@"cell_nozoku.png"], nil];
}

- (void)initNewsArray {
    _currentNewsArray = [NSMutableArray array];
    _newsArray = [NSMutableArray arrayWithObjects:[NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], nil];
}

- (void)sortManuArray:(NSArray *)array {
    
    // テキスト
    NSMutableArray *tempText = [NSMutableArray array];
    for (NSString *text in _menuTextArray) {
        [tempText addObject:text];
    }
    
    // タブサイズ
    NSMutableArray *tempWidth = [NSMutableArray array];
    for (NSNumber *width in _tabWidthArray) {
        [tempWidth addObject:width];
    }
    
    // ラベル
    NSMutableArray *temp = [NSMutableArray array];
    for (UIView *view in _menuArray) {
        [temp addObject:view];
    }
    
    // 画像
    NSMutableArray *tempImage = [NSMutableArray array];
    for (UIImage *image in _imageArray) {
        [tempImage addObject:image];
    }
    
    // 最後は設定ボタン
    for (int i = 0; i < 8; i ++) {
        int index = [array[i] intValue]+1;
        NSString *text = [tempText objectAtIndex:i+1];
        [_menuTextArray replaceObjectAtIndex:index withObject:text];
        
        NSNumber *width = [tempWidth objectAtIndex:i+1];
        [_tabWidthArray replaceObjectAtIndex:index withObject:width];
        
        UILabel *view = [temp objectAtIndex:i+1];
        [_menuArray replaceObjectAtIndex:index withObject:view];
        
        UIImage *image = [tempImage objectAtIndex:i];
        [_imageArray replaceObjectAtIndex:index-1 withObject:image];
    }
    
    // 選択したmenu 設定以外
    for (int i = 0; i < 8; i ++) {
        int index = [array[i] intValue]+1;
        
        // 選択したmenu
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"index"] intValue] == i) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", index] forKey:@"index"];
            [[NSUserDefaults standardUserDefaults] synchronize];;
            break;
        }
    }
    
    // サブmenuの場所
    for (int i = 0; i < 8; i ++) {
        int index = [array[i] intValue]+1;
        
        if (i+1 == _bodyMenuIndex) {
            _bodyMenuIndex = index;
            break;
        }
    }
    for (int i = 0; i < 8; i ++) {
        int index = [array[i] intValue]+1;
        
        if (i+1 == _loveMenuIndex) {
            _loveMenuIndex = index;
            break;
        }
    }
}

@end
