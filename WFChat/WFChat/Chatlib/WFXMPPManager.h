//
//  WFFWXMPPManager.h
//  WFChat
//
//  Created by babywolf on 17/8/17.
//  Copyright © 2017年 babywolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

typedef NS_ENUM(NSInteger, WFConnectionStatus) {
    WFConnectionStatus_UNKNOWN = -1,
    
    WFConnectionStatus_Connected = 0,
    
    WFConnectionStatus_Connecting = 1,
    
    WFConnectionStatus_Unconnected = 2
};

@interface WFXMPPManager : NSObject

@property (nonatomic, strong) XMPPStream *xmppStream;
@property (nonatomic, assign) WFConnectionStatus connectionStatus;

@end
