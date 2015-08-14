//
//  sokuhouData.h
//  NPlantsNews
//
//  Created by 于　超 on 2015/04/28.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SokuhouData : NSObject

@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageUrl;

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSNumber *sokuhouId;

- (id)initWithDict:(NSDictionary *)dict;

@end
