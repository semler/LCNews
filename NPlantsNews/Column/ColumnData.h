//
//  ColumnData.h
//  NPlantsNews
//
//  Created by 于　超 on 2015/04/17.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ColumnData : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *body;

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSNumber *columnId;

@property (nonatomic, strong) NSString *date;

- (id)initWithDict:(NSDictionary *)dict;

@end
