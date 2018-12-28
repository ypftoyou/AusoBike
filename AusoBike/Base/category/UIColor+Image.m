//
//  UIColor+Image.m
//  ICPile
//
//  Created by Chang on 2017/10/9.
//  Copyright © 2017年 Chang. All rights reserved.
//

#import "UIColor+Image.h"

@implementation UIColor (Image)
+ (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
