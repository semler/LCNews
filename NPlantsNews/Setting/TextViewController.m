//
//  TextViewController.m
//  NPlantsNews
//
//  Created by 于　超 on 2015/04/10.
//  Copyright (c) 2015年 bravesoft. All rights reserved.
//

#import "TextViewController.h"

@interface TextViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)returnButtonPressed:(id)sender;

@end

@implementation TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0 , 64, screen.size.width, screen.size.height-64)];
    
    NSError *error;
    NSString *txt=
    [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"/利用規約" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
    
    textView.text = txt;
    textView.editable = NO;
    
    [self.view addSubview:textView];
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)returnButtonPressed:(id)sender {
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
@end
