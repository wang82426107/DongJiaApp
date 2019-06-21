//
//  OrderMenuCell.h
//  DongJia
//
//  Created by bnqc on 2019/6/21.
//  Copyright © 2019年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchModel.h"

@interface OrderMenuCell : UITableViewCell

@property(nonatomic,assign)CGFloat cellHeight;
@property(nonatomic,strong)UIColor *titeColor;
@property(nonatomic,strong)SwitchModel *dataModel;


@end

