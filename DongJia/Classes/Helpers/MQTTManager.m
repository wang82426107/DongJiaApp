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
            manager.topicDictionary = [NSMutableDictionary dictionaryWithCapacity:16];
        }
    });
    return manager;
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

- (void)bindWithUserName:(NSString *)username password:(NSString *)password cliendId:(NSString *)cliendId topicArray:(NSArray <NSString *>*)topicArray isSSL:(BOOL)isSSL {
    
    self.mqttState = MQTTStateStartConnect;
    self.username = username;
    self.password = password;
    self.cliendId = cliendId;
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
        [self bindWithUserName:self.username password:self.password cliendId:self.cliendId topicArray:self.topicArray isSSL:self.isSSL];
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
    
    [self.sessionManager sendData:dataMessage topic:topic qos:MQTTQosLevelAtMostOnce retain:NO];
}

#pragma mark - MQTTClient的代理回调

//状态监听代理方法
- (void)sessionManager:(MQTTSessionManager *)sessionManager didChangeState:(MQTTSessionManagerState)newState {
    
    switch (newState) {
        case MQTTSessionManagerStateConnected:
            NSLog(@"eventCode -- 连接成功");
            self.mqttState = MQTTStateDidConnect;
            break;
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
}


//接受到消息的回调代理方法
- (void)handleMessage:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained {
    
    NSDictionary *message = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"接受消息:%@",message);
}



@end
