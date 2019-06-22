//
//  MainViewController.m
//  DongJia
//
//  Created by bnqc on 2019/6/20.
//  Copyright © 2019年 Dong. All rights reserved.
//

#import "MainViewController.h"
#import "UIView+Extension.h"
#import "ClientAlertView.h"
#import "DefaultViewCell.h"
#import "MainHeaderView.h"
#import "MainClientCell.h"
#import "UIView+Toast.h"
#import "MQTTManager.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIButton *menuButton;
@property(nonatomic,strong)UIButton *userButton;
@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UIImageView *mqttStateView;
@property(nonatomic,strong)UILabel *mqttStateLabel;
@property(nonatomic,strong)MainHeaderView *headerView;
@property(nonatomic,strong)UIButton *clientTitleButton;
@property(nonatomic,strong)UITableView *clientTableView;

@property(nonatomic,strong)ClientAlertView *clientAlertView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.menuButton];
    [self.view addSubview:self.userButton];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.mqttStateView];
    [self.view addSubview:self.mqttStateLabel];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.clientTitleButton];
    [self.view addSubview:self.clientTableView];

    //MQTT初始化
    [[MQTTManager defaultManager] addObserver:self forKeyPath:@"mqttState" options:NSKeyValueObservingOptionNew context:nil];
    [[MQTTManager defaultManager] bindWithUserName:MQTTUserName password:MQTTPassWord topicArray:@[MQTTDataTopic,MQTTClientTopic,MQTTWillTopic] isSSL:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessageNotificationAction:) name:ReceiveMessageNotificationName object:nil];
}

#pragma mark - 懒加载

- (UIButton *)menuButton {
    
    if (_menuButton == nil) {
        _menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, StatusHeight, NavigationBarHeight, NavigationBarHeight)];
        _menuButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_menuButton setImage:[UIImage imageNamed:@"main_menu_icon"] forState:UIControlStateNormal];
    }
    return _menuButton;
}

- (UIButton *)userButton {
    
    if (_userButton == nil) {
        _userButton = [[UIButton alloc] initWithFrame:CGRectMake(KNormalEdgeDistance, StatusHeight, NavigationBarHeight, NavigationBarHeight)];
        _userButton.backgroundColor = [UIColor hexStringToColor:@"404040"];
        _userButton.layer.cornerRadius = NavigationBarHeight/2.0;
        _userButton.userInteractionEnabled = NO;
        _userButton.layer.masksToBounds = YES;
        _userButton.layer.borderColor = KMainColor.CGColor;
        _userButton.layer.borderWidth = 1.0f;
        [_userButton setImage:[UIImage imageNamed:@"main_user_icon"] forState:UIControlStateNormal];
    }
    return _userButton;
}

- (UILabel *)nameLabel {
    
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userButton.right + KNormalViewDistance, StatusHeight, KmainWidth/2.0, NavigationBarHeight/2.0)];
        _nameLabel.textColor = KTitleTextColor;
        _nameLabel.font = KContentTextFont;
        _nameLabel.text = @"骚栋的手机";
    }
    return _nameLabel;
}

- (UIImageView *)mqttStateView {
    
    if (_mqttStateView == nil) {
        _mqttStateView = [[UIImageView alloc] initWithFrame:CGRectMake(_userButton.right + KNormalViewDistance, StatusHeight + NavigationBarHeight/2.0 + (NavigationBarHeight/2.0 - 10)/2.0f, 10, 10)];
        _mqttStateView.backgroundColor = [UIColor lightGrayColor];
        _mqttStateView.layer.cornerRadius = 5.0f;
        _mqttStateView.layer.masksToBounds = YES;
    }
    return _mqttStateView;
}

- (UILabel *)mqttStateLabel {
    
    if (_mqttStateLabel == nil) {
        _mqttStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_mqttStateView.right + KNormalViewDistance, StatusHeight + NavigationBarHeight/2.0, KmainWidth/2.0, 20.0f)];
        _mqttStateLabel.textColor = KTitleTextColor;
        _mqttStateLabel.font = KDetailTextFont;
        _mqttStateLabel.text = @"离线";
    }
    return _mqttStateLabel;
}

- (MainHeaderView *)headerView {
    
    if (_headerView == nil) {
        _headerView = [[MainHeaderView alloc] initWithFrame:CGRectMake(0, StatusHeight + NavigationBarHeight + KNormalEdgeDistance, KmainWidth, KNormalEdgeDistance + 40.0f + KNormalEdgeDistance + 100.0f + KNormalEdgeDistance)];
        _headerView.temperature = @(0);
        _headerView.humidity = @(0);
    }
    return _headerView;
}

- (UIButton *)clientTitleButton {
    
    if (_clientTitleButton == nil) {
        _clientTitleButton = [[UIButton alloc] initWithFrame:CGRectMake(KNormalEdgeDistance, _headerView.bottom, KmainWidth - KNormalEdgeDistance * 2, 60.0f)];
        _clientTitleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _clientTitleButton.titleLabel.font = KBoldFont(20);
        _clientTitleButton.userInteractionEnabled = NO;
        [_clientTitleButton setTitleColor:KTitleTextColor forState:UIControlStateNormal];
        [_clientTitleButton setTitle:@"设备列表" forState:UIControlStateNormal];
    }
    return _clientTitleButton;
}

- (UITableView *)clientTableView {
    
    if (_clientTableView == nil) {
        _clientTableView = [[UITableView alloc] initWithFrame:CGRectMake(KNormalEdgeDistance, _clientTitleButton.bottom, KmainWidth - KNormalEdgeDistance * 2, KmainHeight - _clientTitleButton.bottom) style:UITableViewStyleGrouped];
        _clientTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _clientTableView.backgroundColor = [UIColor clearColor];
        _clientTableView.showsVerticalScrollIndicator = NO;
        _clientTableView.dataSource = self;
        _clientTableView.delegate = self;
        _clientTableView.bounces = NO;
        [_clientTableView registerClass:[DefaultViewCell class] forCellReuseIdentifier:@"DefaultViewCell"];
        [_clientTableView registerClass:[MainClientCell class] forCellReuseIdentifier:@"MainClientCell"];
    }
    return _clientTableView;
}

- (ClientAlertView *)clientAlertView {
    
    if (_clientAlertView == nil) {
        _clientAlertView = [[ClientAlertView alloc] init];
    }
    return _clientAlertView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([MQTTManager defaultManager].clientArray.count == 0) {
        return 1;
    } else {
        return [MQTTManager defaultManager].clientArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([MQTTManager defaultManager].clientArray.count == 0) {
        DefaultViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultViewCell" forIndexPath:indexPath];
        [cell setCellImageName:@"default_no_data" title:@"当前还未有在线设备" titleColor:[UIColor hexStringToColor:@"858585"] bounds:CGRectMake(0, 0, KmainWidth, KmainHeight - _clientTitleButton.bottom)];
        return cell;
    } else {
        MainClientCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainClientCell" forIndexPath:indexPath];
        cell.dataModel = [MQTTManager defaultManager].clientArray[indexPath.section];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([MQTTManager defaultManager].clientArray.count == 0) {
        return KmainHeight - _clientTitleButton.bottom;
    } else {
        return 100.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([MQTTManager defaultManager].clientArray.count == 0) {
        return 0.0f;
    } else {
        return 1.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if ([MQTTManager defaultManager].clientArray.count == 0) {
        return 0.0f;
    } else {
        return KNormalEdgeDistance;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([MQTTManager defaultManager].clientArray.count != 0) {
        
        ClientModel *dataModel = [MQTTManager defaultManager].clientArray[indexPath.section];
        if (dataModel.switchArray.count == 0) {
            [self.view makeToast:@"该终端暂无可控制的电器" duration:0.8 position:CSToastPositionCenter];
            return;
        }
        
        self.clientAlertView.dataModel = [MQTTManager defaultManager].clientArray[indexPath.section];
        [self.view.window addSubview:self.clientAlertView];
        [self.clientAlertView show];
    }
}

#pragma mark - 接受到消息

- (void)receiveMessageNotificationAction:(NSNotification *)notification {
    
    MQTTMessageModel *messageModel = notification.object;
    switch (messageModel.messageType) {
        case MQTTMessageTypeClient:case MQTTMessageTypeWill:{
            [self.clientTableView reloadData];
            break;
        }
        case MQTTMessageTypeData:{
            self.headerView.temperature = messageModel.temperature;
            self.headerView.humidity = messageModel.humidity;
            break;
        }
        default:
            break;
    }
    
}

#pragma mark - 根据不同状态修改UI

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    
    if ([keyPath isEqualToString:@"mqttState"]) {
        
        switch ([MQTTManager defaultManager].mqttState) {

            case MQTTStateStartConnect:
                _mqttStateView.backgroundColor = [UIColor lightGrayColor];
                _mqttStateLabel.text = @"开始连接";
                break;
            case MQTTStateConnecting:
                _mqttStateView.backgroundColor = [UIColor lightGrayColor];
                _mqttStateLabel.text = @"连接中...";
                break;
            case MQTTStateDidConnect:
                _mqttStateView.backgroundColor = [UIColor hexStringToColor:@"1296db"];
                _mqttStateLabel.text = @"已连接";
                break;
            case MQTTStateDisConnect:
                _mqttStateView.backgroundColor = [UIColor lightGrayColor];
                _mqttStateLabel.text = @"离线";
                break;
        }
    }
}

- (void)dealloc {
    
    [[MQTTManager defaultManager] removeObserver:self forKeyPath:@"mqttState"];
}


@end
