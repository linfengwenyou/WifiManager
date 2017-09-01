//
//  LWSWifiManager.h
//  WifiDemo
//
//  Created by lawson on 2017/9/1.
//  Copyright © 2017年 ucsmy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWSWifiManager : NSObject

/**
 当前连接的wifi信息
 */
+ (NSDictionary *)lws_currentWifiInfo;

@end
