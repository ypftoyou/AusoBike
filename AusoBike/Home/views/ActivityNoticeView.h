//
//  ActivityNoticeView.h
//  AusoBike
//
//  Created by Chang on 2017/11/22.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActivityNoticeViewDelegate<NSObject>
/** 活动页被关闭 */
- (void)ActivityNoticeViewClose;
@end

@interface ActivityNoticeView : UIView
@property (nonatomic,strong)NSDictionary *data;
@property (nonatomic,weak)id<ActivityNoticeViewDelegate>delegate;
@end
