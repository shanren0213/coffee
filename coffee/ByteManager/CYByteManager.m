//
//  CYByteManager.m
//  coffee
//
//  Created by 刘文锋 on 2017/11/1.
//  Copyright © 2017年 linfun. All rights reserved.
//

#import "CYByteManager.h"


@implementation CYByteManager

//byte 数组转换为data
+ (NSData *)convertByteToData:(Byte [])bytes{
    int bLenght = sizeof(bytes);
    NSData *data = [[NSData alloc] initWithBytes:bytes length:bLenght];
    return data;
}

//data 转换成 byte数组
+ (Byte *)convertDataToByte:(NSData *)data{
    Byte *testByte = (Byte *)[data bytes];
//    for(int i=0;i<[data length];i++)
//        printf("testByte = %d\n",testByte[i]);
    return testByte;
}
//截取
- (void)bytesplit2byte:(Byte[])src orc:(Byte[])orc begin:(NSInteger)begin count:(NSInteger)count{
    memset(orc, 0, sizeof(char)*count);
    for (NSInteger i = begin; i < begin+count; i++){
        orc[i-begin] = src[i];
    }
}
//获取咖啡机的数据
+ (CYByteModel *)getByteModel:(NSData *)data{
    CYByteModel *byteModel = [[CYByteModel alloc] init];
    Byte *byte = (Byte *)[data bytes];
    
    for(int i=0;i<[data length];i++){
        printf("subData %d = %d\n",i,byte[i]);
        
    }
    byteModel.machineState = byte[0];
    byteModel.cup = byte[1];
    byteModel.timeOne = byte[2];
    byteModel.timeTwo = byte[3];
    byteModel.timeThree = byte[4];
    byteModel.timeFour = byte[5];
    byteModel.pressureOne = byte[6];
    byteModel.pressureTwo = byte[7];
    byteModel.pressureThree = byte[8];
    byteModel.pressureFour = byte[9];
    byteModel.temperature = byte[10];
    byteModel.team = byte[11];
    byteModel.capacityClean = byte[12];
    byteModel.checkout = byte[13];
    
    return byteModel;
    
    
}

#pragma mark - 公共方法

+ (Byte *)malloc_init:(int)length{
    Byte *c = malloc(length);
    memset(c, 0, length);
    return c;
}

//设置头 idx表示指令长度 (8或者13)
+ (void)setHeadByte:(Byte *)byte idx:(int)idx{
    memset(&byte[0], 0xA5, 1);
    memset(&byte[1], idx, 1);
}

//设置命令类型 (1或者2)
+ (void)setTypeByte:(Byte *)byte type:(int)type{
    memset(&byte[2], type, 1);
}


//根据命令类型来组包
+ (Byte *)burstificationWithLength:(int)length type:(int)type{
    Byte *c = [CYByteManager malloc_init:length];
    [CYByteManager setHeadByte:c idx:length];
    [CYByteManager setTypeByte:c type:type];
    NSData *data = [NSData dataWithBytes:c length:length];
    Byte *byte = (Byte *)[data bytes];
    free(c);
    return byte;
}
//获取当前命令类型1的 byte 数组
+ (Byte *)currentByteOfTypeOne:(NSData *)data{
    Byte *byte =  [CYByteManager burstificationWithLength:8 type:1];
    CYByteModel *byteModel = [CYByteManager getByteModel:data];
    
    memset(&byte[3], byteModel.temperature, 1);
    memset(&byte[4], byteModel.team, 1);
    memset(&byte[5], byteModel.capacityClean, 1);
    memset(&byte[6], 0, 1);//出厂设置
    memset(&byte[7], byteModel.checkout, 1);
    
    return byte;
}

//获取当前命令类型2的 byte 数组
+ (Byte *)currentByteOfTypeTwo:(NSData *)data{
    Byte *byte =  [CYByteManager burstificationWithLength:13 type:2];
    CYByteModel *byteModel = [CYByteManager getByteModel:data];
    
    memset(&byte[3], byteModel.timeOne, 1);
    memset(&byte[4], byteModel.timeTwo, 1);
    memset(&byte[5], byteModel.timeThree, 1);
    memset(&byte[6], byteModel.timeFour, 1);
    memset(&byte[7], byteModel.pressureOne, 1);
    memset(&byte[8], byteModel.pressureTwo, 1);
    memset(&byte[9], byteModel.pressureThree, 1);
    memset(&byte[10], byteModel.pressureFour, 1);
    memset(&byte[11], byteModel.cup, 1);
    memset(&byte[12], byteModel.checkout, 1);
    
    return byte;
}

#pragma mark - 长度8,命令类型1

//根据索引设置参数(长度8)
+ (NSData *)settingParametersWithByte:(Byte *)byte idx:(int)idx value:(int)value{
    memset(&byte[idx], value, 1);
    NSData *data = [NSData dataWithBytes:byte length:8];
    return data;
}

//咖啡温度
+ (NSData *)setTemperatureByte:(Byte *)byte tem:(int)tem{
    
    return [CYByteManager settingParametersWithByte:byte idx:3 value:tem];
}
//蒸汽 DUTY
+ (NSData *)setTeamByte:(Byte *)byte duty:(int)duty{
    
    return [CYByteManager settingParametersWithByte:byte idx:4 value:duty];
}
//清洗容量
+ (NSData *)setCleancapacity:(Byte *)byte capacity:(int)capacity{
    return [CYByteManager settingParametersWithByte:byte idx:5 value:capacity];
}
//出厂设置
+ (NSData *)setFactorySetting:(Byte *)byte state:(int)state{
    return [CYByteManager settingParametersWithByte:byte idx:6 value:state];
}
//检验和
+ (NSData *)setCheckout:(Byte *)byte sum:(int)sum{
    return [CYByteManager settingParametersWithByte:byte idx:6 value:sum];
}

#pragma mark - 长度13,命令类型2

//根据索引设置参数(长度13)
+ (NSData *)settingParametersAndTypeTwoWithByte:(Byte *)byte idx:(int)idx value:(int)value{
    memset(&byte[idx], value, 1);
    NSData *data = [NSData dataWithBytes:byte length:13];
    return data;
}

//咖啡时间1
+ (NSData *)setOneCoffeeTimeWithByte:(Byte *)byte time:(int)time{
    return [CYByteManager settingParametersAndTypeTwoWithByte:byte idx:3 value:time];
}
//咖啡时间2
+ (NSData *)setTwoCoffeeTimeWithByte:(Byte *)byte time:(int)time{
    return [CYByteManager settingParametersAndTypeTwoWithByte:byte idx:4 value:time];
}
//咖啡时间3
+ (NSData *)setThreeCoffeeTimeWithByte:(Byte *)byte time:(int)time{
    return [CYByteManager settingParametersAndTypeTwoWithByte:byte idx:5 value:time];
}
//咖啡时间4
+ (NSData *)setFourCoffeeTimeWithByte:(Byte *)byte time:(int)time{
    return [CYByteManager settingParametersAndTypeTwoWithByte:byte idx:6 value:time];
}
//咖啡压力
+ (NSData *)setOnePressureWithByte:(Byte *)byte pre:(int)pre{
    return [CYByteManager settingParametersAndTypeTwoWithByte:byte idx:7 value:pre];
}
//咖啡压力
+ (NSData *)setTwoPressureWithByte:(Byte *)byte pre:(int)pre{
    return [CYByteManager settingParametersAndTypeTwoWithByte:byte idx:8 value:pre];
}
//咖啡压力
+ (NSData *)setThreePressureWithByte:(Byte *)byte pre:(int)pre{
    return [CYByteManager settingParametersAndTypeTwoWithByte:byte idx:9 value:pre];
}
//咖啡压力
+ (NSData *)setFourPressureWithByte:(Byte *)byte pre:(int)pre{
    return [CYByteManager settingParametersAndTypeTwoWithByte:byte idx:10 value:pre];
}

//杯数
+ (NSData *)setCupsWithByte:(Byte *)byte cup:(int)cup{
    return [CYByteManager settingParametersAndTypeTwoWithByte:byte idx:11 value:cup];
}
//检验和
+ (NSData *)setCheckoutOfTypeTwoWithByte:(Byte *)byte sum:(int)sum{
    return [CYByteManager settingParametersAndTypeTwoWithByte:byte idx:12 value:sum];
}
@end
