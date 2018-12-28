//
//  WaitCycleView.m
//  AusoBike
//
//  Created by Chang on 2017/11/20.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "WaitCycleView.h"

@interface WaitCycleView()

@property (nonatomic,strong)UILabel *messageLab;

@end
@implementation WaitCycleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configViews];
    }
    return self;
}

- (void)configViews{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    bgView.backgroundColor = RGBACOLOR(0, 0, 0, 0.4);
    [self addSubview:bgView];
    
    
    UIView *bottomView = [[UIView alloc]init];
    [self addSubview:bottomView];
    
    bottomView.backgroundColor = [UIColor whiteColor];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_bottom).offset(-130);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(150);
    }];
    
    
    UIButton *baseBtn_left = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:baseBtn_left];
    [baseBtn_left setImage:IMAGE_NAMED(@"btn_bike_cancel") forState:UIControlStateNormal];
    baseBtn_left.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [baseBtn_left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(bottomView.mas_left).mas_equalTo(5);
        make.right.mas_equalTo(bottomView.mas_centerX).offset(-8);
        
    }];
    
    ViewShadow(baseBtn_left, RGBORANGE, CGSizeMake(0, 3), 3.f, 0.5);
    
    UIButton *customBtn_left = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:customBtn_left];

    customBtn_left.tag = 1711201818;
    [customBtn_left setTitle:@"取消" forState:UIControlStateNormal];
    [customBtn_left setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    customBtn_left.titleLabel.font = [UIFont HelveticaNeueFontSize:16];
    if (iphone4s || iphone5s) {
        customBtn_left.titleLabel.font = [UIFont HelveticaNeueFontSize:15];
    }
    [customBtn_left  addTarget:self action:@selector(userClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [customBtn_left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(baseBtn_left);
        make.height.width.mas_equalTo(baseBtn_left);
    }];

    
    UIButton *baseBtn_right = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:baseBtn_right];
    [baseBtn_right setImage:IMAGE_NAMED(@"btn_scan_ensure") forState:UIControlStateNormal];
    baseBtn_right.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [baseBtn_right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.right.mas_equalTo(bottomView.mas_right).offset(-5);
        make.left.mas_equalTo(bottomView.mas_centerX).offset(8);
        
//        make.bottom.mas_equalTo(self.mas_bottom);
//        make.left.mas_equalTo(bottomView.mas_left).mas_equalTo(5);
//        make.right.mas_equalTo(bottomView.mas_centerX).offset(-8);
        
    }];
    
    ViewShadow(baseBtn_right, RGBORANGE, CGSizeMake(0, 3), 3.f, 0.5);

    UIButton *customBtn_right = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:customBtn_right];
    
    customBtn_right.tag = 1711201819;
    [customBtn_right setTitle:@"立即用车" forState:UIControlStateNormal];
    [customBtn_right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    customBtn_right.titleLabel.font = [UIFont HelveticaNeueFontSize:16];
    if (iphone4s || iphone5s) {
        customBtn_right.titleLabel.font = [UIFont HelveticaNeueFontSize:15];
    }
    [customBtn_right  addTarget:self action:@selector(userClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [customBtn_right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(baseBtn_right);
        make.height.width.mas_equalTo(baseBtn_right);
    }];

    
   /*
    
    UIButton *ensuerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:ensuerBtn];
    
    [ensuerBtn setTitle:@"立即用车" forState:UIControlStateNormal];
    ensuerBtn.titleLabel.font = [UIFont AvenirWithFontSize:17];
    ensuerBtn.tag = 201711201819;
    [ensuerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ensuerBtn setBackgroundImage:IMAGE_NAMED(@"btn_scan_ensure") forState:UIControlStateNormal];
    [ensuerBtn addTarget:self action:@selector(userClickAction:) forControlEvents:UIControlEventTouchUpInside];

    [ensuerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        
        if (iphone4s || iphone5s) {
            make.right.mas_equalTo(bottomView.mas_right).offset(4);
        }else{
            make.right.mas_equalTo(bottomView.mas_right).offset(-8);

        }
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cancelBtn];
    
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont AvenirWithFontSize:17];
    
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:IMAGE_NAMED(@"btn_bike_cancel") forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(userClickAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = 201711201818;
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bottomView.mas_left).offset(8);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.width.height.mas_equalTo(ensuerBtn);
        
        if (iphone4s || iphone5s) {
            make.left.mas_equalTo(bottomView.mas_left).offset(-4);
        }

    }];
    
    
    */
    
    UILabel *titleLab = [[UILabel alloc]init];
    [self addSubview:titleLab];
    
    self.messageLab = titleLab;
//    self.messageLab.backgroundColor = RANDOW_COLOR;
//    titleLab.text = @"首次充值可以免费骑行一个月，每天限时2小时，超时或者忘记关锁将正常计费，乌拉乌拉乌拉阿莎死啊塑钢";
    titleLab.font = [UIFont HeitiSCWithFontSize:16];
    titleLab.numberOfLines = 0;
    
//        titleLab.backgroundColor = RANDOW_COLOR;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.adjustsFontSizeToFitWidth = YES;
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomView.mas_top).offset(15);
        make.right.mas_equalTo(bottomView.mas_right).offset(-14);
        make.left.mas_equalTo(bottomView.mas_left).offset(14);
        make.bottom.mas_equalTo(baseBtn_left.mas_top).offset(0);//iphone 4 5 offset = 0
        make.bottom.mas_equalTo(baseBtn_right.mas_top).offset(0);
    }];

    [self layoutIfNeeded];

    //挖空
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, bottomView.width, bottomView.height)];
    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake((bottomView.width - bottomView.width / 4.f)/2.f,7,bottomView.width / 4.f, 3) cornerRadius:1.5] bezierPathByReversingPath]];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    bottomView.layer.mask = shapeLayer;

    ViewRadius(bottomView, 20);
}

- (void)setMessage:(NSString *)message{
    _message = message;
    self.messageLab.text = message;
}

- (void)userClickAction:(UIButton *)sender{
    if (sender.tag == 1711201818) {
        [self.delegate WaitCycleViewUserAction:WaitCycleActionCancel];
    }else{
        [self.delegate WaitCycleViewUserAction:WaitCycleActionDone];
    }
}

@end
