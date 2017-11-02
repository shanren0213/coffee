//
//  CYBluetoothManager.m
//  coffee
//
//  Created by 刘文锋 on 2017/10/28.
//  Copyright © 2017年 linfun. All rights reserved.
//

#import "CYBluetoothManager.h"


@implementation CYBluetoothManager



+(instancetype)sharedInstance{
    static CYBluetoothManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CYBluetoothManager alloc] init];
    });
    return manager;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        [self createBabyBluetooth];
    }
    return self;
}

//初始化BabyBluetooth
- (void)createBabyBluetooth{
    //初始化BabyBluetooth 蓝牙库
    baby = [BabyBluetooth shareBabyBluetooth];
    //设置蓝牙委托
    [self babyDelegate];
    
    //开始扫描
    [self startScan];
    
}

#pragma mark - 获取characteristics的名称和值
- (void)readValueForCharacteristics{
    //设置peripheral 然后读取services,然后读取characteristics名称和值和属性，获取characteristics对应的description的名称和值
    //self.peripheral是一个CBPeripheral实例
    if (self.currPeripheral) {
        baby.having(self.currPeripheral).connectToPeripherals().discoverServices().discoverCharacteristics()
        .readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    }
}

#pragma mark - 发送Characteristic的值
- (void)writeValueforCharacteristic:(NSData *)data{
    if (self.currPeripheral&& self.characteristic) {
        
        [self.currPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        //若最后一个参数是CBCharacteristicWriteWithResponse，则会进入setBlockOnDidWriteValueForCharacteristic委托
    }
    
}
#pragma mark - 获取单个特征的值
- (void)readValueForOneCharacteristic{
    if (self.currPeripheral&& self.characteristic) {
        
        //self.peripheral是一个CBPeripheral实例,self.characteristic是一个CBCharacteristic实例
        baby.characteristicDetails(self.currPeripheral,self.characteristic);
    }
}

#pragma mark - 监听一个characteristic 的值

- (void)notifyValueForCharacteristic{
    __weak typeof(self) weakSelf = self;
    
    //self.peripheral是一个CBPeripheral实例,self.characteristic是一个CBCharacteristic实例
    if (self.currPeripheral&& self.characteristic) {
        [baby notify:self.currPeripheral
      characteristic:self.characteristic
               block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                   //接收到值会进入这个方法
                   NSLog(@"new value %@",characteristics.value);
                   weakSelf.updateValueCharacteristic = [[NSString alloc] initWithData:characteristics.value encoding:NSUTF8StringEncoding];
               }];
    }
}

//开始扫描
- (void)startScan{
    //停止之前的连接
    [baby cancelAllPeripheralsConnection];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    baby.scanForPeripherals().begin();
    //baby.scanForPeripherals().begin().stop(10);
    //2 扫描、连接
    baby.scanForPeripherals().connectToPeripherals().begin();
}


//设置蓝牙委托
-(void)babyDelegate{
    
    __weak typeof(self) weakSelf = self;
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
        NSLog(@"搜索到了设备:%@",peripheral);
        if([peripheral.name hasPrefix:@"陈"]){
        
            weakSelf.currPeripheral = peripheral;
            
        }
    }];
    
    //过滤器
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        //最常用的场景是查找某一个前缀开头的设备
        //        if ([peripheralName hasPrefix:@"i"] ) {
        //            return YES;
        //        }
        //return NO;
        //设置查找规则是名称大于1 ， the search rule is peripheral.name length > 1
        if (peripheralName.length >1) {
            return YES;
            
        }
        return NO;
    }];
    
    //示例：
    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBManagerStatePoweredOn) {
            NSLog( @"设备打开成功，开始扫描设备");
        }
    }];
    
    /*
     *搜索设备后连接设备：1:先设置连接的设备的filter 2进行连接
     */
    //1：设置连接的设备的过滤器
    __block BOOL isFirst = YES;
    [baby setFilterOnConnectToPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        //这里的规则是：连接第一个AAA打头的设备
        if(isFirst && [peripheralName hasPrefix:@"i"]){
            isFirst = NO;
            return YES;
        }
        return NO;
    }];
    
    
    
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"设备：%@--连接成功",peripheral.name);
    }];
    
    //设置设备连接失败的委托
    [baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--连接失败",peripheral.name);
    }];
    
    //设置设备断开连接的委托
    [baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--断开连接",peripheral.name);
        //        [baby AutoReconnect:self.currPeripheral];
    }];
    
    
    
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        for (CBCharacteristic *c in service.characteristics) {
            NSLog(@"charateristic name is :%@",c.UUID);
            
        }
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        if ([characteristics.UUID.UUIDString isEqual:@"CDD2"]) {
            NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
            weakSelf.characteristic = characteristics;
        }
        
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    //写Characteristic成功后的block
    [baby setBlockOnDidWriteValueForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"写Characteristic成功后的block:%@,value:%@",characteristic.UUID,characteristic.value);
    }];
    
    
    
}

@end
