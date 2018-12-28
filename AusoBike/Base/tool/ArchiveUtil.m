//
//  ArchiveUtil.m
//  AusoBike
//
//  Created by Chang on 2017/11/15.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "ArchiveUtil.h"
#import "AusoUser.h"

#define AusoFilePathWithName(fileName) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:fileName]
@implementation ArchiveUtil

+ (void)saveUser:(AusoUser *)user{
    [NSKeyedArchiver archiveRootObject:user toFile:AusoFilePathWithName(@"auso_user.plist")];
}

+ (AusoUser *)getUser{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:AusoFilePathWithName(@"auso_user.plist")];
}

+ (void)saveBikeAll:(NSArray *)arr{
    [NSKeyedArchiver archiveRootObject:arr toFile:AusoFilePathWithName(@"auso_bike_all.plist")];
}

+ (NSArray *)getBikeAll{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:AusoFilePathWithName(@"auso_bike_all.plist")];
}
///***********/
//
//+ (void)saveCarInfo:(NSArray *)arr{
//    [NSKeyedArchiver archiveRootObject:arr toFile:AusoFilePathWithName(@"jd_carinfo.plist")];
//}
//
//+ (NSArray *)getCarInfo{
//    return [NSKeyedUnarchiver unarchiveObjectWithFile:AusoFilePathWithName(@"jd_carinfo.plist")];
//
//}

@end
