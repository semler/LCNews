//
//  SokuhouViewController.m
//  NPlantsNews
//
//  Created by 于　超 on 2015/03/19.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import "SokuhouViewController.h"
#import "SokuhouData.h"
#import "VerticallyAlignedLabel.h"
#import "BrowserViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "FM.h"
#import "FMData.h"
#import "ODRefreshControl.h"
#import "MenuManager.h"
#import "EmptyCell.h"
#import "SokuhouTableViewCell.h"
#import "FMManager.h"

@interface SokuhouViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) ODRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *sokuhouArray;
@property (strong, nonatomic) NSMutableArray *status;
@property (nonatomic) BOOL addFlg;
@property (nonatomic) BOOL scrollFlg;
@property (nonatomic) BOOL emptyFlg;
@property (nonatomic) int pageNo;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation SokuhouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sokuhouArray = [NSMutableArray array];
    
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
    _status = [fm getSokuhou];
    
    if ([MenuManager sharedManager].backFromWebFlg) {
        [MenuManager sharedManager].backFromWebFlg = NO;
        [_tableView reloadData];
        return;
    }
    
    _indicator.hidden = YES;
    _label.hidden = YES;
    FMManager *manager = [[FMManager alloc] init];
    NSMutableArray *array = [manager getSokuhouData];
    if ([array count] != 0) {
        _sokuhouArray = array;
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
        return [_sokuhouArray count];
    }
}

// セル高さ
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    
    if (_sokuhouArray != nil && [_sokuhouArray count] != 0) {
        SokuhouData *data = [_sokuhouArray objectAtIndex:[indexPath row]];
        SokuhouTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[SokuhouTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.data = data;
        [cell initFrame:_status];
        return cell;
    } else {
        EmptyCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[EmptyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell initFrame:@"速報がありません。"];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_emptyFlg) {
        return;
    }
    
    SokuhouData *data = [_sokuhouArray objectAtIndex:[indexPath row]];
    
    FM *fm = [[FM alloc] init];
    [fm updateSokuhou:[data.sokuhouId intValue]];
    
    if (data.url != nil && ![@""isEqual:data.url]) {
        BrowserViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"browser"];
        controller.url = data.url;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_tableView.contentSize.height < 110 * 20) {
        return;
    }
    
    //一番下までスクロールしたかどうか
    if(_tableView.contentOffset.y >= (_tableView.contentSize.height - _tableView.bounds.size.height))
    {
        if (!_scrollFlg) {
            _addFlg = YES;
            _scrollFlg = YES;
            _pageNo ++;
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
    [manager GET:SOKUHOU_API parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // データ取得
        if (!_addFlg) {
            [_sokuhouArray removeAllObjects];
        }
        _addFlg = NO;
        
        for (NSDictionary * dict in responseObject[@"sokuhou"]) {
            [_sokuhouArray addObject:[[SokuhouData alloc] initWithDict:dict]];
        }
        
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            _scrollFlg = NO;
            NSLog(@"end: %d", _pageNo);
        });
        
        if ([_sokuhouArray count] == 0) {
            _emptyFlg = YES;
        } else {
            _emptyFlg = NO;
        }
        
        [_tableView reloadData];
        
        [_indicator stopAnimating];
        _indicator.hidden = YES;
        _label.hidden = YES;
        
        FMManager *manager = [[FMManager alloc] init];
        [manager saveSokuhou:_sokuhouArray];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([_sokuhouArray count] != 0) {
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
