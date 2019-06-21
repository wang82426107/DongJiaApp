//
//  OrderMenuDetailView.m
//  DongJia
//
//  Created by bnqc on 2019/6/21.
//  Copyright © 2019年 Dong. All rights reserved.
//

#import "OrderMenuDetailView.h"
#import "UIView+Extension.h"

@interface OrderMenuDetailView ()

@property(nonatomic,strong)UIImageView *mainImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *detailsLabel;
@property(nonatomic,strong)UIButton *switchButton;

@end

@implementation OrderMenuDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 15.0f;
        self.layer.masksToBounds = YES;
        [self addSubview:self.mainImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.detailsLabel];
        [self addSubview:self.switchButton];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    self.nameLabel.frame = CGRectMake(self.mainImageView.right + KNormalViewDistance, KNormalEdgeDistance, self.bounds.size.width - (self.mainImageView.right + KNormalViewDistance + KNormalEdgeDistance), 60.0f);
    self.detailsLabel.frame = CGRectMake(KNormalEdgeDistance,self.mainImageView.bottom + KNormalEdgeDistance, ViewWidth - KNormalEdgeDistance *2, ViewHeight - KNormalViewDistance - 40.0f - (self.mainImageView.bottom + KNormalEdgeDistance));
    self.switchButton.frame = CGRectMake(ViewWidth/3.0, self.detailsLabel.bottom, ViewWidth/3.0, 40.0f);
}

#pragma mark - 懒加载


- (UIImageView *)mainImageView {
    
    if (_mainImageView == nil) {
        _mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KNormalEdgeDistance, KNormalEdgeDistance, 60.0f, 60.0f)];
        _mainImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _mainImageView.layer.masksToBounds = YES;
        _mainImageView.layer.cornerRadius = 30.0f;
        _mainImageView.layer.borderWidth = 1.0f;
        _mainImageView.contentMode = UIViewContentModeCenter;
        _mainImageView.tintColor = [UIColor whiteColor];
    }
    return _mainImageView;
}

- (UILabel *)nameLabel {
    
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.mainImageView.right + KNormalViewDistance, KNormalEdgeDistance, self.bounds.size.width - (self.mainImageView.right + KNormalViewDistance + KNormalEdgeDistance), 60.0f)];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = KBoldFont(16);
    }
    return _nameLabel;
}

- (UILabel *)detailsLabel {
    
    if (_detailsLabel == nil) {
        _detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(KNormalEdgeDistance,self.mainImageView.bottom + KNormalEdgeDistance, ViewWidth - KNormalEdgeDistance *2, ViewHeight - KNormalViewDistance - 40.0f - (self.mainImageView.bottom + KNormalEdgeDistance))];
        _detailsLabel.textColor = [UIColor whiteColor];
        _detailsLabel.font = KContentTextFont;
        _detailsLabel.numberOfLines = 0;
    }
    return _detailsLabel;
}

- (UIButton *)switchButton {
    
    if (_switchButton == nil) {
        _switchButton = [[UIButton alloc] initWithFrame:CGRectMake(ViewWidth/3.0, self.detailsLabel.bottom, ViewWidth/3.0, 40.0f)];
        _switchButton.backgroundColor = [UIColor hexStringToColor:@"c0c0c0"];
        _switchButton.titleLabel.font = KContentTextFont;
        _switchButton.layer.cornerRadius = 20.0f;
        _switchButton.layer.masksToBounds = YES;
        [_switchButton setTitle:@"未知" forState:UIControlStateDisabled];
        [_switchButton setTitle:@"打开" forState:UIControlStateNormal];
        [_switchButton setTitle:@"关闭" forState:UIControlStateSelected];
    }
    return _switchButton;
}

- (void)setDataModel:(SwitchModel *)dataModel {
    
    _dataModel = dataModel;
    
    self.mainImageView.image = [[UIImage imageNamed:dataModel.imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.nameLabel.text = dataModel.name;
    
    switch (dataModel.state) {

        case SwitchStateUnknown:
            _switchButton.backgroundColor = [UIColor hexStringToColor:@"c0c0c0"];
            _detailsLabel.text = @"设备状态:未知";
            [_switchButton setEnabled:NO];
            break;
        case SwitchStateOpen:
            _switchButton.backgroundColor = [UIColor hexStringToColor:@"8deeee"];
            _detailsLabel.text = @"设备状态:关闭";
            _switchButton.selected = NO;
            [_switchButton setEnabled:YES];
            break;
        case SwitchStateClose:
            _switchButton.backgroundColor = [UIColor hexStringToColor:@"ff6a6a"];
            _detailsLabel.text = @"设备状态:打开";
            _switchButton.selected = YES;
            [_switchButton setEnabled:YES];
            break;
    }
}




@end
