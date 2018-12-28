//
//  HomeConsole.h
//  AusoBike
//
//  Created by Chang on 2017/11/6.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

///< 控制器类型枚举
typedef NS_ENUM(NSUInteger, HomeConsoleOpertionType){
    HomeConsoleOpertionWallet = 0,  ///< 钱包
    HomeConsoleOpertionjourney,     ///< 行程
    HomeConsoleOpertionService,     ///< 客服
    HomeConsoleOpertionSetting,     ///< 设置
    HomeConsoleOpertionHeader,      ///< 头部
    HomeConsoleOpertionColse,       ///< 关闭
};
@protocol HomeConsoleDelegate<NSObject>

- (void)HomeConsoleSelectElement:(HomeConsoleOpertionType)type;

@end

@interface HomeConsole : UIView

/**
 高斯模糊背景图片
 */
@property (nonatomic,strong)UIImage *effectsImage;
@property (nonatomic,weak)id <HomeConsoleDelegate> delegate;



/**
 显示
 */
- (void)show;

/**
 隐藏侧边栏

 @param block 触发回调
 */
//- (void)dismissBlock:(void (^)(void))block;
- (void)dismiss;



@end
