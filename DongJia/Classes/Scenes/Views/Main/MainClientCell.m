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

@property(nonatomic,strong)UIView *stateView;
@property(nonatomic,strong)UILabel *nameLabel;

@end

@implementation MainClientCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.stateView];
        [self addSubview:self.nameLabel];
    }
    return self;
}

- (UIView *)stateView {
    
    if (_stateView == nil) {
        _stateView = [[UIView alloc] initWithFrame:CGRectMake(KNormalEdgeDistance, KNormalEdgeDistance, 10, 10)];
        _stateView.layer.cornerRadius = 5.0f;
        _stateView.layer.masksToBounds = YES;
        _stateView.backgroundColor = [UIColor hexStringToColor:@"00EE76"];
    }
    return _stateView;
}

- (UILabel *)nameLabel {
    
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_stateView.right + KNormalViewDistance, 0, KmainWidth/2.0 - (_stateView.right + KNormalViewDistance + KNormalEdgeDistance), 40.0f)];
        _nameLabel.textColor = KTitleTextColor;
        _nameLabel.font = KBoldFont(16);
    }
    return _nameLabel;
}

- (void)setDataModel:(ClientModel *)dataModel {
    
    _dataModel = dataModel;
    _nameLabel.text = dataModel.clientName;
}


@end
