//
//  AusoBikeAnnotation.h
//  AusoBike
//
//  Created by Chang on 2017/11/17.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface AusoBikeAnnotation : NSObject<MKAnnotation>

/** 区域poi数量 */
@property (nonatomic,assign ) NSInteger              count;

/** poi的平均位置 */
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

/** poi集合 */
@property (nonatomic, strong) NSMutableArray         *pois;

/** titel */
@property (nonatomic, copy  ) NSString               *title;

/** 副标题 */
@property (nonatomic, copy  ) NSString               *subtitle;

/** 车辆坐标 */
@property (nonatomic,assign ) CLLocationCoordinate2D bike_coordinate;

/** 当前位置 */
@property (nonatomic,assign ) CLLocationCoordinate2D currentCoordinate;

/** 车牌号 */
@property (nonatomic,strong ) NSString               *license_plate;

/** GEO地理位置 */
@property (nonatomic,strong ) NSString               *address;

/** 初始化 */
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate count:(NSInteger)count;

@end
