//
//  SearchManager.h
//  NPlantsNews
//
//  Created by 于　超 on 2015/04/08.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchManager : NSObject

// 検索履歴
@property (strong, nonatomic) NSString *keyword;
@property (strong, nonatomic) NSMutableArray *history;

+ (SearchManager *)sharedManager;

@property (strong, nonatomic) NSMutableArray *resultArray;

-(void)addHistory:(NSString *)keyWord;


@end
