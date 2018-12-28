//
//  AMapPOI+Model.m
//  AusoBike
//
//  Created by Chang on 2017/11/17.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "AMapPOI+Model.h"
#import <objc/runtime.h>

static char modelkey;

@implementation AMapPOI (Model)

- (void)setModel:(BikeModel *)model{
    objc_setAssociatedObject(self, &modelkey, model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BikeModel *)getModel{
    return objc_getAssociatedObject(self, &modelkey);
}
@end
