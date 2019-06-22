//
//  SwitchModel.m
//  DongJia
//
//  Created by bnqc on 2019/6/21.
//  Copyright © 2019年 Dong. All rights reserved.
//

#import "SwitchModel.h"

@implementation SwitchModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setSwitchType:(NSNumber *)switchType {
    
    _switchType = switchType;
    self.type = [switchType intValue];
}

- (void)setSwitchState:(NSNumber *)switchState {
    
    _switchState = switchState;
    self.state = [switchState intValue];
}

- (void)setType:(SwitchType)type {
    
    _type = type;
    
    switch (type) {
        case SwitchTypeSocket:
            _imageName = @"switch_socket_icon";
            break;
        case SwitchTypeLight:
            _imageName = @"switch_light_icon";
            break;
        case SwitchTypeDeskLamp:
            _imageName = @"switch_desk_lamp_icon";
            break;
        case SwitchTypeAir:
            _imageName = @"switch_air_icon";
            break;
        case SwitchTypeTV:
            _imageName = @"switch_tv_icon";
            break;
        case SwitchTypeWidnow:
            _imageName = @"switch_window_icon";
            break;
    }
}


@end

