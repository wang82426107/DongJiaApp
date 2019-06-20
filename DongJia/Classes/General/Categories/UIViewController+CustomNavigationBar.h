//
//  UIViewController+CustomNavigationBar.h
//  QingLiuEdu
//
//  Created by bnqc on 2018/6/14.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CustomNavigationBar)

/**
 只设置标题和基本样式

 @param titleString 标题
 @param isHavaBottomLine 是否含有分割线
 */
- (void)customNavigationBarWithTitleString:(NSString *)titleString isHavaBottomLine:(BOOL)isHavaBottomLine;


/**
 默认有返回图片按钮(图片:黑色) 有标题 是否含有分割线

 @param leftImageName 返回按钮的图片名称
 @param titleString 标题
 @param isHavaBottomLine 是否含有分割线
 */
- (void)customNavigationBarWithLeftImageName:(NSString *)leftImageName titleString:(NSString *)titleString isHavaBottomLine:(BOOL)isHavaBottomLine;


/**
 默认有返回文字按钮(图片:黑色) 有标题 是否含有分割线

 @param leftString 返回按钮的文字
 @param titleString 标题
 @param isHavaBottomLine 是否含有分割线
 */
- (void)customNavigationBarWithLeftString:(NSString *)leftString titleString:(NSString *)titleString isHavaBottomLine:(BOOL)isHavaBottomLine;


/**
 根据scollView来适配iOS 11偏移问题
 @param scollView 需要适配的scollView
 */
- (void)automaticallyAdjustsScrollViewInsetsWithScollView:(UIScrollView *)scollView;

@end
