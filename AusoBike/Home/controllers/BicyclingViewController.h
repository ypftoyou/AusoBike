//
//  BicyclingViewController.h
//  AusoBike
//
//  Created by Chang on 2017/11/20.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "BaseViewController.h"

@class RouteModel;
@interface BicyclingViewController : BaseViewController

/** 数据源 */
@property (nonatomic,strong)NSDictionary *data;
/** type = 1 骑行中   type = 2 骑行记录 */
@property (nonatomic,assign)NSInteger type;
/** 行程model */
@property (nonatomic,strong)RouteModel *routeModel;
@end
