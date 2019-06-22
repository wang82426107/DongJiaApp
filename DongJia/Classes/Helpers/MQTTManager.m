//
//  MQTTManager.m
//  DongJia
//
//  Created by bnqc on 2019/6/20.
//  Copyright © 2019年 Dong. All rights reserved.
//

#import "MQTTManager.h"
#import <MQTTClient.h>

@interface MQTTManager ()<MQTTSessionManagerDelegate>

@property(nonatomic,strong)NSMutableDictionary *topicDictionary;//带有QOS等级的主题,主题名为键,QOS等级为值
@property(nonatomic,strong)MQTTSessionManager *sessionManager;
@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,copy)NSString *cliendId;
@property(nonatomic,assign)BOOL isSSL;

@end


@implementation MQTTManager

static MQTTManager *manager = nil;

+ (instancetype)defaultManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (manager == nil) {
            manager = [[MQTTManager alloc] init];
            manager.mqttState = MQTTStateDisConnect;
            manager.clientArray = [NSMutableArray arrayWithCapacity:16];
            manager.topicDictionary = [NSMutableDictionary dictionaryWithCapacity:16];
        }
    });
    return manager;
}

- (NSString*)uuid {
    
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

#pragma mark - 懒加载

- (MQTTSessionManager *)sessionManager {
    
    if (_sessionManager == nil) {
        _sessionManager = [[MQTTSessionManager alloc] init];
        [MQTTLog setLogLevel:DDLogLevelError];
        [_sessionManager setDelegate:self];
    }
    return _sessionManager;
}

- (MQTTSSLSecurityPolicy *)customSecurityPolicy {
    
    MQTTSSLSecurityPolicy *securityPolicy = [MQTTSSLSecurityPolicy policyWithPinningMode:MQTTSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesCertificateChain = YES;
    securityPolicy.validatesDomainName = NO;
    return securityPolicy;
}

#pragma mark - 绑定连接MQTT服务器,主动断开,重连服务器

- (void)bindWithUserName:(NSString *)username password:(NSString *)password topicArray:(NSArray <NSString *>*)topicArray isSSL:(BOOL)isSSL {
    
    self.mqttState = MQTTStateStartConnect;
    self.username = username;
    self.password = password;
    self.cliendId = [self uuid];
    self.isSSL = isSSL;

    [self.sessionManager connectTo:AddressOfMQTTServer
                                port:self.isSSL?PortOfMQTTServerWithSSL:PortOfMQTTServer
                                 tls:self.isSSL
                           keepalive:60
                               clean:YES
                                auth:YES
                                user:self.username
                                pass:self.password
                                will:NO
                           willTopic:nil
                             willMsg:nil
                             willQos:MQTTQosLevelAtLeastOnce
                      willRetainFlag:NO
                        withClientId:self.cliendId
                      securityPolicy:[self customSecurityPolicy]
                        certificates:nil
                       protocolLevel:4
                      connectHandler:nil];
    
    if (topicArray != nil) {
        for (NSString *topic in topicArray) {
            [self.topicDictionary setObject:@(MQTTQosLevelAtMostOnce) forKey:topic];
        }
        _topicArray = topicArray;
        self.sessionManager.subscriptions = self.topicDictionary;
    }
}


- (void)disconnectService {
    
    [self.sessionManager disconnectWithDisconnectHandler:^(NSError *error) {
        NSLog(@"断开连接  error = %@",[error description]);
    }];
    [self.sessionManager setDelegate:nil];
    self.sessionManager = nil;
}


- (void)reloadConectService {
    
    if (self.sessionManager && self.sessionManager.port) {
        self.sessionManager.delegate = self;
        [self.sessionManager connectToLast:^(NSError *error) {
            NSLog(@"重新连接  error = %@",[error description]);
        }];
        self.sessionManager.subscriptions = self.topicDictionary;
    }
    else {
        [self bindWithUserName:self.username password:self.password topicArray:self.topicArray isSSL:self.isSSL];
    }
}

#pragma mark - 订阅主题与取消主题

//重置全部订阅
- (void)setTopicArray:(NSArray<NSString *> *)topicArray {
    
    _topicArray = topicArray;
    if (topicArray != nil) {
        [self.topicDictionary removeAllObjects];
        for (NSString *topic in topicArray) {
            [self.topicDictionary setObject:@(MQTTQosLevelAtMostOnce) forKey:topic];
        }
        _topicArray = topicArray;
        self.sessionManager.subscriptions = self.topicDictionary;
    }
}

// 订阅某个主题
- (void)subscribeTopic:(NSString *)topic{
    
    if (![self.topicDictionary.allKeys containsObject:topic]) {
        [self.topicDictionary setObject:@(MQTTQosLevelAtMostOnce) forKey:topic];
        self.sessionManager.subscriptions =  self.topicDictionary;
        _topicArray = self.topicDictionary.allKeys;
    } else {
        NSLog(@"已经存在，不用订阅");
    }
}

// 取消订阅某个主题
- (void)unsubscribeTopic:(NSString *)topic {
        
    if ([self.topicDictionary.allKeys containsObject:topic]) {
        [self.topicDictionary removeObjectForKey:topic];
        self.sessionManager.subscriptions =  self.topicDictionary;
        _topicArray = self.topicDictionary.allKeys;
    } else {
        NSLog(@"不存在，无需取消");
    }
}

#pragma mark - 发送消息

- (void)sendMQTTStringMessage:(NSString *)stringMessage topic:(NSString *)topic {
    
    [self sendMQTTDataMessage:[stringMessage dataUsingEncoding:NSUTF8StringEncoding] topic:topic];
}

- (void)sendMQTTMapMessage:(NSDictionary *)mapMessage topic:(NSString *)topic {
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:mapMessage options:0 error:nil];
    [self sendMQTTDataMessage:data topic:topic];
}

- (void)sendMQTTDataMessage:(NSData *)dataMessage topic:(NSString *)topic {
    
    [self.sessionManager sendData:dataMessage topic:topic qos:MQTTQosLevelAtLeastOnce retain:NO];
}

#pragma mark - MQTTClient的代理回调

//状态监听代理方法
- (void)sessionManager:(MQTTSessionManager *)sessionManager didChangeState:(MQTTSessionManagerState)newState {
    
    switch (newState) {
        case MQTTSessionManagerStateConnected:{
            NSLog(@"eventCode -- 连接成功");
            NSDictionary *message = @{
                                      @"type":@(3),
                                      @"data":@{
                                              @"cliendType":@(0),
                                              @"cliendName":@"骚栋的手机",
                                              @"cliendID":self.cliendId
                                              },
                                      };
            
            self.mqttState = MQTTStateDidConnect;
            [self sendMQTTMapMessage:message topic:MQTTClientTopic];
            break;
        }
        case MQTTSessionManagerStateConnecting:
            NSLog(@"eventCode -- 连接中");
            self.mqttState = MQTTStateConnecting;
            break;
        case MQTTSessionManagerStateClosed:
            NSLog(@"eventCode -- 连接被关闭");
            self.mqttState = MQTTStateDisConnect;
            break;
        case MQTTSessionManagerStateError:
            NSLog(@"eventCode -- 连接错误");
            self.mqttState = MQTTStateDisConnect;
            break;
        case MQTTSessionManagerStateClosing:
            NSLog(@"eventCode -- 关闭中");
            self.mqttState = MQTTStateDisConnect;
            break;
        case MQTTSessionManagerStateStarting:
            NSLog(@"eventCode -- 连接开始");
            break;
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MQTTChangeStateNotificationName object:nil];

}

//接受到消息的回调代理方法
- (void)handleMessage:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained {
    
    NSDictionary *message = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    int type = [message[@"type"] intValue];
    MQTTMessageModel *messageModel = [[MQTTMessageModel alloc] init];
    [messageModel setValuesForKeysWithDictionary:message[@"data"]];
    switch (type) {
        case 0:
            //温湿度数据
            messageModel.messageType = MQTTMessageTypeData;
            break;
        case 1:{
            //反馈数据
            messageModel.messageType = MQTTMessageTypeResponse;
            
            for (ClientModel *clientModel in self.clientArray) {
                if ([clientModel.clientID isEqualToString:messageModel.clientID]) {
                    for (SwitchModel *switchModel in clientModel.switchArray) {
                        if ([switchModel.switchID isEqualToString:messageModel.switchID]) {
                            switchModel.switchState = messageModel.isOn;
                            break;
                        }
                    }
                    break;
                }
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:MQTTOrderResponseStateNotificationName object:@{@"clientID":messageModel.clientID,
                                                                                                                       @"switchID":messageModel.switchID,
                                                                                                                       @"isOn":messageModel.isOn}];
            break;
        }
        case 2:{
            //遗嘱离线数据
            messageModel.messageType = MQTTMessageTypeWill;
            
            //移除所有相关的指令信息
            for (NSInteger i = self.clientArray.count - 1; i >= 0; i--) {
                ClientModel *clientModel = self.clientArray[i];
                if ([clientModel.clientID isEqualToString:messageModel.clientID]) {
                    [self.clientArray removeObject:clientModel];
                }
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:MQTTOrderChangeStateNotificationName object:messageModel];
            break;
        }
        case 3:{
            //设备信息
            messageModel.messageType = MQTTMessageTypeClient;
            
            ClientModel *clientModel = [[ClientModel alloc] init];
            [clientModel setValuesForKeysWithDictionary:message[@"data"]];
            NSArray *switchs = message[@"data"][@"switchs"];
            for (NSDictionary * switchDic in switchs) {
                SwitchModel *switchModel = [[SwitchModel alloc] init];
                switchModel.clientID = clientModel.clientID;
                [switchModel setValuesForKeysWithDictionary:switchDic];
                [clientModel.switchArray addObject:switchModel];
            }

            if (clientModel.clientEunmType == ClientTypeESP8266) {
                BOOL isHaveClient = NO;
                //查看数组中是否有该设备的信息
                for (ClientModel *nowClientModel in self.clientArray) {
                    if ([clientModel.clientID isEqualToString:nowClientModel.clientID]) {
                        isHaveClient = YES;
                        break;
                    }
                }
                if (!isHaveClient) {
                    [self.clientArray addObject:clientModel];
                    [[NSNotificationCenter defaultCenter] postNotificationName:MQTTOrderChangeStateNotificationName object:messageModel];
                }
            }
            
            break;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ReceiveMessageNotificationName object:messageModel];
}



@end

