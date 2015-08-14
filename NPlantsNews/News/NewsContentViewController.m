//
//  NewsContentViewController.m
//  NPlantsNews
//
//  Created by 于　超 on 2015/03/19.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import "NewsContentViewController.h"
#import "MenuManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "NewsData.h"
#import "BrowserViewController.h"
#import "VerticallyAlignedLabel.h"
#import "FM.h"
#import "ViewPagerController.h"
#import "NewsViewController.h"
#import "FMManager.h"
#import "NewsTableViewCell.h"
#import "ODRefreshControl.h"
#import "EmptyCell.h"

@interface NewsContentViewController () <UITableViewDelegate, UITableViewDataSource> {
    AFHTTPRequestOperationManager* afManager;
}

@property (strong, nonatomic) ODRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *newsArray;
@property (nonatomic) BOOL addFlg;
@property (nonatomic) BOOL scrollFlg;
@property (nonatomic) BOOL emptyFlg;
@property (nonatomic) BOOL firstFlg;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation NewsContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _newsArray = [NSMutableArray array];
    
    [self.navigationController.navigationBar setHidden:YES];
    _tableView.separatorInset = UIEdgeInsetsZero;
    
    
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:_tableView];
    [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refreshControl];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pullFromSub) name:@"pullFromSub" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([MenuManager sharedManager].backFromWebFlg) {
        return;
    }
    
    FMManager *manager = [[FMManager alloc] init];
    
    _indicator.hidden = YES;
    _label.hidden = YES;
    NSString *category = [[MenuManager sharedManager].menuTextArray objectAtIndex:_index];
    NSMutableArray *array = [manager getNews:category];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", (int)_index] forKey:@"index"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([array count] != 0) {
        _firstFlg = NO;
        _newsArray = array;
        [_tableView reloadData];
    } else {
        _firstFlg = YES;
        [_indicator startAnimating];
        _indicator.hidden = NO;
        _label.hidden = NO;
    }
    
    _pageNo = 0;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([MenuManager sharedManager].backFromWebFlg) {
        [MenuManager sharedManager].backFromWebFlg = NO;
        return;
    }
    
    NSLog(@"%d", [MenuManager sharedManager].lastIndex);
    NSLog(@"%d", _index);
    
    if (_index != [MenuManager sharedManager].lastIndex) {
        [self performSelector:@selector(pull) withObject:nil afterDelay:0.1];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [afManager.operationQueue cancelAllOperations];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Table Viewのセクション数を指定
- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_emptyFlg) {
        return 1;
    } else {
        return [_newsArray count];
    }
}

// セル高さ
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    
    if (_newsArray != nil && [_newsArray count] != 0) {
        NewsData *data = [_newsArray objectAtIndex:[indexPath row]];
        NewsTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[NewsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.data = data;
        [cell initFrame];
        return cell;
    } else {
        NSString *message;
        if (_firstFlg) {
            message = @"";
        } else {
            message = @"ニュースがありません。";
        }
        EmptyCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[EmptyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell initFrame:message];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_emptyFlg) {
        return;
    }
    _addFlg = NO;
    
    NewsData *data = [_newsArray objectAtIndex:[indexPath row]];
    if (data.url != nil && ![@""isEqual:data.url]) {
        BrowserViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"browser"];
        controller.url = data.url;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_index == 0) {
        return;
    }
    
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
        _scrollFlg = YES;
        [self pull];
        [refreshControl endRefreshing];
    });
}

-(void)pullFromSub {
    if (_index == [MenuManager sharedManager].lastIndex) {
        [self performSelector:@selector(pull) withObject:nil afterDelay:0.1];
    }
}

- (void) pull {
    // 多重呼び出し防止
    if (![MenuManager sharedManager].touchMenuFlg &&[MenuManager sharedManager].lastIndex != -1 && _index != [MenuManager sharedManager].lastIndex) {
        return;
    }
    [MenuManager sharedManager].touchMenuFlg = NO;
    
    afManager = [AFHTTPRequestOperationManager manager];
    if (_index == 0) {
        NSString *category = [[MenuManager sharedManager].menuTextArray objectAtIndex:_index];
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSDictionary* param = @{@"version" : version};
        [afManager GET:TOP_API parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // データ取得
            [_newsArray removeAllObjects];
            
            for (NSDictionary * dict in responseObject[@"news"]) {
                [_newsArray addObject:[[NewsData alloc] initWithDict:dict]];
            }
            
            double delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                _scrollFlg = NO;
            });
            
            if ([_newsArray count] == 0) {
                _emptyFlg = YES;
            } else {
                _emptyFlg = NO;
            }
            
            [_tableView reloadData];
            
            [_indicator stopAnimating];
            _indicator.hidden = YES;
            _label.hidden = YES;
            
            FMManager *manager = [[FMManager alloc] init];
            [manager saveNews:_newsArray menu:category];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if ([_newsArray count] != 0) {
                _emptyFlg = NO;
            } else {
                _emptyFlg = YES;
                [_tableView reloadData];
            }
            _scrollFlg = NO;
            [_indicator stopAnimating];
            _indicator.hidden = YES;
            _label.hidden = YES;
        }];
    } else {
        NSString *category = [[MenuManager sharedManager].menuTextArray objectAtIndex:[[[NSUserDefaults standardUserDefaults] objectForKey:@"index"] intValue]];
        if (category == nil || [@"" isEqualToString:category]) {
            category = [[MenuManager sharedManager].menuTextArray objectAtIndex:0];
        }
        
        NSString *subCategory;
        if ([@"磨く" isEqualToString:category]) {
            subCategory = [[NSUserDefaults standardUserDefaults] objectForKey:@"body"];
            if (subCategory == nil || [@"全選択" isEqualToString:subCategory]) {
                subCategory = @"";
            }
        } else if ([@"恋する" isEqualToString:category]) {
            subCategory = [[NSUserDefaults standardUserDefaults] objectForKey:@"love"];
            if (subCategory == nil || [@"全選択" isEqualToString:subCategory]) {
                subCategory = @"";
            }
        } else {
            subCategory = @"";
        }
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSDictionary* param = @{@"category" : category, @"sub_category" : subCategory, @"page_no" : [NSString stringWithFormat:@"%d", _pageNo], @"page_count" : @"20", @"version" : version};
        [afManager GET:NEWS_API parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // データ取得
            if (!_addFlg) {
                [_newsArray removeAllObjects];
            }
            _addFlg = NO;
            
            for (NSDictionary * dict in responseObject[@"news"]) {
                [_newsArray addObject:[[NewsData alloc] initWithDict:dict]];
            }
            
            double delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                _scrollFlg = NO;
            });
            
            if ([_newsArray count] == 0) {
                _emptyFlg = YES;
            } else {
                _emptyFlg = NO;
            }
            
            [_tableView reloadData];
            
            [_indicator stopAnimating];
            _indicator.hidden = YES;
            _label.hidden = YES;
            
            FMManager *manager = [[FMManager alloc] init];
            [manager saveNews:_newsArray menu:category];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if ([_newsArray count] != 0) {
                _emptyFlg = NO;
            } else {
                _emptyFlg = YES;
                [_tableView reloadData];
            }
            _scrollFlg = NO;
            [_indicator stopAnimating];
            _indicator.hidden = YES;
            _label.hidden = YES;
        }];
    }
}

@end
