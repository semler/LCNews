//
//  MailData.h
//  NPlantsNews
//
//  Created by 于　超 on 2015/04/23.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MailData : NSObject

@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSNumber *mailId;

@property (nonatomic) BOOL firstFlg;
@property (nonatomic) BOOL readed;

- (id)initWithDict:(NSDictionary *)dict;

@end
