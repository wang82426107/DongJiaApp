//
//  SwitchModel.h
//  DongJia
//
//  Created by bnqc on 2019/6/21.
//  Copyright © 2019年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SwitchStateUnknown,
    SwitchStateOpen,
    SwitchStateClose,
} SwitchState;

typedef enum : NSUInteger {
    SwitchTypeSocket,
    SwitchTypeLight,
    SwitchTypeDeskLamp,
    SwitchTypeAir,
    SwitchTypeTV,
    SwitchTypeWidnow,
} SwitchType;

@interface SwitchModel : NSObject

@property(nonatomic,copy)NSString *clientID;//所属设备ID
@property(nonatomic,copy)NSString *switchID;//开关ID
@property(nonatomic,copy)NSNumber *switchType;
@property(nonatomic,copy)NSNumber *switchState;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *details;
@property(nonatomic,readonly)NSString *imageName;

@property(nonatomic,assign)SwitchType type;
@property(nonatomic,assign)SwitchState state;

@end

