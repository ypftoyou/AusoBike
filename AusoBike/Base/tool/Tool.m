//
//  Tool.m
//  AusoBike
//
//  Created by Chang on 2017/11/2.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "Tool.h"
#import <AFNetworking.h>
#import <sys/utsname.h>
#import "ArchiveUtil.h"
#import "AusoUser.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>



@implementation Tool

+ (void)Post:(NSString *)url param:(NSMutableDictionary *)param isHud:(BOOL)ishud result:(ResultBlock)block{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    [param setObject:@"iOS" forKey:@"device"];
//    [param setObject:@"chargecook" forKey:@"apptype"];

    if (ishud) {
        [SVProgressHUD show];
    }
    [session POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (ishud) {
            [SVProgressHUD dismiss];
        }
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if (dict) {
            if ([[dict objectForKey:@"status"]integerValue] == 304) {
                //发通知 去登陆
                [[NSNotificationCenter defaultCenter]postNotificationName:KUser_Notification_login object:nil];
            }
        }
        
        block(YES,dict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (ishud) {
            [SVProgressHUD showErrorWithStatus:KERROR_CONNECTION_FAILED];
            [SVProgressHUD dismissWithDelay:1.5];
        }

        block(NO,nil);
    }];
}

+ (void)Post:(NSString *)url param:(NSMutableDictionary *)param header:(NSMutableDictionary *)header isHUD:(BOOL)ishud result:(ResultBlock)block{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    [param setObject:@"iOS" forKey:@"device"];
//    [param setObject:@"chargecook" forKey:@"apptype"];
    
    if (header != nil) {
        for (NSString *headerKey in header.allKeys) {
            NSString *value = header[headerKey];
            [session.requestSerializer setValue:value forHTTPHeaderField:headerKey];
        }
    }
    
    if (ishud) {
        [SVProgressHUD show];
    }
    [session POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (ishud) {
            [SVProgressHUD dismiss];
        }
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if (dict) {
            if ([[dict objectForKey:@"status"]integerValue] == 304) {
                //发通知 去登陆
                [[NSNotificationCenter defaultCenter]postNotificationName:KUser_Notification_login object:nil];
            }
        }
        
        block(YES,dict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (ishud) {
            [SVProgressHUD showErrorWithStatus:KERROR_CONNECTION_FAILED];
            [SVProgressHUD dismissWithDelay:1.5];
        }
        block(NO,nil);
    }];
}

+ (void)Get:(NSString *)url param:(NSMutableDictionary *)param header:(NSMutableDictionary *)header isHUD:(BOOL)ishud result:(ResultBlock)block{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];

    
    if (header != nil) {
        for (NSString *headerKey in header.allKeys) {
            NSString *value = header[headerKey];
            [session.requestSerializer setValue:value forHTTPHeaderField:headerKey];
        }
    }
    
    if (ishud) {
        [SVProgressHUD show];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    }
    
    [session GET:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (ishud) {
            [SVProgressHUD dismiss];
        }
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dict);
        if (dict) {
            if ([[dict objectForKey:@"code"]integerValue] == 304) {
                //发通知 去登陆
                [[NSNotificationCenter defaultCenter]postNotificationName:KUser_Notification_login object:nil];
            }
        }
        
        block(YES,dict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (ishud) {
            [SVProgressHUD showErrorWithStatus:KERROR_CONNECTION_FAILED];
            [SVProgressHUD dismissWithDelay:1.5];
        }
        NSLog(@"%@",error);
        
        block(NO,nil);
    }];
}
/*
+ (void)Get:(NSString *)url param:(NSMutableDictionary *)param header:(NSMutableDictionary *)header isHUD:(BOOL)ishud result:(ResultBlock)block result:(ResultBlock)block{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [param setObject:@"iOS" forKey:@"device"];
    [param setObject:@"chargecook" forKey:@"apptype"];
    
    if (header != nil) {
        for (NSString *headerKey in header.allKeys) {
            NSString *value = header[headerKey];
            [session.requestSerializer setValue:value forHTTPHeaderField:headerKey];
        }
    }
    
    if (ishud) {
        [SVProgressHUD show];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    }

    [session GET:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (ishud) {
            [SVProgressHUD dismiss];
        }
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if (dict) {
            if ([[dict objectForKey:@"code"]integerValue] == 304) {
                //发通知 去登陆
                [[NSNotificationCenter defaultCenter]postNotificationName:KUser_Notification_login object:nil];
            }
        }
        
        block(YES,dict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (ishud) {
            [SVProgressHUD showErrorWithStatus:error.domain];
            [SVProgressHUD dismissWithDelay:1.5];
        }
        NSLog(@"%@",error);
        
        block(NO,nil);
    }];
}
 */

+ (NSString *)GetAppVersion{
    return @"1";
}

+ (int)GetRandomNumber:(int)from To:(int)to{
    return (int)(from + (arc4random() % (to - from + 1)));
}

+ (NSString *)GetDeviceInfo{
    //    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //    NSLog(@"设备唯一标识符:%@",identifierStr);
    //手机别名： 用户定义的名称
    NSString* userPhoneName = [[UIDevice currentDevice] name];
    NSLog(@"手机别名: %@", userPhoneName);
    //设备名称
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    NSLog(@"设备名称: %@",deviceName );
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本: %@", phoneVersion);
    //手机型号
    NSString * phoneModel =  [self deviceVersion];
    NSLog(@"手机型号:%@",phoneModel);
    //地方型号  （国际化区域名称）
    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
    NSLog(@"国际化区域名称: %@",localPhoneModel );
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    // 当前应用版本号码   int类型
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    NSLog(@"物理尺寸:%.0f × %.0f",width,height);
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    NSLog(@"分辨率是:%.0f × %.0f",width*scale_screen ,height*scale_screen);
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    NSLog(@"运营商:%@", carrier.carrierName);
    
    NSString *SJBM      = [NSString stringWithFormat:@"手机别名:%@|",userPhoneName];
    NSString *SBMC      = [NSString stringWithFormat:@"设备名称:%@|",deviceName];
    NSString *SJXTBB    = [NSString stringWithFormat:@"手机系统版本:%@|",phoneVersion];
    NSString *SJXH      = [NSString stringWithFormat:@"手机型号:%@|",phoneModel];
    NSString *GJHQYMC   = [NSString stringWithFormat:@"国际化区域名称:%@|",localPhoneModel];
    NSString *DQYYRJBB  = [NSString stringWithFormat:@"当前应用软件版本:%@|",appCurVersion];
    NSString *DQYYBBH   = [NSString stringWithFormat:@"当前应用版本号码:%@|",appCurVersionNum];
    NSString *WLCC      = [NSString stringWithFormat:@"物理尺寸:%.0f x %.0f|",width,height];
    NSString *FBL       = [NSString stringWithFormat:@"分辨率:%.0f x %.0f|",width * scale_screen,height * scale_screen];
    NSString *YYS       = [NSString stringWithFormat:@"运营商:%@",carrier.carrierName];
    
    NSString *appendStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",SJBM,SBMC,SJXTBB,SJXH,GJHQYMC,DQYYRJBB,DQYYBBH,WLCC,FBL,YYS];
    return appendStr;
}

+ (NSString *)deviceVersion
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;

}

+ (BOOL)IsLogin{
    return [UserDefault boolForKey:KUserLogin];
}

+ (BOOL)IsCertification{
    if ([[Tool GetUserOption:AusoUserOptionCard]intValue] == 2) {
        return YES;
    }
    return NO;
}
+ (NSString *)GetUserOption:(AusoUserOption)option{
    if (![Tool IsLogin]) {
        return @"";
    }
    AusoUser *user = [ArchiveUtil getUser];
    if (!user) {
        return @"";//文件被第三方工具破坏
    }
    
    switch (option) {
        case AusoUserOptionToken:
            return user.token;
        case AusoUserOptionUserName:
            return user.username;
        case AusoUserOptionDeposit:
            return user.deposit;
        case AusoUserOptionUserId:
            return user.user_id;
        case AusoUserOptionMobile:
            return user.mobile;
        case AusoUserOptionCard:
            return user.card;
        case AusoUserOptionSex:
            return user.sex;
        case AusoUserOptionMoney:
            return user.money;
        case AusoUserOptionPhoto:
            return user.images;
        case AusoUserOptionBirthday:
            return user.birthday;
        case AusoUserOptionNickName:
            return user.nickname;
        default:
            return @"";
    }
}

+ (BOOL)IsPhoneNum:(NSString *)mobile{
    //手机号以13， 15，18, 17开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(14[^4,\\D])|(17[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    BOOL valide = [phoneTest evaluateWithObject:mobile];
    return valide;
}

+ (NSMutableDictionary *)AusoNetHeader{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:[Tool GetUserOption:AusoUserOptionUserId] forKey:@"userid"];
    [param setValue:[Tool GetUserOption:AusoUserOptionToken] forKey:@"token"];
    return param;
}

#pragma mark - 判断空
+ (BOOL)IsEmptyWithSting:(NSString *)string{
    if ([string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        return NO;
    }else{
        return YES;
    }
}

+ (BOOL)isValidateIdentityCard:(NSString *)string{
    BOOL flag;
    if (string.length <= 0) {
        flag = NO;
        return flag;
    }
    
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:string];
}

+ (BOOL)isValidateUserName:(NSString *)string{
    //    字母 数字 下划线
    //   /^[a-zA-Z\d \x{4e00}-\x{9fa5}]+$/us
    //[A-Za-z0-9_\-\u4e00-\u9fa5]+
    NSString *userNameRegex = @"[A-Za-z0-9_\\-\u4e00-\u9fa5]+";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    return  [userNamePredicate evaluateWithObject:string];
}

+ (NSString *)timestampSwitchTime:(NSInteger)timestamp withFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if (format == nil || format.length < 1) {
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    }else{
        [formatter setDateFormat:format];
    }
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
    
}

+ (BOOL)isNetStatus{
    return [UserDefault boolForKey:KUser_NetStatus];
}
@end
