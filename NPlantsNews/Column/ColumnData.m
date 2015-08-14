//
//  ColumnData.m
//  NPlantsNews
//
//  Created by 于　超 on 2015/04/17.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import "ColumnData.h"

@implementation ColumnData

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    _title = [dict valueForKeyPath:@"title"];
    _body = [dict valueForKeyPath:@"body"];
    _imageUrl = [dict valueForKeyPath:@"image"];
    _url = [dict valueForKeyPath:@"url"];
    _columnId = [dict valueForKeyPath:@"column_id"];
    _date = [dict valueForKeyPath:@"date"];
    return self;
}

@end
