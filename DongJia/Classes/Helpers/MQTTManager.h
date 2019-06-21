//
//  MQTTManager.h
//  DongJia
//
//  Created by bnqc on 2019/6/20.
//  Copyright © 2019年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQTTMessageModel.h"
#import "ClientModel.h"
#import "SwitchModel.h"

typedef enum : NSUInteger {
    MQTTStateStartConnect,
    MQTTStateConnecting,
    MQTTStateDidConnect,
    MQTTStateDisConnect,
} MQTTState;

//收到消息的通知,object携带类型为MQTTMessageModel
#define ReceiveMessageNotificationName @"ReceiveMessageNotificationName"

//MQTT状态发生改变的通知,不携带object.也可以使用KVO监听单例中mqttState的变化
#define MQTTChangeStateNotificationName @"MQTTChangeStateNotificationName"

//MQTT的可操作指令发送改变的通知
#define MQTTOrderChangeStateNotificationName @"MQTTOrderChangeStateNotificationName"

@interface MQTTManager : NSObject

//MQTTManager 是MQTT的管理类,默认消息等级全部为QOS 0

+ (instancetype)defaultManager;


/**
 绑定连接MQTT服务器

 @param username 账号
 @param password 密码
 @param topicArray 主题名称数组
 @param isSSL 是否是SSL连接
 */
- (void)bindWithUserName:(NSString *)username password:(NSString *)password topicArray:(NSArray <NSString *>*)topicArray isSSL:(BOOL)isSSL;


/**
 主动断开MQTT服务器
 */
- (void)disconnectService;


/**
 重新连接MQTT服务器
 */
- (void)reloadConectService;


/**
 订阅某个主题

 @param topic 主题名称
 */
- (void)subscribeTopic:(NSString *)topic;


/**
 取消订阅
 
 @param topic 主题名称
 */
- (void)unsubscribeTopic:(NSString *)topic;


/**
 发送字符串类型的消息

 @param stringMessage 字符串消息
 @param topic 主题
 */
- (void)sendMQTTStringMessage:(NSString *)stringMessage topic:(NSString *)topic;


/**
 发送字典类型的消息

 @param mapMessage 字典类型消息
 @param topic 主题
 */
- (void)sendMQTTMapMessage:(NSDictionary *)mapMessage topic:(NSString *)topic;


/**
 MQTT的状态
 */
@property(nonatomic,assign)MQTTState mqttState;


/**
 主题数组
 */
@property(nonatomic,copy)NSArray <NSString *>*topicArray;

/**
 所有在线设备.
 */
@property(nonatomic,strong)NSMutableArray <ClientModel *>*clientArray;


@end

