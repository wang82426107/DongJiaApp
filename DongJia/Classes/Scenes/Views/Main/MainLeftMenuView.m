//
//  MainLeftMenuView.m
//  DongJia
//
//  Created by bnqc on 2019/6/25.
//  Copyright © 2019年 Dong. All rights reserved.
//

#import "MainLeftMenuView.h"
#import "UIView+Extension.h"

@interface MainLeftMenuView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIImageView *headerView;
@property(nonatomic,strong)UITableView *mainTableView;

@end

@implementation MainLeftMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.mainTableView];
    }
    return self;
}

#pragma mark - 懒加载

- (UIImageView *)headerView {
    
    if (_headerView == nil) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewWidth * 383.0/900.)];
        _headerView.image = [UIImage imageNamed:@"main_menu_header_icon"];
    }
    return _headerView;
}

- (UITableView *)mainTableView {
    
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.tableHeaderView = self.headerView;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.bounces = NO;
    }
    return _mainTableView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = KContentTextFont;
    }
    cell.imageView.image = [UIImage imageNamed:@"main_menu_connect_icon"];
    cell.textLabel.text = @"一键联网";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
    }
}

@end
