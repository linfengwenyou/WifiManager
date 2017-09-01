//
//  LWSWifiManager.m
//  WifiDemo
//
//  Created by lawson on 2017/9/1.
//  Copyright © 2017年 ucsmy. All rights reserved.
//

#import "LWSWifiManager.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <arpa/inet.h>
#import <netinet/in.h>
#import <ifaddrs.h>
#include "getgateway.h"

#ifdef DEBUG
#define LWSLog(s, ...)\
NSLog(@"%s(%d): %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
#define LWSLog(s, ...)
#endif

@implementation LWSWifiManager

// 获取无线网络的信息
+ (NSDictionary *)lws_SSIDInfo
{
    
    NSArray *ifs = CFBridgingRelease(CNCopySupportedInterfaces());
    if (!ifs) {
        return nil;
    }
    
    NSDictionary *info = nil;
    for (NSString *ifName in ifs) {
        info = CFBridgingRelease(CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifName));
        if (info && [info count]) {
            break;
        }
    }
    return info;
}


+ (NSDictionary *)lws_currentWifiInfo
{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict addEntriesFromDictionary:[self lws_SSIDInfo]];
    
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        //*/
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    //----192.168.1.255 广播地址
                    NSString *broadcast = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
                    if (broadcast) {
                        [dict setObject:broadcast forKey:@"broadcast"];
                    }
                    //--192.168.1.106 本机地址
                    NSString *localIp = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    if (localIp) {
                        [dict setObject:localIp forKey:@"localIp"];
                    }
                    //--255.255.255.0 子网掩码地址
                    NSString *netmask = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                    if (netmask) {
                        [dict setObject:netmask forKey:@"netmask"];
                    }
                    //--en0 端口地址
                    NSString *interface = [NSString stringWithUTF8String:temp_addr->ifa_name];
                    if (interface) {
                        [dict setObject:interface forKey:@"interface"];
                    }
                    return [dict copy];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return [dict copy];
}

@end
