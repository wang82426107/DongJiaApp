//
//  OrderMenuAlertView.h
//  DongJia
//
//  Created by bnqc on 2019/6/21.
//  Copyright © 2019年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MenuShowStyleTopToBottom,//从头到底动画
    MenuShowStyleBottomToTop,//从底到头动画
} MenuShowStyle;

@interface OrderMenuAlertView : UIView

//宽度不建议设置太小,建议最小为30.0f;

@property(nonatomic,strong)UIColor *titeColor;

- (void)showWithOrderMenuFrame:(CGRect)menuFrame showStyle:(MenuShowStyle)showStyle;

- (void)dismiss;

@end

