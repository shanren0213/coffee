//
//  ServiceInfo.m
//  coffee
//
//  Created by 刘文锋 on 2017/10/30.
//  Copyright © 2017年 linfun. All rights reserved.
//

#import "ServiceInfo.h"

@implementation ServiceInfo

-(instancetype)init{
    self = [super init];
    if (self) {
        _characteristics = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
