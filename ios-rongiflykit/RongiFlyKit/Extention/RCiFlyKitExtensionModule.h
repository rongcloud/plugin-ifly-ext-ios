//
//  RCiFlyKitExtensionModule.h
//  RongiFlyKit
//
//  Created by Sin on 16/11/15.
//  Copyright © 2016年 Sin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>

@interface RCiFlyKitExtensionModule : NSObject <RongIMKitExtensionModule>
+ (instancetype)sharedRCiFlyKitExtensionModule;
- (void)setiFlyAppkey:(NSString *)key;
@end
