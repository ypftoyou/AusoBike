//
//  ScanViewController.h
//  AusoBike
//
//  Created by Chang on 2017/11/20.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
typedef void (^ReturnDataBlock)(NSDictionary *data,NSString *bikeNumber);
@interface ScanViewController : BaseViewController
@property (nonatomic,copy)ReturnDataBlock returnDataBlock;
@property (nonatomic,strong)CLLocation *currentLocation;
@end
