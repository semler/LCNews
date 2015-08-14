//
//  MailTableViewCell.m
//  NPlantsNews
//
//  Created by 于　超 on 2015/05/31.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import "MailTableViewCell.h"
#import "FMData.h"
#import "VerticallyAlignedLabel.h"

@interface MailTableViewCell () {
    UIView *view;
    UILabel *date;
    VerticallyAlignedLabel *title;
    UIImageView *icon1;
    UIImageView *icon2;
    UIView *pink;
}
@end

@implementation MailTableViewCell

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
    
    date = [[UILabel alloc] initWithFrame:CGRectMake(50 , 10, 180, 15)];
    date.font = [UIFont systemFontOfSize:13.0];
    date.textColor = [UIColor lightGrayColor];
    date.numberOfLines = 1;
    
    title = [[VerticallyAlignedLabel alloc] initWithFrame:CGRectMake(50, 30, screen.size.width-90, 50)];
    title.verticalAlignment = VerticalAlignmentTop;
    title.font = [UIFont boldSystemFontOfSize:16.0];
    title.textColor = [UIColor blackColor];
    title.numberOfLines = 2;
    
    icon1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 37, 22, 15)];
    icon1.image = [UIImage imageNamed:@"icon_mailbox_on.png"];
    icon2 = [[UIImageView alloc] initWithFrame:CGRectMake(screen.size.width-30, 40, 8, 12)];
    icon2.image = [UIImage imageNamed:@"btn_arrow_on.png"];
    
    view = [[UIView alloc] initWithFrame:CGRectMake(5, 5, screen.size.width-10, 89)];
    view.backgroundColor = [UIColor whiteColor];
    
    pink = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen.size.width-10, 2)];
    pink.backgroundColor = [UIColor colorWithRed:1 green:0.667 blue:0.804 alpha:1];
    pink.hidden = YES;
    
    [view addSubview:icon1];
    [view addSubview:date];
    [view addSubview:title];
    [view addSubview:icon2];
    [view addSubview:pink];
    [self.contentView addSubview:view];
    
    return self;
}

- (void) initFrame: (NSMutableArray *)status {
    if (self) {
        date.text = _data.date;
        
        title.text = _data.title;
        
        for (int i = 0; i < [status count]; i ++) {
            FMData *fmData = [status objectAtIndex:i];
            if ([_data.mailId integerValue] == fmData.number) {
                icon1.frame = CGRectMake(icon1.frame.origin.x, icon1.frame.origin.y-4, 22, 23);
                icon1.image = [UIImage imageNamed:@"icon_mailbox_off.png"];
                title.textColor = [UIColor lightGrayColor];
                icon2.image = [UIImage imageNamed:@"btn_arrow_off.png"];
                break;
            }
        }
        
        if (_data.firstFlg) {
            pink.hidden = NO;
        } else {
            pink.hidden = YES;
        }
    }
}

@end
