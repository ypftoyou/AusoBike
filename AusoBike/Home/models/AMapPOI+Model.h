//
//  AMapPOI+Model.h
//  AusoBike
//
//  Created by Chang on 2017/11/17.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import <AMapSearchKit/AMapSearchKit.h>

@class BikeModel;

@interface AMapPOI (Model)
- (void)setModel:(BikeModel *)model;
- (BikeModel *)getModel;
@end
