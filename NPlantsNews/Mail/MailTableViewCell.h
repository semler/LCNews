//
//  MailTableViewCell.h
//  NPlantsNews
//
//  Created by 于　超 on 2015/05/31.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MailData.h"

@interface MailTableViewCell : UITableViewCell

@property (strong, nonatomic) MailData *data;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void) initFrame: (NSMutableArray *)status;

@end
