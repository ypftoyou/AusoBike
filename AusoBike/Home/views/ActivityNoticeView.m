//
//  ActivityNoticeView.m
//  AusoBike
//
//  Created by Chang on 2017/11/22.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "ActivityNoticeView.h"
#import <UIImageView+WebCache.h>
#import <UIImage+AFNetworking.h>
#import "UITextView+Fuck.h"
#import <SDImageCache.h>
#import <SDWebImageManager.h>

@interface ActivityNoticeView()
@property (nonatomic, strong) UIView      *whiteView;
@property (nonatomic, strong) UIView      *backView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIButton    *closeButton;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UITextView  *contentLabel;
@property (nonatomic, strong) UILabel     *lineView;

@end
@implementation ActivityNoticeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    _backView = [[UIView alloc]init];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.4;
    [self addSubview:_backView];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap)];
//    [_backView addGestureRecognizer:tap];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:IMAGE_NAMED(@"btn_cancel") forState:UIControlStateNormal];
//    _closeButton.backgroundColor = [UIColor redColor];
    [_closeButton addTarget:self action:@selector(handleCloseAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeButton];
    
    _lineView = [[UILabel alloc]init];
    _lineView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_lineView];
    
    _whiteView = [[UIView alloc]init];
    _whiteView.layer.cornerRadius = 10;
    _whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_whiteView];
    
    _topImageView = [[UIImageView alloc]init];
    _topImageView.backgroundColor = [UIColor clearColor];
//    _topImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_whiteView addSubview:_topImageView];
    
    ViewRadius(_topImageView, 1);
    
    _titleLabel = [[UILabel alloc]init];
//    _titleLabel.text = @"活动时间：11月13日-12月12日";
    _titleLabel.font = [UIFont HelveticaNeueBoldFontSize:20];
    
    if (iphone5s || iphone4s) {
        _titleLabel.font = [UIFont HelveticaNeueBoldFontSize:17];

    }
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = RGBORANGE;
    [_whiteView addSubview:_titleLabel];
    
    _contentLabel = [[UITextView alloc]init];
    _contentLabel.font = [UIFont HeitiSCWithFontSize:15];
    
    if (iphone5s || iphone4s) {
        _contentLabel.font = [UIFont HeitiSCWithFontSize:13];

    }
    _contentLabel.editable = NO;
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    
    _contentLabel.textColor = RGB100;
    [_whiteView addSubview:_contentLabel];
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self);
    }];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(100);
    }];
    
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_closeButton);
        make.top.mas_equalTo(_closeButton.mas_bottom);
        make.width.mas_equalTo(1.1);
        make.height.mas_equalTo(35);
    }];
    
    [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(_lineView.mas_bottom);
        make.height.mas_equalTo(KScreenWidth - 30);
    }];
    
    [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(_topImageView.mas_bottom).offset(30);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(10);
        make.bottom.mas_equalTo(_whiteView.mas_bottom).offset(-10);
    }];
    
    [self layoutIfNeeded];

}

- (void)layoutSubviews {
    [super layoutSubviews];
  
    
    
}

- (void)handleCloseAction {
//    [self removeViewFromSupView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(ActivityNoticeViewClose)]) {
        [self.delegate ActivityNoticeViewClose];
    }
}

- (void)handleTap {
    [self removeViewFromSupView];
}

- (void)setData:(NSDictionary *)data{
    _data = data;
    _contentLabel.text = [data valueForKey:@"content"];
//    _contentLabel.text =  @"为推广环保出行，促进市民骑行共享单车。我司现\n\r推出限时免费骑行活动：凡在11月13日至12月12日\n\r期间骑行骜松单车的用户，均享有每天骑行前两个\r\n小时免费的优惠。";
    
    NSInteger start_time = [[data valueForKey:@"create_time"]integerValue];
    NSInteger end_time = [[data valueForKey:@"end_time"]integerValue];
    
    NSString *start = [Tool timestampSwitchTime:start_time withFormat:@"MM月dd日"];
    NSString *end = [Tool timestampSwitchTime:end_time withFormat:@"MM月dd日"];
    

    _titleLabel.text = [NSString stringWithFormat:@"活动时间：%@-%@",start,end];
    
//    [_topImageView sd_setImageWithURL:[NSURL URLWithString:[data valueForKey:@"images"]]];
    
    NSString *strURL = [NSString stringWithFormat:@"%@",[data valueForKey:@"images"]];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString *key = [manager cacheKeyForURL:[NSURL URLWithString:strURL]];
    SDImageCache *cache = [SDImageCache sharedImageCache];
    UIImage *cacheImage = [cache imageFromDiskCacheForKey:key];
    
    if (cacheImage) {
        CGFloat sc = self.topImageView.width / cacheImage.size.width;
        CGFloat tc = cacheImage.size.height * sc;
        _topImageView.image = cacheImage;
        
        [_topImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(tc);
        }];
        
    }else{
        [_topImageView sd_setImageWithURL:[NSURL URLWithString:[data valueForKey:@"images"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            NSData *imageData = UIImagePNGRepresentation(image);
            
            [[SDImageCache sharedImageCache]storeImageDataToDisk:imageData forKey:[data valueForKey:@"images"]];
            
            CGFloat sc = _topImageView.width / image.size.width;
            CGFloat tc = image.size.height * sc;
            
            [_topImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.top.mas_equalTo(10);
                make.right.mas_equalTo(-10);
                make.height.mas_equalTo(tc);
            }];
        }];
    }
}

/*
data =     {
    content = "为推广环保出行，促进市民骑行共享单车。我司现
    推出限时免费骑行活动：凡在11月13日至12月12日
    期间骑行骜松单车的用户，均享有每天骑行前两个
    小时免费的优惠。";
    "create_time" = 1510922231;
    "end_time" = 1513094340;
    id = 1;
    images = "http://www.bisilai.com/Public/aosong/activity.png";
    "start_time" = 1510502400;
    status = 1;
    title = "骜松单车";
};
info = "当前活动";
*/
- (void)removeViewFromSupView {
    for (UIView *views in self.subviews) {
        [views removeFromSuperview];
    }
    [self removeFromSuperview];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
