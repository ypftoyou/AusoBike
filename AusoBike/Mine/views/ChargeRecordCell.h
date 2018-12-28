//
//  ChargeRecordCell.h
//  AoSongBike
//
//  Created by Solomo on 2017/7/14.
//  Copyright © 2017年 骜松单车. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChargeRecordCell : UITableViewCell
/**
 日期
 */
@property(nonatomic,strong)UILabel  *dateLabel;
/**
 时间
 */
@property(nonatomic,strong)UILabel  *timeLabel;
/**
 金额
 */
@property(nonatomic,strong)UILabel  *priceLab;
/**
 数据
 */
@property(nonatomic,strong)NSDictionary  *infoDict;
/**
 0:充值记录  1:退款记录
 */
@property(nonatomic,copy)NSString  *types;

@property (nonatomic,strong)UIImageView *icon;

@property (nonatomic,strong)UILabel *payTypeLab;

@end
