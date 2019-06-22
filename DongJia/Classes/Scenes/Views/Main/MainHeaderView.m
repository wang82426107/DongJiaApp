//
//  MainHeaderView.m
//  DongJia
//
//  Created by 王巍栋 on 2019/6/22.
//  Copyright © 2019 Dong. All rights reserved.
//

#import "MainHeaderView.h"
#import "UIView+Extension.h"

@interface MainHeaderView ()
@property(nonatomic,strong)UIImageView *mainView;
@property(nonatomic,strong)UIButton *titleButton;
@property(nonatomic,strong)UILabel *temperatureLabel;//温度
@property(nonatomic,strong)UILabel *humidityLabel;//湿度

@end

@implementation MainHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.mainView];
    }
    return self;
}

#pragma mark - 懒加载

- (UIImageView *)mainView {
    
    if (_mainView == nil) {
        UIImage *bgImage = [[UIImage imageNamed:@"common_view_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeTile];
        _mainView = [[UIImageView alloc] initWithImage:bgImage];
        _mainView.frame = CGRectMake(KNormalEdgeDistance, 0, KmainWidth - KNormalEdgeDistance * 2, KNormalEdgeDistance + 40.0f + KNormalEdgeDistance + 100.0f + KNormalEdgeDistance);
        _mainView.layer.shadowColor = [UIColor hexStringToColor:@"000000"].CGColor;
        _mainView.layer.shadowOffset = CGSizeMake(0, 4);
        _mainView.layer.shadowOpacity = 0.1;
        _mainView.layer.shadowRadius = 2.0f;
        [_mainView addSubview:self.titleButton];
        [_mainView addSubview:self.temperatureLabel];
        [_mainView addSubview:self.humidityLabel];
    }
    return _mainView;
}

- (UIButton *)titleButton {
    
    if (_titleButton == nil) {
        _titleButton = [[UIButton alloc] initWithFrame:CGRectMake(KNormalEdgeDistance, KNormalEdgeDistance, KmainWidth - KNormalEdgeDistance * 2, 40.0f)];
        _titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _titleButton.titleLabel.font = KBoldFont(20);
        _titleButton.userInteractionEnabled = NO;
        [_titleButton setImage:[UIImage imageNamed:@"main_header_icon"] forState:UIControlStateNormal];
        [_titleButton setTitleColor:KTitleTextColor forState:UIControlStateNormal];
        [_titleButton setTitle:@"  室内温湿度" forState:UIControlStateNormal];
    }
    return _titleButton;
}

- (UILabel *)temperatureLabel {
    
    if (_temperatureLabel == nil) {
        _temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(KNormalEdgeDistance * 2, _titleButton.bottom + KNormalViewDistance, KmainWidth/2.0 - KNormalEdgeDistance * 4, 100.0f)];
        _temperatureLabel.textColor = [UIColor hexStringToColor:@"EE5C42"];
    }
    return _temperatureLabel;
}

- (UILabel *)humidityLabel {
    
    if (_humidityLabel == nil) {
        _humidityLabel = [[UILabel alloc] initWithFrame:CGRectMake(_temperatureLabel.right, _titleButton.bottom + KNormalViewDistance, KmainWidth/2.0 - KNormalEdgeDistance * 4, 100.0f)];
        _humidityLabel.textColor = [UIColor hexStringToColor:@"00F5FF"];
    }
    return _humidityLabel;
}

- (void)setHumidity:(NSNumber *)humidity {
    
    _humidity = humidity;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentRight;
    NSString * humidityString = [NSString stringWithFormat:@"%@",humidity];
    NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %%",humidityString]];
    [contentString addAttribute:NSFontAttributeName value:KAgencyFont(30) range:NSMakeRange(0, contentString.length)];
    [contentString addAttribute:NSFontAttributeName value:KAgencyFont(60) range:NSMakeRange(0, humidityString.length)];
    [contentString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, contentString.length)];
    self.humidityLabel.attributedText = contentString;
}

- (void)setTemperature:(NSNumber *)temperature {
    
    _temperature = temperature;
    NSString * temperatureString = [NSString stringWithFormat:@"%@",temperature];
    NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ °C",temperatureString]];
    [contentString addAttribute:NSFontAttributeName value:KAgencyFont(30) range:NSMakeRange(0, contentString.length)];
    [contentString addAttribute:NSFontAttributeName value:KAgencyFont(60) range:NSMakeRange(0, temperatureString.length)];
    self.temperatureLabel.attributedText = contentString;
}

@end
