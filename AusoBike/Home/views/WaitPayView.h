//
//  WaitPayView.h
//  AusoBike
//
//  Created by Chang on 2017/11/23.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WaitPayViewDelegate<NSObject>
/** 用户点击 同意去付款 */
- (void)WaitPayViewUserAccept;
@end
@interface WaitPayView : UIView

@property (nonatomic,strong)NSDictionary *data;
@property (nonatomic,weak)id<WaitPayViewDelegate>delegate;
@end
