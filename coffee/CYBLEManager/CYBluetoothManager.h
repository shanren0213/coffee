//
//  CYBluetoothManager.h
//  coffee
//
//  Created by 刘文锋 on 2017/10/28.
//  Copyright © 2017年 linfun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BabyBluetooth.h"

@interface CYBluetoothManager : NSObject{
    BabyBluetooth *baby;
}


@property (nonatomic,strong) CBPeripheral *currPeripheral;
@property (nonatomic,strong) CBCharacteristic *characteristic;
@property (nonatomic,strong) NSString *updateValueCharacteristic;

+ (instancetype)sharedInstance;

//初始化BabyBluetooth
- (void)createBabyBluetooth;

//获取characteristics的名称和值
- (void)readValueForCharacteristics;

//监听一个characteristic 的值
- (void)notifyValueForCharacteristic;

//发送Characteristic的值
- (void)writeValueforCharacteristic:(NSData *)data;

//获取单个特征的值
- (void)readValueForOneCharacteristic;

@end
