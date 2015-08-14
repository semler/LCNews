//
//  NewsData.h
//  NPlantsNews
//
//  Created by 于　超 on 2015/04/03.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NewsData : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSNumber *newsId;
@property (nonatomic, strong) NSString *subCategory;

- (id)initWithDict:(NSDictionary *)dict;

@end
