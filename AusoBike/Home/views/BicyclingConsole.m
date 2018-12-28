//
//  BicyclingConsole.m
//  AusoBike
//
//  Created by Chang on 2017/11/20.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "BicyclingConsole.h"
#import <UIImageView+WebCache.h>

@interface BicyclingConsole()

@property (nonatomic,strong)NSMutableArray *labelArr;
@property (nonatomic,strong)UILabel *chargeModeLab;
@property (nonatomic,strong)UILabel *startTimeLab;

@end
@implementation BicyclingConsole

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    
    self.backgroundColor = [UIColor whiteColor];
    ViewShadow(self, [UIColor grayColor], CGSizeMake(-3, -3), 2, 0.4);
    
    
    UIImageView *userPhoto = [[UIImageView alloc]init];
    [self addSubview:userPhoto];
    
    NSString *photoURL = [Tool GetUserOption:AusoUserOptionPhoto];
    if (photoURL.length < 1 || [photoURL isKindOfClass:[NSNull class]]) {
        userPhoto.image =IMAGE_NAMED(@"defaultavatar");
    }else{
        [userPhoto sd_setImageWithURL:[NSURL URLWithString:photoURL] placeholderImage:IMAGE_NAMED(@"defaultavatar")];
    }
    
    [userPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_top);
        make.width.height.mas_equalTo(80);
    }];
    
    [self layoutIfNeeded];
    
//    ViewShadow(userPhoto,RGB241, CGSizeMake(2, 2), 3, 0.4);

    
    NSArray *infoArr = @[@"行程消费",@"骑行时长",@"车辆编号"];
    
    self.labelArr = [NSMutableArray array];
    
    CGFloat W = self.width / 3.f;
    for (int i = 0; i < infoArr.count; i ++) {
        UILabel *info_lab =[[UILabel alloc]init];
        [self addSubview:info_lab];
//        info_lab.backgroundColor = RANDOW_COLOR;
        info_lab.font = [UIFont AvenirWithFontSize:16];
        info_lab.adjustsFontSizeToFitWidth = YES;
        info_lab.textAlignment = NSTextAlignmentCenter;
        
        [info_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(userPhoto.mas_bottom).offset(10);
            make.left.mas_equalTo(i * W);
//            make.height.mas_equalTo(30);
            make.width.mas_equalTo(W);
        }];
        
        UILabel *remid = [[UILabel alloc]init];
        [self addSubview:remid];
        remid.font = [UIFont AvenirWithFontSize:13];
        remid.textAlignment = NSTextAlignmentCenter;
        remid.textColor = [UIColor lightGrayColor];
        remid.text = infoArr[i];
        
        [remid mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(info_lab.mas_bottom).offset(5);
            make.left.width.mas_equalTo(info_lab);
        }];
        
        [self.labelArr addObject:info_lab];
    
    }
    
    UILabel *msgLab = [[UILabel alloc]init];
    [self addSubview:msgLab];
    msgLab.textColor = RGB100;
    msgLab.textAlignment = NSTextAlignmentCenter;
    msgLab.font = [UIFont AvenirWithFontSize:13];
    
    self.startTimeLab = msgLab;
    [msgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-3);
    }];
    
    userPhoto.layer.shadowColor = [UIColor grayColor].CGColor;
    userPhoto.layer.shadowRadius = 3;
    userPhoto.layer.shadowOffset = CGSizeMake(1, -3);
    userPhoto.layer.shadowOpacity = 0.2;
    userPhoto.layer.cornerRadius = 40.f;
    userPhoto.layer.masksToBounds = YES;

}

- (void)setPrice:(NSString *)price{
    _price = price;
    UILabel *label_price = self.labelArr[0];
    if ([price isEqualToString:@"(null)"] || [price isKindOfClass:[NSNull class]] || price.length < 1) {
        label_price.text = [NSString stringWithFormat:@"0.0 元"];
    }else{
        label_price.text = [NSString stringWithFormat:@"%@ 元",price];
    }
}

- (void)setTime:(NSString *)time{
    _time = time;
    UILabel *label_price = self.labelArr[1];
    
    if ([time isEqualToString:@"(null)"] || [time isKindOfClass:[NSNull class]] || time.length < 1) {
        label_price.text = [NSString stringWithFormat:@"0 分钟"];
    }else{
        
        
        NSInteger time_int = [time integerValue];
        
        if (time_int > 60) {
            
            NSInteger c = time_int / 60;
            NSInteger b = time_int % 60;
            
            label_price.text = [NSString stringWithFormat:@"%ld小时 %ld分钟",c,b];

        }else if(time_int == 60){
            label_price.text = [NSString stringWithFormat:@"1 小时"];
        }else{
            label_price.text = [NSString stringWithFormat:@"%@ 分钟",time];

        }
    }
}

- (void)setBike_num:(NSString *)bike_num{
    _bike_num = bike_num;
    
    //隐藏编号
    NSString *last_str = [bike_num substringToIndex:4];
    
    NSString *first_str = [bike_num substringFromIndex:bike_num.length - 4];
    
    NSString *num_str = [NSString stringWithFormat:@"%@ **** %@",last_str,first_str];
    
    UILabel *label_number = [self.labelArr lastObject];
    label_number.text = num_str;
    
    
//    NSInteger timestamp = [[data valueForKey:@"start_time"]integerValue];
//    self.startTimeLab.text = [NSString stringWithFormat:@"开始骑行时间：%@",[Tool timestampSwitchTime:timestamp withFormat:nil]];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.startTimeLab.text = title;
}
@end
