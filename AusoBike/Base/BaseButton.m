//
//  BaseButton.m
//  AusoBike
//
//  Created by Chang on 2017/11/25.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "BaseButton.h"

@implementation BaseButton
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}


- (void)setupView{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = IMAGE_NAMED(@"btn_normol_blue");
    
}
@end
