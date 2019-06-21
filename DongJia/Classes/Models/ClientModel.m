//
//  ClientModel.m
//  DongJia
//
//  Created by bnqc on 2019/6/21.
//  Copyright © 2019年 Dong. All rights reserved.
//

#import "ClientModel.h"

@implementation ClientModel

- (instancetype)init {
    
    if (self = [super init]) {
        self.switchArray = [NSMutableArray arrayWithCapacity:16];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setClientType:(NSNumber *)clientType {
    
    _clientType = clientType;
    _clientEunmType = [clientType intValue];
}


@end
