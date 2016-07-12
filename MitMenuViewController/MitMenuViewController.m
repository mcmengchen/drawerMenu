//
//  MitMenuViewController.m
//  MitMenuViewController
//
//  Created by william on 16/7/11.
//  Copyright © 2016年 Mitchell. All rights reserved.
//

#import "MitMenuViewController.h"
#import "MitMainViewController.h"
#import "MitLeftViewController.h"
@interface MitMenuViewController ()

/** 当前内容视图 */
@property (nonatomic, strong) UIViewController * contentController;
/** 是否正在动画 */
@property (nonatomic, assign) BOOL isAnimating;
/** 是否已经打开 */
@property (nonatomic, assign) BOOL isOpen;
/** 控制器 */
@property (nonatomic, strong) NSArray * controllers;
/** 遮盖视图 */
@property (nonatomic, strong) UIView * maskView;
/** 开始手势 */
@property (nonatomic, assign) BOOL gestureBegin;
/** 菜单宽度 */
@property (nonatomic, assign) CGFloat menuWidth;

@end

@implementation MitMenuViewController


- (instancetype)initWithMenuWidth:(CGFloat)width{
    if (self = [super init]) {
        self.menuWidth = width;
        
    }
    return self;
}


#pragma mark ------------------- lifeCycle ------------------------

#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置手势开始标识符
    self.gestureBegin = false;
    //初始化打开标识符
    self.isOpen = NO;
    //添加自控制器
    [self addController:self.leftViewController];
    [self addController:self.mainViewController];
    [self addContentController:self.mainViewController];
}

#pragma mark - 创建 -> 遮盖视图
-(UIView *)maskView{
    if (!_maskView) {
        UIView * vi = [[UIView alloc]initWithFrame:self.view.bounds];
        vi.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.11];
        vi.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
        [vi addGestureRecognizer:tap];
        _maskView = vi;
    }
    return _maskView;
}


#pragma mark - action: 点击遮盖视图
- (void)click:(UITapGestureRecognizer*)tap{
    if (tap.view == self.maskView) {
        NSLog(@"遮盖视图是第一响应者");
        [self openMenu];
    }
}

#pragma mark - action: 添加子控制器
- (void)addController:(UIViewController*)controller{
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
}

#pragma mark - action: 修改当前的主视图
- (void)addContentController:(UIViewController *)controller{
    if (controller == self.contentController) {
        return;
    }
    [self.contentController willMoveToParentViewController:nil];
    [self.contentController.view removeFromSuperview];
    [self.contentController removeFromParentViewController];
    
    self.contentController = controller;
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    
    //添加遮盖视图
    [self.contentController.view addSubview:self.maskView];
    self.maskView.hidden = YES;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.contentController.view addGestureRecognizer:pan];
    
    self.contentController.view.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.contentController.view.layer.shadowOffset = CGSizeMake(-1,0);
    self.contentController.view.layer.shadowOpacity = 0.6;//阴影透明度，默认0
    self.contentController.view.layer.shadowRadius = 1;//阴影半径，默认3
}



#pragma mark - action: 给内容视图添加拖拽手势
- (void)pan:(UIPanGestureRecognizer*)pan{
    CGPoint transP = [pan translationInView:self.contentController.view];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [pan locationInView:self.contentController.view];
        if (location.x>=0&&location.x<=60) {
            self.gestureBegin = true;
        }
    }else if(pan.state == UIGestureRecognizerStateEnded){
        NSLog(@"结束了");
        if (self.gestureBegin) {
            if (transP.x>0) {
                NSLog(@"向左");
                [self performSelector:@selector(openMenu) withObject:nil];
            }else{
                NSLog(@"向右边");
                [self performSelector:@selector(openMenu) withObject:nil];
            }
        }
        self.gestureBegin = false;
    }else{
        NSLog(@"跟随");
        if (self.gestureBegin) {
            CGPoint location = [pan locationInView:self.contentController.view];
            NSInteger movement = location.x;
            [pan setTranslation:CGPointZero inView:pan.view];
            CGRect rect = self.contentController.view.frame;
            rect.origin.x += movement;
            if (rect.origin.x >= 0 && rect.origin.x <= self.menuWidth)
                self.contentController.view.frame = rect;
        }
    }
}



#pragma mark - action: 打开菜单
- (void)openMenu{
    if (self.isAnimating) {
        return;
    }
    self.isAnimating = YES;
    if (!self.isOpen) {
        [UIView animateWithDuration:0.1 animations:^{
            switch (self.type) {
                case MitMenuTypeLittle:
                {
                    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
                    CGFloat size = self.menuWidth/screenWidth;
                    self.contentController.view.frame = CGRectMake(self.menuWidth, size*screenHeight, screenWidth-self.menuWidth, screenHeight*(1-size));
                }

                    break;
                case MitMenuTypeNormal:
                    self.contentController.view.center = CGPointMake(CGRectGetMidX(self.view.frame)+self.menuWidth, CGRectGetMidY(self.view.frame));
                default:
                    break;
            }
        }completion:^(BOOL finished) {
            self.isAnimating = NO;
        }];
    }else{
        [UIView animateWithDuration:0.1 animations:^{
            switch (self.type) {
                case MitMenuTypeLittle:
                {
                    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
                    self.contentController.view.frame = CGRectMake(0, 0,screenWidth , screenHeight);
                }
                    break;
                case MitMenuTypeNormal:
                {
                    self.contentController.view.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));

                }
            }
        }completion:^(BOOL finished) {
            self.isAnimating = NO;
        }];
    }
    self.isOpen = !self.isOpen;
    if (self.isOpen) {
        self.maskView.hidden = false;
    }else{
        self.maskView.hidden = true;
    }
    
}




@end
