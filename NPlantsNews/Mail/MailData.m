//
//  MailData.m
//  NPlantsNews
//
//  Created by 于　超 on 2015/04/23.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import "MailData.h"

@implementation MailData

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    _date = [dict valueForKeyPath:@"date"];
    _title = [dict valueForKeyPath:@"title"];
    _url = [dict valueForKeyPath:@"url"];
    _mailId = [dict valueForKeyPath:@"mail_id"];
    return self;
}

@end
