//
//  MQTTManager.m
//  DongJia
//
//  Created by bnqc on 2019/6/20.
//  Copyright © 2019年 Dong. All rights reserved.
//

#import "MQTTManager.h"
#import <MQTTClient.h>

@interface MQTTManager ()

@property(nonatomic,strong)MQTTSessionManager *sessionManager;
@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,copy)NSString *cliendId;
@property(nonatomic,assign)BOOL isSSL;


@end


@implementation MQTTManager

static MQTTManager *manager = nil;

+ (instancetype)defualtManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (manager == nil) {
            manager = [[MQTTManager alloc] init];
        }
    });
    return manager;
}

#pragma mark - 绑定
- (void)bindWithUserName:(NSString *)username password:(NSString *)password cliendId:(NSString *)cliendId isSSL:(BOOL)isSSL{
    
    self.username = username;
    self.password = password;
    self.cliendId = cliendId;
    self.SSL = isSSL;
    /*
     self.mySession = [[MQTTSession alloc]initWithClientId:self.cliendId userName:self.username password:self.password keepAlive:60 cleanSession:YES will:NO willTopic:nil willMsg:nil willQoS:MQTTQosLevelAtLeastOnce willRetainFlag:NO protocolLevel:4 queue:dispatch_get_main_queue() securityPolicy:[self customSecurityPolicy] certificates:nil];
     
     self.isDiscontent = NO;
     
     self.mySession.delegate = self;
     
     [self.mySession connectToHost:AddressOfMQTTServer port:self.isSSL?PortOfMQTTServerWithSSL:PortOfMQTTServer usingSSL:isSSL];
     
     [self.mySession addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
     */
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
    
    
    self.isDiscontent = NO;
    self.sessionManager.subscriptions = self.subedDict;
}

- (MQTTSSLSecurityPolicy *)customSecurityPolicy
{
    MQTTSSLSecurityPolicy *securityPolicy = [MQTTSSLSecurityPolicy policyWithPinningMode:MQTTSSLPinningModeNone];
    
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesCertificateChain = YES;
    securityPolicy.validatesDomainName = NO;
    return securityPolicy;
}

@end
