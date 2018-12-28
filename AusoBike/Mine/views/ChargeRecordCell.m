//
//  ChargeRecordCell.m
//  CoolBicyle
//
//  Created by Solomo on 2017/7/14.
//  Copyright © 2017年 骜松单车. All rights reserved.
//

#import "ChargeRecordCell.h"

@implementation ChargeRecordCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.font = [UIFont systemFontOfSize:16];
        [self setSeparatorInset:UIEdgeInsetsZero];//设置分割线
        self.textLabel.textColor = [UIColor blackColor];
        self.detailTextLabel.textColor = [UIColor blackColor];
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.detailTextLabel.font = [UIFont systemFontOfSize:15];
        [self initUI];
    }
    return self;
    
}
-(void)initUI
{
    UILabel *dateLabel = [[UILabel alloc] init];
    [self addSubview:dateLabel];
    CGFloat WIDTH = 50;
    CGFloat Height = self.height/2;
    dateLabel.font = [UIFont AvenirWithFontSize:12];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.top.mas_equalTo(self.mas_top);
        make.width.mas_equalTo(WIDTH);
        make.height.mas_equalTo(Height);
    }];
    dateLabel.textColor = [UIColor blackColor];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    self.dateLabel =dateLabel;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    [self addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.top.mas_equalTo(dateLabel.mas_bottom);
        make.width.mas_equalTo(WIDTH);
        make.height.mas_equalTo(Height);
    }];
    
    
    self.icon = [[UIImageView alloc]init];
    self.icon.image = IMAGE_NAMED(@"ico_recharge");
    
    [self.contentView addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
//    self.imageView.image = [UIImage imageNamed:@"ico_recharge"];

    //充值
//    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
////        make.left.mas_equalTo(self.mas_left).offset(60);
//        make.left.mas_equalTo(60);
//        make.centerY.mas_equalTo(self.mas_centerY);
//    }];
//    [self.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
////        make.left.mas_equalTo(self.icon.mas_right).offset(10);
//        make.left.mas_equalTo(90);
//        make.centerY.mas_equalTo(self.mas_centerY);
//    }];
    
    self.payTypeLab = [[UILabel alloc]init];
    [self.contentView addSubview:self.payTypeLab];
    
    [self.payTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).offset(10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    self.timeLabel = timeLabel;
    timeLabel.font = [UIFont AvenirWithFontSize:12];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = [UIColor blackColor];
    //金额
    
    UILabel *priceLab = [[UILabel alloc] init];
    priceLab.textAlignment = NSTextAlignmentRight;
    priceLab.frame = CGRectMake(0, 0, 100, 20);
    priceLab.textColor = [UIColor blackColor];
    priceLab.font = [UIFont AvenirWithFontSize:20];
    self.accessoryView = priceLab;
    self.priceLab = priceLab;
    
}
-(void)setInfoDict:(NSDictionary *)infoDict
{
    _infoDict = infoDict;
    //充值方式
    NSString *way = [NSString stringWithFormat:@"%@",[infoDict valueForKey:@"way"]];
    if ([self.types isEqualToString:@"0"]) {//充值记录
        if ([way isEqualToString:@"1"]) {//支付宝
           self.payTypeLab.text = [NSString stringWithFormat:@"%@充值",@"支付宝"];
        }else{
            
            self.payTypeLab.text = [NSString stringWithFormat:@"%@充值",@"微信"];
        }
    }else//退款记录
    {
        if ([way isEqualToString:@"1"]) {//支付宝
            self.payTypeLab.text = [NSString stringWithFormat:@"%@",@"支付宝"];
        }else{
            
            self.payTypeLab.text = [NSString stringWithFormat:@"%@",@"微信"];
        }
//        self.textLabel.text = [NSString stringWithFormat:@"%@",way];
        
    }
    
    //时间
    NSString *create_time;
    if ([self.types isEqualToString:@"0"]) {//充值
        create_time = [NSString stringWithFormat:@"%@",[infoDict valueForKey:@"create_time"]];
    }else if ([self.types isEqualToString:@"1"])//退款
    {
        NSString *create_time_1 = [NSString stringWithFormat:@"%@",[infoDict valueForKey:@"create_time"]];
        if (create_time_1.length < 10) {
            create_time = @"";
        }else{
            create_time =  [create_time_1 substringToIndex:10];
        }
        
    }
    NSString *timeString = [self distanceTimeWithBeforeTime:[create_time doubleValue]];
    
    if ([timeString containsString:@"/"]) {
        NSArray *strArray = [timeString componentsSeparatedByString:@"/"];
        self.dateLabel.text = [strArray firstObject];
        self.timeLabel.text = [strArray lastObject];
    }else{
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        self.dateLabel.text = timeString;
    }
    //金额
    NSString *price = [NSString stringWithFormat:@"%@",[infoDict valueForKey:@"price"]];
    if ([self.types isEqualToString:@"0"]) {
        _priceLab.text = [NSString stringWithFormat:@"+%@",price];
    }else{
        _priceLab.text = [NSString stringWithFormat:@"%@",price];
    }
}


#pragma mark -返回刚刚,今天,昨天
- (NSString *)distanceTimeWithBeforeTime:(double)beTime
{
    //    return @"2017.09.06/12:35";
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    double distanceTime = now - beTime;
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    
    [df setDateFormat:@"dd"];
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    NSString * lastDay = [df stringFromDate:beDate];
    
    //    if (distanceTime < 60) {//小于一分钟
    //        distanceStr = @"刚刚";
    //    }
    //    else if (distanceTime <60*60) {//时间小于一个小时
    //        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
    //    }
    //    else if(distanceTime <24*60*60 && [nowDay integerValue] == [lastDay integerValue]){//时间小于一天
    //        distanceStr = [NSString stringWithFormat:@"今天/%@",timeStr];
    //    }
    //    else
    if(distanceTime<24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){
        //        if ([nowDay integerValue] - [lastDay integerValue] ==1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
        //            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
        //        }
        //        else
        {
            [df setDateFormat:@"MM.dd/HH:mm"];
            distanceStr = [df stringFromDate:beDate];
        }
        
    }
    else if(distanceTime <24*60*60*365){
        [df setDateFormat:@"MM.dd/HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    else{
        [df setDateFormat:@"yyyy.MM.dd/HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    return distanceStr;
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
