//
//  ClientAlertView.h
//  DongJia
//
//  Created by 王巍栋 on 2019/6/22.
//  Copyright © 2019 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientModel.h"

@interface ClientAlertView : UIView

@property(nonatomic,strong)ClientModel *dataModel;

- (void)show;

- (void)dismiss;

@end

