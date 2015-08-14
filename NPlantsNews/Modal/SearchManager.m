//
//  SearchManager.m
//  NPlantsNews
//
//  Created by 于　超 on 2015/04/08.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import "SearchManager.h"

@implementation SearchManager

static SearchManager *searchManager = nil;

+ (SearchManager *)sharedManager{
    if (!searchManager) {
        searchManager = [[SearchManager alloc] init];
    }
    return searchManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _history = [[[NSUserDefaults standardUserDefaults] objectForKey:@"history"] mutableCopy];
        
        if (_history == nil) {
            _history = [NSMutableArray array];
        }
    }
    return self;
}

-(void)addHistory:(NSString *)keyWord {
    
    for (int i = 0; i < [_history count]; i ++) {
        NSString *history = [_history objectAtIndex:i];
        if ([history isEqualToString:keyWord]) {
            [_history removeObject:history];
            [_history addObject:keyWord];
            return;
        }
    }
    
    if ([_history count] < 5) {
        [_history addObject:keyWord];
    } else {
        NSString *history;
        for (int i = 1; i < 5; i ++) {
            history = [_history objectAtIndex:i];
            [_history replaceObjectAtIndex:i-1 withObject:history];
        }
        [_history replaceObjectAtIndex:4 withObject:keyWord];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_history forKey:@"history"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
