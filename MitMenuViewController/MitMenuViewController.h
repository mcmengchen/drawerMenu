//
//  MitMenuViewController.h
//  MitMenuViewController
//
//  Created by william on 16/7/11.
//  Copyright © 2016年 Mitchell. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MitMainViewController;
@class MitLeftViewController;

typedef NS_ENUM(NSUInteger, MitMenuType) {
    MitMenuTypeNormal,
    MitMenuTypeLittle,
};




@interface MitMenuViewController : UIViewController
/** 类型 */
@property (nonatomic, assign) MitMenuType type;
/** 主视图 */
@property (nonatomic, strong) MitMainViewController * mainViewController;
/** 左视图 */
@property (nonatomic, strong) MitLeftViewController * leftViewController;


- (instancetype)initWithMenuWidth:(CGFloat)width;

@end
