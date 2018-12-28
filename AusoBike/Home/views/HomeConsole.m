//
//  HomeConsole.m
//  AusoBike
//
//  Created by Chang on 2017/11/6.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "HomeConsole.h"
#import <UIImageView+WebCache.h>
#define LEFT_WIDTH  KScreenWidth / 6 * 5

@interface HomeConsole()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIImageView * backGroundImageView;
@property (nonatomic,strong)NSArray *dataArr;
@property (nonatomic,strong)NSArray *cellImgs;
@property (nonatomic,strong)UIView  *leftView;
@property (nonatomic,strong)UILabel *nikeLab;
@property (nonatomic,strong)UILabel *identification;
@property (nonatomic,strong)UIImageView *userImageView;

@end

@implementation HomeConsole

- (NSArray *)cellImgs{
    if (_cellImgs == nil) {
        _cellImgs = @[@"ico_home_mywallet",@"ico_home_myway",@"ico_home_userguide",@"ico_home_setting"];
    }
    
    return _cellImgs;
}

- (NSArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = @[@"我的钱包",@"我的行程",@"我的客服",@"设置"];
    }
    return _dataArr;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    
    return self;
}

#pragma mark - 实例化界面
- (void)setupViews{
    //背景图片
    self.backGroundImageView = [[UIImageView alloc]initWithFrame:self.frame];
    self.backGroundImageView.alpha = 0;
    self.backGroundImageView.backgroundColor = RGBACOLOR(0, 0, 0, 0.3);
    self.backGroundImageView.userInteractionEnabled = YES;
    [self addSubview:self.backGroundImageView];
    
    UIView *leftView = [[UIView alloc]init];
    self.leftView = leftView;
    [self addSubview:leftView];
    
    leftView.backgroundColor = [UIColor whiteColor];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(-LEFT_WIDTH);
        make.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(LEFT_WIDTH);
    }];

    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor lightGrayColor];
    [leftView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(leftView).offset(-10);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(80);
        make.centerY.mas_equalTo(leftView);
    }];
    
    UIImageView *topBackImgView = [[UIImageView alloc]init];
    topBackImgView.image = IMAGE_NAMED(@"bg_leftbar");
    [leftView addSubview:topBackImgView];
    
    [topBackImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.mas_equalTo(leftView);
    }];
    
    //头像
    UIImageView *photoImgView = [[UIImageView alloc]init];
    self.userImageView = photoImgView;
    
    if ([Tool GetUserOption:AusoUserOptionPhoto].length < 1) {
        photoImgView.image =IMAGE_NAMED(@"defaultavatar");

    }else{
        [photoImgView sd_setImageWithURL:[NSURL URLWithString:[Tool GetUserOption:AusoUserOptionPhoto]]];
    }
    
    [leftView addSubview:photoImgView];
    [photoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.left.mas_equalTo(12);
        make.width.height.mas_equalTo(54);
    }];
    
    [self layoutIfNeeded];
    ViewRadius(photoImgView,54 / 2.f);
    //昵称
    UILabel *nikeLab = [[UILabel alloc]init];
    [leftView addSubview:nikeLab];
    
    self.nikeLab = nikeLab;
    self.nikeLab.font = [UIFont AvenirWithFontSize:17];
    self.nikeLab.textColor = RGB_THEME_BACKGROUND;
    
    nikeLab.text = [Tool GetUserOption:AusoUserOptionNickName];
    [nikeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(photoImgView.mas_right).offset(10);
        make.top.mas_equalTo(photoImgView).offset(5);
        make.right.mas_equalTo(leftView.mas_right).offset(-30);
    }];
    
    UILabel *identification = [[UILabel alloc]init];
    [leftView addSubview:identification];
    
    
    if ([[Tool GetUserOption:AusoUserOptionCard]integerValue] != 2) {
        //未实名认证
        identification.text = @"未认证";
        identification.textColor = RGB100;
    }else{
        identification.text = @"已认证";
        identification.textColor = RGBORANGE;
    }
    
    identification.backgroundColor = [UIColor whiteColor];
    identification.font = [UIFont AvenirWithFontSize:11.5];
    identification.textAlignment = NSTextAlignmentCenter;
    self.identification = identification;
    
    [identification mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nikeLab);
        make.top.mas_equalTo(nikeLab.mas_bottom).offset(2);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    
    ViewBorderRadius(identification, 20 / 2.f, 1, RGB241);
    
    //箭头
    UIImageView *arrow = [[UIImageView alloc]init];
    [leftView addSubview:arrow];
    
    arrow.image = IMAGE_NAMED(@"arrow_down");
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.centerY.mas_equalTo(photoImgView.mas_centerY);
    }];
    
    //透明遮罩 响应点击事件
    UIView *tapView = [[UIView alloc]init];
    [leftView addSubview:tapView];
    
    tapView.backgroundColor = [UIColor clearColor];
    [tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.bottom.mas_equalTo(photoImgView);
        make.right.mas_equalTo(arrow.mas_right);
    }];
    
    UITapGestureRecognizer *singTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singTapGeust:)];
    [tapView addGestureRecognizer:singTap];
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [leftView addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topBackImgView.mas_bottom);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-26);
        make.bottom.mas_equalTo(0);
    }];
    
    ViewRadius(line, 2);
    
    UITapGestureRecognizer *singbackGroundTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
    [self.backGroundImageView addGestureRecognizer:singbackGroundTap];
    
    //清扫
    [self layoutIfNeeded];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0,leftView.width, leftView.height)];
    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:line.frame cornerRadius:1.5] bezierPathByReversingPath]];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    leftView.layer.mask = shapeLayer;
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [leftView addGestureRecognizer:swipeGesture];
    
    [self addGestureRecognizer:swipeGesture];
    
    
    
    
}

#pragma mark -
#pragma mark - tableView 代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"HomeConsoleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    
    cell.textLabel.text = self.dataArr[indexPath.row];
    cell.textLabel.font = [UIFont italicSystemFontOfSize:16];
    cell.textLabel.textColor = RGB_THEME_BACKGROUND;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = IMAGE_NAMED(self.cellImgs[indexPath.row]);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(HomeConsoleSelectElement:)]) {
        [self dismiss:^{
            switch (indexPath.row) {
                case 0:
                    [self.delegate HomeConsoleSelectElement:HomeConsoleOpertionWallet];
                    break;
                case 1:
                    [self.delegate HomeConsoleSelectElement:HomeConsoleOpertionjourney];
                    break;
                case 2:
                    [self.delegate HomeConsoleSelectElement:HomeConsoleOpertionService];
                    break;
                case 3:
                    [self.delegate HomeConsoleSelectElement:HomeConsoleOpertionSetting];
                    break;
                default:
                    break;
            }
        }];
    }
}

- (void)singTapGeust:(UITapGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(HomeConsoleSelectElement:)]) {
        [self dismiss:^{
            [self.delegate HomeConsoleSelectElement:HomeConsoleOpertionHeader];
        }];
    }
}
- (void)show{
    
    NSString *str = [Tool GetUserOption:AusoUserOptionPhoto];
    NSLog(@"%@",str);
    if ([Tool GetUserOption:AusoUserOptionPhoto].length < 1) {
        self.userImageView.image =IMAGE_NAMED(@"defaultavatar");
    }else{
        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:[Tool GetUserOption:AusoUserOptionPhoto]]placeholderImage:IMAGE_NAMED(@"defaultavatar")];
    }
    
    self.nikeLab.text = [Tool GetUserOption:AusoUserOptionNickName];

    if ([[Tool GetUserOption:AusoUserOptionCard]integerValue] != 2) {
        //未实名认证
        self.identification.text = @"未认证";
        self.identification.textColor = RGB100;
    }else{
        self.identification.text = @"已认证";
        self.identification.textColor = RGBORANGE;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        [self.leftView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
        }];
        [self layoutIfNeeded];

        self.backGroundImageView.alpha = 1;
    }];
}

- (void)dismiss:(void(^)(void))block{
    [UIView animateWithDuration:0.3 animations:^{
        [self.leftView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(-LEFT_WIDTH);
        }];
        [self layoutIfNeeded];

        self.backGroundImageView.alpha = 0;
        
    } completion:^(BOOL finished) {
        block();
    }];
}

- (void)close{
    [UIView animateWithDuration:0.3 animations:^{
        [self.leftView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(-LEFT_WIDTH);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.delegate HomeConsoleSelectElement:HomeConsoleOpertionColse];
    }];
}

- (void)dismiss{
    //有空再做
}

@end
