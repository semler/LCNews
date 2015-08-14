//
//  SearchResultViewController.m
//  NPlantsNews
//
//  Created by 于　超 on 2015/04/09.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import "SearchResultViewController.h"
#import "SearchManager.h"
#import "NewsData.h"
#import "BrowserViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "VerticallyAlignedLabel.h"
#import "UIImageView+WebCache.h"
#import "ODRefreshControl.h"
#import "NewsTableViewCell.h"
#import "MenuManager.h"
#import "EmptyCell.h"

@interface SearchResultViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) ODRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *newsArray;
@property (nonatomic) int pageNo;
@property (nonatomic) BOOL scrollFlg;
@property (nonatomic) BOOL addFlg;
@property (nonatomic) BOOL emptyFlg;
@property (nonatomic) UILabel *result;

@property (weak, nonatomic) IBOutlet UILabel *keywordLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *label;

- (IBAction)returnButtonPressed:(id)sender;

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _newsArray = [NSMutableArray array];
    
    [self.navigationController.navigationBar setHidden:YES];
    _tableView.separatorInset = UIEdgeInsetsZero;
    
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:_tableView];
    [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refreshControl];
    _keywordLabel.text = [SearchManager sharedManager].keyword;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([MenuManager sharedManager].backFromWebFlg) {
        [MenuManager sharedManager].backFromWebFlg = NO;
        return;
    }
    
    _result.hidden = YES;
    _pageNo = 0;
    _keywordLabel.text = _keyWord;
    
    [_indicator startAnimating];
    _indicator.hidden = NO;
    _label.hidden = NO;
    
    [self performSelector:@selector(pull) withObject:nil afterDelay:0.0];
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
        EmptyCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[EmptyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell initFrame:@"ニュースがありません。"];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsData *data = [_newsArray objectAtIndex:[indexPath row]];
    
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
    NSDictionary* param = @{@"keyword" : _keyWord, @"page_no" : [NSString stringWithFormat:@"%d", _pageNo], @"page_count" : @"20", @"version" : version};
    [manager GET:SEARCH_API parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            NSLog(@"end: %d", _pageNo);
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([_newsArray count] != 0) {
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

- (IBAction)returnButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
