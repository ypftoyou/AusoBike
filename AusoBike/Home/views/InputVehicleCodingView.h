//
//  InputVehicleCodingView.h
//  AusoBike
//
//  Created by Chang on 2017/11/21.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol InputVehicleCodingViewDelegate <NSObject>

- (void)clickLockingButton:(NSString *)stirng;
- (void)InputVehicleCodingViewClose;

@end
@interface InputVehicleCodingView : UIView

@property (nonatomic, strong)UIView *whiteView;
@property (nonatomic, strong)UIView *backView;
@property (nonatomic, weak) id<InputVehicleCodingViewDelegate>delegate;

@end
