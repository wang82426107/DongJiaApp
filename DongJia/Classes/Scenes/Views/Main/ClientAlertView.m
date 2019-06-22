//
//  ClientAlertView.m
//  DongJia
//
//  Created by 王巍栋 on 2019/6/22.
//  Copyright © 2019 Dong. All rights reserved.
//

#import "ClientAlertView.h"
#import "ClientAlertViewCell.h"
#import "UIView+Extension.h"
#import "MQTTManager.h"

@interface ClientAlertView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property(nonatomic,strong)UIView *mainView;
@property(nonatomic,strong)UICollectionView *switchListView;
@property(nonatomic,strong)UILabel *switchNameView;
@property(nonatomic,strong)UILabel *switchDetailView;
@property(nonatomic,strong)UIButton *openButton;
@property(nonatomic,assign)NSInteger selectIndex;

@end

@implementation ClientAlertView

- (instancetype)init {
    
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = KRGBAColor(0, 0, 0, 0);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSwitchStateAction:) name:MQTTOrderResponseStateNotificationName object:nil];
        [self addSubview:self.mainView];
    }
    return self;
}

#pragma mark - 设置数据

- (void)setDataModel:(ClientModel *)dataModel {
    
    _dataModel = dataModel;
    self.selectIndex = 0;
    [_switchListView reloadData];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    
    _selectIndex = selectIndex;
    
    if (selectIndex < self.dataModel.switchArray.count) {
        
        SwitchModel *switchModel = self.dataModel.switchArray[selectIndex];
        _switchNameView.text = switchModel.name;
        switch (switchModel.state) {
            case SwitchStateClose:
                [_openButton setTitle:@"打开" forState:UIControlStateNormal];
                _openButton.backgroundColor = [UIColor hexStringToColor:@"8deeee"];
                _switchDetailView.text = @"设备状态:关闭";
                _openButton.selected = NO;
                break;
            case SwitchStateOpen:
                [_openButton setTitle:@"关闭" forState:UIControlStateNormal];
                _openButton.backgroundColor = [UIColor hexStringToColor:@"ff6a6a"];
                _switchDetailView.text = @"设备状态:打开";
                _openButton.selected = YES;
                break;
        }
    }
}

- (void)changeSwitchStateAction:(NSNotification *)notification {
    
    NSDictionary *obj = notification.object;
    NSString *clientID = obj[@"clientID"];
    NSString *switchID = obj[@"switchID"];
    
    if ([clientID isEqualToString:self.dataModel.clientID]) {
        
        for (int i = 0; i < self.dataModel.switchArray.count; i++) {
            SwitchModel *switchModel = self.dataModel.switchArray[i];
            if ([switchModel.switchID isEqualToString:switchID]) {
                if (i == _selectIndex) {
                    self.selectIndex = i;
                }
                break;
            }
        }
    }
}

#pragma mark - 懒加载

- (UIView *)mainView {
    
    if (_mainView == nil) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, KNoSafeHeight, KmainWidth, 400.0f)];
        _mainView.backgroundColor = [UIColor whiteColor];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_mainView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _mainView.bounds;
        maskLayer.path = maskPath.CGPath;
        _mainView.layer.mask = maskLayer;
        [_mainView addSubview:self.switchListView];
        [_mainView addSubview:self.switchNameView];
        [_mainView addSubview:self.switchDetailView];
        [_mainView addSubview:self.openButton];
    }
    return _mainView;
}

- (UICollectionView *)switchListView {
 
    if (_switchListView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(200.0f, 200.0f);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _switchListView = [[UICollectionView alloc] initWithFrame:CGRectMake(KmainWidth/2.0 - 100.0f, 0, 200.0f, 200.0f) collectionViewLayout:layout];
        _switchListView.backgroundColor = [UIColor whiteColor];
        _switchListView.showsHorizontalScrollIndicator = NO;
        _switchListView.pagingEnabled = YES;
        _switchListView.dataSource = self;
        _switchListView.delegate = self;
        _switchListView.bounces = NO;
        [_switchListView registerClass:[ClientAlertViewCell class] forCellWithReuseIdentifier:@"ClientAlertViewCell"];
    }
    return _switchListView;
}

- (UILabel *)switchNameView {
    
    if (_switchNameView == nil) {
        _switchNameView = [[UILabel alloc] initWithFrame:CGRectMake(KNormalEdgeDistance, _switchListView.bottom, KmainWidth - KNormalEdgeDistance *2, 40.0f)];
        _switchNameView.textAlignment = NSTextAlignmentCenter;
        _switchNameView.textColor = KTitleTextColor;
        _switchNameView.font = KBoldFont(18);
    }
    return _switchNameView;
}

- (UILabel *)switchDetailView {
    
    if (_switchDetailView == nil) {
        _switchDetailView = [[UILabel alloc] initWithFrame:CGRectMake(KNormalEdgeDistance, _switchNameView.bottom + KNormalEdgeDistance, KmainWidth - KNormalEdgeDistance *2, 40.0f)];
        _switchDetailView.textColor = KDetailTextColor;
        _switchDetailView.font = KContentTextFont;
        _switchDetailView.numberOfLines = 0;
    }
    return _switchDetailView;
}

- (UIButton *)openButton {
    
    if (_openButton == nil) {
        _openButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _mainView.height - 50.0f, KmainWidth, 50.0f)];
        _openButton.titleLabel.font = KBoldFont(14);
        [_openButton addTarget:self action:@selector(sendOpenOrCloseMessageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openButton;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataModel.switchArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ClientAlertViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ClientAlertViewCell" forIndexPath:indexPath];
    SwitchModel *dataModel = self.dataModel.switchArray[indexPath.row];
    cell.imageName = dataModel.imageName;
    return cell;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.selectIndex = scrollView.contentOffset.x/200.0f;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}


- (void)sendOpenOrCloseMessageAction:(UIButton *)sender {
    
    SwitchModel *dataModel = self.dataModel.switchArray[_selectIndex];
    NSDictionary *message = @{
                              @"type":@(4),
                              @"data":@{
                                      @"clientID":self.dataModel.clientID,
                                      @"switchID":dataModel.switchID,
                                      @"isOn":sender.isSelected ? @(0) : @(1),
                                      }
                              };
    [[MQTTManager defaultManager] sendMQTTMapMessage:message topic:MQTTOrderTopic];
}


#pragma mark - 显示与隐藏

- (void)show {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = KRGBAColor(0, 0, 0, 0.1);
        self.mainView.frame = CGRectMake(0, KNoSafeHeight - 400.0f, KmainWidth, 400.0f);
    }];
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = KRGBAColor(0, 0, 0, 0);
        self.mainView.frame = CGRectMake(0, KNoSafeHeight, KmainWidth, 400.0f);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    CALayer *layer=[self.layer hitTest:touchPoint];
    if (layer != self.mainView.layer) {
        [self dismiss];
    }
}

@end
