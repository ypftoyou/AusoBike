//
//  UITextView+Fuck.m
//  AusoBike
//
//  Created by Chang on 2017/11/22.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "UITextView+Fuck.h"

@implementation UITextView (Fuck)

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//        if (action == @selector(paste:))//禁止粘贴
//            return NO;
//        if (action == @selector(select:))// 禁止选择
//            return NO;
//        if (action == @selector(selectAll:))// 禁止全选
//            return NO;
//        return [super canPerformAction:action withSender:sender];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController)
    {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}
@end
