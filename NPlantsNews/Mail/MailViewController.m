//
//  MailViewController.m
//  NPlantsNews
//
//  Created by 于　超 on 2015/03/19.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import "MailViewController.h"
#import "MailData.h"
#import "VerticallyAlignedLabel.h"
#import "BrowserViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "FM.h"
#import "FMData.h"
#import "UIImageView+WebCache.h"
#import "EmptyCell.h"
#import "MailTableViewCell.h"
#import "ODRefreshControl.h"
#import "MenuManager.h"
#import "FMManager.h"

@interface MailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) ODRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *mailArray;
@property (strong, nonatomic) NSMutableArray *status;
@property (nonatomic) BOOL addFlg;
@property (nonatomic) BOOL scrollFlg;
@property (nonatomic) BOOL emptyFlg;
@property (nonatomic) int pageNo;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic) int totalCount;

@end

@implementation MailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mailArray = [NSMutableArray array];
    
    [self.navigationController.navigationBar setHidden:YES];
    _tableView.separatorInset = UIEdgeInsetsZero;
    
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:_tableView];
    [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refreshControl];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
    FM *fm = [[FM alloc] init];
    _status = [fm getMail];
    
    if ([MenuManager sharedManager].backFromWebFlg) {
        [MenuManager sharedManager].backFromWebFlg = NO;
        [_tableView reloadData];
        return;
    }
    
    _indicator.hidden = YES;
    _label.hidden = YES;
    FMManager *manager = [[FMManager alloc] init];
    NSMutableArray *array = [manager getMailData];
    if ([array count] != 0) {
        _mailArray = array;
        [_tableView reloadData];
    } else {
        [_indicator startAnimating];
        _indicator.hidden = NO;
        _label.hidden = NO;
    }
    
    _pageNo = 0;
    [self performSelector:@selector(pull) withObject:nil afterDelay:0.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Table Viewのセクション数を指定
- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_emptyFlg) {
        return 1;
    } else {
        return [_mailArray count];
    }
}

// セル高さ
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    
    if (_mailArray != nil && [_mailArray count] != 0) {
        MailData *data = [_mailArray objectAtIndex:[indexPath row]];
        
        if ([indexPath row] == 0) {
            data.firstFlg = YES;
        } else {
            data.firstFlg = NO;
        }
        
        MailTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[MailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.data = data;
        [cell initFrame:_status];
        return cell;
    } else {
        EmptyCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[EmptyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell initFrame:@"メールがありません。"];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_emptyFlg) {
        return;
    }
    
    MailData *data = [_mailArray objectAtIndex:[indexPath row]];
    
    FM *fm = [[FM alloc] init];
    [fm updateMail:[data.mailId intValue]];
    _status = [fm getMail];
    
    //チェックメール
    _totalCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"total_count"] intValue];
    if (_totalCount == [_status count]) {
        NSNotification *notification =[NSNotification notificationWithName:@"redOff" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    
    if (data.url != nil && ![@""isEqual:data.url]) {
        BrowserViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"browser"];
        controller.url = data.url;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_tableView.contentSize.height < 90 * 20) {
        return;
    }
    
    //一番下までスクロールしたかどうか
    if(_tableView.contentOffset.y >= (_tableView.contentSize.height - _tableView.bounds.size.height))
    {
        if (!_scrollFlg) {
            _scrollFlg = YES;
            _addFlg = YES;
            _pageNo ++;
            NSLog(@"XXXXXXXXXXXXXXXXXX %d %@", _pageNo, _tableView);
            [self pull];
        }
    }
}

- (void)refresh:(ODRefreshControl *)refreshControl
{
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        _pageNo = 0;
        [self pull];
        [refreshControl endRefreshing];
    });
}

- (void) pull {
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSDictionary* param = @{@"page_no" : [NSString stringWithFormat:@"%d", _pageNo], @"page_count" : @"20", @"version" : version};
    [manager GET:MAIL_API parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // データ取得
        if (!_addFlg) {
            [_mailArray removeAllObjects];
        }
        _addFlg = NO;
        
        for (NSDictionary * dict in responseObject[@"mail"]) {
            [_mailArray addObject:[[MailData alloc] initWithDict:dict]];
        }
        
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            _scrollFlg = NO;
            NSLog(@"end: %d", _pageNo);
        });
        
        if ([_mailArray count] == 0) {
            _emptyFlg = YES;
        } else {
            _emptyFlg = NO;
        }
        
        [_tableView reloadData];
        
        [_indicator stopAnimating];
        _indicator.hidden = YES;
        _label.hidden = YES;
        
        FMManager *manager = [[FMManager alloc] init];
        [manager saveMail:_mailArray];
        FM *fm = [[FM alloc] init];
        _status = [fm getMail];
        
        _totalCount = [responseObject[@"total_count"] intValue];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:_totalCount] forKey:@"total_count"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (_totalCount == [_status count]) {
            NSNotification *notification =[NSNotification notificationWithName:@"redOff" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([_mailArray count] != 0) {
            _emptyFlg = NO;
        } else {
            _emptyFlg = YES;
            [_tableView reloadData];
        }
        [_indicator stopAnimating];
        _indicator.hidden = YES;
        _label.hidden = YES;
    }];
}

@end
