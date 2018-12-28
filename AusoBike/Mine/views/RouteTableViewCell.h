//
//  RouteTableViewCell.h
//  AusoBike
//
//  Created by Chang on 2017/11/22.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RouteModel;
@interface RouteTableViewCell : UITableViewCell
- (void)initWithModel:(RouteModel *)model;
@end
