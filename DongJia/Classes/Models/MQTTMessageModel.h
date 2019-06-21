//
//  MQTTMessageModel.h
//  DongJia
//
//  Created by bnqc on 2019/6/21.
//  Copyright © 2019年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    MQTTMessageTypeData,//数据类型消息,例如温湿度等数据消息
    MQTTMessageTypeResponse,//响应类型数据,例如打开开关等反馈信息
    MQTTMessageTypeWill,//离线遗嘱消息,例如某个设备离线会发送的数据
    MQTTMessageTypeClient,//设备信息
} MQTTMessageType;

@interface MQTTMessageModel : NSObject

// MQTTMessageModel 是MQTT的默认消息类型

@property(nonatomic,assign)MQTTMessageType messageType;

@property(nonatomic,copy)NSNumber *temperature;//温度
@property(nonatomic,copy)NSNumber *humidity;//湿度
@property(nonatomic,copy)NSNumber *switchState;//开关状态
@property(nonatomic,copy)NSString *clientID;//设备ID
@property(nonatomic,copy)NSString *switchID;//开关ID
@property(nonatomic,copy)NSString *cliendName;//设备名称
@property(nonatomic,copy)NSNumber *cliendType;//设备类型
@property(nonatomic,copy)NSNumber *isOn;//是否已经打开开关

@end


