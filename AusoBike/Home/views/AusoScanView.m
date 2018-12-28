//
//  AusoScanView.m
//  AusoBike
//
//  Created by Chang on 2017/11/20.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "AusoScanView.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
#import "FBShimmeringView.h"
@interface AusoScanView()<AVCaptureMetadataOutputObjectsDelegate>

/** 视频流媒体 */
@property (strong,nonatomic) AVCaptureDevice            * device;
@property (strong,nonatomic) AVCaptureDeviceInput       * input;
@property (strong,nonatomic) AVCaptureMetadataOutput    * output;
@property (strong,nonatomic) AVCaptureSession           * session;
@property (strong,nonatomic) AVCaptureVideoPreviewLayer * preview;
@property (assign,nonatomic) CGSize                     frameSize;
@property (nonatomic,assign) CGRect                     scanRect;


/** 是否正在处理二维码中 */
@property (nonatomic,assign) BOOL                       isProcessing;

/** 线条移动的位置 */
@property (nonatomic,assign) BOOL                       lineMoveUpOrDown;
@property (nonatomic,assign) int                        lineMoveNum;
@property (nonatomic,weak  ) NSTimer                    *scanAnimationTimer;
@property (nonatomic,strong) UIImageView                *scanLine;

@end

@implementation AusoScanView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupCamera];

        [self setupViews];

    }
    return self;
}

- (void)setupViews{
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview:baseView];
    
    baseView.backgroundColor = RGBACOLOR(0, 0, 0, 0.4);

    UIView *cubeMark = [[UIView alloc]init];
    [self addSubview:cubeMark];
    
    [cubeMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(50);
        make.centerX.mas_equalTo(self);
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-60);
        make.height.mas_equalTo(cubeMark.mas_width);
    }];
    
    [cubeMark layoutIfNeeded];
    [self layoutIfNeeded];
    
    self.scanRect = cubeMark.frame;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.width, self.height)];
       [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:cubeMark.frame cornerRadius:1] bezierPathByReversingPath]];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    baseView.layer.mask = shapeLayer;
    
    NSArray *imageArr = @[@"QRCodeLeftTop",@"QRCodeRightTop",@"QRCodeLeftBottom",@"QRCodeRightBottom"];
    for (int i = 0; i < 4; i ++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = IMAGE_NAMED(imageArr[i]);
        [self addSubview:imageView];
        if (i == 0) {
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.mas_equalTo(cubeMark);
            }];
        }else if (i == 1){
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.mas_equalTo(cubeMark);
            }];
        }else if (i == 2){
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.mas_equalTo(cubeMark);
            }];
        }else{
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.mas_equalTo(cubeMark);
            }];
        }
    }
    

    UIImageView *scanLine = [[UIImageView alloc]init];
    [self addSubview:scanLine];
    
    self.scanLine = scanLine;
    scanLine.image = IMAGE_NAMED(@"QRCodeScanningLine");
    [scanLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cubeMark);
        make.centerX.mas_equalTo(self.mas_centerX);
        
    }];
    
    UILabel *remindLab = [[UILabel alloc]init];
    [self addSubview:remindLab];
    
    remindLab.text = @"扫描车辆上的二维码，就可以骑行小骜啦";
    remindLab.font = [UIFont systemFontOfSize:14.0];
    remindLab.textAlignment = NSTextAlignmentCenter;
    remindLab.textColor = [UIColor whiteColor];
    
    [remindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cubeMark.mas_bottom).offset(12);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    UIButton *inputNum_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:inputNum_btn];
    
    [inputNum_btn setTitle:@"输入车辆编码" forState:UIControlStateNormal];
    inputNum_btn.titleLabel.font = [UIFont HelveticaNeueBoldFontSize:17];
    [inputNum_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [inputNum_btn addTarget:self action:@selector(inputNumber:) forControlEvents:UIControlEventTouchUpInside];
    [inputNum_btn setBackgroundColor:RGBORANGE];
    
    [inputNum_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(remindLab.mas_bottom).offset(30);
        make.width.mas_equalTo(cubeMark.mas_width);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(43);
    }];
    
    [self layoutIfNeeded];
    ViewShadow(inputNum_btn, [UIColor blackColor], CGSizeMake(3,3), 3, 0.4);
    inputNum_btn.layer.cornerRadius = 1;
    
    
    UIView *line = [[UIView alloc]init];
    [self addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(inputNum_btn.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.width.mas_equalTo(1);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    UIButton *lightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:lightBtn];
    
    [lightBtn setImage:IMAGE_NAMED(@"ico_scan_light") forState:UIControlStateNormal];
    [lightBtn setImage:IMAGE_NAMED(@"ico_scan_light_pre") forState:UIControlStateSelected];
    [lightBtn addTarget:self action:@selector(lightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [lightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(cubeMark.mas_width);
        make.centerX.mas_equalTo(line.mas_centerX);
        make.centerY.mas_equalTo(line.mas_centerY);
    }];
    
    [self layoutIfNeeded];
    
    FBShimmeringView *shimmeringView           = [[FBShimmeringView alloc] initWithFrame:remindLab.frame];
    shimmeringView.shimmering                  = YES;
    shimmeringView.shimmeringBeginFadeDuration = 0.3;
    shimmeringView.shimmeringOpacity           = 0.3;
    shimmeringView.shimmeringSpeed             = 180;
        [self addSubview:shimmeringView];

    shimmeringView.contentView                 = remindLab;

    [self start];
}

- (void)inputNumber:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(AusoScanViewScanfInput)]) {
        [self.delegate AusoScanViewScanfInput];
    }
}
#pragma mark -
#pragma mark - 开启摄像头
- (void)setupCamera{
    if (TARGET_IPHONE_SIMULATOR) {
        return;
    }
    
    if (!self.device) {
        //视频流媒体
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    if (!self.input) {
        //输出流媒体
        self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    }
    
    if (!self.output) {
        self.output = [[AVCaptureMetadataOutput alloc]init];
    }
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    if (!self.session) {
        self.session = [[AVCaptureSession alloc]init];
    }
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    //条码类型
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    if (!self.preview) {
        self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    }
    self.preview.frame = CGRectMake(0, 0,self.width, self.height);
    self.preview.backgroundColor = RGB_THEME_BACKGROUND.CGColor;
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer insertSublayer:self.preview atIndex:0];
    
//    [self.session startRunning];
    
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if ([metadataObjects count] > 0) {
        if (!self.isProcessing) {
            [self.session stopRunning];
            self.isProcessing = YES;
            
            [self SG_playSoundEffect:@"noticeMusic.wav"];

            AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
            
            NSString *stringValue = metadataObject.stringValue;
            
            NSLog(@"取得结果 %@",stringValue);
            
            if (![stringValue containsString:@"www.aosongtech.com"]) {
                
                [SVProgressHUD showErrorWithStatus:@"无效二维码"];
                [SVProgressHUD dismissWithDelay:1.5 completion:^{
                    [self.session startRunning];
                    self.isProcessing = NO;
                }];
                return;
                
            }else{
                
                [self accordingQRcode:stringValue];
                
            }
        }
    }
}

/** 播放音效文件 */
- (void)SG_playSoundEffect:(NSString *)name {
    // 获取音效
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    // 1、获得系统声音ID
    SystemSoundID soundID = 0;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    
    // 2、播放音频
    AudioServicesPlayAlertSound(soundID);
}


#pragma mark - 识别扫码结果
- (void)accordingQRcode:(NSString *)str{
    //用 “=” 号 分割传入的扫描结果字符串  例如 http://www.ipower001.com/Pay/Codes/order_source
    NSArray *infoArr = [str componentsSeparatedByString:@"="];
    
    //分割后 会得到一个数组  也就是 “=” 前部分 和 “=” 后部分   这里去 数组的最后一个元素  就是充电桩编号
    NSString *deviceNum= [infoArr lastObject];
    
    if (deviceNum.length < 1) {
        [SVProgressHUD showErrorWithStatus:@"编号不能为空"];
        [SVProgressHUD dismissWithDelay:1.5 completion:^{
            [self.session startRunning];
            self.isProcessing = NO;
        }];
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(AusoScanViewQRInformation:)]) {
            [self.delegate AusoScanViewQRInformation:deviceNum];
        }
    }
}
- (void)lightBtnClick:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self turnTorchOn:YES];
    }
    else{
        [self turnTorchOn:NO];
    }
}

- (void)turnTorchOn:(bool)on
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}


#pragma mark - 开始
- (void)start{
    if (!self.scanAnimationTimer) {
        self.scanAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:1.9f
                                                                   target:self
                                                                 selector:@selector(scanAnimation)
                                                                 userInfo:nil
                                                                  repeats:YES];
    }else{
        [self.scanAnimationTimer setFireDate:[NSDate distantPast]];
        
    }
    
    self.isProcessing = NO;
    [self.session startRunning];    
}

- (void)scanAnimation{
    
    CGFloat _h = self.lineMoveUpOrDown ? 10 : -10;
    
    //动画掉帧
    [UIView animateWithDuration:0.2 animations:^{
        self.scanLine.layer.shadowOffset = CGSizeMake(0, _h);
    }];
    
    if (!self.lineMoveUpOrDown) {
        [UIView animateWithDuration:1.8 animations:^{
            self.scanLine.origin = CGPointMake(self.scanLine.left,self.scanRect.origin.y + self.scanRect.size.height - 22);
        } completion:^(BOOL finished) {
            self.lineMoveUpOrDown = YES;
        }];
    }else{
        [UIView animateWithDuration:1.8 animations:^{
            self.scanLine.origin = CGPointMake(self.scanLine.left,self.scanRect.origin.y + 22);
        } completion:^(BOOL finished) {
            self.lineMoveUpOrDown = NO;
        }];
    }
}
#pragma mark - 停止
- (void)stop{
    [self.scanAnimationTimer setFireDate:[NSDate distantFuture]];
    self.isProcessing = YES;
    [self.session stopRunning];
}
@end
