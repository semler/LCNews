//
//  FM.h
//  NPlantsNews
//
//  Created by 于　超 on 2015/04/28.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsData.h"
#import "ColumnData.h"
#import "MailData.h"
#import "SokuhouData.h"

@protocol FMDelegate <NSObject>

//

@end

@interface FM : NSObject

@property (nonatomic, assign) id<FMDelegate> delegate;

@property (nonatomic) NSString *dbPath;

- (NSMutableArray *)getColumn;
- (NSMutableArray *)getMail;
- (NSMutableArray *)getSokuhou;
- (void)updateColumn:(ColumnData *)data;
- (void)updateMail:(int)number;
- (void)updateSokuhou:(int)number;

- (void)deleteNews:(NSString *)menu;
- (void)saveNews:(NewsData *)data menu:(NSString *)menu;
- (NSMutableArray *)getNews:(NSString *)menu;
- (void)deleteColumn;
- (void)saveColumn:(ColumnData *)data;
- (NSMutableArray *)getColumnData;
- (void)deleteMail;
- (void)saveMail:(MailData *)data;
- (NSMutableArray *)getMailData;
- (void)deleteSokuhou;
- (void)saveSokuhou:(SokuhouData *)data;
- (NSMutableArray *)getSokuhouData;

@end
