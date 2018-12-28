//
//  RouteModel.h
//  AusoBike
//
//  Created by Chang on 2017/11/22.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "BaseModel.h"

@interface RouteModel : BaseModel
/** 结束时间 */
@property (nonatomic,strong) NSString *end_time;
/** 结束时的纬度 */
@property (nonatomic,strong) NSString *end_x;
/** 结束时的经度 */
@property (nonatomic,strong) NSString *end_y;
/** id标识 */
@property (nonatomic,strong) NSString *rid;
/** 车牌—长码 */
@property (nonatomic,strong) NSString *number;
/** 车牌-短码 */
@property (nonatomic,strong) NSString *license_plate;
/** 费用 */
@property (nonatomic,strong) NSString *price;
/** 开始时间 */
@property (nonatomic,strong) NSString *start_time;
/** 开始时的纬度 */
@property (nonatomic,strong) NSString *start_x;
/** 开始时的经度 */
@property (nonatomic,strong) NSString *start_y;

@end
