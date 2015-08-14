//
//  sokuhouData.m
//  NPlantsNews
//
//  Created by 于　超 on 2015/04/28.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import "SokuhouData.h"

@implementation SokuhouData

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    _date = [dict valueForKeyPath:@"date"];
    _title = [dict valueForKeyPath:@"title"];
    _imageUrl = [dict valueForKeyPath:@"image"];
    
    _url = [dict valueForKeyPath:@"url"];
    _sokuhouId = [dict valueForKeyPath:@"sokuhou_id"];
    return self;
}

@end
