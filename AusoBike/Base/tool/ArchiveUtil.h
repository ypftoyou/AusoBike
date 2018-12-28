//
//  ArchiveUtil.h
//  AusoBike
//
//  Created by Chang on 2017/11/15.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AusoUser;

@interface ArchiveUtil : NSObject

+ (void)saveUser:(AusoUser *)user;
+ (AusoUser *)getUser;

+ (void)saveBikeAll:(NSArray *)arr;
+ (NSArray *)getBikeAll;
@end
