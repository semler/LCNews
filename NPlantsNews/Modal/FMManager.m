//
//  FMManager.m
//  NPlantsNews
//
//  Created by 于　超 on 2015/05/28.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import "FMManager.h"
#import "NewsData.h"
#import "MenuManager.h"
#import "FM.h"
#import "ColumnData.h"
#import "MailData.h"
#import "SokuhouData.h"

@implementation FMManager

- (void)saveNews:(NSMutableArray *)array  menu:(NSString *)category {
    FM *fm = [[FM alloc] init];
    [fm deleteNews:category];
    
    NewsData *data;
    
    int count;
    if ([[[MenuManager sharedManager].menuTextArray objectAtIndex:0] isEqualToString:category]) {
        count = (int)[array count];
    } else {
        count = 20;
    }
    for (int i = 0; i < [array count]; i ++) {
        if (i >= count) {
            break;
        }
        data = [array objectAtIndex:i];
        [fm saveNews:data menu:category];
    }
}

- (NSMutableArray *)getNews:(NSString *)category {
    FM *fm = [[FM alloc] init];
    NSMutableArray *array = [fm getNews:category];
    
    return array;
}

- (void)saveColumn:(NSMutableArray *)array {
    FM *fm = [[FM alloc] init];
    [fm deleteColumn];
    
    ColumnData *data;
    for (int i = 0; i < [array count]; i ++) {
        if (i >= 20) {
            break;
        }
        data = [array objectAtIndex:i];
        [fm saveColumn:data];
    }

}

- (NSMutableArray *)getColumnData {
    FM *fm = [[FM alloc] init];
    NSMutableArray *array = [fm getColumnData];
    
    return array;
}

- (void)saveMail:(NSMutableArray *)array {
    FM *fm = [[FM alloc] init];
    [fm deleteMail];
    
    MailData *data;
    for (int i = 0; i < [array count]; i ++) {
        if (i >= 20) {
            break;
        }
        data = [array objectAtIndex:i];
        [fm saveMail:data];
    }
    
}

- (NSMutableArray *)getMailData {
    FM *fm = [[FM alloc] init];
    NSMutableArray *array = [fm getMailData];
    
    return array;
}

- (void)saveSokuhou:(NSMutableArray *)array {
    FM *fm = [[FM alloc] init];
    [fm deleteSokuhou];
    
    SokuhouData *data;
    for (int i = 0; i < [array count]; i ++) {
        if (i >= 20) {
            break;
        }
        data = [array objectAtIndex:i];
        [fm saveSokuhou:data];
    }
    
}

- (NSMutableArray *)getSokuhouData {
    FM *fm = [[FM alloc] init];
    NSMutableArray *array = [fm getSokuhouData];
    
    return array;
}

@end
