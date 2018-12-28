//
//  BaseViewController.h
//  AusoBike
//
//  Created by Chang on 2017/11/2.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

///< 导航栏按钮枚举
typedef NS_ENUM(NSUInteger, NaviItemType){
    NaviItemTypeLeftButton = 0,  ///< 导航栏左边按钮
    NaviItemTypeRightButton,     ///< 导航栏右边按钮
};

///< 导航栏按钮属性枚举
typedef NS_ENUM(NSUInteger, NaviOperType){
    NaviOperTypeImage = 0,  ///< 图片按钮
    NaviOperTypeTitle,     ///< 文字按钮
};

@interface BaseViewController : UIViewController



- (void)createNaviBackButton;///< 返回按钮
- (void)createNaviHideBack;///< 隐藏返回按钮

/**
 创建导航栏左右按钮

 @param itemType 按钮 -> 左边按钮  右边按钮
 @param operType 描述 -> 图片按钮  文字按钮
 */
- (void)createNaviItemType:(NaviItemType)itemType NaviOperType:(NaviOperType)operType NameString:(NSString *)string;

- (void)navigationLeftBtnClick:(UIButton *)sender;
- (void)navigationRightBtnClick:(UIButton *)sende;
- (void)navigationPopAction:(UIButton *)sender;

- (void)show;
- (void)dissmiss;

- (void)showInfo:(NSString *)string;
- (void)showInfo:(NSString *)string alert:(CGFloat)alert;

- (void)showError:(NSString *)string;
- (void)showError:(NSString *)string alert:(CGFloat)alert;

- (void)showSuccess:(NSString *)string;
- (void)showSuccess:(NSString *)string alert:(CGFloat)alert;

- (void)showWait:(NSString *)string;
- (void)showWait:(NSString *)string alert:(CGFloat)alert;

/** 验证操作是否成功 */
- (BOOL)resultVerify:(NSDictionary *)dict;

/** 返回体信息 */
- (NSString *)resultInfo:(NSDictionary *)dict;

/** 返回体数据 */
- (id)resultData:(NSDictionary *)dict;

- (void)wantToDestination:(CLLocationCoordinate2D)location;
@end
