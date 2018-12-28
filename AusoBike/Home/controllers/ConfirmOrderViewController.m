//
//  ConfirmOrderViewController.m
//  AusoBike
//
//  Created by Chang on 2017/11/23.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import <MapKit/MapKit.h>
#import "ReChargeViewController.h"

@interface ConfirmOrderViewController ()<UITableViewDelegate,UIAlertViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSArray *sourceArr;
@property (nonatomic,strong)NSArray *titleArr;

@end

@implementation ConfirmOrderViewController

- (NSArray *)titleArr{
    if (_titleArr == nil) {
        _titleArr = @[@"行程消费",@"费用详情"];
    }
    return _titleArr;
}

- (NSArray *)sourceArr{
    if (_sourceArr == nil) {
        _sourceArr = @[@[@"支付金额"],@[@"骑行时长",@"骑行费用"]];
    }
    return _sourceArr;
}

- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
        
        NSString *parice = [NSString stringWithFormat:@"%@ 元",[self.dict valueForKey:@"price"]];
        NSString *time_long = [NSString stringWithFormat:@"%@ 分钟",[self.dict valueForKeyPath:@"time_long"]];//骑行时长 分钟
        NSString *time_long_pricem = [NSString stringWithFormat:@"%@ 元",[self.dict valueForKeyPath:@"time_long_price"]];//骑行费用 元
        NSArray *arr1 = @[@[parice],@[time_long,time_long_pricem]];
        
        _dataArr = [NSMutableArray arrayWithArray:arr1];
        
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"确认订单";
    [self createNaviItemType:NaviItemTypeLeftButton NaviOperType:NaviOperTypeImage NameString:@"navi_btn_cancel"];

    [self configViews];
}
- (void)configViews{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"btn_normol_blue"] forState:UIControlStateNormal];
    [commitBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont HelveticaNeueFontSize:17];
    [commitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(userPay:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
    
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_bottom).offset(-120);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        if (iphone5s || iphone4s) {
            make.left.mas_equalTo(26);
        }
    }];
}

- (void)userPay:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
    
    if ([[Tool GetUserOption:AusoUserOptionMoney]doubleValue] < [[self.dict valueForKey:@"price"]doubleValue]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"余额不足" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去充值", nil];
        alert.tag = 66;
        [alert show];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:[self.dict valueForKey:@"order_sn"] forKey:@"order_sn"];
    [param setValue:[self.dict valueForKey:@"device"] forKey:@"device_no"];
    [param setValue:[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude] forKey:@"latitude"];
    [param setValue:[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude] forKey:@"longitude"];
    
    [Tool Post:API_UserPay param:param header:[Tool AusoNetHeader] isHUD:YES result:^(BOOL status, NSDictionary *result) {
        if (status) {
            if ([self resultVerify:result]) {
                [self showSuccess:[self resultInfo:result]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }else{
                [self showInfo:[self resultInfo:result]];
            }
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - tableView 代理

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArr[section]count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.titleArr[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"ConfirmOrderViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    cell.textLabel.text = self.sourceArr[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont AvenirWithFontSize:16];
    
    cell.detailTextLabel.text = self.dataArr[indexPath.section][indexPath.row];
    
    return cell;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //去充值
    if (alertView.tag == 66) {
        if (buttonIndex ==1) {
            ReChargeViewController *charge = [[ReChargeViewController alloc] init];
            charge.type = 2;
            [self.navigationController pushViewController:charge animated:YES];
        }
    }
}

- (void)navigationLeftBtnClick:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
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
