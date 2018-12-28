//
//  InputVehicleCodingView.m
//  AusoBike
//
//  Created by Chang on 2017/11/21.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "InputVehicleCodingView.h"

@interface InputVehicleCodingView()

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIButton    *closeButton;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton    *lockingButton;
@property (nonatomic, strong) UILabel     *lineView;

@end

@implementation InputVehicleCodingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initSubViews];
    }
    return self;
}

- (void)_initSubViews {
    
    _backView = [[UIView alloc]init];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.4;
    [self addSubview:_backView];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap)];
//    [_backView addGestureRecognizer:tap];
    
    _whiteView = [[UIView alloc]init];
    _whiteView.layer.cornerRadius = 8;
    _whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_whiteView];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"输入车辆编码";
    _titleLabel.font = [UIFont HelveticaNeueBoldFontSize:20];
    _titleLabel.textColor = RGBACOLOR(0, 0, 0, 1);
    [_whiteView addSubview:_titleLabel];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:IMAGE_NAMED(@"btn_scan_cancel") forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(handleCloseAction) forControlEvents:UIControlEventTouchUpInside];
    [_whiteView addSubview:_closeButton];
    
    
    _textField = [[UITextField alloc]init];
    _textField.placeholder = @"请输入车辆编号";
    
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:22];
    if (font == nil) {
        font = [UIFont systemFontOfSize:22];
    }
    _textField.font = font;
    [_textField setValue:RGBACOLOR(125, 125, 125, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [_textField setValue:[UIFont AvenirWithFontSize:16] forKeyPath:@"_placeholderLabel.font"];
    _textField.tintColor = RGBORANGE;
    _textField.textColor = RGB_THEME_BACKGROUND;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [_whiteView addSubview:_textField];
    
    _lineView = [[UILabel alloc]init];
    _lineView.backgroundColor = RGBACOLOR(255, 147, 125, 1);
    [_whiteView addSubview:_lineView];
    
    _lockingButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [_lockingButton setTitle:@"开锁" forState:UIControlStateNormal];
    [_lockingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _lockingButton.titleLabel.font = [UIFont AvenirWithFontSize:15];
    [_lockingButton setBackgroundImage:IMAGE_NAMED(@"btn_scan_high") forState:UIControlStateNormal];
    [_lockingButton setBackgroundImage:IMAGE_NAMED(@"btn_scan_nor") forState:UIControlStateDisabled];
    [_lockingButton addTarget:self action:@selector(handlelockingAction) forControlEvents:UIControlEventTouchUpInside];
    _lockingButton.enabled = NO;

    [_whiteView addSubview:_lockingButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self);
    }];
    
    CGFloat x = KScreenWidth / 2 - 272 / 2;
    [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(x);
        make.right.mas_equalTo(-x);
        make.top.mas_equalTo(130);
        make.height.mas_equalTo(223);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(22);
        make.top.mas_equalTo(25);
    }];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(24);
//        make.width.height.mas_equalTo(15);
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(68);
        make.left.mas_equalTo(22);
        make.right.mas_equalTo(25);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(22);
        make.right.mas_equalTo(-25);
        make.top.mas_equalTo(_textField.mas_bottom).offset(8);
        make.height.mas_equalTo(2);
    }];
    
    [_lockingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_lineView.mas_bottom).offset(20);
//        make.left.right.mas_equalTo(_lineView);
//        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
}

- (void)textFieldDidChange:(UITextField *)textField{
    NSDictionary *attrsDictionary =@{
                                     NSFontAttributeName: _textField.font,
                                     NSKernAttributeName:[NSNumber numberWithFloat:10.0f]//这里修改字符间距
                                     };
    textField.attributedText=[[NSAttributedString alloc]initWithString:textField.text attributes:attrsDictionary];
    
    if (textField.text.length > 7) {
        textField.text = [textField.text substringToIndex:7];
    }
    
    if (textField.text.length != 7) {
        _lockingButton.enabled = NO;
    }else{
        _lockingButton.enabled = YES;
        
    }
}


#pragma mark --- 关闭按钮
- (void)handleCloseAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(InputVehicleCodingViewClose)]) {
        [self.delegate InputVehicleCodingViewClose];
    }
}

#pragma mark ---开锁按钮
- (void)handlelockingAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickLockingButton:)]) {
        [self.delegate clickLockingButton:_textField.text];
    }
}

#pragma maek ---透明的背景点击
- (void)handleTap {
    [self removeViewFromSupView];
}


- (void)removeViewFromSupView {
    for (UIView *views in self.subviews) {
        [views removeFromSuperview];
    }
    [self removeFromSuperview];
    
}

@end
