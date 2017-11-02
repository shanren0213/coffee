//
//  readAndWriteViewController.m
//  coffee
//
//  Created by 刘文锋 on 2017/10/30.
//  Copyright © 2017年 linfun. All rights reserved.
//

#import "readAndWriteViewController.h"

#define channelOnCharacteristicView @"CharacteristicView"

@interface readAndWriteViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *readLabel;
@property (weak, nonatomic) IBOutlet UILabel *notifyLabel;

@end

@implementation readAndWriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self babyDelegate];
    [self loadData];
//    self.readLabel.text = [[NSString alloc]initWithData:self.currCharacteristic.value encoding:NSUTF8StringEncoding];
    NSLog(@"----self.currCharacteristic%@",self.currCharacteristic);
}
- (void)babyDelegate{
    __weak typeof(self) weakSelf = self;
    
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
    }];
    
    
    
    [baby setBlockOnReadValueForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"CharacteristicViewController===characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    
    
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
        weakSelf.readLabel.text = [[NSString alloc]initWithData:characteristics.value encoding:NSUTF8StringEncoding];
    }];
    
//    [baby setBlockOnReadValueForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
//        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
//        weakSelf.readLabel.text = [[NSString alloc]initWithData:characteristics.value encoding:NSUTF8StringEncoding];
//    }];
    
//    //设置读取characteristics的委托
//    [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
//        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
//    }];
//    //设置发现characteristics的descriptors的委托
//    [baby setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
//        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
//        for (CBDescriptor *d in characteristic.descriptors) {
//            NSLog(@"CBDescriptor name is :%@",d.UUID);
//        }
//    }];
//    //设置读取Descriptor的委托
//    [baby setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
//        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
//    }];
//
    
    
    [baby setBlockOnDidWriteValueForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"写入成功----characteristic name:%@ value is:%@",characteristic.UUID,characteristic.value);
    }];
    
    [baby setBlockOnDidWriteValueForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"写入成功----characteristic name:%@ value is:%@",characteristic.UUID,characteristic.value);
    }];
    
//    [baby notify:self.currPeripheral
//  characteristic:self.currCharacteristic
//           block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
//               //接收到值会进入这个方法
//               NSLog(@"new value %@",characteristics.value);
//               weakSelf.notifyLabel.text = [[NSString alloc] initWithData:characteristics.value encoding:NSUTF8StringEncoding];
//           }];
    
//    [baby setBlockOnDidUpdateNotificationStateForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
//        weakSelf.notifyLabel.text = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
//    }];
    
    [baby AutoReconnect:self.currPeripheral];
    
}
- (void)loadData{
//    baby.channel(channelOnCharacteristicView).characteristicDetails(self.currPeripheral,self.currCharacteristic);
    //连接外设
//    baby.having(self.currPeripheral).connectToPeripherals().discoverServices().begin();
    baby.characteristicDetails(self.currPeripheral,self.currCharacteristic);
   
    
}

- (IBAction)readButton:(id)sender {
//    baby.channel(channelOnCharacteristicView).characteristicDetails(self.currPeripheral,self.currCharacteristic);
//    baby.characteristicDetails(self.currPeripheral,self.currCharacteristic);
    [self.currPeripheral readValueForCharacteristic:self.currCharacteristic];
}

- (IBAction)writeButton:(id)sender {
    NSData *data = [self.textField.text dataUsingEncoding:NSUTF8StringEncoding];
    [self.currPeripheral writeValue:data forCharacteristic:self.currCharacteristic type:CBCharacteristicWriteWithResponse];
}

@end
