//
//  AusoBikeAnnotation.m
//  AusoBike
//
//  Created by Chang on 2017/11/17.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "AusoBikeAnnotation.h"

@implementation AusoBikeAnnotation

#pragma mark - compare

- (NSUInteger)hash
{
    NSString *toHash = [NSString stringWithFormat:@"%.5F%.5F%ld", self.coordinate.latitude, self.coordinate.longitude, (long)self.count];
    return [toHash hash];
}

- (BOOL)isEqual:(id)object
{
    return [self hash] == [object hash];
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate count:(NSInteger)count
{
    self = [super init];
    if (self)
    {
        _coordinate = coordinate;
        _count = count;
        _pois  = [NSMutableArray arrayWithCapacity:count];
    }
    return self;
}

- (void)setCurrentcoordinate:(CLLocationCoordinate2D)Currentcoordinate{
    _currentCoordinate = Currentcoordinate;
}

@end
