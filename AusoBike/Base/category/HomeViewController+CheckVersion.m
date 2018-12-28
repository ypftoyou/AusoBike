//
//  HomeViewController+CheckVersion.m
//  AusoBike
//
//  Created by Chang on 2017/11/25.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "HomeViewController+CheckVersion.h"

#define APP_URL  @"http://itunes.apple.com/lookup?id=1308154769"

@implementation HomeViewController (CheckVersion)

- (void)checkVersion {
    //获取 当前版本
    NSString *currentVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    __block NSString *newVersion = nil;
    
    //版本比较，如果newVersion小于currentVersion，则返回-1，大于则返回1，相等返回0
    int(^compareVersion)(NSString *newVersion, NSString *currentVersion) = ^(NSString *newVersion, NSString *currentVersion) {
        
        if (newVersion == nil || currentVersion == nil) {
            return 0;
        }
        int i = 0;
        
        NSArray *array1 = [newVersion componentsSeparatedByString:@"."];
        NSArray *array2 = [currentVersion componentsSeparatedByString:@"."];
        
        NSInteger len1 = array1.count;
        NSInteger len2 = array2.count;
        
        while (i < len1 || i < len2) {
            NSInteger x1 = i < len1 ? [array1[i] integerValue] : 0;
            NSInteger x2 = i < len1 ? [array2[i] integerValue] : 0;
            
            if (x1 < x2) {
                return -1;
            }else if (x1 > x2){
                return 1;
            }else{
                i++;
            }
        }
        return 0;
    };
    
    //获取 最新版本
    AFHTTPSessionManager* manager=[AFHTTPSessionManager manager];
    [manager POST:APP_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSDictionary *appInfo = responseObject;
         NSDictionary *releaseInfo = appInfo[@"results"][0];
         newVersion = releaseInfo[@"version"];
         NSString *trackViewURL = releaseInfo[@"trackViewUrl"];
         NSString *releaseNotes = releaseInfo[@"releaseNotes"];
         NSString *message = [NSString stringWithFormat:@"%@%@",@"新版本特性",releaseNotes];
         
         if(compareVersion(newVersion,currentVersion) == 1)
         {
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"版本升级" message:message preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
             }];
             UIAlertAction *action = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 NSString *url = trackViewURL;
                 [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
             }];
             [alert addAction:action];
             [alert  addAction:cancel];
             
             [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:^{
                 
             }];
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
     }];
}

@end
