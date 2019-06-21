//
//  OrderMenuAlertView.m
//  DongJia
//
//  Created by bnqc on 2019/6/21.
//  Copyright © 2019年 Dong. All rights reserved.
//

#import "OrderMenuAlertView.h"
#import "OrderMenuDetailView.h"
#import "UIView+Extension.h"
#import "OrderMenuCell.h"
#import "MQTTManager.h"

#define ListTopOrBottomEdgeDistance (20.0f)

@interface OrderMenuAlertView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIView *orderView;//高度为6倍的cellHeight
@property(nonatomic,strong)UITableView *orderListView;
@property(nonatomic,strong)OrderMenuDetailView *detailView;
@property(nonatomic,assign)CGRect menuFrame;
@property(nonatomic,assign)CGFloat cellHeight;//cell的高度与宽度一致
@property(nonatomic,assign)MenuShowStyle showStyle;
@property(nonatomic,assign)NSInteger selectIndex;//选中的指令
@property(nonatomic,strong)NSMutableArray <SwitchModel*>*dataArray;
@property(nonatomic,assign)BOOL isShow;

@end

@implementation OrderMenuAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.titeColor = [UIColor hexStringToColor:@"023c8a"];
        self.isShow = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrderListAction) name:MQTTOrderChangeStateNotificationName object:nil];
        [self addSubview:self.orderView];
        [self addSubview:self.detailView];
        [self changeOrderListAction];
    }
    return self;
}

- (UIView *)orderView {
    
    if (_orderView == nil) {
        
        _orderView = [[UIView alloc] initWithFrame:_menuFrame];
        _orderView.backgroundColor = self.titeColor;
        _orderView.layer.cornerRadius = 15.0f;
        _orderView.layer.masksToBounds = YES;
        [_orderView addSubview:self.orderListView];
    }
    return _orderView;
}

- (OrderMenuDetailView *)detailView {
    
    if (_detailView == nil) {
        _detailView = [[OrderMenuDetailView alloc] initWithFrame:_menuFrame];
        _detailView.backgroundColor = self.titeColor;

    }
    return _detailView;
}

- (UITableView *)orderListView {
    
    if (_orderListView == nil) {
        _orderListView = [[UITableView alloc] initWithFrame:CGRectMake(0, ListTopOrBottomEdgeDistance, _orderView.width, _cellHeight *4) style:UITableViewStylePlain];
        _orderListView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _orderListView.showsVerticalScrollIndicator = NO;
        _orderListView.backgroundColor = self.titeColor;
        _orderListView.dataSource = self;
        _orderListView.delegate = self;
        _orderListView.bounces = NO;
        [_orderListView registerClass:[OrderMenuCell class] forCellReuseIdentifier:@"OrderMenuCell"];
    }
    return _orderListView;
}

#pragma mark - set相关

- (void)setTiteColor:(UIColor *)titeColor {
    
    _titeColor = titeColor;
    _orderView.backgroundColor = titeColor;
    _detailView.backgroundColor = titeColor;
    _orderListView.backgroundColor = titeColor;
}

- (void)changeOrderListAction {
    
    self.dataArray = [NSMutableArray arrayWithCapacity:16];
    for (ClientModel *client in [MQTTManager defaultManager].clientArray) {
        [self.dataArray addObjectsFromArray:client.switchArray];
    }
    self.selectIndex = 0;
    [self.orderListView reloadData];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    
    _selectIndex = selectIndex;
    if (self.dataArray.count == 0) {
        [self dismiss];
    } else {
        self.detailView.dataModel = self.dataArray[selectIndex];
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderMenuCell" forIndexPath:indexPath];
    cell.dataModel = self.dataArray[indexPath.row];
    cell.cellHeight = self.cellHeight;
    cell.titeColor = self.titeColor;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectIndex = indexPath.row;
}

#pragma mark - 显示与关闭

- (void)showWithOrderMenuFrame:(CGRect)menuFrame showStyle:(MenuShowStyle)showStyle {

    _menuFrame = menuFrame;
    _showStyle = showStyle;
    _cellHeight = menuFrame.size.width;
    CGFloat y = showStyle == MenuShowStyleTopToBottom ? menuFrame.origin.y : menuFrame.origin.y + menuFrame.size.height;
    self.orderView.frame = CGRectMake(menuFrame.origin.x, y, menuFrame.size.width, 0);
    self.orderListView.frame = CGRectMake(0, ListTopOrBottomEdgeDistance, _cellHeight, _cellHeight*4);
    [self.orderListView reloadData];
    CGFloat detailX = KmainWidth - KNormalEdgeDistance - _cellHeight * 4 - KNormalViewDistance - _orderView.right >= 0 ? _orderView.right + KNormalViewDistance : _orderView.left - KNormalViewDistance - _cellHeight * 4;
    self.detailView.frame = CGRectMake(detailX, menuFrame.origin.y, _cellHeight * 4, 0);
    self.isShow = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.detailView.frame = CGRectMake(detailX, self.menuFrame.origin.y, self.cellHeight * 4, self.cellHeight * 4);
        if (self.showStyle == MenuShowStyleTopToBottom) {
            self.orderView.frame = CGRectMake(menuFrame.origin.x, y, menuFrame.size.width, self.cellHeight * 4 + ListTopOrBottomEdgeDistance * 2);
        } else {
            self.orderView.frame = CGRectMake(menuFrame.origin.x, self.menuFrame.origin.y, menuFrame.size.width, self.cellHeight * 4 + ListTopOrBottomEdgeDistance * 2);
        }
    }];
}

- (void)dismiss {
    
    self.isShow = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.detailView.height = 0;
        if (self.showStyle == MenuShowStyleTopToBottom) {
            self.orderView.height = 0;
        } else {
            self.orderView.frame = CGRectMake(self.menuFrame.origin.x, self.menuFrame.origin.y + self.menuFrame.size.height, self.menuFrame.size.width, 0);
        }
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    CALayer *layer=[self.layer hitTest:touchPoint];
    if (layer != self.detailView.layer &&
        layer != self.orderView.layer  ) {
        [self dismiss];
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


