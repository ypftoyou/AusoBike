//
//  ReChargeViewController.h
//  AusoBike
//
//  Created by Chang on 2017/11/14.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^RefreshBlock)(void);
@interface ReChargeViewController : BaseViewController
/** 1 需要回调   2无回调 */
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,copy)RefreshBlock refreshBlock;
@end
