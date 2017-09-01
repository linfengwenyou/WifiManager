### 目标：处理iOS涉及到的wifi操作

##### 获取当前连接的wifi信息 

```
NSLog(@"%@",[LWSWifiManager lws_currentWifiInfo]);

#log
2017-09-01 15:36:02.249783+0800 WifiDemo[510:69094] {
    BSSID = "58:97:bd:3a:2c:5f";
    SSID = "UCSMY-OA";
    SSIDDATA = <5543534d 592d4f41>;
    broadcast = "172.17.11.255";
    interface = en0;
    localIp = "172.17.9.71";
    netmask = "255.255.252.0";
}

```


#### 待补充。。

