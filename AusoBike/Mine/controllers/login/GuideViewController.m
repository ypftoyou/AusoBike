//
//  GuideViewController.m
//  AusoBike
//
//  Created by Chang on 2017/11/2.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "GuideViewController.h"
#import "GuideMainView.h"
#import "HomeViewController.h"
#import "BaseNavigationController.h"
#import "GuideHeader.h"
#import "AusoUser.h"
#import "ArchiveUtil.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ReChargeViewController.h"

@interface GuideViewController ()<GuideMainViewDelegate>
@property (nonatomic,strong) GuideMainView *guideView;
@property (nonatomic,strong) GuideHeader *headerView;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,assign) NSInteger indexPage;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [UserDefault setBool:YES forKey:KUser_Load_Guide];
    
    self.title = @"实名认证";
    if (self.initialPage == 0) {
        self.title = @"手机验证";
    }else if (self.initialPage == 1){
        self.title = @"实名认证";
    }else if (self.initialPage == 2){
        self.title = @"交纳押金";
    }else{
        self.title = @"完成";
    }
    
    self.indexPage = self.initialPage;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(aliPayCallBack:) name:@"ALIPAY_ORDER_PAY_NOTIFICATION" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configViews];
    [self createNaviItemType:NaviItemTypeLeftButton NaviOperType:NaviOperTypeImage NameString:@"navi_btn_cancel"];
}

#pragma mark -
#pragma makr - 实装界面
- (void)configViews{
    [self setupHeaderView];
    [self setupMainViews];
}
- (void)setupHeaderView{
    UIImage *image = IMAGE_NAMED(@"bg_pagination1");
    
    self.headerView = [[GuideHeader alloc]initWithFrame:CGRectMake(8, 10, KScreenWidth - 16, image.size.height)];
    self.headerView.center = CGPointMake(self.view.center.x, self.headerView.center.y);
    self.headerView.indexPage = self.indexPage;
    [self.view addSubview:self.headerView];
    
    UITapGestureRecognizer *singTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBory)];
    [self.view addGestureRecognizer:singTap];

}

- (void)hideKeyBory{
    [self.view endEditing:YES];
}

- (void)setupMainViews{
    
    CGFloat Y = 60.0;
    if (iphone5s|| iphone4s) {
        Y = 40.0;
    }
    self.guideView = [[GuideMainView alloc]initWithFrame:CGRectMake(0,self.headerView.bottom + Y, KScreenWidth, KScreenHeight - self.headerView.height - Y - 74)];
    self.guideView.backgroundColor = [UIColor whiteColor];
    self.guideView.delegate = self;
    if (self.initialPage > 0) {
        self.guideView.deposit = self.deposit;
    }
    
    self.guideView.initialPage = self.indexPage;
    [self.view addSubview:self.guideView];
    
}


- (void)getDepositInfo{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"2" forKey:@"type"];
    
    [Tool Get:API_Service param:param header:nil isHUD:YES result:^(BOOL status, NSDictionary *result) {
        if (status) {
            if ([self resultVerify:result]) {
                //去交押金
                NSDictionary *infoDic = [self resultData:result];
                
                self.deposit = [NSString stringWithFormat:@"%@",[infoDic valueForKey:@"deposit"]];
                self.guideView.deposit = self.deposit;
                [self nextPage];
            }else{
                [self showInfo:[self resultInfo:result]];
            }
        }
    }];
}

#pragma mark -
#pragma mark - GuideMainView代理

- (void)guideMainViewPageOneSendCodeWithPhont:(NSString *)phone{
    
}

- (void)guideMainViewPageOneVerifyWithPhone:(NSString *)phone code:(NSString *)code{
    [self nextPage];
}

- (void)guideMainViewPageTwoCommitWithName:(NSString *)name IdCard:(NSString *)idcard{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                             message:@"请确认您所输入的身份信息真实有效，否则将会影响您的押金退还"
                                                                      preferredStyle:UIAlertControllerStyleAlert ];
    
    //添加确定到UIAlertController中
    UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *doneAlert = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self realNameAuthenticationWithName:name IdCard:idcard];

    }];
    [alertController addAction:cancelAlert];
    [alertController addAction:doneAlert];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)guideMainViewPageThreePayType:(GuideMainViewPayType)payType{
    if (payType == GuideMainViewPayTypeWeChatPay) {
        [self showError:@"暂不支持微信支付"];
        return;
    }
    
    [self payWithAliPay];
}

- (void)guideMainViewPageFourAction:(GuideMainViewAction)action{
    if (action == GuideMainViewActionExperience) {
        //立即体验
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        BaseNavigationController *navi = [[BaseNavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init]];
        window.rootViewController = navi;

    }else{
        //充值去吧
    }
}

#pragma mark - 获取支付宝支付
- (void)payWithAliPay{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"2" forKey:@"type"];
    [param setValue:self.deposit forKey:@"prices"];
    
    [Tool Get:API_AliPay param:param header:[Tool AusoNetHeader] isHUD:YES result:^(BOOL status, NSDictionary *result) {
        if (status) {
            [self resultVerify:result];
            
            NSArray *orderArr = [self resultData:result];
            NSLog(@"订单信息---%@",orderArr);
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
                    BOOL isSuccess =NO;
                    if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                        
                        strMsg = @"恭喜您，支付成功!";
                        isSuccess = YES;
                    }else if([resultDic[@"resultStatus"] isEqualToString:@"6001"])
                    {
                        strMsg = @"已取消支付!";
                        
                    }else{
                        strMsg = @"支付失败!";
                    }
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:strTitle
                                                                                             message:strMsg
                                                                                      preferredStyle:UIAlertControllerStyleAlert ];
                    
                    //添加确定到UIAlertController中
                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        if (isSuccess) {
                            [self nextPage];
                        }
                    }];
                    [alertController addAction:OKAction];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
            
                }];
            }
        }
    }];
}

#pragma mark - 支付回调通知
- (void)aliPayCallBack:(NSNotification *)nofification{
    AusoUser *user = [ArchiveUtil getUser];
    user.deposit = self.deposit;
    [ArchiveUtil saveUser:user];
    
    [self nextPage];
    
    //跳转到充值页面
    ReChargeViewController *rechargeVC = [[ReChargeViewController alloc]init];
    rechargeVC.type = 1;
    [rechargeVC setRefreshBlock:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

- (void)nextPage{
    self.indexPage ++;
    if (self.indexPage == 1) {
        self.title = @"实名认证";
    }else if (self.indexPage == 2){
        self.title = @"押金充值";
    }else if (self.indexPage == 3){
        self.title = @"完成";
    }
    
    [self.headerView nextPage];
    [self.guideView nextPageWithAnimation:YES];
}

#pragma mark - navigation left item method
- (void)navigationLeftBtnClick:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];

    /*
    NSString *msg = @"是否退出流程？";
    if (self.indexPage == 0) {
        //说明当前还没有实名认证
//        msg = @"是否退出实名认证？";
        
    }else if (self.indexPage == 1){
//        msg = @"是否退出实名认证？";
    }else if (self.indexPage == 2){
//        msg = @"是否退出押金充值？";
    }else{
        //已经完成  直接退出
        [self.view endEditing:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:msg
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {

                                                          [self dismissViewControllerAnimated:YES completion:nil];

                                                      }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
    */

}

#pragma mark - net 实名认证
- (void)realNameAuthenticationWithName:(NSString *)name IdCard:(NSString *)idcard{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:name forKey:@"username"];
    [param setValue:idcard forKey:@"cade"];
    [param setValue:@"1" forKey:@"type"];
    
    
    [SVProgressHUD showWithStatus:@"实名认证中..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];

    [Tool Post:API_User_Info param:param header:[Tool AusoNetHeader] isHUD:NO result:^(BOOL status, NSDictionary *result) {
        if (status) {
            if ([self resultVerify:result]) {
                //实名认证成功
                AusoUser *user = [ArchiveUtil getUser];
                user.card = @"2";
                [ArchiveUtil saveUser:user];
                
                [SVProgressHUD showSuccessWithStatus:@"实名认证成功"];
                [SVProgressHUD dismissWithDelay:1.0 completion:^{
                    //判断是否交了押金
                    if ([[Tool GetUserOption:AusoUserOptionDeposit]floatValue] < 1) {
                        //没交押金
                        [self getDepositInfo];
                    }else{
                        self.headerView.indexPage = 3;
                        self.guideView.initialPage = 3;
                    }
                }];
            }else{
                [self showInfo:[self resultInfo:result]];
            }
        }else{
            [self showError:@"网络连接失败，请检查网络"];
        }
    }];
}

#pragma mark - net 交纳押金
- (void)paymentDeposit{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ALIPAY_ORDER_PAY_NOTIFICATION" object:nil];
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
