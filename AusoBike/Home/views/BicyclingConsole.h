//
//  BicyclingConsole.h
//  AusoBike
//
//  Created by Chang on 2017/11/20.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BicyclingConsole : UIView
/** 骑行单价 */
@property (nonatomic,strong)NSString *price;
/** 骑行时长-分钟 */
@property (nonatomic,strong)NSString *time;
/** 车牌 */
@property (nonatomic,strong)NSString *bike_num;
/** title 信息 */
@property (nonatomic,strong)NSString *title;
@end
