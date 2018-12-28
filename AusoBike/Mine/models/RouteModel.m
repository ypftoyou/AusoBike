//
//  RouteModel.m
//  AusoBike
//
//  Created by Chang on 2017/11/22.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "RouteModel.h"

@implementation RouteModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"rid":@"id"};
}
@end
