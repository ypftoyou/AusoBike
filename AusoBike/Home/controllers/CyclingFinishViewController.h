//
//  CyclingFinishViewController.h
//  AusoBike
//
//  Created by Chang on 2017/11/22.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^closeBlock)(void);
@interface CyclingFinishViewController : BaseViewController
@property (nonatomic,strong)NSDictionary *dict;
@property (nonatomic,copy) closeBlock closeBlock;
@end
