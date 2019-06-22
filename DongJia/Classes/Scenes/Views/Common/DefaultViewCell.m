//
//  DefaultViewCell.m
//  ZhiKe
//
//  Created by bnqc on 2018/10/30.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import "DefaultViewCell.h"
#import "UIButton+EdgeInsets.h"
@interface DefaultViewCell()

@property(nonatomic,strong)UIImageView *mainBgView;
@property(nonatomic,strong)UILabel *loadingLabel;//加载文字

@end

@implementation DefaultViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UILabel *)loadingLabel{
    
    if(_loadingLabel == nil){
        _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)/2.0 + 10, CGRectGetWidth(self.frame), 20)];
        _loadingLabel.text = @"什么都没有";
        _loadingLabel.textAlignment = NSTextAlignmentCenter;
        _loadingLabel.textColor = [UIColor hexStringToColor:@"858585"];
        _loadingLabel.font = [UIFont systemFontOfSize:12];
    }
    return _loadingLabel;
}

- (UIImageView *)mainBgView{
    
    if(_mainBgView == nil){
        _mainBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_no_data"]];
        _mainBgView.frame = CGRectMake(CGRectGetWidth(self.frame)/2.0 - 78, CGRectGetMinY(_loadingLabel.frame) - 150 - 10, 156, 150);
    }
    return _mainBgView;
}

- (void)setCellImageName:(NSString *)imageName bounds:(CGRect)bounds{
    
    [_loadingLabel removeFromSuperview];
    UIImage *img = [UIImage imageNamed:imageName];
    self.mainBgView.image = img;
    self.mainBgView.frame = CGRectMake(CGRectGetWidth(bounds)/2.0 - img.size.width/2.0, CGRectGetHeight(bounds)/2.0 - img.size.height/2.0, img.size.width, img.size.height);
    [self.contentView addSubview:self.mainBgView];
}

- (void)setCellImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)titleColor bounds:(CGRect)bounds{
    
    UIImage *img = [UIImage imageNamed:imageName];
    self.mainBgView.image = img;
    self.mainBgView.frame = CGRectMake(CGRectGetWidth(bounds)/2.0 - img.size.width/2.0,  CGRectGetHeight(bounds)/2.0 - (20 + 30 + img.size.height)/2.0, img.size.width, img.size.height);
    [self.contentView addSubview:self.mainBgView];
   
    self.loadingLabel.text = title;
    self.loadingLabel.textColor = titleColor;
    self.loadingLabel.frame = CGRectMake(0, CGRectGetMaxY(_mainBgView.frame) + 10, CGRectGetWidth(self.frame), 20);
    [self.contentView addSubview:self.loadingLabel];
}

@end
