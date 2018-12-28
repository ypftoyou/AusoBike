//
//  ReChargeViewController.m
//  AusoBike
//
//  Created by Chang on 2017/11/14.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "ReChargeViewController.h"
#import "UIColor+Image.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AusoUser.h"
#import "ArchiveUtil.h"
#import <MJExtension.h>

@interface ReChargeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray  *dataArr;
@property (nonatomic,strong) NSArray  *imageArr;
@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,strong) UIButton *choosePayBtn;
@property (nonatomic,strong) UIButton *rechargeBtn;
@property (nonatomic,strong) NSArray  *moneyArr;

@end

@implementation ReChargeViewController

- (NSArray *)moneyArr{
    if (_moneyArr == nil) {
        _moneyArr = @[@"20",@"50",@"100",@"200",@"300"];
    }
    return _moneyArr;
}

- (NSArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = @[@"微信",@"支付宝"];
    }
    return _dataArr;
}

- (NSArray *)imageArr{
    if (_imageArr == nil) {
        _imageArr = @[@"ico_pay_wechat",@"ico_pay_zfb"];
    }
    return _imageArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"充值";
    [self configViews];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(aliPayCallBack:) name:@"ALIPAY_ORDER_PAY_NOTIFICATION" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
}
#pragma mark - 支付回调通知
- (void)aliPayCallBack:(NSNotification *)nofification{
    
    //充值成功
    //刷新下数据
    [self getUserInfo];
    
}


- (void)configViews{
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [self footerView];
    tableView.tableHeaderView = [self headerView];
}


- (UIView *)headerView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenWidth * 0.4)];
    view.backgroundColor = [UIColor whiteColor];
    
    CGFloat magin = 20;
    CGFloat w = (KScreenWidth - magin * 4) / 3;
    
    int b = self.moneyArr.count % 3;
    CGFloat h = (view.height - magin * (b + 1)) / b;
    for (int i = 0; i < self.moneyArr.count; i++) {
        int row = i / 3;
        int num = i % 3;
        
        UIButton *button       = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame           = CGRectMake(magin + (w + magin) * num, magin + (h + magin) * row, w, h);
        
        button.backgroundColor = [UIColor whiteColor];
        [button setBackgroundImage:[UIColor  imageWithColor:RGBORANGE] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIColor imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        NSString *title        = [NSString stringWithFormat:@"充值%@元",self.moneyArr[i]];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:RGB100 forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(choosePayType:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont AvenirWithFontSize:13];
        
        button.tag             = 1711141829 + i;
        
        ViewBorderRadius(button, 2, 1, RGBORANGE);
        
        [view addSubview:button];
        
        if (i == 0) {
            self.choosePayBtn = button;
            self.choosePayBtn.selected = YES;

        }
    }
    return view;
}

- (UIView *)footerView{
    
    UIView *view  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 120)];
    
    UIButton *baseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:baseBtn];
    [baseBtn setImage:IMAGE_NAMED(@"btn_normol_blue") forState:UIControlStateNormal];
    baseBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [baseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(view).mas_offset(-10);
        make.centerX.mas_equalTo(view.mas_centerX);
        if (iphone5s || iphone4s) {
            make.left.mas_equalTo(20);
        }
    }];
    
    ViewShadow(baseBtn, RGBORANGE, CGSizeMake(0, 3), 3.f, 0.5);
    
    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:customBtn];
    
    self.rechargeBtn = customBtn;
    
    [customBtn setTitle:@"马上充值" forState:UIControlStateNormal];
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
    //    [view addSubview:chargeBtn];
    //
    //    self.rechargeBtn = chargeBtn;
    //    [chargeBtn setTitle:@"马上充值" forState:UIControlStateNormal];
    //    chargeBtn.titleLabel.font = [UIFont HelveticaNeueFontSize:17];
    //    [chargeBtn setBackgroundImage:[UIImage imageNamed:@"btn_normol_blue"] forState:UIControlStateNormal];
    //    [chargeBtn addTarget:self action:@selector(chargeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [chargeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //
    //
    //    [chargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.mas_equalTo(view).mas_offset(-10);
    //        make.centerX.mas_equalTo(view.mas_centerX);
    //        if (iphone5s || iphone4s) {
    //            make.left.mas_equalTo(26);
    //        }
    //    }];
    //
    //    ViewShadow(chargeBtn, RGBORANGE, CGSizeMake(0, 3), 3.f, 0.5);
    
    return view;
}
#pragma mark -
#pragma mark - tableView 代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"ReChargeViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [cell.contentView addSubview:button];
        
        button.tag = 1711141808 + indexPath.row;
        [button setImage:[UIImage imageNamed:@"btn_recharge_tick_nor"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"btn_recharge_tick_press"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectPayBtn:) forControlEvents:UIControlEventTouchUpInside];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(cell.contentView.mas_right).offset(0);
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            make.height.width.mas_equalTo(50);
        }];
        
        if (indexPath.row == 1) {
            button.selected = YES;
            self.selectBtn = button;
        }else{
            button.selected = NO;
        }
    }
    
    cell.textLabel.text = self.dataArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)selectPayBtn:(UIButton *)btn{
    if (btn.tag == 1711141808) {
        [self showInfo:@"微信支付暂未开通"];
        return;
    }
    
    if (btn != self.selectBtn) {
        self.selectBtn.selected = NO;
        btn.selected = YES;
        self.selectBtn = btn;
    }
}

- (void)choosePayType:(UIButton *)sender{
    if (sender != self.choosePayBtn) {
        self.choosePayBtn.selected = NO;
        sender.selected = YES;
        self.choosePayBtn = sender;
    }
}

- (void)chargeBtnClick:(UIButton *)sender{
    //调用支付宝
    if (!self.choosePayBtn) {
        [self showInfo:@"请选择充值金额"];
        return;
    }
    if (!self.selectBtn) {
        [self showInfo:@"请选择充值方式"];
        return;
    }
    
    NSString *money = self.moneyArr[self.choosePayBtn.tag - 1711141829];
    NSString *payType = self.selectBtn.tag == 1711141808 ? @"微信":@"支付宝";
    
    NSLog(@"充值金额：%@  充值方式：%@",money,payType);
    [self showSuccess:@"开始充值"];
    [self aliPay:sender];
    
}

- (void)aliPay:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    NSString *money = self.moneyArr[self.choosePayBtn.tag - 1711141829];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"1" forKey:@"type"];
    [param setValue:money forKey:@"prices"];
    
    //测试的
//    if ([[Tool GetUserOption:AusoUserOptionMobile]isEqualToString:@"15210713101"]) {
//        [param setValue:@"0.1" forKey:@"prices"];
//    }
    [Tool Get:API_AliPay param:param header:[Tool AusoNetHeader] isHUD:YES result:^(BOOL status, NSDictionary *result) {
        sender.userInteractionEnabled = YES;
        if (status) {
            if ([self resultVerify:result]) {
                NSArray *orderArr = [self resultData:result];
                NSLog(@"%@",orderArr);
                NSString *myString;
                //拼接orderString
                NSMutableString *orderString = [[NSMutableString alloc]init];
                for (NSString *contentstr in orderArr) {
                    if (![contentstr isEqualToString:[orderArr lastObject]]) {
                        myString = [contentstr stringByAppendingString:@"&"];
                    }else{
                        myString = contentstr;
                    }
                    [orderString appendFormat:@"%@", myString];
                    
                    // NOTE: 如果加签成功，则继续执行支付
                }
                
                if (orderString != nil) {
                    //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
                    NSString *appScheme = @"AusoBike";
                    
                    // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
                    
                    // NOTE: 调用支付结果开始支付
                    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                        NSLog(@"reslut = %@",resultDic);
                        NSString * strTitle = [NSString stringWithFormat:@"支付结果"];
                        NSString *strMsg;
                        
                        //【callback处理支付结果】
                        if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                            strMsg = @"恭喜您，支付成功!";
                            [self getUserInfo];
                        }else if([resultDic[@"resultStatus"] isEqualToString:@"6001"]){
                            strMsg = @"已取消支付!";
                        }else{
                            strMsg = @"支付失败!";
                        }
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }];
                }
                
            }else{
                [self showInfo:[self resultInfo:result]];
            }
        }
    }];
}

- (void)getUserInfo{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"1" forKey:@"type"];
    
    NSMutableDictionary *headerInfo = [NSMutableDictionary dictionary];
    [headerInfo setObject:[Tool GetUserOption:AusoUserOptionUserId] forKey:@"userid"];
    [headerInfo setObject:[Tool GetUserOption:AusoUserOptionToken] forKey:@"token"];
    
    [Tool Get:API_User_Info param:param header:headerInfo isHUD:YES result:^(BOOL status, NSDictionary *result) {
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
                
                if (self.refreshBlock) {
                    self.refreshBlock();
                }
                
                if (self.type == 2) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    self.refreshBlock();

                }
                
            }else{
                [self showInfo:[self resultInfo:result]];
                if (self.type == 2) {
                    [self.navigationController popViewControllerAnimated:YES];

                }else{
                    self.refreshBlock();
                }
            }
        }else{
            if (self.type == 2) {
                [self.navigationController popViewControllerAnimated:YES];

            }else{
                self.refreshBlock();
            }
        }
    }];
}



- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationLeftBtnClick:(UIButton *)sender{
    if (self.type == 2) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        self.refreshBlock();
    }
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

