//
//  WaitPayView.m
//  AusoBike
//
//  Created by Chang on 2017/11/23.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "WaitPayView.h"
#import <UIKit/UIKit.h>
@interface WaitPayView()
@property (nonatomic,assign)CGPoint SupPoint;
@end
@implementation WaitPayView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview:bgView];
    
    self.SupPoint = self.center;
    
    bgView.backgroundColor = RGBACOLOR(255,127,14,0.8);

    ViewShadow(bgView, [UIColor blackColor], CGSizeMake(3, 3), 3, 0.6);
    bgView.layer.cornerRadius = 2.f;
    
    
    UILabel *title = [[UILabel alloc]init];
    [self addSubview:title];
    
    title.text = @"您有一笔未支付的订单哦";
    title.font = [UIFont AvenirWithFontSize:16];
//    title.textColor = [UIColor whiteColor];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    UIImageView *arrow = [[UIImageView alloc]init];
    [self addSubview:arrow];
    
    arrow.image = IMAGE_NAMED(@"arrow_down_w");
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    
    UITapGestureRecognizer *singTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoJump)];
    [self addGestureRecognizer:singTap];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    [self addGestureRecognizer:panGesture];
    
}

- (void)gotoJump{
    if (self.delegate && [self.delegate respondsToSelector:@selector(WaitPayViewUserAccept)]) {
        [self.delegate WaitPayViewUserAccept];
    }
}

- (void)panGesture:(UIPanGestureRecognizer *)panGest{
    NSLog(@"被拖动");
    CGPoint point = [panGest translationInView:self];
    NSLog(@"%f,%f",point.x,point.y);
    panGest.view.center = CGPointMake(panGest.view.center.x + point.x, panGest.view.center.y + point.y);
    [panGest setTranslation:CGPointMake(0, 0) inView:self];
    
    //判断方向
    
    //是否结束
    if (panGest.state == UIGestureRecognizerStateEnded || panGest.state == UIGestureRecognizerStateCancelled) {
        
        //判断要去的方向
        
//        CGPoint toPoint;
//        if (abs(point.x - self.SupPoint.x) < 50 || abs(point.y - self.SupPoint.y)) {
//            toPoint = self.SupPoint;
//        }
        
        //有空再搞这个动画
        
        [UIView animateWithDuration:0.418f delay:0 usingSpringWithDamping:1.0f initialSpringVelocity:1.0f options:UIViewAnimationOptionLayoutSubviews animations:^{
            panGest.view.center = self.SupPoint;
//            self.center = CGPointMake(self.SupPoint.x, self.SupPoint.y - 10);

            [panGest setTranslation:CGPointMake(0, 0) inView:self];
        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.218f
//                                  delay:0
//                 usingSpringWithDamping:1.0f
//                  initialSpringVelocity:20.0f
//                                options:UIViewAnimationOptionLayoutSubviews
//                             animations:^{
//                                 self.center = CGPointMake(toPoint.x, self.SupPoint.y + 10);
//                             }
//                             completion:^(BOOL finished) {
////                                 [self removeFromSuperview];
//                             }];
        }];
    }
}

- (void)setData:(NSDictionary *)data{
    _data = data;
}
@end
