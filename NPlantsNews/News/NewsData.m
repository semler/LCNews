//
//  NewsData.m
//  NPlantsNews
//
//  Created by 于　超 on 2015/04/03.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import "NewsData.h"

@implementation NewsData

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    _title = [dict valueForKeyPath:@"title"];
    _source = [dict valueForKeyPath:@"source"];
    _imageUrl = [dict valueForKeyPath:@"image"];
    _url = [dict valueForKeyPath:@"url"];
    _newsId = [dict valueForKeyPath:@"news_id"];
    _subCategory = [dict valueForKeyPath:@"sub_category"];
    return self;
}

@end
