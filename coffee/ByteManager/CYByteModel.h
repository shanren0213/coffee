//
//  CYByteModel.h
//  coffee
//
//  Created by 刘文锋 on 2017/11/2.
//  Copyright © 2017年 linfun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYByteModel : NSObject
@property (nonatomic,assign) int machineState;//机器状态
@property (nonatomic,assign) int cup;//杯数
@property (nonatomic,assign) int timeOne;//咖啡时间1
@property (nonatomic,assign) int timeTwo;//
@property (nonatomic,assign) int timeThree;//
@property (nonatomic,assign) int timeFour;//
@property (nonatomic,assign) int pressureOne;//咖啡压力1
@property (nonatomic,assign) int pressureTwo;//
@property (nonatomic,assign) int pressureThree;//
@property (nonatomic,assign) int pressureFour;//
@property (nonatomic,assign) int temperature;//咖啡温度
@property (nonatomic,assign) int team;//蒸汽DUTY
@property (nonatomic,assign) int capacityClean;//清洁容量
@property (nonatomic,assign) int checkout;//检验和


@end
