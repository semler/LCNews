//
//  NewsTableViewCell.h
//  NPlantsNews
//
//  Created by 于　超 on 2015/05/29.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerticallyAlignedLabel.h"
#import "NewsData.h"

@interface NewsTableViewCell : UITableViewCell

@property (strong, nonatomic) NewsData *data;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void) initFrame;

@end
