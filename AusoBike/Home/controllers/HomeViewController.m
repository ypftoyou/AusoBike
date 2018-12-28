//
//  HomeViewController.m
//  AusoBike
//
//  Created by Chang on 2017/11/6.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeConsole.h"
#import "MineRootViewController.h"
#import "WalletViewController.h"
#import "SettingRootViewController.h"
#import "ServiceViewController.h"
#import "UIColor+Image.h"
#import <MAMapKit/MAMapKit.h>
#import "BikeModel.h"
#import "ArchiveUtil.h"
#import <MJExtension.h>
#import "AusoBikeAnnotation.h"
#import "CoordinateQuadTree.h"
#import "AMapPOI+Model.h"
#import "AusoAnnotationView.h"
#import "ServiceViewController.h"
#import "RouteViewController.h"
#import "HomeHeader.h"
#import "WaitCycleView.h"
#import "ScanViewController.h"
#import "BicyclingViewController.h"
#import "GuideViewController.h"
#import "BaseNavigationController.h"
#import <MJExtension.h>
#import "ActivityNoticeView.h"
#import "CyclingFinishViewController.h"
#import "ConfirmOrderViewController.h"
#import "WaitPayView.h"
#import "HomeViewController+CheckVersion.h"
#import "UIColor+Image.h"
#import "ReChargeViewController.h"
#import "AusoUser.h"
#import "ArchiveUtil.h"

@interface HomeViewController ()<WaitPayViewDelegate,HomeConsoleDelegate,MAMapViewDelegate,HomeHeaderDelegate,WaitCycleViewDelegate,ActivityNoticeViewDelegate>

@property (nonatomic,strong ) HomeConsole        *consoleView;///< 左侧控制台
@property (nonatomic,strong ) MAMapView          *mapView;///< 地图
@property (nonatomic,strong ) CLLocation         *currentLocation;///< 当前位置
@property (nonatomic, assign) BOOL               shouldRegionChangeReCalculate;

@property (nonatomic,assign)CGPoint scanPoint;

/** 拖动距离 */
@property (nonatomic,assign)CGFloat dragDistance;

@property (nonatomic,strong)NSMutableArray *annotations;
/** 方向箭头 */
@property(nonatomic,strong)MAAnnotationView  *userLocationAnnotationView;

/** 四叉树 */
@property (nonatomic, strong) CoordinateQuadTree * coordinateQuadTree;
/** 头部单车详情 */
@property (nonatomic,strong ) HomeHeader         *homeHeader;
/** poi点 */
@property (nonatomic,strong ) AusoBikeAnnotation *selectAnnotation;
/** 等待开锁界面 */
@property (nonatomic,strong ) WaitCycleView      *waitCycleView;
/** 扫描单车返回的信息 */
@property (nonatomic,strong ) NSDictionary       *scanBikeInfo;
/** 扫描单车的车牌号 */
@property (nonatomic,strong ) NSString           *scanBikeNumber;
/** 活动遮罩 */
@property (nonatomic,strong ) ActivityNoticeView *ActivityView;
/** 是否加载过实名认证 */
@property (nonatomic,assign ) BOOL               is_will_name;
/** 是否加载过押金 */
@property (nonatomic,assign ) BOOL               is_will_deposit;
/** 是否加载过活动*/
@property (nonatomic,assign ) BOOL               is_will_activity;
/** 正在进行中的事件 */
@property (nonatomic,assign ) BOOL               is_will_ing;
/** 未付款订单悬浮层 */
@property (nonatomic,strong ) WaitPayView        *waitPayView;
/** map中心点按钮 */
@property(nonatomic,strong)UIButton *mapCenterBtn;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"AOSONGBIKE";
    
    [self checkVersion];
    [self createNaviItemType:NaviItemTypeLeftButton NaviOperType:NaviOperTypeImage NameString:@"navi_btn_usecenter"];
    
    /** 地图图层 */
    [self initMapView];
    
    /** 左侧控制台 */
    [self setupConsoleView];
}




#pragma mark -
#pragma mark - 实例化地图
- (void)initMapView{
    self.mapView = [[MAMapView alloc]init];
    [self.view addSubview:self.mapView];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    self.mapView.customizeUserLocationAccuracyCircleRepresentation = NO;
    
    self.mapView.rotateCameraEnabled = NO;
    self.mapView.rotateEnabled = NO;//不能旋转
    [self.mapView setZoomLevel:14 animated:YES];//设置缩放比例
    //    self.mapView.zoomLevel = 12;
    self.mapView.showsCompass = NO;//是否显示罗盘
    self.mapView.showsScale = YES;//是否显示比例
    self.mapView.showsBuildings = NO;
    self.mapView.showTraffic = NO;
    self.mapView.scaleOrigin = CGPointMake(10,15+64);
    self.mapView.touchPOIEnabled = NO;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.delegate = self;
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.width.height.mas_equalTo(self.view);
    }];
    
    [self mapViewTabbar];
    
    UIButton *centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:centerBtn];
    
    [centerBtn setBackgroundImage:IMAGE_NAMED(@"ico_point") forState:UIControlStateNormal];
    centerBtn.userInteractionEnabled = NO;
    [centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
    self.mapCenterBtn = centerBtn;
    [self.view layoutIfNeeded];
}

#pragma mark - 地图工具栏
- (void)mapViewTabbar{
    //定位按钮
    UIButton *gpsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:gpsBtn];
    
    [gpsBtn addTarget:self action:@selector(backToCurrentLocation:) forControlEvents:UIControlEventTouchUpInside];
    [gpsBtn setImage:IMAGE_NAMED(@"imgs_main_location_shadow") forState:UIControlStateNormal];
    [gpsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo (20);
        make.bottom.mas_equalTo(-50);
    }];
    
    
    UIButton *serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:serviceBtn];
    
    [serviceBtn addTarget:self action:@selector(backToService) forControlEvents:UIControlEventTouchUpInside];
    [serviceBtn setImage:IMAGE_NAMED(@"imgs_main_phone") forState:UIControlStateNormal];
    [serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-50);
    }];
    
    UIButton *scanfBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:scanfBtn];
    
    [scanfBtn setImage:IMAGE_NAMED(@"ico_usebicycle") forState:UIControlStateNormal];
    [scanfBtn setImage:IMAGE_NAMED(@"ico_usebicycle_press") forState:UIControlStateHighlighted];
    [scanfBtn addTarget:self action:@selector(backToScanQR) forControlEvents:UIControlEventTouchUpInside];
    [scanfBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(gpsBtn.mas_centerY);
    }];
    
    [self.view layoutIfNeeded];
    self.scanPoint = scanfBtn.center;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    [scanfBtn addGestureRecognizer:panGesture];
    
    ViewShadow(gpsBtn, [UIColor grayColor], CGSizeMake(0,0), 2, 0.5);
    
}

- (void)panGesture:(UIPanGestureRecognizer *)panGest{
    UIView  *views = panGest.view;
    
    if (views.top <= KScreenHeight / 3) {
        [self backToScanQR];
    }
    
    UIButton *btn = (UIButton *)panGest.view;
    CGPoint point = [panGest translationInView:self.view];
    panGest.view.center = CGPointMake(panGest.view.center.x + point.x, panGest.view.center.y + point.y);
    [panGest setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if (panGest.state == UIGestureRecognizerStateBegan) {
        [btn setImage:IMAGE_NAMED(@"ico_usebicycle_press") forState:UIControlStateNormal];
    }
    
    if (panGest.state == UIGestureRecognizerStateEnded || panGest.state == UIGestureRecognizerStateCancelled) {
        [btn setImage:IMAGE_NAMED(@"ico_usebicycle") forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.318f delay:0 usingSpringWithDamping:1.0f initialSpringVelocity:1.0f options:UIViewAnimationOptionLayoutSubviews animations:^{
            panGest.view.center = CGPointMake(self.scanPoint.x, self.scanPoint.y - 64);
            
            [panGest setTranslation:CGPointMake(0, 0) inView:self.view];
        } completion:^(BOOL finished) {
            
        }];
    }
    
}


#pragma mark -
#pragma mark - 实例化控制台
- (void)setupConsoleView{
    self.consoleView = [[HomeConsole alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    self.consoleView.left = -self.consoleView.width;
    self.consoleView.delegate = self;
    [self.view addSubview:self.consoleView];
}

#pragma mark -
#pragma mark - 控制台代理

- (void)HomeConsoleSelectElement:(HomeConsoleOpertionType)type{
    NSLog(@"进了");
    switch (type) {
        case HomeConsoleOpertionWallet:
            [self.navigationController pushViewController:[[WalletViewController alloc]init] animated:YES];
            
            break;
        case HomeConsoleOpertionjourney:
            [self.navigationController pushViewController:[[RouteViewController alloc]init] animated:YES];
            break;
        case HomeConsoleOpertionService:
            [self.navigationController pushViewController:[[ServiceViewController alloc]init] animated:YES];
            break;
        case HomeConsoleOpertionSetting:
            [self.navigationController pushViewController:[[SettingRootViewController alloc]init] animated:YES];
            break;
        case HomeConsoleOpertionHeader:
            [self.navigationController pushViewController:[[MineRootViewController alloc]init] animated:YES];
            
            break;
        case HomeConsoleOpertionColse:
            break;
        default:
            break;
    }
    
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.consoleView.left = -self.consoleView.width;
}

#pragma mark -
#pragma mark - 扫码确认骑车代理
- (void)WaitCycleViewUserAction:(WaitCycleAction)action{
    
    if (action == WaitCycleActionCancel) {
        //        [self showInfo:@"用户取消了"];
    }else if (action == WaitCycleActionDone){
        //        [self showInfo:@"用户确认了"];
        [self AusoBikeUnlocking];
    }else{
        //        [self showInfo:@"权限错误"];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.waitCycleView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.waitCycleView removeFromSuperview];
        self.waitCycleView = nil;
    }];
}

#pragma mark -
#pragma mark - 单车详情代理
- (void)HomeHeaderNavigationWithLocation:(CLLocationCoordinate2D)location{
    [self.mapView deselectAnnotation:self.selectAnnotation animated:YES];
    self.selectAnnotation = nil;
    
    [self wantToDestination:location];
}

#pragma mark -
#pragma mark - 活动页面代理
- (void)ActivityNoticeViewClose{
    //被关闭
    [UIView animateWithDuration:0.3 animations:^{
        self.ActivityView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.ActivityView removeFromSuperview];
        self.ActivityView = nil;
    }];
}

#pragma mark -
#pragma mark - 未付款订单悬浮层代理
- (void)WaitPayViewUserAccept{
    [UIView animateWithDuration:0.3 animations:^{
        self.waitPayView.alpha = 0;
    } completion:^(BOOL finished) {
        NSDictionary *dict = self.waitPayView.data;
        [self.waitPayView removeFromSuperview];
        self.waitPayView = nil;
        
        ConfirmOrderViewController *confirmVC = [[ConfirmOrderViewController alloc]init];
        confirmVC.dict = dict;
        confirmVC.currentLocation = self.currentLocation;
        BaseNavigationController *navi = [[BaseNavigationController alloc]initWithRootViewController:confirmVC];
        [self presentViewController:navi animated:YES completion:nil];
    }];
}

#pragma mark -
#pragma mark - 高德地图代理
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    
    if (userLocation.location != self.currentLocation) {
        self.currentLocation = [userLocation.location copy];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self getBikeAllDataWithLocation:self.currentLocation.coordinate];
            
        });
        
        if (!updatingLocation && self.userLocationAnnotationView != nil){
            [UIView animateWithDuration:0.1 animations:^{
                
                double degree = userLocation.heading.trueHeading - self.mapView.rotationDegree;
                self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f);
            }];
        }
        
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[AusoBikeAnnotation class]]) {
        /* dequeue重用annotationView. */
        static NSString *const AnnotatioViewReuseID = @"AusoAnnotationViewID";
        
        AusoAnnotationView *annotationView = (AusoAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotatioViewReuseID];
        
        if (!annotationView){
            annotationView = [[AusoAnnotationView alloc] initWithAnnotation:annotation
                                                            reuseIdentifier:AnnotatioViewReuseID];
        }
        
        /* 设置annotationView的属性. */
        annotationView.annotation = annotation;
        annotationView.count = [(AusoBikeAnnotation *)annotation count];
        
        /* 不弹出原生annotation */
        annotationView.canShowCallout = NO;
        
        return annotationView;
        
    }else if ([annotation isKindOfClass:[MAUserLocation class]]){
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"userPosition"];
        self.userLocationAnnotationView = annotationView;
        
        return annotationView;
    }
    
    return nil;
}


- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    //点击对应的animation
    if ([view isKindOfClass:[AusoAnnotationView class]]) {
        AusoBikeAnnotation *annotation = (AusoBikeAnnotation *)view.annotation;
        AMapPOI *poi = [annotation.pois lastObject];
        BikeModel *model = [poi getModel];
        model.currentCoordinate = self.currentLocation.coordinate;
        if (annotation.pois.count != 1) {
            if (self.mapView.zoomLevel < 10) {
                self.mapView.zoomLevel = 10;
            }else{
                self.mapView.zoomLevel += 2;
                
            }
            [self.mapView setCenterCoordinate:model.superCoordinate animated:YES];
            
        }else{
            
            if (!self.selectAnnotation) {
                HomeHeader *header = [[HomeHeader alloc]initWithFrame:CGRectMake(0,-130, KScreenWidth, 130)];
                header.model = model;
                header.delegate = self;
                self.homeHeader = header;
                [self.view addSubview:header];
                
                [UIView animateWithDuration:0.3 animations:^{
                    header.top = 0;
                }];
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (self.homeHeader == nil) {
                        HomeHeader *header = [[HomeHeader alloc]initWithFrame:CGRectMake(0,-130, KScreenWidth, 130)];
                        header.model = model;
                        header.delegate = self;
                        self.homeHeader = header;
                        [self.view addSubview:header];
                        
                        [UIView animateWithDuration:0.3 animations:^{
                            header.top = 0;
                        }];
                    }
                    
                    self.homeHeader.model = model;
                });
            }
            
            self.selectAnnotation = annotation;
            
            [self.mapView setCenterCoordinate:model.superCoordinate animated:YES];
            
        }
    }
}

- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate{
    //    if (self.homeHeader) {
    //        [UIView animateWithDuration:0.3 animations:^{
    //            self.homeHeader.top = -self.homeHeader.height;
    //
    //        }completion:^(BOOL finished) {
    //            [self.homeHeader removeFromSuperview];
    //            self.homeHeader = nil;
    //        }];
    //    }
}

- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view{
    [UIView animateWithDuration:0.3 animations:^{
        self.homeHeader.top = -self.homeHeader.height;
        self.homeHeader.alpha = 0;
    }completion:^(BOOL finished) {
        [self.homeHeader removeFromSuperview];
        self.homeHeader = nil;
        //        self.selectAnnotation = nil;
        
    }];
}

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction{
    if (!wasUserAction) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.mapCenterBtn.center = CGPointMake(self.mapCenterBtn.center.x, self.mapCenterBtn.center.y - 15);
    } completion:^(BOOL finished) {
        self.mapCenterBtn.center = CGPointMake(self.mapCenterBtn.center.x, self.mapCenterBtn.center.y + 15);
    }];
    
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    
    if (centerCoordinate.latitude <0 || centerCoordinate.longitude<0) {
        return;
    }else{
        [self getBikeAllDataWithLocation:centerCoordinate];
    }
}

//一次加载200多条嘻嘻 动画调用频繁 导致内存紧张 先不用
//- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
//
//    MKAnnotationView *annotationView;
//    for (annotationView in views){
//        if (![annotationView isKindOfClass:[MKPinAnnotationView class]]){
//            annotationView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);//将要显示的view按照正常比例显示出来
//            [UIView animateWithDuration:0.5 // 动画时长
//                                  delay:0.0 // 动画延迟
//                 usingSpringWithDamping:0.5 // 类似弹簧振动效果 0~1
//                  initialSpringVelocity:5.0 // 初始速度 6
//                                options:UIViewAnimationOptionCurveEaseInOut // 动画过渡效果
//                             animations:^{
//
//                                 annotationView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);//将要显示的view按照正常比例显示出来
//
//                             } completion:^(BOOL finished) {
//                                 // 动画完成后执行
//                                 // code...
//                                 annotationView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);//将要显示的view按照正常比例显示出来
//                             }];
//        }
//    }
//}

#pragma mark -
#pragma mark - 获取单车信息
- (void)getBikeAllDataWithLocation:(CLLocationCoordinate2D)location{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:[NSString stringWithFormat:@"%f",location.latitude] forKey:@"latitude"];
    [param setValue:[NSString stringWithFormat:@"%f",location.longitude] forKey:@"longitude"];
    
    NSLog(@"---");
    [SVProgressHUD show];
    //    SVProgressHUD
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    [Tool Get:API_BikeList param:param header:[Tool AusoNetHeader] isHUD:NO result:^(BOOL status, NSDictionary *result) {
        NSLog(@"请求结束");
        [SVProgressHUD dismiss];
        if (status) {
            NSArray *infoArr = [result valueForKey:@"data"];
            
            NSMutableArray *poiArr = [NSMutableArray array];
            
            if (![infoArr isKindOfClass:[NSArray class]] || infoArr.count < 1) {
                return ;
            }
            
            if (self.annotations && self.annotations > 0) {
                [self.mapView removeAnnotations:self.annotations];
                self.annotations = nil;
            }
            
            for (NSDictionary *infoDic in infoArr) {
                BikeModel *model = [[BikeModel alloc]initWithAnnotationModelWithDict:infoDic];
                
                AMapPOI *poi = [[AMapPOI alloc]init];
                poi.location = [AMapGeoPoint locationWithLatitude:[model.latitude floatValue] longitude:[model.longitude floatValue]];
                [poi setModel:model];
                
                [poiArr addObject:poi];
            }
            
            self.annotations = [NSMutableArray arrayWithArray:poiArr];
            self.shouldRegionChangeReCalculate = NO;
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSLog(@"进入 四叉树");
                [weakSelf.coordinateQuadTree buildTreeWithPOIs:poiArr];
                weakSelf.shouldRegionChangeReCalculate = YES;
                [weakSelf addAnnotationsToMapView:weakSelf.mapView];
                
            });
            
            NSLog(@"");
        }else{
            [self showError:KERROR_CONNECTION_FAILED];
        }
    }];
}

#pragma mark - 开锁
- (void)AusoBikeUnlocking{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *latitude = [NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude];
    
    [param setValue:latitude forKey:@"start_x"];
    [param setValue:longitude forKey:@"start_y"];
    [param setValue:@"1" forKey:@"order_way"];
    [param setValue:self.scanBikeNumber forKey:@"number"];
    
    [SVProgressHUD showWithStatus:@"正在开锁..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [Tool Get:API_BikeUnlock param:param header:[Tool AusoNetHeader] isHUD:NO result:^(BOOL status, NSDictionary *result) {
        if (status) {
            NSLog(@"%@",result);
            if ([[result valueForKey:Result_Code]intValue] == 0) {
                //开锁成功
                [SVProgressHUD showInfoWithStatus:@"开锁成功"];
                [SVProgressHUD dismissWithDelay:1 completion:^{
                    BicyclingViewController *bicyVC = [[BicyclingViewController alloc]init];
                    bicyVC.data = [self resultData:result];
                    
                    BaseNavigationController *navi =[[BaseNavigationController alloc]initWithRootViewController:bicyVC];
                    [self presentViewController:navi animated:YES completion:nil];
                }];
            }else if ([[result valueForKey:Result_Code]intValue] == 1){
                [SVProgressHUD showInfoWithStatus:[self resultInfo:result]];
                [SVProgressHUD dismissWithDelay:2 completion:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
            }
        }
    }];
}

#pragma mark - 开锁成功
- (void)unLockSuccess{
    
}


#pragma mark -
#pragma mark - 聚合点
- (void)addAnnotationsToMapView:(MAMapView *)mapView{
    @synchronized(self){
        if (self.coordinateQuadTree.root == nil || !self.shouldRegionChangeReCalculate){
            NSLog(@"tree is not ready.");
            return;
        }
        
        /* 根据当前zoomLevel和zoomScale 进行annotation聚合. */
        MAMapRect visibleRect = self.mapView.visibleMapRect;
        double zoomScale = self.mapView.bounds.size.width / visibleRect.size.width;
        double zoomLevel = self.mapView.zoomLevel;
        NSLog(@"地图 缩放级别%.3f",zoomLevel);
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSArray *annotations = [weakSelf.coordinateQuadTree clusteredAnnotationsWithinMapRect:visibleRect
                                                                                    withZoomScale:zoomScale
                                                                                     andZoomLevel:zoomLevel];
            /* 更新annotation. */
            [weakSelf updateMapViewAnnotationsWithAnnotations:annotations];
        });
    }
}

/* 更新annotation. */
- (void)updateMapViewAnnotationsWithAnnotations:(NSArray *)annotations
{
    /* 用户滑动时，保留仍然可用的标注，去除屏幕外标注，添加新增区域的标注 */
    NSMutableSet *before = [NSMutableSet setWithArray:self.mapView.annotations];
    [before removeObject:[self.mapView userLocation]];
    NSSet *after = [NSSet setWithArray:annotations];
    
    /* 保留仍然位于屏幕内的annotation. */
    NSMutableSet *toKeep = [NSMutableSet setWithSet:before];
    [toKeep intersectSet:after];
    
    /* 需要添加的annotation. */
    NSMutableSet *toAdd = [NSMutableSet setWithSet:after];
    [toAdd minusSet:toKeep];
    
    /* 删除位于屏幕外的annotation. */
    NSMutableSet *toRemove = [NSMutableSet setWithSet:before];
    [toRemove minusSet:after];
    
    /* 更新. */
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView addAnnotations:[toAdd allObjects]];
        [self.mapView removeAnnotations:[toRemove allObjects]];
    });
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    [self addAnnotationsToMapView:self.mapView];
}

#pragma mark - 左边导航栏
- (void)navigationLeftBtnClick:(UIButton *)sender{
    if (self.waitCycleView) {
        return;
    }
    
    if (self.selectAnnotation) {
        [self.mapView deselectAnnotation:self.selectAnnotation animated:YES];
        self.selectAnnotation = nil;
    }
    self.consoleView.left = 0;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.consoleView show];
}

- (instancetype)init{
    if (self = [super init]) {
        self.coordinateQuadTree = [[CoordinateQuadTree alloc]init];
    }
    return self;
}

#pragma mark - 回到当前位置
- (void)backToCurrentLocation:(UIButton *)sender{
    
    [self.mapView deselectAnnotation:self.selectAnnotation animated:YES];
    self.selectAnnotation = nil;
    
    [UIView animateWithDuration:0.5 animations:^{
        sender.transform = CGAffineTransformMakeRotation(M_PI);
        
    } completion:^(BOOL finished) {
        sender.transform = CGAffineTransformIdentity;
    }];
    
    
    if(self.mapView.userLocation.updating && self.mapView.userLocation.location) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
        [self.mapView setZoomLevel:12 animated:YES];//设置缩放比例
    }
    //获取单车位置信息
    [self getBikeAllDataWithLocation:self.currentLocation.coordinate];
}

#pragma mark - 前往客服
- (void)backToService{
    [self.navigationController pushViewController:[[ServiceViewController alloc]init] animated:YES];
}
#pragma mark - 前往扫码
- (void)backToScanQR{
    

    if (![Tool isNetStatus]) {
        [self showInfo:@"您的设备未联网，请检查网络"];
        return;
    }

    if ([[Tool GetUserOption:AusoUserOptionCard]intValue] != 2) {
//        弹个框框
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您还未实名认证"
                                                                                 message:@"是否前往实名认证？"
                                                                          preferredStyle:UIAlertControllerStyleAlert ];
        
        //添加确定到UIAlertController中
        UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *doneAlert = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {            
            GuideViewController *guideVC = [[GuideViewController alloc]init];
            guideVC.initialPage = 1;
            BaseNavigationController *navi = [[BaseNavigationController alloc]initWithRootViewController:guideVC];
            
            [self presentViewController:navi animated:YES completion:nil];
        }];
        
        [alertController addAction:cancelAlert];
        [alertController addAction:doneAlert];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    if ([[Tool GetUserOption:AusoUserOptionDeposit]floatValue] < 1) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您还未交纳押金"
                                                                                 message:@"是否前往交纳押金？"
                                                                          preferredStyle:UIAlertControllerStyleAlert ];
        
        //添加确定到UIAlertController中
        UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        }];
        
        UIAlertAction *doneAlert = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self getDepositInfo];
        }];
        [alertController addAction:cancelAlert];
        [alertController addAction:doneAlert];
        
        [self presentViewController:alertController animated:YES completion:nil];

        
        return;
    }
    
    
    if ([[Tool GetUserOption:AusoUserOptionMoney]floatValue] < 1) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您的余额不足"
                                                                                 message:@"是否前去充值？"
                                                                          preferredStyle:UIAlertControllerStyleAlert ];
        
        //添加确定到UIAlertController中
        UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *doneAlert = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ReChargeViewController *chargeVC = [[ReChargeViewController alloc]init];
            chargeVC.type = 2;
            [self.navigationController pushViewController:chargeVC animated:YES];
        }];
        [alertController addAction:cancelAlert];
        [alertController addAction:doneAlert];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        return;
    }
    
    
    
    [SVProgressHUD show];
    ScanViewController *scanVC = [[ScanViewController alloc]init];
    scanVC.currentLocation = self.currentLocation;
    
    BaseNavigationController *navi = [[BaseNavigationController alloc]initWithRootViewController:scanVC];
    
    [scanVC setReturnDataBlock:^(NSDictionary *data, NSString *bikeNumber) {
        self.scanBikeInfo = [NSDictionary dictionaryWithDictionary:data];
        self.scanBikeNumber = bikeNumber;
        NSLog(@"%@",data);
        //        [self AusoBikeUnlocking];
        //        if (self.waitCycleView == nil) {
        WaitCycleView *waitVC = [[WaitCycleView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        waitVC.delegate = self;
        waitVC.message = [data valueForKey:@"prompt"];
        self.waitCycleView = waitVC;
        [self.view addSubview:waitVC];
        //        }
    }];
    [SVProgressHUD dismiss];
    [self presentViewController:navi animated:YES completion:nil];
}



#pragma mark - 获取活动信息
- (void)GetActivityInfo{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"3" forKey:@"type"];
    
    [Tool Get:API_Service param:param header:nil isHUD:YES result:^(BOOL status, NSDictionary *result) {
        self.is_will_ing = NO;
        self.is_will_activity = YES;
        if (result) {
            if ([self resultVerify:result]) {
                //展示
                [UserDefault setBool:YES forKey:Kuser_load_AD];
                [self showActivityWithData:[self resultData:result]];
            }else{
                [self showInfo:[self resultInfo:result]];
            }
        }
    }];
}

#pragma mark - 展示活动信息
- (void)showActivityWithData:(NSDictionary *)dict{
    if (self.ActivityView) {
        [self.ActivityView removeFromSuperview];
    }
    
    self.ActivityView = [[ActivityNoticeView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    self.ActivityView.data = dict;
    self.ActivityView.delegate = self;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.ActivityView];
}
- (void)GetBikeTypeAndOrder{
    if (![Tool IsLogin]) {
        return;
    }
    
    [Tool Get:API_BikeUnPayOrder param:nil header:[Tool AusoNetHeader] isHUD:NO result:^(BOOL status, NSDictionary *result) {
        if (status) {
            if ([self resultVerify:result]) {
                NSDictionary *infoDic = [self resultData:result];
                int code = [[infoDic valueForKey:@"status"]intValue];
                if (code == 1) {
                    //正在进行
                    BicyclingViewController *bicyVC = [[BicyclingViewController alloc]init];
                    bicyVC.data = infoDic;
                    
                    BaseNavigationController *navi = [[BaseNavigationController alloc]initWithRootViewController:bicyVC];
                    [self presentViewController:navi animated:YES completion:nil];
                }else if (code == 3){
                    if (self.waitPayView == nil) {
                        self.waitPayView = [[WaitPayView alloc]initWithFrame:CGRectMake((KScreenWidth - KScreenWidth * 0.8)/2 , 10, KScreenWidth * 0.8, 40)];
                        self.waitPayView.delegate = self;
                        [self.view addSubview:self.waitPayView];
                    }
                    
                    self.waitPayView.data = infoDic;
                    
                }
            }
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    UIImage *image = [UIColor imageWithColor:RGB_THEME_BACKGROUND];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]};
    if (self.ActivityView) {
        [self.ActivityView removeFromSuperview];
        self.ActivityView = nil;
    }
}

/**
 获取押金金额
 */
- (void)getDepositInfo{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"2" forKey:@"type"];
    
    [Tool Get:API_Service param:param header:nil isHUD:YES result:^(BOOL status, NSDictionary *result) {
        if (status) {
            if ([self resultVerify:result]) {
                //去交押金
                NSDictionary *infoDic = [self resultData:result];
                GuideViewController *guideVC = [[GuideViewController alloc]init];
                guideVC.initialPage = 2;
                guideVC.deposit = [NSString stringWithFormat:@"%@",[infoDic valueForKey:@"deposit"]];
                BaseNavigationController *navi = [[BaseNavigationController alloc]initWithRootViewController:guideVC];
                
                [self presentViewController:navi animated:YES completion:nil];
            }
        }
    }];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIImage *image = [UIImage imageNamed:@"navi_bg"];
    if (iPhone6Plus) {
        image = IMAGE_NAMED(@"navi_bg_plus");
    }
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar.titleTextAttributes=@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]}];
    self.navigationController.navigationBar.titleTextAttributes=@{NSFontAttributeName:[UIFont HelveticaNeueBoldFontSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    
    //隐藏键盘
    [self.view endEditing:YES];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    //看用户有没有加载过引导流程   如果没有加载过  强制进入引导过程
    
    if (![UserDefault boolForKey:KUser_Load_Guide]) {

        if ([[Tool GetUserOption:AusoUserOptionCard]intValue] != 2) {
            //实名认证
            GuideViewController *guideVC = [[GuideViewController alloc]init];
            guideVC.initialPage = 1;
            BaseNavigationController *navi = [[BaseNavigationController alloc]initWithRootViewController:guideVC];
            
            [self presentViewController:navi animated:YES completion:nil];
            
            return;
        }
        
        if ([[Tool GetUserOption:AusoUserOptionDeposit]floatValue] < 1) {
            [self getDepositInfo];
            
            return;
        }
        
    }
    
    if (![UserDefault boolForKey:Kuser_load_AD]) {
        [self GetActivityInfo];
        
    }
    
    if ([Tool IsLogin]) {
        [self GetBikeTypeAndOrder];
        [self getUserInfo];
    }
    
}



- (void)getUserInfo{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"1" forKey:@"type"];
    
    NSMutableDictionary *headerInfo = [NSMutableDictionary dictionary];
    [headerInfo setObject:[Tool GetUserOption:AusoUserOptionUserId] forKey:@"userid"];
    [headerInfo setObject:[Tool GetUserOption:AusoUserOptionToken] forKey:@"token"];
    
    [Tool Get:API_User_Info param:param header:headerInfo isHUD:NO result:^(BOOL status, NSDictionary *result) {
        if (status) {
            if ([self resultVerify:result]) {
                NSLog(@"%@",result);
                
                AusoUser *temp = [ArchiveUtil getUser];
                //从后台拿到 用户信息
                AusoUser *user = [AusoUser mj_objectWithKeyValues:[result objectForKey:@"data"]];
                user.token = temp.token;
                user.user_id = temp.user_id;
                //归档
                [ArchiveUtil saveUser:user];
            }
        }
    }];
}


@end

