//
//  MenuManager.h
//  NPlantsNews
//
//  Created by 于　超 on 2015/03/19.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NewsContentViewController.h"

@interface MenuManager : NSObject
// タブ移動距離
@property (nonatomic) int tabMoveSet;
// サブメニュー幅
@property (nonatomic) int subMenuWidth;
// メニュー
@property (strong, nonatomic) NSMutableArray *menuArray;
// タブwidth
@property (strong, nonatomic) NSMutableArray *tabWidthArray;
// ラベルテキスト
@property (strong, nonatomic) NSMutableArray *menuTextArray;
// メニュー色
@property (strong, nonatomic) NSMutableArray *colorArray;
// 並び替え画像
@property (strong, nonatomic) NSMutableArray *imageArray;
// ニュース
@property (strong, nonatomic) NSMutableArray *newsArray;
// ニュース
@property (strong, nonatomic) NSMutableArray *currentNewsArray;
// 選択したmenu
//@property (nonatomic) int currentIndex;
// 選択したmenu
@property (nonatomic) int lastIndex;
// 選択したボディmenu
@property (nonatomic) int bodyMenuIndex;
// 選択した恋menu
@property (nonatomic) int loveMenuIndex;
// 前選択したタブ
@property (nonatomic) CGRect lastTabframe;
// 選択したタブ
@property (nonatomic) CGRect nextTabframe;

// ソートフラグ
@property (nonatomic) BOOL menuSortFlg;
// リロード
@property (nonatomic) BOOL reloadFlg;
// リロード
@property (nonatomic) BOOL backFromWebFlg;
//
@property (nonatomic) BOOL touchMenuFlg;
//
@property (strong, nonatomic) NewsContentViewController *currentController;

+ (MenuManager *)sharedManager;

- (void)initLabel;
- (void)sortManuArray:(NSArray *)array;
//- (void)add:(NSArray *)array;

@end
