//
//  ColumnTableViewCell.m
//  NPlantsNews
//
//  Created by 于　超 on 2015/05/31.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import "ColumnTableViewCell.h"
#import "VerticallyAlignedLabel.h"
#import "UIImageView+WebCache.h"
#import "FMData.h"

@interface ColumnTableViewCell () {
    UIView *view;
    UIImageView *bg;
    VerticallyAlignedLabel *title;
    UIImageView *imageView;
    VerticallyAlignedLabel *body;
    UIImageView *icon;
    UIImageView *text;
}
@end

@implementation ColumnTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.contentView.backgroundColor = [UIColor colorWithRed:0.894 green:0.906 blue:0.918 alpha:1];
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    title = [[VerticallyAlignedLabel alloc] initWithFrame:CGRectMake(128, 10, screen.size.width-153, 55)];
    title.verticalAlignment = VerticalAlignmentTop;
    title.font = [UIFont boldSystemFontOfSize:15.0];
    title.numberOfLines = 3;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 100, 65)];
    imageView.layer.cornerRadius = 5.0f;
    imageView.layer.masksToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.hidden = NO;
    
    body = [[VerticallyAlignedLabel alloc] initWithFrame:CGRectMake(15, 85, screen.size.width-40, 35)];
    body.verticalAlignment = VerticalAlignmentTop;
    body.font = [UIFont systemFontOfSize:13.0];
    body.textColor = [UIColor blackColor];
    body.numberOfLines = 3;
    
    icon = [[UIImageView alloc] initWithFrame:CGRectMake(2, 129, 51, 20)];
    icon.image = [UIImage imageNamed:@"icon_new.png"];
    icon.hidden = NO;
    
    text = [[UIImageView alloc] initWithFrame:CGRectMake(screen.size.width-10-59-15, 128, 59, 12)];
    text.image = [UIImage imageNamed:@"btn_readmore.png"];

    view = [[UIView alloc] initWithFrame:CGRectMake(5, 5, screen.size.width-10, 150)];
    
    bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen.size.width-10, 150)];
    bg.image = [UIImage imageNamed:@"bg_column.png"];

    [view addSubview:bg];
    [view addSubview:title];
    [view addSubview:body];
    [view addSubview:imageView];
    [view addSubview:icon];
    [view addSubview:text];
    [self.contentView addSubview:view];
    
    return self;
}

- (void) initFrame: (NSMutableArray *)status {
    if (self) {
        CGRect screen = [[UIScreen mainScreen] bounds];
        
        if (_data.imageUrl == nil || [@"" isEqual:_data.imageUrl] || [_data.imageUrl isEqual:[NSNull null]]) {
            title.frame = CGRectMake(15, 10, screen.size.width-40, 55);
            title.text = _data.title;
            imageView.hidden = YES;
        } else {
            title.text = _data.title;
            
            NSURL *url = [NSURL URLWithString:_data.imageUrl];
            [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"empty_news.png"] options:SDWebImageDelayPlaceholder];
            imageView.hidden = NO;
        }
        
        body.text = _data.body;
        
        for (int i = 0; i < [status count]; i ++) {
            FMData *fmData = [status objectAtIndex:i];
            if ([_data.columnId integerValue] == fmData.number && [fmData.date isEqual:_data.date]) {
                icon.hidden = YES;
                break;
            } else {
                icon.hidden = NO;
            }
        }
    }
}

@end
