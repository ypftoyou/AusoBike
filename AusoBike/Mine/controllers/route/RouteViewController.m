//
//  RouteViewController.m
//  AusoBike
//
//  Created by Chang on 2017/11/18.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "RouteViewController.h"
#import "RouteModel.h"
#import <MJExtension.h>
#import "RouteTableViewCell.h"
#import "BicyclingViewController.h"

@interface RouteViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,assign)NSInteger page;

@end

@implementation RouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    
    self.title = @"我的行程";
    [self configViews];
    
    [self getRouteListWithPage:self.page];
    
}
- (void)configViews{
    self.view.backgroundColor = RANDOW_COLOR;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    tableView.backgroundColor = RGB241;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    self.tableView = tableView;
}

#pragma mark -
#pragma mark - tableView 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"RouteViewCell";
    RouteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[RouteTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell initWithModel:self.dataArr[indexPath.section]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == self.dataArr.count - 1) {
        return 8;

    }else{
        return 0.001;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BicyclingViewController *bicyVC = [[BicyclingViewController alloc]init];
    bicyVC.routeModel = self.dataArr[indexPath.section];
    bicyVC.type = 2;
    [self.navigationController pushViewController:bicyVC animated:YES];
}
- (void)getRouteListWithPage:(NSInteger)page{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"1" forKey:@"type"];
    [param setValue:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    [Tool Get:API_RouteList param:param header:[Tool AusoNetHeader] isHUD:YES result:^(BOOL status, NSDictionary *result) {
        if (status) {
            if ([self resultVerify:result]) {
                //
                NSDictionary *data = [self resultData:result];
                NSArray *infoArr = [data valueForKey:@"data"];
                if (infoArr.count > 0) {
                    self.dataArr = [NSMutableArray array];
                    for (NSDictionary *infoDic in infoArr) {
                        RouteModel *model = [RouteModel mj_objectWithKeyValues:infoDic];
                        [self.dataArr addObject:model];
                    }
                    
                    [self.tableView reloadData];
                }
                NSLog(@"");
            }else{
                [self showInfo:[self resultInfo:result]];
                
            }
        }
    }];
}

- (void)footNormalView{
    
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
