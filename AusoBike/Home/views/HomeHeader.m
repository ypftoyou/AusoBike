//
//  HomeHeader.m
//  AusoBike
//
//  Created by Chang on 2017/11/18.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "HomeHeader.h"
#import "BikeModel.h"
#import <MapKit/MapKit.h>
#import <MAMapKit/MAMapKit.h>

@interface HomeHeader()
/** 地址 */
@property (nonatomic,strong) UILabel    *address_lab;
/** 距离 */
@property (nonatomic,strong) UILabel    *distance_lab;
/** 车牌 */
@property (nonatomic,strong) UILabel    *license_lab;
/** 导航 */
@property (nonatomic,strong) UIButton   *navi_btn;

@property (nonatomic,strong) CLGeocoder *geo;

@end

@implementation HomeHeader

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    ViewShadow(view,[UIColor grayColor], CGSizeMake(0, 5), 8, 0.8);
    
//    UIImageView *header_gillleft = [[UIImageView alloc]init];
//    [self addSubview:header_gillleft];
//
//    header_gillleft.backgroundColor = RANDOW_COLOR;
//    header_gillleft.contentMode = UIViewContentModeScaleToFill;
//    header_gillleft.image = IMAGE_NAMED(@"home_head_left");
//    [header_gillleft mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.width.mas_equalTo(12);
//        make.top.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
//    }];
//
//    UIImageView *header_gillright = [[UIImageView alloc]init];
//    [self addSubview:header_gillright];
//
//    header_gillright.backgroundColor = RANDOW_COLOR;
//    header_gillright.contentMode = UIViewContentModeScaleAspectFill;
//    header_gillright.image = IMAGE_NAMED(@"home_head_right");
//    [header_gillright mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(0);
//        make.width.mas_equalTo(6);
//        make.top.mas_equalTo(35);
//        make.bottom.mas_equalTo(-15);
//    }];
    
    UIView *topView = [[UIView alloc]init];
    [self addSubview:topView];
    
    topView.backgroundColor = RGB241;
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.top.mas_equalTo(self);
        make.height.mas_equalTo(20);
    }];
    
    ViewShadow(topView, [UIColor grayColor], CGSizeMake(0, 2), 2, 0.3);
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self);
    }];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    [self addSubview:imageView];
    
    imageView.image = IMAGE_NAMED(@"ico_blacklocation");
//    imageView.backgroundColor = RANDOW_COLOR;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.height.mas_equalTo(20);
    }];
    
    self.address_lab = [[UILabel alloc]init];
    [self addSubview:self.address_lab];
    
//    self.address_lab.text = @"河南省商丘市神火大道铭创花园1号院";
    self.address_lab.font = [UIFont HeitiSCWithFontSize:12];
    [self.address_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    

    
    self.distance_lab = [[UILabel alloc]init];
    [self addSubview:self.distance_lab];
//    self.distance_lab.backgroundColor = RANDOW_COLOR;
    self.distance_lab.textAlignment = NSTextAlignmentCenter;
//    self.distance_lab.text = @"1234 m";
    self.distance_lab.font = [UIFont AvenirWithFontSize:18];
    [self.distance_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.address_lab.mas_bottom).offset(6);
        make.width.mas_equalTo(KScreenWidth/2);
    }];
    
    UILabel *distanceMark = [[UILabel alloc]init];
    [self addSubview:distanceMark];
    
//    distanceMark.backgroundColor = RANDOW_COLOR;
    distanceMark.font = [UIFont HeitiSCWithFontSize:13];
    distanceMark.textAlignment = self.distance_lab.textAlignment;
    distanceMark.text = @"距离起始位置";
    [distanceMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.distance_lab.mas_bottom);
        make.left.width.mas_equalTo(self.distance_lab);
    }];
    
    self.license_lab = [[UILabel alloc]init];
    [self addSubview:self.license_lab];
    
//    self.license_lab.backgroundColor = RANDOW_COLOR;
    self.license_lab.textAlignment = self.distance_lab.textAlignment;
//    self.license_lab.text = @"22736";
    self.license_lab.font = self.distance_lab.font;
    [self.license_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.address_lab.mas_bottom).offset(6);
        make.left.mas_equalTo(self.distance_lab.mas_right);
        make.width.height.mas_equalTo(self.distance_lab);
    }];
    
    UILabel *licenseMark = [[UILabel alloc]init];
    [self addSubview:licenseMark];
    
//    licenseMark.backgroundColor = RANDOW_COLOR;
    licenseMark.textAlignment = distanceMark.textAlignment;
    licenseMark.font = distanceMark.font;
    licenseMark.text = @"车牌号码";
    [licenseMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.license_lab.mas_bottom);
        make.height.width.mas_equalTo(distanceMark);
        make.right.mas_equalTo(self.license_lab);
    }];
    
    UIButton *naviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:naviBtn];
    
    [naviBtn setTitle:@"导航至此单车" forState:UIControlStateNormal];
    [naviBtn setBackgroundColor:RGBACOLOR(254, 203, 116, 1)];
    naviBtn.titleLabel.font = [UIFont AvenirWithFontSize:16];
    [naviBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [naviBtn addTarget:self action:@selector(navigation:) forControlEvents:UIControlEventTouchUpInside];
    [naviBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.top.mas_equalTo(distanceMark.mas_bottom).offset(14);
        make.centerX.mas_equalTo(view.mas_centerX);
        make.height.mas_equalTo(35);
    }];
    
    [self layoutIfNeeded];
//    ViewBorderRadius(naviBtn, 3, 1, [UIColor grayColor]);
    ViewShadow(naviBtn, [UIColor grayColor], CGSizeMake(3, 3), 3, 0.5);
    naviBtn.layer.cornerRadius = 2.f;

}

- (void)setModel:(BikeModel *)model{
    _model = model;
    self.license_lab.text = self.model.license_plate;
    [self reverseGeoCodeWithCoor:self.model.coordinate];
}

// 反地理编码(把经纬度---> 详细地址)
- (void)reverseGeoCodeWithCoor:(CLLocationCoordinate2D)coorD
{
    double latitude = coorD.latitude;
    double longitude = coorD.longitude;
    self.geo = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    [self.geo reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //判断是否有错误或者placemarks是否为空
        if (error !=nil || placemarks.count==0) {
            NSLog(@"%@",error);
            return ;
        }
        for (CLPlacemark *placemark in placemarks) {
            //详细地址
            NSString *addressStr = placemark.name;
            NSDictionary *addressDict = [placemark addressDictionary];
            //            NSLog(@"%@",[addressDict description]);
            NSString *State = [addressDict valueForKey:@"State"];
            NSString *Street = [addressDict valueForKey:@"Street"];
            NSString *Citys = [addressDict valueForKey:@"City"];
            NSString *subLocality=[addressDict objectForKey:@"SubLocality"];
            if ([Street isEqual:[NSNull null]]) {
                Street = addressStr;
            }
            NSString *address = [NSString stringWithFormat:@"%@%@",subLocality,addressStr];
            NSString *cityAddress;
            if ([State isEqualToString:Citys]) {
                cityAddress = [NSString stringWithFormat:@"%@",Citys];
            }else{
                if (State!=nil) {
                    cityAddress = [NSString stringWithFormat:@"%@%@",State,Citys];
                }else{
                    cityAddress = [NSString stringWithFormat:@"%@",Citys];
                }            }
            
            NSLog(@"%@-%@-%@",State,Citys,address);
            
            //1.位置
            self.address_lab.text = [NSString stringWithFormat:@"%@%@",cityAddress,address];
            
            
            //3.距离
            NSString *disStr = [self DistanceWithCurrent:self.model.currentCoordinate tolocation:self.model.coordinate];
            
            self.distance_lab.text = disStr;

        }
    }];
}

-(NSString *)DistanceWithCurrent:(CLLocationCoordinate2D)current tolocation:(CLLocationCoordinate2D)to{
    //1.将两个经纬度点转成投影点
    MAMapPoint point1 = MAMapPointForCoordinate(current);
    MAMapPoint point2 = MAMapPointForCoordinate(to);
    
    //2.计算距离
    
    CLLocationDistance distances = MAMetersBetweenMapPoints(point1,point2);
    NSString * dis = @"";
    if (distances <1000) {
        distances = MAMetersBetweenMapPoints(point1,point2);
        dis = [NSString stringWithFormat:@"%.fm",distances];
    }else{
        distances = (MAMetersBetweenMapPoints(point1,point2)/1000);
        dis = [NSString stringWithFormat:@"%.1fkm",distances];
    }
    return dis;
}

- (void)navigation:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(HomeHeaderNavigationWithLocation:)]) {
        [self.delegate HomeHeaderNavigationWithLocation:self.model.coordinate];
    }
}
@end
