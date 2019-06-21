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
            _imageName = @"menu_socket_icon";
            break;
        case SwitchTypeLight:
            _imageName = @"menu_light_icon";
            break;
        case SwitchTypeDeskLamp:
            _imageName = @"menu_desk_lamp_icon";
            break;
        case SwitchTypeAir:
            _imageName = @"menu_air_icon";
            break;
        case SwitchTypeTV:
            _imageName = @"menu_tv_icon";
            break;
        case SwitchTypeWidnow:
            _imageName = @"menu_window_icon";
            break;
    }
}


@end

