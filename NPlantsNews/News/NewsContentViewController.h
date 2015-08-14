//
//  NewsContentViewController.h
//  NPlantsNews
//
//  Created by 于　超 on 2015/03/19.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsContentViewController : UIViewController

@property (nonatomic) int index;
@property (nonatomic) int pageNo;

- (void) pull;

@end
