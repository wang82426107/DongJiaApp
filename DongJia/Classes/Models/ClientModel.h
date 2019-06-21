//
//  ClientModel.h
//  DongJia
//
//  Created by bnqc on 2019/6/21.
//  Copyright © 2019年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SwitchModel.h"

typedef enum : NSUInteger {
    ClientTypeApp,//数据类型消息,例如温湿度等数据消息
    ClientTypeESP8266,//响应类型数据,例如打开开关等反馈信息
} ClientType;

@interface ClientModel : NSObject

@property(nonatomic,copy)NSString *clientID;//离线设备ID
@property(nonatomic,copy)NSString *clientName;//设备名称
@property(nonatomic,copy)NSNumber *clientType;//设备类型
@property(nonatomic,assign)ClientType clientEunmType;
@property(nonatomic,strong)NSMutableArray <SwitchModel *>*switchArray;

@end

