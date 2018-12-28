//
//  Tool.h
//  AusoBike
//
//  Created by Chang on 2017/11/2.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ResultBlock)(BOOL status,NSDictionary *result);

typedef NS_ENUM(NSInteger,AusoUserOption) {
    /** 用户Token */
    AusoUserOptionToken = 0,
    /** 用户UserID */
    AusoUserOptionUserId,
    /** 用户押金 */
    AusoUserOptionDeposit,
    /** 用户姓名 */
    AusoUserOptionUserName,
    /** 用户手机号 */
    AusoUserOptionMobile,
    /** 实名认证 0未认证  2已认证 */
    AusoUserOptionCard,
    /** 性别 */
    AusoUserOptionSex,
    /** 生日 */
    AusoUserOptionBirthday,
    /** 头像 */
    AusoUserOptionPhoto,
    /** 昵称 */
    AusoUserOptionNickName,
    /** 余额 */
    AusoUserOptionMoney
    
};

@interface Tool : NSObject
+ (void)Post:(NSString *)url param:(NSMutableDictionary *)param isHud:(BOOL)ishud result:(ResultBlock)block;
+ (void)Post:(NSString *)url param:(NSMutableDictionary *)param header:(NSMutableDictionary *)header isHUD:(BOOL)ishud result:(ResultBlock)block;
+ (void)Get:(NSString *)url param:(NSMutableDictionary *)param header:(NSMutableDictionary *)header isHUD:(BOOL)ishud result:(ResultBlock)block;
/** 应用版本号 */
+ (NSString *)GetAppVersion;

/** 获取随机数 */
+ (int)GetRandomNumber:(int)from To:(int)to;

/** 获取设备信息 */
+ (NSString *)GetDeviceInfo;

/** 是否已登录 */
+ (BOOL)IsLogin;

/** 是否实名认证 */
+ (BOOL)IsCertification;

/** 判断字符串是否为空 */
+ (BOOL)IsEmptyWithSting:(NSString *)string;


/** 获取用户信息 */
+ (NSString *)GetUserOption:(AusoUserOption)option;

/** 是否是手机号 */
+ (BOOL)IsPhoneNum:(NSString *)mobile;

+ (NSMutableDictionary *)AusoNetHeader;

+ (NSString *)deviceVersion;

+ (BOOL)isValidateIdentityCard:(NSString *)string;

+ (BOOL)isValidateUserName:(NSString *)string;

+ (NSString *)timestampSwitchTime:(NSInteger)timestamp withFormat:(NSString *)format;

+ (BOOL)isNetStatus;
@end
