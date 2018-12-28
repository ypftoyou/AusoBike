//
//  BikeModel.m
//  AusoBike
//
//  Created by Chang on 2017/11/17.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "BikeModel.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

@implementation BikeModel

- (instancetype)initWithAnnotationModelWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        if (![dict[@"latitude"] isEqual:[NSNull null]] && ![dict[@"longitude"] isEqual:[NSNull null]]) {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([dict[@"latitude"] doubleValue], [dict[@"longitude"] doubleValue]);
            self.superCoordinate = coordinate;
            self.number = [NSString stringWithFormat:@"%@",dict[@"number"]];
            self.license_plate = [NSString stringWithFormat:@"%@",dict[@"license_plate"]];
            self.longitude = [NSString stringWithFormat:@"%@",dict[@"longitude"]];
            self.latitude =  [NSString stringWithFormat:@"%@",dict[@"latitude"]];

            CLLocationCoordinate2D amapcoor = AMapCoordinateConvert(coordinate, AMapCoordinateTypeGPS);
            self.coordinate = amapcoor;
        }
    }
    return self;
}

- (void)setCurrentCoordinate:(CLLocationCoordinate2D)currentCoordinate{
    _currentCoordinate = currentCoordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate{
    _coordinate = coordinate;
}


@end
