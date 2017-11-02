//
//  CYSettingViewController.m
//  coffee
//
//  Created by 纬线 on 2017/10/23.
//  Copyright © 2017年 linfun. All rights reserved.
//

#import "CYSettingViewController.h"
#import "CYByteManager.h"


@interface CYSettingViewController ()

@end

@implementation CYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    Byte bytes[]={0xA6,0xff,0b11};
//    int bLenght = sizeof(bytes);
//    NSLog(@"bLenght:%d",bLenght);
//    NSString *strIdL  = [NSString stringWithFormat:@"%@",[[NSString alloc]initWithFormat:@"%02lx",(long)bytes[1]]];
//    NSLog(@"%@",strIdL);
//    NSLog(@"%s",bytes);
//    NSData *adata = [[NSData alloc] initWithBytes:bytes length:3];
//    NSData *adata1 = [CYByteManager convertByteToData:bytes];
//    NSLog(@"adata:%@",adata);
//    NSLog(@"adata1:%@",adata1);
//
//
//
//    NSString *testString = @"iu78hgkuwhda67jkhjvf";
//    NSData *testData = [testString dataUsingEncoding: NSUTF8StringEncoding];
//    NSLog(@"%@",testData);
//    NSLog(@"testData length:%ld",[testData length]);
//    Byte *testByte = (Byte *)[testData bytes];
//    Byte testByte1[10];
//    int b = sizeof(testByte1);
//    NSLog(@"b:%d",b);
//
//    for(int i=0;i<[testData length];i++)
//        printf("testByte%d = %d\n",i,testByte[i]);
//    testByte[0] = 0x8f;
//    NSLog(@"%d",testByte[0]);
//
//    NSLog(@"---------------");
//
//    Byte bytes1[]={0xA6,0xff,0b11};
//    Byte bytes2[]={0x01,0x0A,0XFF};
//    int a = sizeof(bytes1);
//    NSLog(@"%d",a);
//
//    NSData *data1 = [[NSData alloc] initWithBytes:bytes1 length:3];
//    NSData *data2 = [[NSData alloc] initWithBytes:bytes2 length:3];
//    NSMutableData *mutabelData = [NSMutableData data];
//    [mutabelData appendData:data1];
//    [mutabelData appendData:data2];
//    [mutabelData appendBytes:bytes1 length:3];
//    bytes2[1] = 0x0B;
//    [mutabelData appendBytes:bytes2 length:3];
//
//    Byte *appendByte = (Byte *)[mutabelData bytes];
//    NSLog(@"%s",appendByte);
//
//    Byte *abc = malloc(12);
//    memset(abc, 0, 12);
//
//    for(int i=0;i<[mutabelData length];i++){
//        printf("testByte = %d\n",appendByte[i]);
////        memset(&abc[i], appendByte[i], 1);
//        abc[i] = appendByte[i];
//        printf("abc = %d\n",abc[i]);
//    }
//
//
//    //byte数组转16进制字符串
//    NSString *hexStr=@"";
//    for(int i=0;i<[mutabelData length];i++)
//    {
//        NSString *newHexStr = [NSString stringWithFormat:@"%x",abc[i]&0xff];///16进制数
//        if([newHexStr length]==1)
//            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
//        else
//            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
//    }
//    NSLog(@"bytes 的16进制数为:%@",hexStr);
//
//
//
//    NSLog(@"%@",mutabelData);
//    NSString *str = [[NSString alloc] initWithBytes:appendByte length:12 encoding:NSUTF8StringEncoding];
//    NSString *strData = [[NSString alloc] initWithData:mutabelData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",str);
//    NSLog(@"%@",strData);
    
//    Byte bytes3[]={0xA6,0xff,0b11,0xA6,0xff,0b11,0xA6,0x89};
//    NSData *data = [CYByteManager setTemperatureByte:bytes3 tem:90];
//    NSLog(@"%@",data);
//    NSData *subData =[data subdataWithRange:NSMakeRange(2, 3)];
//    Byte *byte = (Byte *)[subData bytes];
//    for(int i=0;i<[subData length];i++)
//        printf("subData %d = %d\n",i,byte[i]);
//    NSLog(@"----------");
//    NSLog(@"%@",subData);
//    for(int i=0;i<[data length];i++)
//        printf("data %d = %d\n",i,bytes3[i]);
    
//    Byte bytes4[]={0xA6,0xff,0b11,0xA6,0xff,0b11,0xA6,0x89,0xA6,0xff,0b11,0xA6,0xff,0b11};
//    NSData *data = [NSData dataWithBytes:bytes4 length:14];
//    CYByteModel *byteModel = [CYByteManager getByteModel:data];
//    NSLog(@"%d",byteModel.checkout);
    
    Byte *byte = [CYByteManager burstificationWithLength:8 type:1];
    NSData *data1 = [NSData dataWithBytes:byte length:8];
    NSLog(@"%@",data1);
    
    NSData *data = [CYByteManager setTemperatureByte:byte tem:100];
    NSLog(@"%@",data);
    data = [CYByteManager setTeamByte:byte duty:6];
    NSLog(@"%@",data);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
