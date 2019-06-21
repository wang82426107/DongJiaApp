//
//  MainViewController.m
//  DongJia
//
//  Created by bnqc on 2019/6/20.
//  Copyright © 2019年 Dong. All rights reserved.
//

#import "MainViewController.h"
#import "OrderMenuAlertView.h"
#import "UIView+Extension.h"
#import "MainClientCell.h"
#import "UIView+Toast.h"
#import "MQTTManager.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIImageView *mqttStateView;
@property(nonatomic,strong)UILabel *mqttStateLabel;
@property(nonatomic,strong)UIButton *userButton;
@property(nonatomic,strong)UIButton *orderButton;
@property(nonatomic,strong)OrderMenuAlertView *orderMenu;
@property(nonatomic,strong)UITableView *clientTableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.userButton];
    [self.view addSubview:self.mqttStateView];
    [self.view addSubview:self.mqttStateLabel];
    [self.view addSubview:self.orderButton];
    [self.view addSubview:self.clientTableView];

    //MQTT初始化
    [[MQTTManager defaultManager] addObserver:self forKeyPath:@"mqttState" options:NSKeyValueObservingOptionNew context:nil];
    [[MQTTManager defaultManager] bindWithUserName:MQTTUserName password:MQTTPassWord topicArray:@[MQTTDataTopic,MQTTSwitchTopic,MQTTOnlineTopic,MQTTWillTopic] isSSL:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessageNotificationAction:) name:ReceiveMessageNotificationName object:nil];
}

#pragma mark - 懒加载

- (UIButton *)userButton {
    
    if (_userButton == nil) {
        _userButton = [[UIButton alloc] initWithFrame:CGRectMake(KNormalEdgeDistance, StatusHeight + KNormalEdgeDistance, 60, 60)];
        [_userButton setImage:[UIImage imageNamed:@"user_button_icon"] forState:UIControlStateNormal];
    }
    return _userButton;
}


- (UIImageView *)mqttStateView {
    
    if (_mqttStateView == nil) {
        _mqttStateView = [[UIImageView alloc] initWithFrame:CGRectMake(_userButton.right + KNormalViewDistance, StatusHeight + KNormalEdgeDistance + 20, 20, 20)];
        _mqttStateView.backgroundColor = [UIColor lightGrayColor];
        _mqttStateView.layer.cornerRadius = 10.0f;
        _mqttStateView.layer.masksToBounds = YES;
    }
    return _mqttStateView;
}

- (UILabel *)mqttStateLabel {
    
    if (_mqttStateLabel == nil) {
        _mqttStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_mqttStateView.right + KNormalViewDistance, StatusHeight + KNormalEdgeDistance, 200, 60)];
        _mqttStateLabel.textColor = KTitleTextColor;
        _mqttStateLabel.font = KBoldFont(16);
        _mqttStateLabel.text = @"离线";
    }
    return _mqttStateLabel;
}

- (UIButton *)orderButton {
    
    if (_orderButton == nil) {
        _orderButton = [[UIButton alloc] initWithFrame:CGRectMake(KmainWidth - KNormalEdgeDistance - _userButton.width, _userButton.top, _userButton.width, _userButton.height)];
        _orderButton.backgroundColor = [UIColor lightGrayColor];
        _orderButton.layer.cornerRadius = _orderButton.width/2.0;
        _orderButton.layer.masksToBounds = YES;
        [_orderButton setImage:[UIImage imageNamed:@"order_button_icon"] forState:UIControlStateNormal];
        [_orderButton addTarget:self action:@selector(showOrderMenuAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderButton;
}

- (OrderMenuAlertView *)orderMenu {
    
    if (_orderMenu == nil) {
        _orderMenu = [[OrderMenuAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _orderMenu.titeColor =  [UIColor hexStringToColor:@"023c8a"];
    }
    return _orderMenu;
}

- (UITableView *)clientTableView {
    
    if (_clientTableView == nil) {
        _clientTableView = [[UITableView alloc] initWithFrame:CGRectMake(KmainWidth/4.0, KmainHeight - 200.0f, KmainWidth/2.0, 200.0f) style:UITableViewStylePlain];
        _clientTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _clientTableView.showsVerticalScrollIndicator = NO;
        _clientTableView.backgroundColor = [UIColor lightGrayColor];
        _clientTableView.dataSource = self;
        _clientTableView.delegate = self;
        _clientTableView.bounces = NO;
        [_clientTableView registerClass:[MainClientCell class] forCellReuseIdentifier:@"MainClientCell"];
    }
    return _clientTableView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [MQTTManager defaultManager].clientArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MainClientCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainClientCell" forIndexPath:indexPath];
    cell.dataModel = [MQTTManager defaultManager].clientArray[indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40.0f;
}

#pragma mark - 显示指令菜单

- (void)showOrderMenuAction {
    
    if ([MQTTManager defaultManager].clientArray.count == 0) {
        
        [self.view makeToast:@"当前还没任何设备在线" duration:0.8 position:CSToastPositionCenter];
        return;
    }
    
    [self.view.window addSubview:self.orderMenu];
    [self.orderMenu showWithOrderMenuFrame:CGRectMake(_orderButton.x, _orderButton.bottom + KNormalViewDistance, _orderButton.width, 0) showStyle:MenuShowStyleTopToBottom];
}

#pragma mark - 接受到消息

- (void)receiveMessageNotificationAction:(NSNotification *)notification {
    
    MQTTMessageModel *messageModel = notification.object;
    switch (messageModel.messageType) {
        case MQTTMessageTypeClient:case MQTTMessageTypeWill:{
            [self.clientTableView reloadData];
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
