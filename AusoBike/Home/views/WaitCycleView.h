//
//  WaitCycleView.h
//  AusoBike
//
//  Created by Chang on 2017/11/20.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,WaitCycleAction) {
    /** 用户取消 */
    WaitCycleActionCancel = 0,
    /** 用户确认 */
    WaitCycleActionDone
};

@protocol WaitCycleViewDelegate<NSObject>

- (void)WaitCycleViewUserAction:(WaitCycleAction)action;

@end

@interface WaitCycleView : UIView

@property (nonatomic,weak)id<WaitCycleViewDelegate>delegate;
@property (nonatomic,strong)NSString *message;

@end
