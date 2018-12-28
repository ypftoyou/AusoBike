//
//  UITextField+AusoBackSpace.h
//  AusoBike
//
//  Created by Chang on 2017/11/16.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AusoBackSpaceTextFieldDelegate<NSObject>
- (void)textFieldDidDeleteBackSpace:(UITextField *)textField;

@end

@interface UITextField (AusoBackSpace)
@property (weak,nonatomic)id<AusoBackSpaceTextFieldDelegate>delegate;

@end
