//
//  WalletViewController.m
//  AusoBike
//
//  Created by Chang on 2017/11/13.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "WalletViewController.h"
#import "ReChargeViewController.h"
#import "ArchiveUtil.h"
#import "AusoUser.h"
#import "GuideViewController.h"
#import "BaseNavigationController.h"
#import "RechargeListViewController.h"
#import "RefundListViewController.h"
#import <MJExtension.h>
#import "ArchiveUtil.h"
#import "AusoUser.h"
#import <MJRefresh.h>

@interface WalletViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *dataArr;
@property (nonatomic,strong)NSArray *cellImgs;
@property (nonatomic,strong)UILabel *moneyLab;
@end

@implementation WalletViewController
- (NSArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = @[@"我的押金",@"充值记录",@"退款记录"];
    }
    return _dataArr;
}

- (NSArray *)cellImgs{
    if (_cellImgs == nil) {
        _cellImgs = @[@"ico_mywallet_mydeposit",@"ico_mywallet_rechargerecord",@"ico_mywallet_rechargerecord"];
    }
    return _cellImgs;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的钱包";
    self.view.backgroundColor = RGB241;
    [self configViews];
    [self getUserInfo];
    [self.tableView.mj_header beginRefreshing];
}


- (void)getUserInfo{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"1" forKey:@"type"];
    
    NSMutableDictionary *headerInfo = [NSMutableDictionary dictionary];
    [headerInfo setObject:[Tool GetUserOption:AusoUserOptionUserId] forKey:@"userid"];
    [headerInfo setObject:[Tool GetUserOption:AusoUserOptionToken] forKey:@"token"];
    
    [Tool Get:API_User_Info param:param header:headerInfo isHUD:NO result:^(BOOL status, NSDictionary *result) {
        [self.tableView.mj_header endRefreshing];
        if (status) {
            if ([self resultVerify:result]) {
                NSLog(@"%@",result);
                
                AusoUser *temp = [ArchiveUtil getUser];
                //从后台拿到 用户信息
                AusoUser *user = [AusoUser mj_objectWithKeyValues:[result objectForKey:@"data"]];
                user.token = temp.token;
                user.user_id = temp.user_id;
                //归档
                [ArchiveUtil saveUser:user];
                
                //刷新数据源
              NSString *str = [NSString stringWithFormat:@"%@ 元",[Tool GetUserOption:AusoUserOptionMoney]];
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:str];
                [attributedString addAttributes:@{NSForegroundColorAttributeName:RGB100} range:NSMakeRange(str.length - 1, 1)];
                [attributedString addAttributes:@{NSFontAttributeName:[UIFont AvenirWithFontSize:15]} range:NSMakeRange(str.length - 1, 1)];
                self.moneyLab.attributedText = attributedString;
                
                [self.tableView reloadData];
                
            }
        }
    }];
}

- (void)configViews{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.tableHeaderView = [self headerView];
    self.tableView = tableView;
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getUserInfo];
    }];
    
    UIButton *baseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:baseBtn];
    [baseBtn setImage:IMAGE_NAMED(@"btn_normol_blue") forState:UIControlStateNormal];
    baseBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [baseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        if (iphone5s) {
            make.left.mas_equalTo(20);
            make.bottom.mas_equalTo(self.view).mas_offset(-49);

        }else if (iphone4s){
            make.left.mas_equalTo(20);
            make.bottom.mas_equalTo(self.view).mas_offset(-8);

        }else{
            make.bottom.mas_equalTo(self.view).mas_offset(-49);

        }
    }];
    
    ViewShadow(baseBtn, RGBORANGE, CGSizeMake(0, 3), 3.f, 0.5);
    
    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:customBtn];
    
    [customBtn setTitle:@"去充值" forState:UIControlStateNormal];
    [customBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    customBtn.titleLabel.font = [UIFont HelveticaNeueFontSize:17];
    if (iphone5s || iphone4s) {
        customBtn.titleLabel.font = [UIFont HelveticaNeueFontSize:16];

    }
    [customBtn  addTarget:self action:@selector(chargeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [customBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(baseBtn);
        make.height.width.mas_equalTo(baseBtn);
      
    }];

//    UIButton *chargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:chargeBtn];
//
//    [chargeBtn setTitle:@"去充值" forState:UIControlStateNormal];
//     chargeBtn.titleLabel.font = [UIFont HelveticaNeueFontSize:17];
//    [chargeBtn setBackgroundImage:[UIImage imageNamed:@"btn_normol_blue"] forState:UIControlStateNormal];
//    [chargeBtn addTarget:self action:@selector(chargeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [chargeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//
//
//    [chargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.view).mas_offset(-49);
//        make.centerX.mas_equalTo(self.view.mas_centerX);
//        if (iphone5s || iphone4s) {
//            make.left.mas_equalTo(26);
//        }
//    }];
//
//    ViewShadow(chargeBtn, RGBORANGE, CGSizeMake(0, 3), 3.f, 0.5);

}

- (UIView *)headerView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth,KScreenWidth * 0.6)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *leftImgView = [[UIImageView alloc]init];
    [view addSubview:leftImgView];
    
    leftImgView.contentMode = UIViewContentModeScaleAspectFit;
    leftImgView.image = [UIImage imageNamed:@"ico_mywallet"];
    [leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(view);
        make.width.mas_equalTo(160);
    }];
    
    UILabel *moneyLab = [[UILabel alloc]init];
    [view addSubview:moneyLab];
    
//    moneyLab.text = @"1000.89元";
    moneyLab.textColor = RGBORANGE;
    NSString *str = [NSString stringWithFormat:@"%@ 元",[Tool GetUserOption:AusoUserOptionMoney]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:str];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:RGB100} range:NSMakeRange(str.length - 1, 1)];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont AvenirWithFontSize:15]} range:NSMakeRange(str.length - 1, 1)];
    moneyLab.attributedText = attributedString;
    
//    moneyLab.text = [NSString stringWithFormat:@"%@元",[Tool GetUserOption:AusoUserOptionMoney]];
    
    
    
    moneyLab.font = [UIFont HYQiHeiWithFontSize:30];
    self.moneyLab = moneyLab;
    
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(view.mas_centerY);
    }];
    
    UILabel *moneytitle = [[UILabel alloc]init];
    [view addSubview:moneytitle];
    
    moneytitle.text = @"我的余额";
    moneytitle.font = [UIFont AvenirWithFontSize:16];
    moneytitle.textAlignment = NSTextAlignmentRight;
    [moneytitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(moneyLab.mas_centerX);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(moneyLab.mas_top).offset(-16);
    }];
    
    return view;
}

#pragma mark -
#pragma mark - tableView 代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"walletTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    
    cell.imageView.image = [UIImage imageNamed:self.cellImgs[indexPath.row]];
    cell.textLabel.text = self.dataArr[indexPath.row];
    cell.textLabel.font = [UIFont AvenirWithFontSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == 0) {
//        cell.detailTextLabel.text = @"199元";
        cell.detailTextLabel.font = [UIFont HeitiSCWithFontSize:15];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        
        if ([[Tool GetUserOption:AusoUserOptionDeposit]integerValue] > 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@,退押金",[Tool GetUserOption:AusoUserOptionDeposit]];
        }else{
            cell.detailTextLabel.text = @"请交纳押金";
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if ([[Tool GetUserOption:AusoUserOptionDeposit]integerValue] > 0) {
            //退押金
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"退押金" message:@"Hi 主人，以后就要交299的押金了，您确定要退押金吗？" preferredStyle:UIAlertControllerStyleAlert];
            
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self refund];
            }]];
            
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else{
            [self getDepositInfo];
        }
    }else if (indexPath.row == 1){
        [self.navigationController pushViewController:[[RechargeListViewController alloc]init] animated:YES];
    }else{
        [self.navigationController pushViewController:[[RefundListViewController alloc]init] animated:YES];

    }
}

- (void)getDepositInfo{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"2" forKey:@"type"];
    
    [Tool Get:API_Service param:param header:nil isHUD:YES result:^(BOOL status, NSDictionary *result) {
        if (status) {
            if ([self resultVerify:result]) {
                //去交押金
                NSDictionary *infoDic = [self resultData:result];
                GuideViewController *guideVC = [[GuideViewController alloc]init];
                guideVC.initialPage = 2;
                guideVC.deposit = [NSString stringWithFormat:@"%@",[infoDic valueForKey:@"deposit"]];
                BaseNavigationController *navi = [[BaseNavigationController alloc]initWithRootViewController:guideVC];
                
                [self presentViewController:navi animated:YES completion:nil];
            }
        }
    }];
}

- (void)refund{
    //user/refund/create
    [Tool Get:API_Refund param:nil header:[Tool AusoNetHeader] isHUD:YES result:^(BOOL status, NSDictionary *result) {
        if (result) {
            if ([self resultVerify:result]) {
                
                AusoUser *user = [ArchiveUtil getUser];
                user.deposit = @"0";
                [ArchiveUtil saveUser:user];
                
                UIAlertView *okalert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请成功!押金将在1~3个工作日退回原支付账号!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [okalert show];
                
                [self.tableView reloadData];
            }else{
                [self showInfo:[self resultInfo:result]];
            }
        }
    }];
}



- (void)chargeBtnClick:(UIButton *)sender{
    ReChargeViewController *rechargeVC = [[ReChargeViewController alloc]init];
    rechargeVC.type = 2;
 
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    if (self.moneyLab) {
        self.moneyLab.text = [NSString stringWithFormat:@"%@元",[Tool GetUserOption:AusoUserOptionMoney]];
    }
    
    if (self.tableView) {
        [self.tableView.mj_header beginRefreshing];
    }
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
