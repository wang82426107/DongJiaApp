//
//  ClientAlertViewCell.m
//  DongJia
//
//  Created by 王巍栋 on 2019/6/22.
//  Copyright © 2019 Dong. All rights reserved.
//

#import "ClientAlertViewCell.h"

@interface ClientAlertViewCell ()

@property(nonatomic,strong)UIImageView *mainImageView;

@end

@implementation ClientAlertViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.mainImageView];
    }
    return self;
}

- (UIImageView *)mainImageView {
    
    if (_mainImageView == nil) {
        _mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ViewWidth/2.0 - 50.0f, ViewHeight/2.0 - 50.0f, 100, 100)];
        _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
        _mainImageView.clipsToBounds = YES;
    }
    return _mainImageView;
}

- (void)setImageName:(NSString *)imageName {
    
    _imageName = imageName;
    self.mainImageView.image = [UIImage imageNamed:imageName];
}


@end
