//
//  ConfirmOrderViewController.h
//  AusoBike
//
//  Created by Chang on 2017/11/23.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
@interface ConfirmOrderViewController : BaseViewController
@property (nonatomic,strong)NSDictionary *dict;
@property (nonatomic,strong)CLLocation *currentLocation;
@end
