//
//  NSDictionary+StringForKey.m
//  GDPile
//
//  Created by Chang on 2017/10/16.
//  Copyright © 2017年 Chang. All rights reserved.
//

#import "NSDictionary+StringForKey.h"

@implementation NSDictionary (StringForKey)

- (NSString *)stringForKey:(NSString *)key{
    return [NSString stringWithFormat:@"%@",[self objectForKey:key]];
}
@end
