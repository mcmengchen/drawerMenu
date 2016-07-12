//
//  MitMainViewController.m
//  MitMenuViewController
//
//  Created by william on 16/7/11.
//  Copyright © 2016年 Mitchell. All rights reserved.
//

#import "MitMainViewController.h"
#import "MitMenuViewController.h"
@interface MitMainViewController ()

@end

@implementation MitMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 60);
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 100, 100, 100)];
    text.backgroundColor = [UIColor redColor];
    [self.view addSubview:text];
    
}
- (void)btnClick{
    NSLog(@"打印");
    
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    if(touch.view == self.view){
        [self.view endEditing:YES];
        NSLog(@"%s",__func__);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
