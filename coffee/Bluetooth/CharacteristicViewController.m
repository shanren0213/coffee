//
//  CharacteristicViewController.m
//  coffee
//
//  Created by 刘文锋 on 2017/10/28.
//  Copyright © 2017年 linfun. All rights reserved.
//

#import "CharacteristicViewController.h"
#import "SVProgressHUD.h"
#import "ServiceInfo.h"
#import "readAndWriteViewController.h"

#define width [UIScreen mainScreen].bounds.size.width
#define height [UIScreen mainScreen].bounds.size.height

@interface CharacteristicViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;


@end

@implementation CharacteristicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD showWithStatus:@"正在连接设备"];
    
    [self babyDelegate];
    
    [self.view addSubview:self.tableView];
    
//    [self performSelector:@selector(loadData) withObject:nil afterDelay:2];
    [self loadData];
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width, height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}
-(NSMutableArray *)services{
    if (!_services) {
        _services = [[NSMutableArray alloc] init];
    }
    return _services;
}

- (void)loadData{
    //设置peripheral 然后读取services,然后读取characteristics名称和值和属性，获取characteristics对应的description的名称和值
    //self.peripheral是一个CBPeripheral实例
    baby.having(self.currPeripheral).connectToPeripherals().discoverServices().discoverCharacteristics()
    .readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
}

- (void)babyDelegate{
    __weak typeof(self) weakSelf = self;
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    
    [baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接成功",peripheral.name]];
    }];
    
    //设置设备连接失败的委托
    [baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--连接失败",peripheral.name);
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接失败",peripheral.name]];
    }];
    
    //设置设备断开连接的委托
    
    [baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--断开连接",peripheral.name);
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--断开失败",peripheral.name]];
    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *s in peripheral.services) {
            ///插入section到tableview
            [weakSelf insertSectionToTableView:s];
        }
    }];
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        //插入row到tableview
        [weakSelf insertRowToTableView:service];
        
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    
}

- (void)insertSectionToTableView:(CBService *)service{
    ServiceInfo *info = [[ServiceInfo alloc] init];
    info.serviceUUID = service.UUID;
    [self.services addObject:info];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:self.services.count-1];
    [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)insertRowToTableView:(CBService *)service{
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    int sect = -1;
    for (int i = 0; i < self.services.count; i++) {
        ServiceInfo *info = [self.services objectAtIndex:i];
        if (service.UUID == info.serviceUUID) {
            sect = i;
        }
    }
    if (sect != -1) {
        ServiceInfo *info = [self.services objectAtIndex:sect];
        for (int row =0; row <service.characteristics.count; row++) {
            CBCharacteristic *c = service.characteristics[row];
            [info.characteristics addObject:c];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:sect];
            [indexPaths addObject:indexPath];
             NSLog(@"add indexpath in row:%d, sect:%d",row,sect);
        }
        ServiceInfo *curInfo =[self.services objectAtIndex:sect];
        NSLog(@"%@",curInfo.characteristics);
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.services.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ServiceInfo *info = self.services[section];
    return info.characteristics.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"characteristicsCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"characteristicsCell"];
    }
    
    ServiceInfo *info = self.services[indexPath.section];
    CBCharacteristic *characteristic = info.characteristics[indexPath.row];
    cell.textLabel.text = [characteristic.UUID UUIDString];
    cell.detailTextLabel.text = characteristic.description;
    
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    ServiceInfo *info = self.services[section];
    label.text = [info.serviceUUID UUIDString];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor darkGrayColor];
    
    return label;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    readAndWriteViewController *vc = [[readAndWriteViewController alloc] init];
    ServiceInfo *info = self.services[indexPath.section];
    CBCharacteristic *characteristic = info.characteristics[indexPath.row];
    vc.currCharacteristic = characteristic;
    vc.currPeripheral = self.currPeripheral;
    vc->baby = baby;
    [self.navigationController pushViewController:vc animated:YES];
}





@end
