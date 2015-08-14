//
//  SokuhouTableViewCell.m
//  NPlantsNews
//
//  Created by 于　超 on 2015/05/31.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import "SokuhouTableViewCell.h"
#import "FMData.h"
#import "VerticallyAlignedLabel.h"
#import "UIImageView+WebCache.h"

@interface SokuhouTableViewCell () {
    UIView *view;
    UIImageView *bg;
    UIImageView *icon;
    UILabel *date;
    VerticallyAlignedLabel *title;
    UIImageView *imageView;
}
@end

@implementation SokuhouTableViewCell

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
    
    icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 15, 15)];
    icon.image = [UIImage imageNamed:@"icon_heart_unread.png"];
    
    date = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 145, 15)];
    date.font = [UIFont systemFontOfSize:13.0];
    date.textColor = [UIColor lightGrayColor];
    date.numberOfLines = 1;
    
    title = [[VerticallyAlignedLabel alloc] initWithFrame:CGRectMake(10, 35, screen.size.width-30, 55)];
    title.text = _data.title;
    title.verticalAlignment = VerticalAlignmentTop;
    title.font = [UIFont boldSystemFontOfSize:15.0];
    title.numberOfLines = 3;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(screen.size.width-130, 10, 110, 80)];
    imageView.layer.cornerRadius = 5.0f;
    imageView.layer.masksToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    view = [[UIView alloc] initWithFrame:CGRectMake(5, 5, screen.size.width-10, 100)];
    
    bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen.size.width-10, 100)];
    bg.image = [UIImage imageNamed:@"bg_cell.png"];
    
    [view addSubview:bg];
    [view addSubview:icon];
    [view addSubview:date];
    [view addSubview:imageView];
    [view addSubview:title];
    [self.contentView addSubview:view];
    
    return self;
}

- (void) initFrame: (NSMutableArray *)status {
    if (self) {
        CGRect screen = [[UIScreen mainScreen] bounds];
        
        for (int i = 0; i < [status count]; i ++) {
            FMData *fmData = [status objectAtIndex:i];
            if ([_data.sokuhouId integerValue] == fmData.number) {
                icon.image = [UIImage imageNamed:@"icon_heart_read.png"];
                break;
            }
        }
        
        date.text = _data.date;
        
        if (_data.imageUrl == nil || [@"" isEqual:_data.imageUrl] || [_data.imageUrl isEqual:[NSNull null]]) {
            title.text = _data.title;
            
            imageView.hidden = YES;
        } else {
            title.frame = CGRectMake(10, 35, screen.size.width-150, 55);
            title.text = _data.title;
            
            NSURL *url = [NSURL URLWithString:_data.imageUrl];
            [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"empty_news.png"] options:SDWebImageDelayPlaceholder];
            imageView.hidden = NO;
        }
    }
}

@end
