//
//  NewsTableViewCell.m
//  NPlantsNews
//
//  Created by 于　超 on 2015/05/29.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MenuManager.h"

@interface NewsTableViewCell () {
    VerticallyAlignedLabel *title;
    UIImageView *image;
    UIImageView *bg;
    UIView *view;
    UILabel *source;
    UILabel *subMenu;
}

@end

@implementation NewsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.contentView.backgroundColor = [UIColor colorWithRed:0.894 green:0.906 blue:0.918 alpha:1];
    
    view = [[UIView alloc] initWithFrame:CGRectMake(5, 5, screen.size.width-10, 100)];
    
    bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen.size.width-10, 100)];
    bg.image = [UIImage imageNamed:@"bg_cell.png"];
    
    title = [[VerticallyAlignedLabel alloc] initWithFrame:CGRectMake(10, 10, screen.size.width-150, 55)];
    title.verticalAlignment = VerticalAlignmentTop;
    title.font = [UIFont boldSystemFontOfSize:15.0];
    title.numberOfLines = 3;
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(screen.size.width-130, 10, 110, 80)];
    image.layer.cornerRadius = 5.0f;
    image.layer.masksToBounds = YES;
    image.contentMode = UIViewContentModeScaleAspectFill;
    
    [view addSubview:bg];
    [view addSubview:title];
    [view addSubview:image];
    
    // font色
    NSString *category = [[MenuManager sharedManager].menuTextArray objectAtIndex:[[[NSUserDefaults standardUserDefaults] objectForKey:@"index"] intValue]];
    NSString *subCategory;
    if ([@"磨く" isEqualToString:category]) {
        subCategory = [[NSUserDefaults standardUserDefaults] objectForKey:@"body"];
        subMenu = [[UILabel alloc] initWithFrame:CGRectMake(10, 72, 100, 20)];
        subMenu.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:11];
        subMenu.numberOfLines = 0;
        subMenu.textAlignment = NSTextAlignmentLeft;
        if ([@"全選択" isEqualToString:subCategory]) {
            subMenu.textColor = [UIColor lightGrayColor];
        } else {
            subMenu.textColor = [[MenuManager sharedManager].colorArray objectAtIndex:[[[NSUserDefaults standardUserDefaults] objectForKey:@"index"] intValue]];
        }
        [view addSubview:subMenu];
    } else if ([@"恋する" isEqualToString:category]) {
        subCategory = [[NSUserDefaults standardUserDefaults] objectForKey:@"love"];
        subMenu = [[UILabel alloc] initWithFrame:CGRectMake(10, 72, 100, 20)];
        subMenu.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:11];
        subMenu.numberOfLines = 0;
        subMenu.textAlignment = NSTextAlignmentLeft;
        if ([@"全選択" isEqualToString:subCategory]) {
            subMenu.textColor = [UIColor lightGrayColor];
        } else {
            subMenu.textColor = [[MenuManager sharedManager].colorArray objectAtIndex:[[[NSUserDefaults standardUserDefaults] objectForKey:@"index"] intValue]];
        }
        [view addSubview:subMenu];
    } else {
        
    }
    source = [[UILabel alloc] initWithFrame:CGRectMake(10, 72, 170, 20)];
    source.font = [UIFont systemFontOfSize:11.0];
    source.textColor = [UIColor lightGrayColor];
    
    [view addSubview:source];
    [self.contentView addSubview:view];
    
    return self;
}

- (void) initFrame {
    if (self) {
        CGRect screen = [[UIScreen mainScreen] bounds];
        
        if (_data.imageUrl == nil || [@"" isEqual:_data.imageUrl] || [_data.imageUrl isEqual:[NSNull null]]) {
            title.frame = CGRectMake(10, 10, screen.size.width-30, 55);
            title.text = _data.title;
            image.hidden = YES;
        } else {
            title.text = _data.title;
    
            NSURL *url = [NSURL URLWithString:_data.imageUrl];
            [image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"empty_news.png"] options:SDWebImageDelayPlaceholder];
            image.hidden = NO;
        }
        
        NSString *category = [[MenuManager sharedManager].menuTextArray objectAtIndex:[[[NSUserDefaults standardUserDefaults] objectForKey:@"index"] intValue]];
        subMenu.text = _data.subCategory;
        if ([@"磨く" isEqualToString:category]) {
            if (_data.source != nil && ![@"" isEqualToString:_data.source]) {
                int width = [subMenu.text sizeWithAttributes:@{NSFontAttributeName:subMenu.font}].width;
                subMenu.frame = CGRectMake(10, 72, width+5, 20);
                source.frame = CGRectMake(width+10, 72, 150, 20);
                source.text = [NSString stringWithFormat:@" | %@", _data.source];
            }
        } else if ([@"恋する" isEqualToString:category]) {
            if (_data.source != nil && ![@"" isEqualToString:_data.source]) {
                int width = [subMenu.text sizeWithAttributes:@{NSFontAttributeName:subMenu.font}].width;
                subMenu.frame = CGRectMake(10, 72, width+5, 20);
                source.frame = CGRectMake(width+10, 72, 150, 20);
                source.text = [NSString stringWithFormat:@" | %@", _data.source];
            }
        } else {
            source.text = _data.source;
        }
    }
}

@end
