//
//  CYByteManager.h
//  coffee
//
//  Created by 刘文锋 on 2017/11/1.
//  Copyright © 2017年 linfun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYByteModel.h"

@interface CYByteManager : NSObject

//byte数组 转换为data
+ (NSData *)convertByteToData:(Byte[])bytes;

//data 转换成 byte数组
+ (Byte *)convertDataToByte:(NSData *)data;

//根据命令类型来组包
+ (Byte *)burstificationWithLength:(int)length type:(int)type;

//获取咖啡机的数据
+ (CYByteModel *)getByteModel:(NSData *)data;

//获取当前命令类型1的 byte 数组
+ (Byte *)currentByteOfTypeOne:(NSData *)data;

//获取当前命令类型2的 byte 数组
+ (Byte *)currentByteOfTypeTwo:(NSData *)data;

#pragma mark - 长度8,命令类型1

//咖啡温度
+ (NSData *)setTemperatureByte:(Byte *)byte tem:(int)tem;

//蒸汽 DUTY
+ (NSData *)setTeamByte:(Byte *)byte duty:(int)duty;

//清洗容量
+ (NSData *)setCleancapacity:(Byte *)byte capacity:(int)capacity;

//出厂设置
+ (NSData *)setFactorySetting:(Byte *)byte state:(int)state;

//检验和
+ (NSData *)setCheckout:(Byte *)byte sum:(int)sum;



#pragma mark - 长度13,命令类型2

//根据索引设置参数(长度13)
+ (NSData *)settingParametersAndTypeTwoWithByte:(Byte *)byte idx:(int)idx value:(int)value;

//咖啡时间1
+ (NSData *)setOneCoffeeTimeWithByte:(Byte *)byte time:(int)time;
//咖啡时间2
+ (NSData *)setTwoCoffeeTimeWithByte:(Byte *)byte time:(int)time;
//咖啡时间3
+ (NSData *)setThreeCoffeeTimeWithByte:(Byte *)byte time:(int)time;
//咖啡时间4
+ (NSData *)setFourCoffeeTimeWithByte:(Byte *)byte time:(int)time;

//咖啡压力
+ (NSData *)setOnePressureWithByte:(Byte *)byte pre:(int)pre;
//咖啡压力
+ (NSData *)setTwoPressureWithByte:(Byte *)byte pre:(int)pre;
//咖啡压力
+ (NSData *)setThreePressureWithByte:(Byte *)byte pre:(int)pre;
//咖啡压力
+ (NSData *)setFourPressureWithByte:(Byte *)byte pre:(int)pre;

//杯数
+ (NSData *)setCupsWithByte:(Byte *)byte cup:(int)cup;
//检验和
+ (NSData *)setCheckoutOfTypeTwoWithByte:(Byte *)byte sum:(int)sum;
@end
