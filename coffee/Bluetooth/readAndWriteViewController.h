//
//  readAndWriteViewController.h
//  coffee
//
//  Created by 刘文锋 on 2017/10/30.
//  Copyright © 2017年 linfun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BabyBluetooth.h"

@interface readAndWriteViewController : UIViewController{
@public
    BabyBluetooth *baby;
}
@property(strong,nonatomic)CBPeripheral *currPeripheral;
@property (nonatomic,strong)CBCharacteristic *currCharacteristic;

@end
