//
//  WFFWXMPPManager.m
//  WFChat
//
//  Created by babywolf on 17/8/17.
//  Copyright © 2017年 babywolf. All rights reserved.
//

#import "WFFWXMPPManager.h"
#import "XMPPStreamManagement.h"
#import "XMPPAutoPing.h"
#import "XMPPDateTimeProfiles.h"
#import "XMPPTimer.h"
#import "Common.h"

@interface WFFWXMPPManager()

@property (nonatomic, strong) NSString *domain;
@property (nonatomic, strong) NSString *resource;
@property (nonatomic, strong) NSString *hostName;
@property (nonatomic, assign) NSInteger port;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong) XMPPStreamManagement *streamManagement;
@property (nonatomic, strong) XMPPAutoPing *xmppAutoPing;
@property (nonatomic, strong) XMPPTimer *xmppTimer;
@property (nonatomic, strong) XMPPJID *JID;
@property (nonatomic) dispatch_queue_t workQueue;
@property (nonatomic) dispatch_queue_t storageQueue;

@end

@implementation WFFWXMPPManager

- (instancetype)init {
    if (self = [super init]) {
        self.connectionStatus = WFConnectionStatus_Unconnected;
        self.resource = @"mobile";
        self.hostName = [[NSUserDefaults standardUserDefaults] objectForKey:kHost];
        self.username = [[NSUserDefaults standardUserDefaults] objectForKey:kUsername];
        self.password = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
        self.port = 5222;
        self.workQueue = dispatch_queue_create([[NSString stringWithFormat:@"%@.work.%@",[self class],self] UTF8String], NULL);
        [self setupStream];
    }
    return self;
}

- (void)setupStream {
    self.xmppStream = [[XMPPStream alloc] init];
    self.xmppStream.enableBackgroundingOnSocket = YES;
    self.xmppReconnect = [[XMPPReconnect alloc] init];
    self.xmppReconnect.reconnectTimerInterval = 3;
    [self.xmppReconnect activate:self.xmppStream];
    
    self.xmppAutoPing = [[XMPPAutoPing alloc] init];
    self.xmppAutoPing.pingInterval = 10;
    self.xmppAutoPing.pingTimeout = 8;
    [self.xmppAutoPing activate:self.xmppStream];
    
    [self.xmppAutoPing addDelegate:self delegateQueue:self.workQueue];
    [self.xmppStream addDelegate:self delegateQueue:self.workQueue];
}

#pragma mark -- XMPPAutoPingDelegate
- (void)xmppAutoPingDidSendPing:(XMPPAutoPing *)sender {
    
}

- (void)xmppAutoPingDidReceivePong:(XMPPAutoPing *)sender {
    if (self.connectionStatus != WFConnectionStatus_Connected) {
        [self changeConnectionStatus:WFConnectionStatus_Connected];
    }
}

- (void)xmppAutoPingDidTimeout:(XMPPAutoPing *)sender {
    [self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:nil];
}

#pragma mark Connect/Disconnect
-(BOOL)connectWithUsername:(NSString *)username
                 password:(NSString *)password
                      host:(NSString *)host {
    self.username=username;
    self.password=password;
    self.hostName=host;
    self.JID = [XMPPJID jidWithUser:self.username domain:self.domain resource:self.resource];
    [self.xmppStream setMyJID:self.JID];
    [self.xmppStream setHostName:self.hostName];
    [self.xmppStream setHostPort:self.port];
    
    if (![self.JID.domain isEqualToString:self.xmppStream.myJID.domain]) {
        [self.xmppStream disconnectAfterSending];
        return NO;
    }
    NSError *error = nil;
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        return NO;
    }
    return YES;
}

- (void)changeConnectionStatus:(WFConnectionStatus)connectionStatus {
    self.connectionStatus = connectionStatus;
    if (self.connectionStatus == WFConnectionStatus_Connected) {
        
    }else {
        
    }
}

@end
