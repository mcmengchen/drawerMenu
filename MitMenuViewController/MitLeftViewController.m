//
//  MitLeftViewController.m
//  MitMenuViewController
//
//  Created by william on 16/7/11.
//  Copyright © 2016年 Mitchell. All rights reserved.
//

#import "MitLeftViewController.h"
#import "DemoViewController.h"
@interface MitLeftViewController ()

@end

@implementation MitLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor orangeColor];

    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 50);
    [btn setTitle:@"left" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)btnClick{
    NSLog(@"left");
    DemoViewController * vi = [DemoViewController new];
    [self.navigationController pushViewController:vi animated:NO];
}






@end
