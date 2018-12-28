//
//  BaseViewController.m
//  AusoBike
//
//  Created by Chang on 2017/11/2.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RANDOW_COLOR;
    [self createNaviBackButton];
    
}

//隐藏返回按钮
- (void)createNaviHideBack{
    self.navigationItem.leftBarButtonItem = nil;
}

//默认返回按钮
- (void)createNaviBackButton{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navi_btn_return"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationPopAction:)];
}

/**
 设置导航栏左右按钮

 @param itemType 按钮类型
 @param operType 内容类型
 @param string 类型内容
 */
- (void)createNaviItemType:(NaviItemType)itemType NaviOperType:(NaviOperType)operType NameString:(NSString *)string{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    if (itemType == NaviItemTypeLeftButton) {
        if (operType == NaviOperTypeTitle) {
//
//            [button setTitle:string forState:UIControlStateNormal];
//            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//
//            item.customView = button;
            
            item = [[UIBarButtonItem alloc]initWithTitle:string style:UIBarButtonItemStylePlain target:self action:@selector(navigationLeftBtnClick:)];
        }else{
            
            UIImage *image = [UIImage imageNamed:string];
            
            [button setImage:image forState:UIControlStateNormal];
//            button.size = CGSizeMake(image.size.width, image.size.height);
            button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            [button addTarget:self action:@selector(navigationLeftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            item.customView = button;
        }
        
        self.navigationItem.leftBarButtonItem = item;

    }else{
        if (operType == NaviOperTypeTitle) {
            [button setTitle:string forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(navigationRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.titleLabel.textAlignment = NSTextAlignmentRight;
            button.frame = CGRectMake(0, 0, 44, item.customView.height);
            item.customView = button;
//            item = [[UIBarButtonItem alloc]initWithTitle:string style:UIBarButtonItemStylePlain target:self action:@selector(navigationRightBtnClick:)];
        }else{
            
            UIImage *image = [UIImage imageNamed:string];
            
            [button setImage:image forState:UIControlStateNormal];
            button.size = CGSizeMake(image.size.width, image.size.height);
            [button addTarget:self action:@selector(navigationRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            item.customView = button;
        }
        
        self.navigationItem.rightBarButtonItem = item;
    }
}


- (void)navigationLeftBtnClick:(UIButton *)sender{}
- (void)navigationRightBtnClick:(UIButton *)sender{}



- (void)navigationPopAction:(UIButton *)sender{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark - HUD

- (void)showInfo:(NSString *)string{
    [SVProgressHUD showInfoWithStatus:string];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD dismissWithDelay:1.5];
}

- (void)showInfo:(NSString *)string alert:(CGFloat)alert{
    [SVProgressHUD showInfoWithStatus:string];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD dismissWithDelay:alert];
}

- (void)showWait:(NSString *)string{
    [SVProgressHUD showWithStatus:string];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD dismissWithDelay:1.5];
}

- (void)showWait:(NSString *)string alert:(CGFloat)alert{
    [SVProgressHUD showWithStatus:string];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD dismissWithDelay:alert];
}

- (void)showError:(NSString *)string{
    [SVProgressHUD showErrorWithStatus:string];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD dismissWithDelay:1.5];
}

- (void)showError:(NSString *)string alert:(CGFloat)alert{
    [SVProgressHUD showErrorWithStatus:string];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD dismissWithDelay:alert];
}

- (void)showSuccess:(NSString *)string{
    [SVProgressHUD showSuccessWithStatus:string];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD dismissWithDelay:1.5];
}

- (void)showSuccess:(NSString *)string alert:(CGFloat)alert{
    [SVProgressHUD showSuccessWithStatus:string];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD dismissWithDelay:alert];
}

- (void)show{
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];

}

- (void)dissmiss{
    [SVProgressHUD dismiss];
}

- (BOOL)resultVerify:(NSDictionary *)dict{
    return [[dict objectForKey: Result_Code]integerValue] == 0 ? YES:NO;
}
- (NSString *)resultInfo:(NSDictionary *)dict{
    return [NSString stringWithFormat:@"%@",[dict valueForKey:Result_Info]];
}
- (id)resultData:(NSDictionary *)dict{
    return [dict valueForKey:@"data"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)wantToDestination:(CLLocationCoordinate2D)location{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"导航到工具" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //自带地图
    [alertController addAction:[UIAlertAction actionWithTitle:@"自带地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"alertController -- 自带地图");
        
        //使用自带地图导航
        MKMapItem *currentLocation =[MKMapItem mapItemForCurrentLocation];
        
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:location addressDictionary:nil]];
        
        [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                                                                   MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
        
        
    }]];
    
    //判断是否安装了高德地图，如果安装了高德地图，则使用高德地图导航
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 高德地图");
            NSString *urlsting =[[NSString stringWithFormat:@"iosamap://navi?sourceApplication= &backScheme= &lat=%f&lon=%f&dev=0&style=2",location.latitude,location.longitude]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication  sharedApplication]openURL:[NSURL URLWithString:urlsting]];
            
        }]];
    }
    
    //判断是否安装了百度地图，如果安装了百度地图，则使用百度地图导航
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 百度地图");
            NSString *urlsting =[[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",location.latitude,location.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
            
        }]];
    }
    //判断是否安装了谷歌地图，如果安装了谷歌地图，则使用谷歌地图导航
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"谷歌地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 谷歌地图");
            NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",@"导航",@"nav123456",location.latitude, location.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }]];
    }
    //判断是否安装了腾讯地图，如果安装了腾讯地图，则使用腾讯地图导航
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"腾讯地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 腾讯地图");
            NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=终点&coord_type=1&policy=0",location.latitude, location.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }]];
    }
    //添加取消选项
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    
    //显示alertController
    [self presentViewController:alertController animated:YES completion:nil];
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
