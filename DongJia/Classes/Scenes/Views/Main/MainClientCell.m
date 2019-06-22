//
//  MainClientCell.m
//  DongJia
//
//  Created by bnqc on 2019/6/21.
//  Copyright © 2019年 Dong. All rights reserved.
//

#import "MainClientCell.h"
#import "UIView+Extension.h"

@interface MainClientCell ()

@property(nonatomic,strong)UIView *mainView;
@property(nonatomic,strong)UIButton *nameButton;
@property(nonatomic,strong)UIButton *switchNumButton;
@property(nonatomic,strong)UILabel *locationLabel;

@end

@implementation MainClientCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.mainView];
    }
    return self;
}

- (UIView *)mainView {
    
    if (_mainView == nil) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KmainWidth - KNormalEdgeDistance * 2, 100.0f)];
        _mainView.backgroundColor = [UIColor whiteColor];
        _mainView.layer.cornerRadius = KNormalEdgeDistance;
        _mainView.layer.masksToBounds = YES;
        [_mainView addSubview:self.nameButton];
        [_mainView addSubview:self.locationLabel];
        [_mainView addSubview:self.switchNumButton];
    }
    return _mainView;
}

- (UIButton *)nameButton {
    
    if (_nameButton == nil) {
        _nameButton = [[UIButton alloc] initWithFrame:CGRectMake(KNormalEdgeDistance, KNormalViewDistance, _mainView.width - KNormalEdgeDistance*2, 40.0f)];
        _nameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _nameButton.titleLabel.font = KBoldFont(16);
        _nameButton.userInteractionEnabled = NO;
        [_nameButton setImage:[UIImage imageNamed:@"main_client_icon"] forState:UIControlStateNormal];
        [_nameButton setTitleColor:KTitleTextColor forState:UIControlStateNormal];
        [_nameButton setTitle:@"  温湿度状况" forState:UIControlStateNormal];
    }
    return _nameButton;
}

- (UILabel *)locationLabel {
    
    if (_locationLabel == nil) {
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(_mainView.width/2.0, _nameButton.bottom, _mainView.width/2.0 - KNormalEdgeDistance, 40.0f)];
        _locationLabel.textColor = KDetailTextColor;
        _locationLabel.font = KDetailTextFont;
        _locationLabel.text = @"设备位置: 未知";
    }
    return _locationLabel;
}

- (UIButton *)switchNumButton {
    
    if (_switchNumButton == nil) {
        _switchNumButton = [[UIButton alloc] initWithFrame:CGRectMake(KNormalEdgeDistance, _nameButton.bottom, _mainView.width/2.0 - KNormalEdgeDistance, 40.0f)];
        _switchNumButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _switchNumButton.titleLabel.font = KDetailTextFont;
        _switchNumButton.userInteractionEnabled = NO;
        [_switchNumButton setTitleColor:KDetailTextColor forState:UIControlStateNormal];
    }
    return _switchNumButton;
}



- (void)setDataModel:(ClientModel *)dataModel {
    
    _dataModel = dataModel;
    
    [_switchNumButton setTitle:[NSString stringWithFormat:@"可控家电: %d个",(int)dataModel.switchArray.count] forState:UIControlStateNormal];
    [_nameButton setTitle:[NSString stringWithFormat:@"  %@",dataModel.clientName] forState:UIControlStateNormal];
}


@end
