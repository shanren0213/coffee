//
//  ServiceInfo.h
//  coffee
//
//  Created by 刘文锋 on 2017/10/30.
//  Copyright © 2017年 linfun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ServiceInfo : NSObject
@property (nonatomic,strong) CBUUID *serviceUUID;
@property (nonatomic,strong) NSMutableArray *characteristics;

@end
