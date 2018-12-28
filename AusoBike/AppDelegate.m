//
//  AppDelegate.m
//  AusoBike
//
//  Created by Chang on 2017/11/2.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AlipaySDK/AlipaySDK.h>
#import "HomeViewController.h"

#import "AusoUser.h"
#import "ArchiveUtil.h"
#import <MJExtension.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [UserDefault setBool:NO forKey:Kuser_load_AD];
    /** 导航栏 */
    [self configNavigationBar];
    [self configAmap];
    [self afnReachabilityTest];
    //注册登陆通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkLoginNotification:) name:KUser_Notification_login object:nil];

    BaseNavigationController *navi = nil;
    if ([Tool IsLogin]) {
        [self getUserInfo];
        navi = [[BaseNavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init]];

    }else{
        navi = [[BaseNavigationController alloc]initWithRootViewController:[[LoginViewController alloc]init]];
    }
    
    self.window.rootViewController = navi;
    [self.window makeKeyWindow];
    return YES;
}



#pragma mark -
#pragma mark - 高德
- (void)configAmap{
    [AMapServices sharedServices].apiKey = AMapKey;
}

- (void)afnReachabilityTest {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 一共有四种状态
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                [UserDefault setBool:NO forKey:KUser_NetStatus];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [UserDefault setBool:YES forKey:KUser_NetStatus];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [UserDefault setBool:YES forKey:KUser_NetStatus];
                break;
            case AFNetworkReachabilityStatusUnknown:
            default:
                [UserDefault setBool:NO forKey:KUser_NetStatus];
                break;
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark -
#pragma mark - 导航栏全局设置
- (void)configNavigationBar{
    UIFont *font = [UIFont systemFontOfSize:18];
    
    NSDictionary *texteAttributes = @{NSFontAttributeName:font,NSForegroundColorAttributeName : [UIColor whiteColor] };
    [[UINavigationBar appearance] setTitleTextAttributes:texteAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    UIImage *image = [self imageWithColor:RGB_THEME_BACKGROUND];
    [[UINavigationBar appearance] setBackgroundImage:image forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      NSLog(@"result = %@",resultDic);
                                                      
                                                      //【callback处理支付结果】
                                                      NSString * strTitle = [NSString stringWithFormat:@"支付结果"];
                                                      NSString *strMsg;

                                                      if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                                                          
                                                          strMsg = @"恭喜您，支付成功!";
                                                          NSNotification *notification = [NSNotification notificationWithName:@"ALIPAY_ORDER_PAY_NOTIFICATION" object:@"success"];
                                                          [[NSNotificationCenter defaultCenter] postNotification:notification];
                                                          
                                                      }else if([resultDic[@"resultStatus"] isEqualToString:@"6001"])
                                                      {
                                                          strMsg = @"已取消支付!";
                                                          
                                                      }else{
                                                          strMsg = @"支付失败!";
                                                          
                                                      }
                                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                                      [alert show];
                                                      
                                                  }]; }
    if ([url.host isEqualToString:@"platformapi"]){ //支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSString * strTitle = [NSString stringWithFormat:@"支付结果"];
            NSString *strMsg;

            //【callback处理支付结果】
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {

                strMsg = @"恭喜您，支付成功!";
                NSNotification *notification = [NSNotification notificationWithName:@"ALIPAY_ORDER_PAY_NOTIFICATION" object:@"success"];
                [[NSNotificationCenter defaultCenter] postNotification:notification];

            }else if([resultDic[@"resultStatus"] isEqualToString:@"6001"])
            {
                strMsg = @"已取消支付!";

            }else{
                strMsg = @"支付失败!";

            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }else{
        //return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSString * strTitle = [NSString stringWithFormat:@"支付结果"];
            NSString *strMsg;

            //【callback处理支付结果】
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {

                strMsg = @"恭喜您，支付成功!";
                NSNotification *notification = [NSNotification notificationWithName:@"ALIPAY_ORDER_PAY_NOTIFICATION" object:@"success"];
                [[NSNotificationCenter defaultCenter] postNotification:notification];


            }else if([resultDic[@"resultStatus"] isEqualToString:@"6001"])
            {
                strMsg = @"已取消支付!";

            }else{
                strMsg = @"支付失败!";

            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];

            [alert show];
//
        }];
    }else{
//        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

/*
#pragma mark - 重写AppDelegate的handleOpenURL和openURL方法：
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma -mark ---微信回调
//回调方法
-(void)onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:{
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                NSNotification *notification = [NSNotification notificationWithName:@"ORDER_PAY_NOTIFICATION" object:@"success"];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                break;
            }
            default:{
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                NSNotification *notification = [NSNotification notificationWithName:@"ORDER_PAY_NOTIFICATION" object:@"fail"];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                break;
            }
        }
    }
}
*/


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 检测到登录通知
- (void)checkLoginNotification:(NSNotification *)noti{
    //删除本地信息
    [UserDefault removeObjectForKey:KUserLogin];
    
    AusoUser *user = [[AusoUser alloc]init];
    [ArchiveUtil saveUser:user];
    
    
    //判断现在根视图是不是loginView
    
    UIViewController *controller = [self currentViewController];
    
    if (![controller isKindOfClass:[LoginViewController class]]) {
        [controller presentViewController:[[LoginViewController alloc]init] animated:YES completion:nil];
    }
}

- (UIViewController*)currentViewController{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}
- (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - 拉取个人信息
- (void)getUserInfo{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"1" forKey:@"type"];
    
    [Tool Get:API_User_Info param:param header:[Tool AusoNetHeader] isHUD:NO result:^(BOOL status, NSDictionary *result) {
        if (status) {
            if ([[result valueForKey:@"code"]intValue] == 0) {
                NSLog(@"首页 拉取个人信息成功");
                AusoUser *temp = [ArchiveUtil getUser];
                //从后台拿到 用户信息
                AusoUser *user = [AusoUser mj_objectWithKeyValues:[result objectForKey:@"data"]];
                user.token = temp.token;
                user.user_id = temp.user_id;
                //归档
                [ArchiveUtil saveUser:user];
            }
        }
    }];
}


//禁用第三方键盘
- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier
{
    return NO;
}

@end
