//
//  CharacteristicViewController.h
//  coffee
//
//  Created by 刘文锋 on 2017/10/28.
//  Copyright © 2017年 linfun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BabyBluetooth.h"

@interface CharacteristicViewController : UIViewController{
    @public
    BabyBluetooth *baby;
}

@property (nonatomic, strong) NSMutableArray *services;
@property(strong,nonatomic)CBPeripheral *currPeripheral;

@end
