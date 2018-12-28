//
//  ServiceViewController.m
//  AusoBike
//
//  Created by Chang on 2017/11/14.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "ServiceViewController.h"

@interface ServiceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *dataArr;
@property (nonatomic,strong)NSArray *detailArr;
@property (nonatomic,strong)NSString *telphone;
@end

@implementation ServiceViewController
- (NSArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = @[@[@"总机服务台"],@[@"智能小松"],@[@"人工客服"]];
    }
    return _dataArr;
}

- (NSArray *)detailArr{
    if (_detailArr == nil) {
        _detailArr = @[@[@"引导您正确使用骜松单车：\n\t->开锁解锁功能演示\n\t->计费计算规则\n\t->停车点规划"],@[@"引导您退款、退押金、充值\n实名认证、学生认证、月卡、年卡办理"],@[@"遇到异常订单、骑行计价异常、无法关锁\n可以拨打我们的人工客服哦！"]];
    }
    return _detailArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的客服";
    [self getServiceInfo];
    [self configViews];
}

- (void)configViews{
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
}

#pragma mark -
#pragma mark - tableView 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 104;
    }
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArr[section]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"ServiceViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    cell.textLabel.text = self.dataArr[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont AvenirWithFontSize:16];
    cell.detailTextLabel.text = self.detailArr[indexPath.section][indexPath.row];
    cell.detailTextLabel.font= [UIFont HeitiSCWithFontSize:13];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0) {
        cell.textLabel.textColor = RGBORANGE;
    }else if (indexPath.section == 1){
        cell.textLabel.textColor = RGBLV;
    }else if (indexPath.section == 2){
        cell.textLabel.textColor = RGBRED;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        [self showInfo:@"正在开发中\n很快就和大家见面了 O(∩_∩)O~~"];
        return;
    }
    
    if (indexPath.section == 1) {
        [self showInfo:@"正在开发中\n很块就和大家见面了 O(∩_∩)O~~"];
        return;
    }
    
    
    if (self.telphone.length < 1 || self.telphone == nil) {
        [self showError:@"人工客服暂不可用"];
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"人工客服电话" message:self.telphone preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"拨打客服电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *tel= [NSString stringWithFormat:@"telprompt:%@",self.telphone];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:tel]];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)getServiceInfo{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"1" forKey:@"type"];

    [Tool Get:API_Service param:param header:nil isHUD:YES result:^(BOOL status, NSDictionary *result) {
        if (result) {
            if ([self resultVerify:result]) {
                NSArray *infoArr = [self resultData:result];
                NSDictionary *infoDic = [infoArr lastObject];
                self.telphone = [NSString stringWithFormat:@"%@",[infoDic valueForKey:@"mobile"]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
