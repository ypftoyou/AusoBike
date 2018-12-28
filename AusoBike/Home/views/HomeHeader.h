//
//  HomeHeader.h
//  AusoBike
//
//  Created by Chang on 2017/11/18.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class BikeModel;
@protocol HomeHeaderDelegate<NSObject>
- (void)HomeHeaderNavigationWithLocation:(CLLocationCoordinate2D)location;
@end

@interface HomeHeader : UIView

@property (nonatomic,strong)BikeModel *model;

@property (nonatomic,weak)id <HomeHeaderDelegate> delegate;

@end
