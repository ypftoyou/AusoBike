//
//  UITextField+AusoBackSpace.m
//  AusoBike
//
//  Created by Chang on 2017/11/16.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "UITextField+AusoBackSpace.h"
#import <objc/runtime.h>
@implementation UITextField (AusoBackSpace)
+ (void)load{
    //! 交换2个方法中的IMP
    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"deleteBackward"));
    Method method2 = class_getInstanceMethod([self class], @selector(Auso_deleteBackward));
    method_exchangeImplementations(method1, method2);
    
    //! 下面这个交换主要解决大于等于8.0小于8.3系统不调用deleteBackward的问题
    Method method3 = class_getInstanceMethod([self class], NSSelectorFromString(@"keyboardInputShouldDelete:"));
    Method method4 = class_getInstanceMethod([self class], @selector(Auso_keyboardInputShouldDelete:));
    method_exchangeImplementations(method3, method4);
}

- (void)Auso_deleteBackward{
    [self Auso_deleteBackward];
    if ([self.delegate respondsToSelector:@selector(textFieldDidDeleteBackSpace:)]){
        id <AusoBackSpaceTextFieldDelegate> delegate = (id<AusoBackSpaceTextFieldDelegate>)self.delegate;
        [delegate textFieldDidDeleteBackSpace:self];
    }
}

- (BOOL)Auso_keyboardInputShouldDelete:(UITextField *)textField {
    BOOL shouldDelete = [self Auso_keyboardInputShouldDelete:textField];
    BOOL isMoreThanIos8_0 = ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f);
    BOOL isLessThanIos8_3 = ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.3f);
    if (![textField.text length] && isMoreThanIos8_0 && isLessThanIos8_3) {
        [self deleteBackward];
    }
    return shouldDelete;
}@end
