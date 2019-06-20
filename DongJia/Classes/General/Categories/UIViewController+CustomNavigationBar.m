//
//  UIViewController+CustomNavigationBar.m
//  QingLiuEdu
//
//  Created by bnqc on 2018/6/14.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import "UIViewController+CustomNavigationBar.h"

@implementation UIViewController (CustomNavigationBar)

- (void)customNavigationBarWithTitleString:(NSString *)titleString isHavaBottomLine:(BOOL)isHavaBottomLine{
    if (titleString == nil) {
        titleString = @"";
    }
    self.navigationItem.title = titleString;
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;//分割线
  [self loadBasicSettingActionIsHavaBottomLine:isHavaBottomLine];
}

- (void)customNavigationBarWithLeftImageName:(NSString *)leftImageName titleString:(NSString *)titleString isHavaBottomLine:(BOOL)isHavaBottomLine{
    
    if (leftImageName == nil) {
        leftImageName = @"common_return_icon";
    }
    if (titleString == nil) {
        titleString = @"";
    }
    self.navigationItem.title = titleString;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:leftImageName] style:UIBarButtonItemStyleDone target:self action:@selector(popViewControllerAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor hexStringToColor:@"2f2f2f"];
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;//分割线
    [self loadBasicSettingActionIsHavaBottomLine:isHavaBottomLine];
}

- (void)customNavigationBarWithLeftString:(NSString *)leftString titleString:(NSString *)titleString isHavaBottomLine:(BOOL)isHavaBottomLine{
    
    if (leftString == nil) {
        leftString = @"返回";
    }
    if (titleString == nil) {
        titleString = @"";
    }
    
    self.navigationItem.title = titleString;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:leftString style:UIBarButtonItemStyleDone target:self action:@selector(popViewControllerAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor hexStringToColor:@"2f2f2f"];
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;//分割线
    [self loadBasicSettingActionIsHavaBottomLine:isHavaBottomLine];
}

- (void)automaticallyAdjustsScrollViewInsetsWithScollView:(UIScrollView *)scollView{
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        scollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)loadBasicSettingActionIsHavaBottomLine:(BOOL)isHavaBottomLine{
    
    self.navigationController.navigationBar.barTintColor = [UIColor hexStringToColor:@"ffffff"];
    UIFont *titleFont = ([UIFont systemFontOfSize:18]);
    if (KBoldFont(18) != nil) {
        titleFont = KBoldFont(18);
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:titleFont, NSForegroundColorAttributeName:[UIColor hexStringToColor:@"2f2f2f"]}];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateSelected];
    
    // 自定义分割线
    UIView *footView = [self.navigationController.navigationBar viewWithTag:1001];
    if (footView == nil) {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, KmainWidth, 1)];
        footView.backgroundColor = [UIColor hexStringToColor:@"f3f4f8"];
        footView.tag = 1001;
        [self.navigationController.navigationBar addSubview:footView];
        [self.navigationController.navigationBar bringSubviewToFront:footView];
    }
    if (isHavaBottomLine) {
        footView.hidden = NO;
    } else {
        footView.hidden = YES;
    }
}

- (void)popViewControllerAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
