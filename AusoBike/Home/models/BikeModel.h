//
//  BikeModel.h
//  AusoBike
//
//  Created by Chang on 2017/11/17.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "BaseModel.h"
#import <MapKit/MapKit.h>

@interface BikeModel : BaseModel
@property (nonatomic,strong) NSString               *number;///< 号码
@property (nonatomic,strong) NSString               *latitude;///< 纬度
@property (nonatomic,strong) NSString               *longitude;///< 经度
@property (nonatomic,strong) NSString               *license_plate;///< 车牌
/** 火星坐标 */
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
/** 当前位置 */
@property (nonatomic,assign) CLLocationCoordinate2D currentCoordinate;
/** 坐标系 */
@property (nonatomic,assign) CLLocationCoordinate2D superCoordinate;
/** geo地址 */
@property (nonatomic,strong) NSString               *address;

- (instancetype)initWithAnnotationModelWithDict:(NSDictionary *)dict;


@end
