//
//  HelpViewController.m
//  NPlantsNews
//
//  Created by 于　超 on 2015/06/12.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

- (IBAction)backButtonPressed:(id)sender;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height-64;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [_scrollView setContentSize:CGSizeMake((2*width), height)];
    
    UIImageView *bg1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    bg1.image = [UIImage imageNamed:@"bg_tutorial_b_1.png"];
    [_scrollView addSubview:bg1];
    UIImageView *bg2 = [[UIImageView alloc]initWithFrame:CGRectMake(width, 0, width, height)];
    bg2.image = [UIImage imageNamed:@"bg_tutorial_b_2.png"];
    [_scrollView addSubview:bg2];
    
    _pageControl.numberOfPages = 2;
    _pageControl.currentPage = 0;
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.455 green:0.651 blue:0.851 alpha:1];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.804 green:0.902 blue:1 alpha:1];
    _pageControl.userInteractionEnabled = YES;
    
    if ([UIScreen mainScreen].bounds.size.height < 500) {
        self.view.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1];
        bg1.contentMode = UIViewContentModeScaleAspectFit;
        bg2.contentMode = UIViewContentModeScaleAspectFit;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    _pageControl.currentPage = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * スクロールビューがスワイプされたとき
 * @attention UIScrollViewのデリゲートメソッド
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    if ((NSInteger)fmod(scrollView.contentOffset.x , pageWidth) == 0) {
        // ページコントロールに現在のページを設定
        _pageControl.currentPage = scrollView.contentOffset.x / pageWidth;
    }
}

/**
 * ページコントロールがタップされたとき
 */
- (IBAction)pageChange:(id)sender {
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * _pageControl.currentPage;
    [_scrollView scrollRectToVisible:frame animated:YES];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
