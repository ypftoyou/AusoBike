//
//  Define.h
//  AusoBike
//
//  Created by Chang on 2017/11/2.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#ifndef Define_h
#define Define_h


#endif /* Define_h */

#if DEBUG
//#define API_DOMAIN  @"http://192.168.0.160:8089/"///测试服务器
#define API_DOMAIN  @"https://askj.bisilai.com/"///正式服务器

#else
#define API_DOMAIN  @"https://askj.bisilai.com/"///正式服务器
#endif

/** 账户密码登录 */
#define API_Login_Account  API_DOMAIN"api/v1/user/account"
#define API_Login_Code     API_DOMAIN"api/v1/login/show"
#define API_User_Info      API_DOMAIN"api/v1/userinfo"
#define API_Send_Code      API_DOMAIN"api/v1/login/create"
#define API_BikeList       API_DOMAIN"api/v1/trend"
#define API_Service        API_DOMAIN"api/v1/show"
#define API_BikeInfo       API_DOMAIN"api/v1/trend/show"
#define API_BikeUnlock     API_DOMAIN"api/v1/unlock"
#define API_BikeUnPayOrder API_DOMAIN"api/v1/trend/create"
#define API_AliPay         API_DOMAIN"api/v1/user/payalipay"
#define API_Motion         API_DOMAIN"api/v1/motion"
#define API_RouteList      API_DOMAIN"api/v1/userinfo/show"
#define API_UserPay        API_DOMAIN"api/v1/userpay"
#define API_Refund         API_DOMAIN"api/v1/user/refund/create"




#if DEBUG

#define NSLog(FORMAT, ...) fprintf(stderr,"[%s:%d行] %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

//#define NSLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])


#else
// 调到release模式 nslog 不会走
#define NSLog(FORMAT, ...) nil

#endif


/* - - - - - - - - 颜色宏 - - - - - - - - */

//主题色
#define RGB_THEME               RGBACOLOR(78,228,193,1)
//主题背景色
#define RGB_THEME_BACKGROUND    RGBACOLOR(36,36,36,1)
//RGB颜色
#define RGBACOLOR(r,g,b,a)      [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
//随机色
#define RANDOW_COLOR            [UIColor colorWithRed:(arc4random()%100)/100.0 green:(arc4random()%100)/100.0 blue:(arc4random()%100) alpha:1]

#define RGBGREEN            RGBACOLOR(187,228,108,1)
#define RGBBLUE             RGBACOLOR(137,210,248,1)
//#define RGBORANGE           RGBACOLOR(255,179,73,1)
#define RGBORANGE           RGBACOLOR(255,127,14,1)

#define RGBRED              RGBACOLOR(238,106,95,1)
#define RGBLV               RGBACOLOR(16, 162, 116, 1)//草地绿 真好看
#define RGBREPLACERED       RGBACOLOR(239,81,81,1)
#define RGB241              RGBACOLOR(241,241,241,1)
#define RGB100              RGBACOLOR(100,100,100,1)


/* - - - - - - - - 系统类 - - - - - - - - */
#define AlipayAppID @"2017092908992585"              //支付宝AppID,骜松单车
#define AMapKey @"4a563eaa3960e3a2b4bdbb09bd9cd56e"  //高德地图AppKey

#define KScreenHeight   [[UIScreen mainScreen] bounds].size.height
#define KScreenWidth    [[UIScreen mainScreen] bounds].size.width

#define UserDefault     [NSUserDefaults standardUserDefaults]
#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define KERROR_CONNECTION_FAILED     @"网络连接失败,请检查网络"
#define Result_Info  @"info"
#define Result_Code  @"code"

#define KCellFontSize   16.f

#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;


#define iphone4s ([[UIScreen mainScreen] bounds].size.height == 480)
#define iphone5s ([[UIScreen mainScreen] bounds].size.height == 568)
#define iPhone6Plus   ([[UIScreen mainScreen] bounds].size.width == 414)
#define iPhone6  ([[UIScreen mainScreen] bounds].size.width == 375)
// 判断是否是iPhone X
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//判断是否是ios7
#define ios7 ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
#define ios8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)

//Vier圆角
#define ViewRadius(View,Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

//View圆角加边框
#define ViewBorderRadius(View,Radius,Width,Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

//阴影
#define ViewShadow(View,Color,Offset,Radius,Opacity)\
\
[View.layer setShadowColor:[Color CGColor]];\
[View.layer setShadowOffset:(Offset)];\
[View.layer setShadowRadius:(Radius)];\
[View.layer setShadowOpacity:(Opacity)]

// 按钮点击事件
#define ADDBUTTON_Selector(button, selectorName) [button addTarget:self action:@selector(selectorName) forControlEvents:UIControlEventTouchUpInside]


//强弱引用
#define KWeakSelf(type)__weak typeof(type)weak##type = type;
#define KStrongSelf(type)__strong typeof(type)type = weak##type;

//imageName
#define IMAGE_NAMED(name)[UIImage imageNamed:name]

//由角度获取弧度 由弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)

/* - - - - - - - - User - - - - - - - - */
//此用户有加载过app，更换用户重新进行引导过程

#define WXAPPID @"wxb8ff1e0a69ca8411"//微信APPID

#define KUserAppLoad    @"user_app_load"

//用户Token
#define KUserToken      @"user_token"

//用户手机号
#define KUserPhone      @"user_telphone"

//用户id
#define KUserId         @"user_id"

//用户余额
#define KUserDeposit    @"user_deposit"

//是否登录了
#define KUserLogin      @"user_login"

//是否加载过押金
#define KUser_Load_Deposit @"user_load_deposit"

//是否进行过流程
#define KUser_Load_Guide @"user_load_guide"

#define Kuser_load_AD   @"user_load_ad"

#define KUser_NetStatus @"user_netstatus"
//
//通知用户去登陆
#define KUser_Notification_login    @"user_notification_login"

