//
//  RouteTableViewCell.m
//  AusoBike
//
//  Created by Chang on 2017/11/22.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "RouteTableViewCell.h"
#import "RouteModel.h"

@interface RouteTableViewCell()
@property (nonatomic,strong) UIView      *bgView;
@property (nonatomic,strong) UIImageView *arrows;
@property (nonatomic,strong) UILabel     *money_lab;
@property (nonatomic,strong) UILabel     *time_lab;
@property (nonatomic,strong) UILabel     *bike_lab;
@property (nonatomic,strong) UILabel     *consumption_lab;
@property (nonatomic,strong) UIImageView *clock;

@end

@implementation RouteTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self configViews];
    }
    return self;
}

- (void)configViews{
    UIView *bgView = [[UIView alloc]init];
    [self.contentView addSubview:bgView];
    
    self.bgView = bgView;
    bgView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    [bgView addSubview:imageView];
    
//    imageView.backgroundColor = RANDOW_COLOR;
    imageView.image = IMAGE_NAMED(@"ico_myway_time");
    self.clock = imageView;
    
    UILabel *time_lab = [[UILabel alloc]init];
    time_lab.textColor = RGB_THEME_BACKGROUND;
//    time_lab.text = @"2017.11.21 13:23:22";
    time_lab.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:time_lab];
    self.time_lab = time_lab;
    
    UILabel *consumption_title = [[UILabel alloc]init];
    consumption_title.text = @"行程消费";
    consumption_title.font = [UIFont AvenirWithFontSize:12];
    consumption_title.textColor = RGB100;
    [bgView addSubview:consumption_title];
    self.consumption_lab = consumption_title;
    
    UILabel *money_lab = [[UILabel alloc]init];
//    money_lab.text = @"￥ 0.0";
    money_lab.font = [UIFont systemFontOfSize:20];
    money_lab.textAlignment = NSTextAlignmentCenter;
    money_lab.textColor = RGBORANGE;
    [bgView addSubview:money_lab];
    self.money_lab = money_lab;
    
    UILabel *bike_lab = [[UILabel alloc]init];
//    bike_lab.text = @"车牌号：123456789876543";
    bike_lab.font = consumption_title.font;
    bike_lab.textColor = consumption_title.textColor;
    [bgView addSubview:bike_lab];
    self.bike_lab = bike_lab;
    
    UIImageView *arrows = [[UIImageView alloc]init];
    arrows.image = IMAGE_NAMED(@"arrow_down");
//    arrows.backgroundColor = RANDOW_COLOR;
    [bgView addSubview:arrows];
    self.arrows = arrows;
    
}
- (void)layoutSubviews{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(self.contentView);
    }];
    
    
    ViewShadow(self.bgView,[UIColor grayColor], CGSizeMake(0, 0), 3, 0.2);
    self.bgView.layer.cornerRadius = 3.f;
    
    [self.clock mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(5);
        make.width.height.mas_equalTo(17);
    }];
    
    [self.time_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.clock.mas_right).offset(2);
        make.centerY.mas_equalTo(self.clock.mas_centerY);
    }];
    
    [self.consumption_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.clock.mas_left);
        make.bottom.mas_equalTo(-5);
    }];
    
    [self.money_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.consumption_lab.mas_right).offset(10);
        make.bottom.mas_equalTo(self.consumption_lab);
        make.width.mas_equalTo(70);
    }];
    
    [self.bike_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.money_lab.mas_right).offset(10);
        make.bottom.mas_equalTo(self.consumption_lab);
    }];
    
    [self.arrows mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-6);
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
    }];
}

- (void)initWithModel:(RouteModel *)model{
    self.time_lab.text = [Tool timestampSwitchTime:[model.start_time integerValue] withFormat:@"YYYY.MM.dd hh:mm:ss"];
    self.money_lab.text = [NSString stringWithFormat:@"￥ %@",model.price];
    self.bike_lab.text = [NSString stringWithFormat:@"车牌号：%@",model.number];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
