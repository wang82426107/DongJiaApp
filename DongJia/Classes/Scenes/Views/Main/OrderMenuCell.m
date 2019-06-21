//
//  OrderMenuCell.m
//  DongJia
//
//  Created by bnqc on 2019/6/21.
//  Copyright © 2019年 Dong. All rights reserved.
//

#import "OrderMenuCell.h"

@interface OrderMenuCell ()

@property(nonatomic,strong)UIImageView *mainImageView;

@end


@implementation OrderMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor hexStringToColor:@"023c8a"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.mainImageView];
    }
    return self;
}

- (UIImageView *)mainImageView {
    
    if (_mainImageView == nil) {
        _mainImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _mainImageView.contentMode = UIViewContentModeCenter;
        _mainImageView.backgroundColor = [UIColor whiteColor];
        _mainImageView.clipsToBounds = YES;
    }
    return _mainImageView;
}


- (void)setCellHeight:(CGFloat)cellHeight {
    
    _cellHeight = cellHeight;
    
    if (cellHeight != self.mainImageView.frame.size.width + 10) {
        self.mainImageView.frame = CGRectMake(5, 5, cellHeight - 10, cellHeight - 10);
        self.mainImageView.layer.cornerRadius = (cellHeight - 10)/2.0;
        self.mainImageView.layer.masksToBounds = YES;
    }
}

- (void)setDataModel:(SwitchModel *)dataModel {
    
    _dataModel = dataModel;
    self.mainImageView.image = [UIImage imageNamed:dataModel.imageName];
}

@end
