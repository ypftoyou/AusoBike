//
//  BicyclingViewController.m
//  AusoBike
//
//  Created by Chang on 2017/11/20.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "BicyclingViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "BicyclingConsole.h"
#import "CyclingFinishViewController.h"
#import "RouteModel.h"
#import "ServiceViewController.h"

@interface BicyclingViewController ()<MAMapViewDelegate>
@property (nonatomic,strong) MAMapView        *mapView;
@property (nonatomic,strong) CLLocation       *currentLocation;
@property (nonatomic,strong) BicyclingConsole *console;
@property (nonatomic,strong) NSTimer          *runderTimer;

@end

@implementation BicyclingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMapView];
    [self initConsole];
    
    if (self.type == 2) {
        self.title = @"骑行记录";
    }else{
        self.title = @"骑行中";
        [self checkInfo];
        [self startRunLoop];
        [self createNaviHideBack];
        //[self createNaviItemType:NaviItemTypeRightButton NaviOperType:NaviOperTypeTitle NameString:@"报修"];
    }
}
- (void)initConsole{
    BicyclingConsole *console = [[BicyclingConsole alloc]initWithFrame:CGRectMake(0, self.view.bottom - 64 - 150, self.view.width, 150)];
    self.console = console;
    
    if (self.type == 2) {
        console.price = self.routeModel.price;
        
        //时间
        NSInteger m = [self.routeModel.end_time integerValue] - [self.routeModel.start_time integerValue];
        
        console.time = [NSString stringWithFormat:@"%ld",m / 60];
        
        console.title = [NSString stringWithFormat:@"开始时间：%@  结束时间：%@",[Tool timestampSwitchTime:[self.routeModel.start_time integerValue] withFormat:@"MM月dd日 hh:mm"],[Tool timestampSwitchTime:[self.routeModel.end_time integerValue] withFormat:@"MM月dd日 hh:mm"]];
        console.bike_num = self.routeModel.number;
    }else{
        NSInteger timestamp = [[self.data valueForKey:@"start_time"]integerValue];
        console.title = [NSString stringWithFormat:@"开始骑行时间：%@",[Tool timestampSwitchTime:timestamp withFormat:nil]];
        console.bike_num = [self.data valueForKey:@"number"];
    }
    
    [self.view addSubview:console];
}
- (void)initMapView{
    //1.添加地图
    ///初始化地图
    MAMapView *mapView = [[MAMapView alloc] init];
    self.mapView = mapView;
    mapView.delegate = self;
    //2.实例化地图
    self.mapView.showsUserLocation = YES;
    self.mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    self.mapView.customizeUserLocationAccuracyCircleRepresentation = NO;
    
    self.mapView.rotateEnabled = NO;//不能旋转
    [self.mapView setZoomLevel:15 animated:YES];//设置缩放比例
    self.mapView.showsCompass = NO;//是否显示罗盘
    self.mapView.showsScale = YES;//是否显示比例
    self.mapView.scaleOrigin = CGPointMake(10,15+64);
    if (self.type != 2) {
        self.mapView.centerCoordinate = self.mapView.userLocation.location.coordinate;
    }
    self.mapView.touchPOIEnabled = NO;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    //    self.mapView.distanceFilter = 200;
    [self.view addSubview:_mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(0);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-150);
    }];

    [self initMapTabbar];
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if (updatingLocation == YES) {
        self.currentLocation = userLocation.location;
    }
}

#pragma mark - 轮询
- (void)startRunLoop{
    if (self.runderTimer == nil) {
        self.runderTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(checkInfo) userInfo:nil repeats:YES];
    }
}

- (void)checkInfo{
    NSLog(@"轮询中");
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:[NSString stringWithFormat:@"%@",[self.data valueForKey:@"start_time"]] forKey:@"start_time"];//开始时间
    [param setValue:[NSString stringWithFormat:@"%@",[self.data valueForKey:@"time_long"]] forKey:@"time_long"];//默认时长
    [param setValue:[NSString stringWithFormat:@"%@",[self.data valueForKey:@"price"]] forKey:@"price"];//单价
    [param setValue:[NSString stringWithFormat:@"%@",[self.data valueForKey:@"device"]] forKey:@"device"];//车辆秘钥
    [param setValue:[NSString stringWithFormat:@"%@",[self.data valueForKey:@"factory"]] forKey:@"factory"];//锁厂

    [Tool Post:API_Motion param:param header:[Tool AusoNetHeader] isHUD:NO result:^(BOOL status, NSDictionary *result) {
        if (status) {//info = 单车循环
            NSLog(@"%@",result);
            
            //code = 1 进行中  code = 0 已经结束
            int code = [[result valueForKey:@"code"]intValue];
            NSDictionary *infoDic = [self resultData:result];

            if (code == 0) {
                //取消定时器
                [self.runderTimer invalidate];
                self.runderTimer = nil;
                
                CyclingFinishViewController *cyclingVC = [[CyclingFinishViewController alloc]init];
                cyclingVC.dict = infoDic;
                [cyclingVC setCloseBlock:^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [self.navigationController pushViewController:cyclingVC animated:YES];
                
            }else{
                self.console.price = [NSString stringWithFormat:@"%@",[infoDic valueForKey:@"price"]];
                self.console.time =[NSString stringWithFormat:@"%@",[infoDic valueForKey:@"time"]];
            }
        }
    }];
}

- (void)initMapTabbar{
    UIButton *gpsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:gpsBtn];
    
    [gpsBtn addTarget:self action:@selector(backToCurrentLocation:) forControlEvents:UIControlEventTouchUpInside];
    [gpsBtn setImage:IMAGE_NAMED(@"imgs_main_location") forState:UIControlStateNormal];
    [gpsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo (20);
        make.bottom.mas_equalTo(self.mapView.mas_bottom).offset(-77);
    }];
    
    UIButton *serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:serviceBtn];
    
    [serviceBtn addTarget:self action:@selector(backToService) forControlEvents:UIControlEventTouchUpInside];
    [serviceBtn setImage:IMAGE_NAMED(@"imgs_main_phone") forState:UIControlStateNormal];
    [serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(gpsBtn.mas_bottom).offset(17);
    }];

}

- (void)backToCurrentLocation:(UIButton *)sender{
    if(self.mapView.userLocation.updating && self.mapView.userLocation.location) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
        [self.mapView setZoomLevel:15 animated:YES];//设置缩放比例
    }}

- (void)backToService{
    [self.navigationController pushViewController:[[ServiceViewController alloc]init] animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
