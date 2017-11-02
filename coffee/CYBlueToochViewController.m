//
//  CYBlueToochViewController.m
//  coffee
//
//  Created by 纬线 on 2017/10/23.
//  Copyright © 2017年 linfun. All rights reserved.
//

#import "CYBlueToochViewController.h"
#import "BabyBluetooth.h"
#import "CYBluetoothManager.h"
#import "PreripheralViewController.h"

/** 判断手机蓝牙状态 */
#define SERVICE_UUID            @"CDD1"
#define CHARACTERISTIC_UUID     @"CDD2"

@interface CYBlueToochViewController (){
	 BabyBluetooth *baby;
}
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *get;
@property (weak, nonatomic) IBOutlet UIButton *post;



@property (nonatomic,strong) CBPeripheral *currPeripheral;
@property (nonatomic,strong) CBCharacteristic *characteristic;
@property (nonatomic,strong) CYBluetoothManager *blueManager;
@end

@implementation CYBlueToochViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    //初始化BabyBluetooth 蓝牙库
//    baby = [BabyBluetooth shareBabyBluetooth];
//    //设置蓝牙委托
//    [self babyDelegate];
    
//    self.blueManager = [CYBluetoothManager sharedInstance];
    

}
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
//    //停止之前的连接
//    [baby cancelAllPeripheralsConnection];
//    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
//    baby.scanForPeripherals().begin();
//    //baby.scanForPeripherals().begin().stop(10);
//    //2 扫描、连接
//    baby.scanForPeripherals().connectToPeripherals().begin();
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.blueManager readValueForCharacteristics];
            
        });
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //self.peripheral是一个CBPeripheral实例,self.characteristic是一个CBCharacteristic实例
            if (self.currPeripheral&& self.characteristic) {
                [baby notify:self.currPeripheral
              characteristic:self.characteristic
                       block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                           //接收到值会进入这个方法
                           NSLog(@"new value %@",characteristics.value);
                           self.textField.text = [[NSString alloc] initWithData:characteristics.value encoding:NSUTF8StringEncoding];
                       }];
            }
            
            
            

        });
    });
    
}

//设置蓝牙委托
-(void)babyDelegate{
    __weak typeof(self) weakSelf = self;
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
        NSLog(@"搜索到了设备:%@",peripheral);
        if([peripheral.name hasPrefix:@"i"]){
            
            weakSelf.currPeripheral = peripheral;
            
        }
    }];
    
    
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
- (IBAction)getClick:(id)sender {
//    //self.peripheral是一个CBPeripheral实例,self.characteristic是一个CBCharacteristic实例
//    baby.characteristicDetails(self.currPeripheral,self.characteristic);
    
    [self.blueManager readValueForOneCharacteristic];
}
- (IBAction)postClick:(id)sender {
    //示例：写一0X01到characteristic
//    Byte b = 0X01;
//    NSData *data = [NSData dataWithBytes:&b length:sizeof(b)];
    
    NSData *data = [self.textField.text dataUsingEncoding:NSUTF8StringEncoding];
//    [self.currPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
//    //若最后一个参数是CBCharacteristicWriteWithResponse，则会进入setBlockOnDidWriteValueForCharacteristic委托
    
    [self.blueManager writeValueforCharacteristic:data];
}
- (IBAction)scanButton:(id)sender {
    PreripheralViewController *vc = [[PreripheralViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
