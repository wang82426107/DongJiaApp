//
//  DefaultViewCell.h
//  ZhiKe
//
//  Created by bnqc on 2018/10/30.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefaultViewCell : UITableViewCell

//DetailViewCell用于应对特殊情况的tableView
- (void)setCellImageName:(NSString *)imageName bounds:(CGRect)bounds;

- (void)setCellImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)titleColor bounds:(CGRect)bounds;

@end
