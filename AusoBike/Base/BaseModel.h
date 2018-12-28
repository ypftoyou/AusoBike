//
//  BaseModel.h
//  AusoBike
//
//  Created by Chang on 2017/11/2.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject<NSCoding>

- (NSArray *)getAllProperties;
- (NSDictionary *)properties_aps;

@end
