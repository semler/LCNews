//
//  SearchViewController.m
//  NPlantsNews
//
//  Created by 于　超 on 2015/03/25.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "NewsData.h"
#import "SearchResultViewController.h"
#import "AppDelegate.h"

@interface SearchViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) NSMutableArray *history;

@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)closeButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _history = [NSMutableArray array];
    
    [self.navigationController.navigationBar setHidden:YES];
    _cancelButton.hidden = YES;
    _tableView.hidden = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;
    // プレースホルダ
    _textField.placeholder = @"検索したい文言を入力";
    _textField.returnKeyType = UIReturnKeySearch;
    
    // 枠線のスタイルを設定
    _textField.borderStyle = UITextBorderStyleNone;
    // クリアボタンモード
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    // ラベルのテキストのフォントを設定
    _textField.font = [UIFont fontWithName:@"HiraKakuPro-W3" size:32];
    _textField.textColor = [UIColor colorWithRed:0.486 green:0.486 blue:0.486 alpha:1];
    _cancelButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuPro-W6" size:28];
    _cancelButton.titleLabel.textColor = [UIColor colorWithRed:0.557 green:0.557 blue:0.557 alpha:1];
    
    // デリゲートを設定
    _textField.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
//    _tableView.dataSource = self;
//    _tableView.delegate = self;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [_history removeAllObjects];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _textField.placeholder = @"検索";
    _cancelButton.hidden = NO;
    
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    // UIViewAnimationCurve　を UIViewAnimationOptionに変換
    UIViewAnimationOptions animationOptions = animationCurve << 16;
    
    // 移動
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:animationOptions
                     animations:^{
                         _logo.center = CGPointMake(_logo.center.x, -47.5);
                         _textField.center = CGPointMake(_textField.center.x, 35);
                         _cancelButton.center = CGPointMake(_cancelButton.center.x, 35);
                         _bgImage.center = CGPointMake(_bgImage.center.x, 35);
                     }
                     completion:^(BOOL finished) {_tableView.hidden = NO;}];
    
    [self.tableView reloadData];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    _textField.placeholder = @"検索したい文言を入力";
    _cancelButton.hidden = YES;
    _tableView.hidden = YES;
    
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    // UIViewAnimationCurve　を UIViewAnimationOptionに変換
    UIViewAnimationOptions animationOptions = animationCurve << 16;
    
    // 元の位置に戻す
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:animationOptions
                     animations:^{
                         float center = ([[UIScreen mainScreen] bounds].size.height - 52)/2;
                         _logo.center = CGPointMake(_logo.center.x, center-82.5);
                         _textField.center = CGPointMake(_textField.center.x, center);
                         _cancelButton.center = CGPointMake(_cancelButton.center.x, center);
                         _bgImage.center = CGPointMake(_bgImage.center.x, center);
                     }
                     completion:^(BOOL finished) {}];
}

/**
 * キーボードでReturnキーが押されたとき
 * @param textField イベントが発生したテキストフィールド
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // キーボードを隠す
    [self.view endEditing:YES];
    
    // 検索履歴追加
    [[SearchManager sharedManager] addHistory:textField.text];
    
    // 検索
    [self search:textField.text];
    
    return YES;
}

- (IBAction)closeButtonPressed:(id)sender {
    //[self.navigationController popViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [_textField resignFirstResponder];
}

- (void)search:(NSString *)keyword {
    SearchResultViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"result"];
    controller.keyWord = keyword;
    [self.navigationController pushViewController:controller animated:YES];
}

// Table Viewのセクション数を指定
- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView {
    return 1;
}

//セクションのタイトルを設定
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"検索履歴";
}

// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog([NSString stringWithFormat:@"%lu",(unsigned long)[[SearchManager sharedManager].history count]]);
    return [[SearchManager sharedManager].history count];
}

// セル高さ
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *history = [[SearchManager sharedManager].history objectAtIndex:([[SearchManager sharedManager].history count]-1-[indexPath row])];
    
    UILabel *historyLabel = (UILabel*)[cell viewWithTag:1];
    historyLabel.text = history;
    
    [_history addObject:history];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self search:[_history objectAtIndex:[indexPath row]]];
    // 検索履歴追加
    [[SearchManager sharedManager] addHistory:[_history objectAtIndex:[indexPath row]]];
}


@end
