//
//  GuideViewController.h
//  AusoBike
//
//  Created by Chang on 2017/11/2.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "BaseViewController.h"

@interface GuideViewController : BaseViewController

@property (nonatomic,assign)NSInteger initialPage;///< 进行的步骤
/** 押金 */
@property (nonatomic,strong)NSString *deposit;
@end
