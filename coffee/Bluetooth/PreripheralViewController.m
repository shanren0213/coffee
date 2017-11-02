//
//  PreripheralViewController.m
//  coffee
//
//  Created by 刘文锋 on 2017/10/28.
//  Copyright © 2017年 linfun. All rights reserved.
//

#import "PreripheralViewController.h"
#import "BabyBluetooth.h"
#import "SVProgressHUD.h"
#import "CharacteristicViewController.h"

@interface PreripheralViewController ()
{
    BabyBluetooth *baby;
    NSMutableArray *peripheralDataArray;
}
@end

@implementation PreripheralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
    
    [SVProgressHUD showInfoWithStatus:@"准备打开设备"];
    NSLog(@"viewDidLoad");
    peripheralDataArray = [[NSMutableArray alloc]init];
    
    //初始化BabyBluetooth 蓝牙库
    baby = [BabyBluetooth shareBabyBluetooth];
    //设置蓝牙委托
    [self babyDelegate];
    //停止之前的连接
    [baby cancelAllPeripheralsConnection];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    baby.scanForPeripherals().begin();
    //baby.scanForPeripherals().begin().stop(10);
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"viewWillDisappear");
}

#pragma mark -蓝牙配置和操作

//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    
    __weak typeof(self) weakSelf = self;
    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBManagerStatePoweredOn) {
            [SVProgressHUD showInfoWithStatus:@"设备打开成功，开始扫描设备"];
        }else{
            [SVProgressHUD showInfoWithStatus:@"请开启蓝牙!"];
        }
        switch (central.state) {
            case CBManagerStatePoweredOn:
                NSLog(@"CBManagerStatePoweredOn");
                [SVProgressHUD showSuccessWithStatus:@"蓝牙已打开"];
                break;
            case CBManagerStatePoweredOff:
                NSLog(@"CBManagerStatePoweredOff");
                [SVProgressHUD showErrorWithStatus:@"蓝牙已关闭"];
                break;
            case CBManagerStateResetting:
                NSLog(@"CBManagerStateResetting");
                break;
                
            case CBManagerStateUnsupported:
                NSLog(@"CBManagerStateUnsupported");
                break;
                
            case CBManagerStateUnauthorized:
                NSLog(@"CBManagerStateUnauthorized");
                break;
                
            case CBManagerStateUnknown:
                NSLog(@"CBManagerStateUnknown");
                break;
        }
    }];
    
    
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备-名称:%@",peripheral.name);
        NSLog(@"搜索到了设备:%@",peripheral);
        [weakSelf insertTableView:peripheral advertisementData:advertisementData RSSI:RSSI];
    }];
    

    
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        
        //最常用的场景是查找某一个前缀开头的设备
        //        if ([peripheralName hasPrefix:@"Pxxxx"] ) {
        //            return YES;
        //        }
        //        return NO;
        
        //设置查找规则是名称大于0 ， the search rule is peripheral.name length > 0
//        if (peripheralName.length >0) {
//            return YES;
//        }
        return YES;
    }];
    

    
}

#pragma mark -UIViewController 方法
//插入table数据
-(void)insertTableView:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    NSArray *peripherals = [peripheralDataArray valueForKey:@"peripheral"];
    if(![peripherals containsObject:peripheral]) {
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:peripherals.count inSection:0];
        [indexPaths addObject:indexPath];
        
        NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
        [item setValue:peripheral forKey:@"peripheral"];
        [item setValue:RSSI forKey:@"RSSI"];
        [item setValue:advertisementData forKey:@"advertisementData"];
        [peripheralDataArray addObject:item];
        
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return peripheralDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSDictionary *item = [peripheralDataArray objectAtIndex:indexPath.row];
    NSDictionary *advertisementData = [item valueForKey:@"advertisementData"];
    CBPeripheral *peripheral = [item valueForKey:@"peripheral"];
    NSNumber *RSSI = [item objectForKey:@"RSSI"];
    
    NSString *peripheralName;
    if ([advertisementData objectForKey:@"kCBAdvDataLocalName"]) {
        peripheralName = [NSString stringWithFormat:@"%@",[advertisementData objectForKey:@"kCBAdvDataLocalName"]];
    }else if (!([peripheral.name isEqualToString:@""] || peripheral.name == nil)){
        peripheralName = peripheral.name;
    }else{
        peripheralName = [peripheral.identifier UUIDString];
    }
    
    cell.textLabel.text = peripheralName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"RSSI:%@",RSSI];
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //停止扫描
    [baby cancelScan];
    
    CharacteristicViewController *VC = [[CharacteristicViewController alloc] init];
    NSDictionary *item = [peripheralDataArray objectAtIndex:indexPath.row];
    
    CBPeripheral *peripheral = [item valueForKey:@"peripheral"];
    
    VC.currPeripheral = peripheral;
    VC->baby = baby;
    [self.navigationController pushViewController:VC animated:YES];
    
}



@end
