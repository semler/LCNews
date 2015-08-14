//
//  NewsEmptyCell.m
//  NPlantsNews
//
//  Created by 于　超 on 2015/05/30.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import "EmptyCell.h"

@implementation EmptyCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.contentView.backgroundColor = [UIColor colorWithRed:0.894 green:0.906 blue:0.918 alpha:1];
    return self;
}

- (void) initFrame:(NSString *)str {
    CGRect screen = [[UIScreen mainScreen] bounds];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((screen.size.width-200)/2, 20, 200, 30)];
    label.font = [UIFont systemFontOfSize:17.0];
    label.textColor = [UIColor colorWithRed:0.412 green:0.616 blue:0.831 alpha:1];
    label.text = str;
    label.textAlignment = NSTextAlignmentCenter;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:label];
}

@end
