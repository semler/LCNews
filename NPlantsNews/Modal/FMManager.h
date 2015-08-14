//
//  FMManager.h
//  NPlantsNews
//
//  Created by 于　超 on 2015/05/28.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMManager : NSObject

- (void)saveNews:(NSMutableArray *)array menu:(NSString *)category;
- (NSMutableArray *)getNews:(NSString *)category;
- (void)saveColumn:(NSMutableArray *)array;
- (NSMutableArray *)getColumnData;
- (void)saveMail:(NSMutableArray *)array;
- (NSMutableArray *)getMailData;
- (void)saveSokuhou:(NSMutableArray *)array;
- (NSMutableArray *)getSokuhouData;

@end
