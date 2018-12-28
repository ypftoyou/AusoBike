//
//  ScanViewController.m
//  AusoBike
//
//  Created by Chang on 2017/11/20.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "ScanViewController.h"
#import "AusoScanView.h"
#import "InputVehicleCodingView.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface ScanViewController ()<AusoScanViewDelegate,InputVehicleCodingViewDelegate>
@property (nonatomic,strong)InputVehicleCodingView *inputView;
@property (nonatomic,strong)AusoScanView *scanView;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫码骑车";
    [self createNaviItemType:NaviItemTypeLeftButton NaviOperType:NaviOperTypeImage NameString:@"navi_btn_cancel"];

    [self configViews];
}

- (void)configViews{
    AusoScanView *scanView = [[AusoScanView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    [self.view addSubview:scanView];
    self.scanView = scanView;
    scanView.delegate = self;

}

- (void)AusoScanViewQRInformation:(NSString *)info{

    [self.view endEditing:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:info forKey:@"number"];

    [Tool Get:API_BikeInfo param:param header:[Tool AusoNetHeader] isHUD:YES result:^(BOOL status, NSDictionary *result) {
        if (status) {
            if ([self resultVerify:result]) {
                self.returnDataBlock([result valueForKey:@"data"],info);
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [SVProgressHUD showInfoWithStatus:[self resultInfo:result]];
                [SVProgressHUD dismissWithDelay:1.5 completion:^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
            }
        }
    }];
}

- (void)AusoScanViewScanfInput{
    //手动输入
    if (self.inputView) {
        [self.inputView removeFromSuperview];
        self.inputView = nil;
    }
    
    [self.scanView stop];
    InputVehicleCodingView *inputView = [[InputVehicleCodingView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    inputView.delegate = self;
    self.inputView = inputView;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:inputView];
}

#pragma mark - input代理
- (void)clickLockingButton:(NSString *)stirng{
//    NSLog(@"%@",stirng);
//    self.returnDataBlock(nil, stirng);
//    [self.inputView removeFromSuperview];
//    self.inputView = nil;
//    [self dismissViewControllerAnimated:YES completion:nil];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:stirng forKey:@"number"];
//    [param setValue:stirng forKey:@"license_plate"];

    [Tool Get:API_BikeInfo param:param header:[Tool AusoNetHeader] isHUD:YES result:^(BOOL status, NSDictionary *result) {
        if (status) {
            if ([self resultVerify:result]) {
                    [self.inputView removeFromSuperview];
                    self.inputView = nil;

                self.returnDataBlock([result valueForKey:@"data"],stirng);
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                    [self.inputView removeFromSuperview];
                    self.inputView = nil;

                [SVProgressHUD showInfoWithStatus:[self resultInfo:result]];
                [SVProgressHUD dismissWithDelay:1.5 completion:^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
            }
        }
    }];
}

- (void)InputVehicleCodingViewClose{
    [self.inputView removeFromSuperview];
    self.inputView = nil;
    
    [self.scanView start];
}

- (void)navigationLeftBtnClick:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
        
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            
            [device unlockForConfiguration];
        }
    }
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
