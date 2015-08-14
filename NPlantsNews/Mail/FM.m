//
//  FM.m
//  NPlantsNews
//
//  Created by 于　超 on 2015/04/28.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import "FM.h"
#import "FMDatabase.h"
#import <sqlite3.h>
#import "FMData.h"
#import "ColumnData.h"

@implementation FM

@synthesize delegate;

- (id)init {
    self = [super init];
    if (self != nil) {
        _dbPath = [self getPath];
        
        [self createColumnBD];
        [self createMailBD];
        [self createSokuhouBD];
        [self createNewsBD];
    }
    return self;
}

- (NSString*)getPath {
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"news.db"]];
    return path;
}

- (NSMutableArray *)getColumn {
    [self createColumnBD];
    
    NSMutableArray *array = [NSMutableArray array];
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    NSString *sql = @"SELECT number, date FROM column_status";
    
    [db open];
    FMResultSet *results = [db executeQuery:sql];
    
    while([results next]){
        FMData *data = [[FMData alloc] init];
        data.number = [results intForColumn:@"number"];
        data.date = [results stringForColumn:@"date"];
        [array addObject:data];
    }
    [db close];
    
    return array;
}

- (NSMutableArray *)getMail {
    [self createMailBD];
    
    NSMutableArray *array = [NSMutableArray array];
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    NSString *sql = @"SELECT number FROM mail_status";
    
    [db open];
    FMResultSet *results = [db executeQuery:sql];
    
    while([results next]){
        FMData *data = [[FMData alloc] init];
        data.number = [results intForColumn:@"number"];
        [array addObject:data];
    }
    [db close];
    
    return array;
}

- (NSMutableArray *)getSokuhou {
    [self createSokuhouBD];
    
    NSMutableArray *array = [NSMutableArray array];
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    NSString *sql = @"SELECT number FROM sokuhou_status";
    
    [db open];
    FMResultSet *results = [db executeQuery:sql];
    
    while([results next]){
        FMData *data = [[FMData alloc] init];
        data.number = [results intForColumn:@"number"];
        [array addObject:data];
    }
    [db close];
    
    return array;
}

- (void)createColumnBD {
    _dbPath = [self getPath];
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    [db open];
    [db close];
    
    NSString *sql1 = @"CREATE TABLE IF NOT EXISTS column_status (id INTEGER PRIMARY KEY AUTOINCREMENT, number INTEGER, date TEXT)";
    
    [db open];
    [db executeUpdate:sql1];
    [db close];
    
    NSString *sql2 = @"CREATE TABLE IF NOT EXISTS column (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, imageUrl TEXT, body TEXT, url TEXT, columnId INTEGER, date TEXT)";
    
    [db open];
    [db executeUpdate:sql2];
    [db close];
}

- (void)createMailBD {
    _dbPath = [self getPath];
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    [db open];
    [db close];
    
    NSString *sql1 = @"CREATE TABLE IF NOT EXISTS mail_status (id INTEGER PRIMARY KEY AUTOINCREMENT, number INTEGER)";
    
    [db open];
    [db executeUpdate:sql1];
    [db close];
    
    NSString *sql2 = @"CREATE TABLE IF NOT EXISTS mail (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, title TEXT, url TEXT, mailId INTEGER)";
    
    [db open];
    [db executeUpdate:sql2];
    [db close];
}

- (void)createSokuhouBD {
    _dbPath = [self getPath];
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    [db open];
    [db close];
    
    NSString *sql1 = @"CREATE TABLE IF NOT EXISTS sokuhou_status (id INTEGER PRIMARY KEY AUTOINCREMENT, number INTEGER)";
    
    [db open];
    [db executeUpdate:sql1];
    [db close];
    
    NSString *sql2 = @"CREATE TABLE IF NOT EXISTS sokuhou (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, title TEXT, imageUrl TEXT, url TEXT, sokuhouId INTEGER)";
    
    [db open];
    [db executeUpdate:sql2];
    [db close];
}

- (void)createNewsBD {
    _dbPath = [self getPath];
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    [db open];
    [db close];
    
    NSString *sql = @"CREATE TABLE IF NOT EXISTS news (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, source TEXT, imageUrl TEXT, url TEXT, newsId INTEGER, menu TEXT, subMenu TEXT)";
    
    [db open];
    [db executeUpdate:sql];
    [db close];
}

- (void)deleteNews:(NSString *)menu {
    _dbPath = [self getPath];
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    
    NSString *sql = @"DELETE FROM news WHERE menu = ?";
    [db open];
    [db executeUpdate:sql, menu];
    [db close];
}

- (void)saveNews:(NewsData *)data menu:(NSString *)menu {
    _dbPath = [self getPath];
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    
    NSString *sql = @"INSERT INTO news (title, source, imageUrl, url, newsId, menu, subMenu) VALUES (?, ?, ?, ?, ?, ?, ?)";
    [db open];
    [db executeUpdate:sql, data.title, data.source, data.imageUrl, data.url, [NSString stringWithFormat:@"%d", [data.newsId intValue]], menu, data.subCategory];
    [db close];
}

- (NSMutableArray *)getNews:(NSString *)menu {
    NSMutableArray *array = [NSMutableArray array];
    
    _dbPath = [self getPath];
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    
    NSString *sql = @"SELECT * FROM news WHERE menu = ?";
    [db open];
    FMResultSet *results = [db executeQuery:sql, menu];
    
    while([results next]){
        NewsData *data = [[NewsData alloc] init];
        data.title = [results stringForColumn:@"title"];
        data.source = [results stringForColumn:@"source"];
        data.imageUrl = [results stringForColumn:@"imageUrl"];
        data.url = [results stringForColumn:@"url"];
        data.newsId = [NSNumber numberWithInt:[results intForColumn:@"newsId"]];
        data.subCategory = [results stringForColumn:@"subMenu"];
        [array addObject:data];
    }
    [db close];
    
    return array;
}

- (void)deleteColumn {
    _dbPath = [self getPath];
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    
    NSString *sql = @"DELETE FROM column";
    [db open];
    [db executeUpdate:sql];
    [db close];
}

- (void)saveColumn:(ColumnData *)data {
    _dbPath = [self getPath];
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    
    NSString *sql = @"INSERT INTO column (title, imageUrl, body, url, columnId, date) VALUES (?, ?, ?, ?, ?, ?)";
    [db open];
    [db executeUpdate:sql, data.title, data.imageUrl, data.body, data.url, [NSString stringWithFormat:@"%d", [data.columnId intValue]], data.date];
    [db close];
}

- (NSMutableArray *)getColumnData {
    NSMutableArray *array = [NSMutableArray array];
    
    _dbPath = [self getPath];
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    
    NSString *sql = @"SELECT * FROM column";
    [db open];
    FMResultSet *results = [db executeQuery:sql];
    
    while([results next]){
        ColumnData *data = [[ColumnData alloc] init];
        data.title = [results stringForColumn:@"title"];
        data.imageUrl = [results stringForColumn:@"imageUrl"];
        data.body = [results stringForColumn:@"body"];
        data.url = [results stringForColumn:@"url"];
        data.columnId = [NSNumber numberWithInt:[results intForColumn:@"columnId"]];
        data.date = [results stringForColumn:@"date"];
        [array addObject:data];
    }
    [db close];
    
    return array;
}

- (void)updateColumn:(ColumnData *)data {
    _dbPath = [self getPath];
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    NSString *sql = @"SELECT * FROM column_status WHERE number = ?";
    
    [db open];
    FMResultSet *results = [db executeQuery:sql, [NSString stringWithFormat:@"%d", [data.columnId intValue]]];
    
    int count = 0;
    while([results next]){//必ず回す、そうしないと結果は0になる
        count = [results columnCount];
    }
    [db close];
    
    if (count == 0) {
        NSString *sql = @"INSERT INTO column_status (number, date) VALUES (?, ?)";
        
        [db open];
        [db executeUpdate:sql, [NSString stringWithFormat:@"%d", [data.columnId intValue]], data.date];
        [db close];
    } else {
        NSString *sql = @"UPDATE column_status SET date = ? WHERE number = ?";
        
        [db open];
        [db executeUpdate:sql, data.date, [NSString stringWithFormat:@"%d", [data.columnId intValue]]];
        [db close];
    }
}

- (void)deleteMail {
    _dbPath = [self getPath];
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    
    NSString *sql = @"DELETE FROM mail";
    [db open];
    [db executeUpdate:sql];
    [db close];
}

- (void)saveMail:(MailData *)data {
    _dbPath = [self getPath];
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    
    NSString *sql = @"INSERT INTO mail (date, title, url, mailId) VALUES (?, ?, ?, ?)";
    [db open];
    [db executeUpdate:sql, data.date, data.title, data.url, [NSString stringWithFormat:@"%d", [data.mailId intValue]]];
    [db close];
}

- (NSMutableArray *)getMailData {
    NSMutableArray *array = [NSMutableArray array];
    
    _dbPath = [self getPath];
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    
    NSString *sql = @"SELECT * FROM mail";
    [db open];
    FMResultSet *results = [db executeQuery:sql];
    
    while([results next]){
        MailData *data = [[MailData alloc] init];
        data.date = [results stringForColumn:@"date"];
        data.title = [results stringForColumn:@"title"];
        data.url = [results stringForColumn:@"url"];
        data.mailId = [NSNumber numberWithInt:[results intForColumn:@"mailId"]];
        [array addObject:data];
    }
    [db close];
    
    return array;
}

- (void)updateMail:(int)number {
    _dbPath = [self getPath];
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    NSString *sql = @"SELECT * FROM mail_status WHERE number = ?";
    
    [db open];
    FMResultSet *results = [db executeQuery:sql, [NSString stringWithFormat:@"%d", number]];
    
    int count = 0;
    while([results next]){//必ず回す、そうしないと結果は0になる
        count = [results columnCount];
    }
    [db close];
    
    if (count == 0) {
        NSString *sql = @"INSERT INTO mail_status (number) VALUES (?)";
        
        [db open];
        [db executeUpdate:sql, [NSString stringWithFormat:@"%d", number]];
        [db close];
    }
}

- (void)deleteSokuhou {
    _dbPath = [self getPath];
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    
    NSString *sql = @"DELETE FROM sokuhou";
    [db open];
    [db executeUpdate:sql];
    [db close];
}

- (void)saveSokuhou:(SokuhouData *)data {
    _dbPath = [self getPath];
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    
    NSString *sql = @"INSERT INTO sokuhou (date, title, imageUrl, url, sokuhouId) VALUES (?, ?, ?, ?, ?)";
    [db open];
    [db executeUpdate:sql, data.date, data.title, data.imageUrl, data.url, [NSString stringWithFormat:@"%d", [data.sokuhouId intValue]]];
    [db close];
}

- (NSMutableArray *)getSokuhouData {
    NSMutableArray *array = [NSMutableArray array];
    
    _dbPath = [self getPath];
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    
    NSString *sql = @"SELECT * FROM sokuhou";
    [db open];
    FMResultSet *results = [db executeQuery:sql];
    
    while([results next]){
        SokuhouData *data = [[SokuhouData alloc] init];
        data.date = [results stringForColumn:@"date"];
        data.title = [results stringForColumn:@"title"];
        data.imageUrl = [results stringForColumn:@"imageUrl"];
        data.url = [results stringForColumn:@"url"];
        data.sokuhouId = [NSNumber numberWithInt:[results intForColumn:@"sokuhouId"]];
        [array addObject:data];
    }
    [db close];
    
    return array;
}

- (void)updateSokuhou:(int)number {
    _dbPath = [self getPath];
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    NSString *sql = @"SELECT * FROM sokuhou_status WHERE number = ?";
    
    [db open];
    FMResultSet *results = [db executeQuery:sql, [NSString stringWithFormat:@"%d", number]];
    
    int count = 0;
    while([results next]){//必ず回す、そうしないと結果は0になる
        count = [results columnCount];
    }
    [db close];
    
    if (count == 0) {
        NSString *sql = @"INSERT INTO sokuhou_status (number) VALUES (?)";
        
        [db open];
        [db executeUpdate:sql, [NSString stringWithFormat:@"%d", number]];
        [db close];
    }
}

@end
