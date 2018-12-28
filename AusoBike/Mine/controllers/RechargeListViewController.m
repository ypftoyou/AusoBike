//
//  RechargeListViewController.m
//  AusoBike
//
//  Created by Chang on 2017/11/23.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "RechargeListViewController.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "ChargeRecordCell.h"


@interface RechargeListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView    *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,assign) NSInteger      page;

@end

@implementation RechargeListViewController

- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"充值记录";
    _page = 1;
    [self configViwes];

    [self.tableView.mj_header beginRefreshing];
//    [self getInfoWithPage:self.page];
    
}


- (UIView *)footView{
    UILabel *labe = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenWidth)];
    labe.text = @"您还没有充值记录哦！";
    labe.font = [UIFont AvenirWithFontSize:18];
    labe.textAlignment = NSTextAlignmentCenter;
    return labe;
}

- (void)configViwes{
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
//    tableView.tableHeaderView = [self headerView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.dataArr = [NSMutableArray array];
        self.page = 1;
        [self getInfoWithPage:self.page];
    }];
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [self getInfoWithPage:self.page];
    }];
    
}

#pragma mark -
#pragma mark - tableView 代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"RechargeListViewCell";
    ChargeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[ChargeRecordCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.types = @"0";
    cell.infoDict =  self.dataArr[indexPath.row];
    
    
    return cell;
}

- (void)getInfoWithPage:(NSInteger)page{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"3" forKey:@"type"];
    [param setValue:@"31" forKey:@"status"];
    [param setValue:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];

    [Tool Get:API_RouteList param:param header:[Tool AusoNetHeader] isHUD:YES result:^(BOOL status, NSDictionary *result) {
        if (page == 1) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        if (status) {
            if ([self resultVerify:result]) {
                NSDictionary *data = [self resultData:result];
                NSArray *infoArr = [data valueForKey:@"data"];
                if (infoArr.count > 0) {
                    //有数据
                    for (NSDictionary *infoDic in infoArr) {
                        [self.dataArr addObject:infoDic];
                    }
                    self.tableView.tableFooterView = [UIView new];
                    [self.tableView reloadData];
                }else{
                    if (self.page == 1) {
                        self.tableView.tableFooterView = [self footView];
                    }
                }
            }else{
                if (self.page == 1) {
                    self.tableView.tableFooterView = [self footView];

                }
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
