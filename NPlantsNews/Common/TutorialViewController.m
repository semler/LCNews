//
//  TutorialViewController.m
//  NPlantsNews
//
//  Created by 于　超 on 2015/05/29.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

- (IBAction)close:(id)sender;

@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [_scrollView setContentSize:CGSizeMake((2*width), height)];
    
    UIImageView *bg1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    bg1.image = [UIImage imageNamed:@"tutorial1_bg.png"];
    [_scrollView addSubview:bg1];
    UIImageView *bg2 = [[UIImageView alloc]initWithFrame:CGRectMake(width, 0, width, height)];
    bg2.image = [UIImage imageNamed:@"tutorial2_bg.png"];
    [_scrollView addSubview:bg2];
    
    _pageControl.numberOfPages = 2;
    _pageControl.currentPage = 0;
    _pageControl.userInteractionEnabled = YES;
    
    if ([UIScreen mainScreen].bounds.size.height < 500) {
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        bg1.contentMode = UIViewContentModeScaleAspectFit;
        bg2.contentMode = UIViewContentModeScaleAspectFit;
    }
}

-(void) showTutorial:(UIViewController *)root {
    [root.view addSubview:self.view];
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

- (IBAction)close:(id)sender {
    [self.view removeFromSuperview];
}
@end
