//
//  ChangeViewController.m
//  NPlantsNews
//
//  Created by 于　超 on 2015/03/25.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import "ChangeMenuViewController.h"
#import "MenuManager.h"
#define Duration 0.2

@interface ChangeMenuViewController () {
    BOOL contain;
    CGPoint startPoint;
    CGPoint originPoint;
}

@property (nonatomic) BOOL sortFlg;
@property (strong, nonatomic) NSMutableArray *sortArray;

@property (nonatomic) BOOL beginFlg;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

- (IBAction)backButtonPressed:(id)sender;

@end

@implementation ChangeMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (int i = 0; i < [self.buttons count]; i ++) {
        UIButton *button = [self.buttons objectAtIndex:i];
        [button setTitle:[[MenuManager sharedManager].menuTextArray objectAtIndex:i+1] forState:UIControlStateNormal];
        button.adjustsImageWhenHighlighted = NO;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, [[UIScreen mainScreen] bounds].size.width/12, 0, 0);
        button.tag = i;
        button.exclusiveTouch = YES;
        
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressed:)];
        longGesture.minimumPressDuration = 0.2;
        [button addGestureRecognizer:longGesture];
        [button setBackgroundImage:[[MenuManager sharedManager].imageArray objectAtIndex:i] forState:UIControlStateNormal];
    }
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 角丸
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:_bottomView.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _bottomView.bounds;
    maskLayer.path = maskPath.CGPath;
    _bottomView.layer.mask = maskLayer;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", 9] forKey:@"index"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)buttonPressed:(UILongPressGestureRecognizer *)sender
{
    UIButton *btn = (UIButton *)sender.view;
    
    // タップエリア
    CGPoint tapPoint = [sender locationInView:sender.view];
    CGRect screen = [[UIScreen mainScreen] bounds];
    int width = screen.size.width;
    if (tapPoint.x < width-20-80 && !_beginFlg) {
        return;
    }
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        _beginFlg = YES;
        startPoint = [sender locationInView:sender.view];
        originPoint = btn.center;
        [UIView animateWithDuration:Duration animations:^{
            
            btn.transform = CGAffineTransformMakeScale(1.1, 1.1);
            btn.alpha = 0.7;
        }];
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        
        CGPoint newPoint = [sender locationInView:sender.view];
        CGFloat deltaX = newPoint.x-startPoint.x;
        CGFloat deltaY = newPoint.y-startPoint.y;
        
        btn.center = CGPointMake(btn.center.x+deltaX,btn.center.y+deltaY);
        
        NSInteger index = [self indexOfPoint:btn.center withButton:btn];
        if (index<0)
        {
            contain = NO;
        }
        else
        {
            [UIView animateWithDuration:Duration animations:^{
                
                CGPoint temp = CGPointZero;
                UIButton *button = self.buttons[index];
                temp = button.center;
                button.center = originPoint;
                btn.center = temp;
                originPoint = btn.center;
                
                // タグ交換
                float tag = btn.tag;
                btn.tag = button.tag;
                button.tag = tag;
                self.sortFlg = YES;
                
                contain = YES;
            }];
        }
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:Duration animations:^{
            
            btn.transform = CGAffineTransformIdentity;
            btn.alpha = 1.0;
            if (!contain)
            {
                btn.center = originPoint;
            }
        }];
        
        // ソート順保存
        self.sortArray = [NSMutableArray array];
        for (UIButton *button in self.buttons) {
            // ソート
            NSNumber *index = [NSNumber numberWithLong:button.tag];
            [self.sortArray addObject:index];
        }
        _beginFlg = NO;
    }
}

- (NSInteger)indexOfPoint:(CGPoint)point withButton:(UIButton *)btn
{
    for (NSInteger i = 0;i<self.buttons.count;i++)
    {
        UIButton *button = self.buttons[i];
        if (button != btn)
        {
            if (CGRectContainsPoint(button.frame, point))
            {
                return i;
            }
        }
    }
    return -1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender {
    if (self.sortFlg) {
        [MenuManager sharedManager].menuSortFlg = YES;
        [MenuManager sharedManager].reloadFlg = YES;
        [[MenuManager sharedManager] sortManuArray:self.sortArray];
    }
    
    NSData *menu = [NSKeyedArchiver archivedDataWithRootObject:[MenuManager sharedManager].menuArray];
    [[NSUserDefaults standardUserDefaults] setObject:menu forKey:@"menu"];
    NSData *tabWidth = [NSKeyedArchiver archivedDataWithRootObject:[MenuManager sharedManager].tabWidthArray];
    [[NSUserDefaults standardUserDefaults] setObject:tabWidth forKey:@"tabWidth"];
    NSData *menuText = [NSKeyedArchiver archivedDataWithRootObject:[MenuManager sharedManager].menuTextArray];
    [[NSUserDefaults standardUserDefaults] setObject:menuText forKey:@"menuText"];
    NSData *color = [NSKeyedArchiver archivedDataWithRootObject:[MenuManager sharedManager].colorArray];
    [[NSUserDefaults standardUserDefaults] setObject:color forKey:@"color"];
    [[NSUserDefaults standardUserDefaults] setObject: [NSString stringWithFormat:@"%d", [MenuManager sharedManager].bodyMenuIndex] forKey:@"bodyIndex"];
    [[NSUserDefaults standardUserDefaults] setObject: [NSString stringWithFormat:@"%d", [MenuManager sharedManager].loveMenuIndex] forKey:@"loveIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSNotification *notification =[NSNotification notificationWithName:@"reload" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
