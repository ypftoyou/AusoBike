//
//  AusoScanView.h
//  AusoBike
//
//  Created by Chang on 2017/11/20.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AusoScanViewDelegate<NSObject>

- (void)AusoScanViewQRInformation:(NSString *)info;
- (void)AusoScanViewScanfInput;

@end

@interface AusoScanView : UIView

@property (nonatomic,weak)id<AusoScanViewDelegate>delegate;

/** 开始 */
- (void)start;

/** 停止 */
- (void)stop;




@end
