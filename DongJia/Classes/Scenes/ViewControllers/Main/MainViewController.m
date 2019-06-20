//
//  MainViewController.m
//  DongJia
//
//  Created by bnqc on 2019/6/20.
//  Copyright © 2019年 Dong. All rights reserved.
//

#import "MainViewController.h"
#import "UIView+Extension.h"
#import "TYCircleMenu.h"
#import "MQTTManager.h"

@interface MainViewController ()<TYCircleMenuDelegate>

@property(nonatomic,strong)UIImageView *mqttStateView;
@property(nonatomic,strong)UILabel *mqttStateLabel;
@property(nonatomic,strong)UIButton *userButton;
@property(nonatomic,strong)TYCircleMenu *orderMenu;
@property(nonatomic,strong)UITableView *mainTableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.userButton];
    [self.view addSubview:self.mqttStateView];
    [self.view addSubview:self.mqttStateLabel];
    [self.view addSubview:self.orderMenu];

    
    //MQTT初始化
    [[MQTTManager defaultManager] addObserver:self forKeyPath:@"mqttState" options:NSKeyValueObservingOptionNew context:nil];
    [[MQTTManager defaultManager] bindWithUserName:MQTTUserName password:MQTTPassWord cliendId:@"3333333" topicArray:@[@"Will",@"SD_LED"] isSSL:NO];
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

- (TYCircleMenu *)orderMenu {
    
    if (_orderMenu == nil) {
        NSArray *titleItems = @[@"客厅空调",@"客厅灯",@"卧室空调",@"卧室灯",
                                @"抽风机",@"冰箱",@"客厅空调",@"主卧窗户",
                                @"次卧窗户",@"书房台灯",@"洗衣机",@"电视机"];
        NSArray *imageItems = @[@"test_0",@"test_1",@"test_2",@"test_3",
                                @"test_4",@"test_5",@"test_6",@"test_7",
                                @"test_8",@"test_9",@"test_10",@"test_11"];
        _orderMenu = [[TYCircleMenu alloc]initWithRadious:300 itemOffset:0 imageArray:imageItems titleArray:titleItems cycle:YES menuDelegate:self];
    }
    return _orderMenu;
}

#pragma mark - 选择发送菜单的下标

- (void)selectMenuAtIndex:(NSInteger)index {

    
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
