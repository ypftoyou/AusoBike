//
//  GuideMainView.m
//  AusoBike
//
//  Created by Chang on 2017/11/7.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "GuideMainView.h"

#define NUM @"0123456789"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

const double Magin = 50;

@interface GuideMainView()<UITextFieldDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UITextField  *tf_pageOnePhone;
@property (nonatomic,strong) UITextField  *tf_pageOneCode;
@property (nonatomic,strong) UITextField  *tf_pageTwoName;
@property (nonatomic,strong) UITextField  *tf_pageTwoIdCard;
@property (nonatomic,strong) UILabel      *pageThreeLabel;
@property (nonatomic,strong) UIView       *pageTwo_viewName;
@property (nonatomic,strong) UIView       *pageTwo_viewIdCard;

@property (nonatomic,strong) UIButton *pageThreeChoosePayTypeBtn;///< 支付方式
@end

@implementation GuideMainView

- (void)setInitialPage:(NSInteger)initialPage{
    _initialPage = initialPage;
    [self.scrollView setContentOffset:CGPointMake(initialPage * self.width, 0) animated:NO];
}

- (void)setData:(NSDictionary *)data{
    _data = data;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview:self.scrollView];
    
    [self setPageOne];
    [self setPageTwo];
    [self setPageThree];
    [self setPageFour];
    
    self.scrollView.scrollEnabled = NO;
    [self.scrollView setContentSize:CGSizeMake(self.width * 4,0)];
}

- (void)setPageOne{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self.scrollView addSubview:view];
    CGFloat hight = 40.f;
    NSArray *titleArr = @[@"请输入手机号",@"请输入验证码"];
    for (int i = 0; i < titleArr.count; i ++) {
       
        UIView *bgView = [[UIView alloc]init];
        [view addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(i  * 70);
            make.height.mas_equalTo(hight);
        }];
        
        [bgView layoutIfNeeded];

        ViewBorderRadius(bgView, 0, 1, [UIColor orangeColor]);
        
        UIImageView *iconView = [[UIImageView alloc]init];
        iconView.backgroundColor = RANDOW_COLOR;
        [bgView addSubview:iconView];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.width.height.mas_equalTo(30);
            make.centerY.mas_equalTo(bgView.mas_centerY);
        }];
        
        UILabel *line = [[UILabel alloc]init];
        [bgView addSubview:line];
        
        line.backgroundColor = [UIColor grayColor];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(10);
            make.width.mas_equalTo(1);
            make.height.centerY.mas_equalTo(iconView);
        }];
        
        UITextField *textField = [[UITextField alloc]init];
        [bgView addSubview:textField];
        
        textField.placeholder = titleArr[i];
        textField.backgroundColor = RANDOW_COLOR;
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(line.mas_right).offset(8);
            make.height.centerY.mas_equalTo(line);
            make.right.mas_equalTo(-10);
        }];
        
        if (i == 1) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [bgView addSubview:button];
            [button setTitle:@"获取验证码" forState:UIControlStateNormal];
            button.backgroundColor = RGBACOLOR(254, 186, 17, 1);
            button.titleLabel.font = [UIFont AvenirWithFontSize:15];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.height.right.mas_equalTo(bgView);
                make.width.mas_equalTo(100);
            }];
            [view layoutIfNeeded];
            
            [textField mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(button.mas_left).offset(-10);
                make.height.centerY.mas_equalTo(line);
                make.right.mas_equalTo(-110);
            }];
            self.tf_pageOnePhone = textField;
        }else{
            self.tf_pageOneCode = textField;
        }
    }
    
    UIButton *verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [verifyBtn setBackgroundImage:[UIImage imageNamed:@"btn_normol_blue"] forState:UIControlStateNormal];
    [verifyBtn setTitle:@"验证" forState:UIControlStateNormal];
    verifyBtn.titleLabel.font = [UIFont HelveticaNeueFontSize:17];
    [verifyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [verifyBtn addTarget:self action:@selector(pageOneVerifyClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:verifyBtn];
    
    [verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(180);
        make.centerX.mas_equalTo(view);
        if (iphone5s || iphone4s) {
            make.left.mas_equalTo(26);
        }
    }];
    
    [view layoutIfNeeded];
    
}

- (void)setPageTwo{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(self.width, 0, self.width, self.height)];
    
    
    [self.scrollView addSubview:view];
    
    NSArray *titleArr = @[@"请输入真实姓名",@"请输入身份证号码"];
    NSArray *imageArr = @[@"ico_user",@"ico_code"];
    
    for (int i = 0; i < titleArr.count; i ++) {
        
        UIView *bgView = [[UIView alloc]init];
        [view addSubview:bgView];
        
        ViewBorderRadius(bgView, 6, 1.2, [UIColor lightGrayColor]);

        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(i  * 70);
            make.height.mas_equalTo(50);
        }];
        
        
        UIImageView *icon = [[UIImageView alloc]init];
        [view addSubview:icon];
        
        [icon setImage:IMAGE_NAMED(imageArr[i])];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left).offset(10);
            make.centerY.mas_equalTo(bgView.mas_centerY);
            make.width.mas_equalTo(icon.mas_height);
        }];
        
        UIImageView *line = [[UIImageView alloc]init];
        [view addSubview:line];
        
        line.image = IMAGE_NAMED(@"di_certification");
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(icon.mas_right);
            make.centerY.mas_equalTo(bgView.mas_centerY);
            make.width.mas_equalTo(line.mas_height);
        }];
        
        UITextField *textField = [[UITextField alloc]init];
        [view addSubview:textField];
        textField.placeholder = titleArr[i];
        textField.delegate = self;
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(line.mas_right).offset(0);
            make.centerY.mas_equalTo(bgView.mas_centerY);
            make.height.mas_equalTo(bgView.mas_height);
            make.right.mas_equalTo(bgView.mas_right).offset(-10);
        }];
        
        if (i == 0) {

            self.tf_pageTwoName = textField;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:)name:UITextFieldTextDidChangeNotification object:self.tf_pageTwoName];
            self.pageTwo_viewName = bgView;
        }else{
            self.pageTwo_viewIdCard = bgView;
            self.tf_pageTwoIdCard = textField;
            self.tf_pageTwoIdCard.keyboardType = UIKeyboardTypeASCIICapable;
            [self.tf_pageTwoIdCard addTarget:self action:@selector(textFieldChangeValue:) forControlEvents:UIControlEventEditingChanged];
            self.tf_pageTwoIdCard.returnKeyType =  UIReturnKeyDone;
        }

    }
    
    UIButton *baseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:baseBtn];
    [baseBtn setImage:IMAGE_NAMED(@"btn_normol_blue") forState:UIControlStateNormal];
    baseBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [baseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        if (iphone5s || iphone4s) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(self.pageTwo_viewIdCard.mas_bottom).offset(70);
        }else{
            make.top.mas_equalTo(self.pageTwo_viewIdCard.mas_bottom).offset(50);
        }
    }];
    
    ViewShadow(baseBtn, RGBORANGE, CGSizeMake(0, 3), 3.f, 0.5);
    
    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:customBtn];
    
    [customBtn setTitle:@"提交资料" forState:UIControlStateNormal];
    [customBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (iphone5s || iphone4s) {
        customBtn.titleLabel.font = [UIFont HelveticaNeueFontSize:16];
    }else{
        customBtn.titleLabel.font = [UIFont HelveticaNeueFontSize:17];
    }
    [customBtn  addTarget:self action:@selector(pageTwoCommitClick:) forControlEvents:UIControlEventTouchUpInside];
    [customBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(baseBtn);
        make.height.width.mas_equalTo(baseBtn);
    }];
    
    UILabel *msgLab = [[UILabel alloc]init];
    [view addSubview:msgLab];

    msgLab.text = @"请您放心填写，身份信息不会泄露";
    msgLab.font = [UIFont AvenirWithFontSize:13];
    msgLab.textColor = RGBACOLOR(100, 100, 100, 1);
    
    [msgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view);
        make.top.mas_equalTo(customBtn.mas_bottom).offset(10);
    }];

    [view layoutIfNeeded];
    ViewShadow(baseBtn, [UIColor grayColor], CGSizeMake(0, 3), 3, 0.4);

    UITapGestureRecognizer *singTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBord)];
    [view addGestureRecognizer:singTap];
}

- (void)hideKeyBord{
    [self endEditing:YES];
}
- (void)setPageThree{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(self.width * 2, 0, self.width, self.height)];
    view.backgroundColor= RGB241;
    
    [self.scrollView addSubview:view];
    
    UILabel *topLab = [[UILabel alloc]init];
    [view addSubview:topLab];
    
    topLab.text = @"押金交纳";
    topLab.font= [UIFont HelveticaNeueFontSize:14];
    topLab.textColor = RGB100;
    [topLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    UIView *topView = [[UIView alloc]init];
    [view addSubview:topView];
    
    topView.backgroundColor = [UIColor whiteColor];
  
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topLab.mas_bottom).offset(1);
        make.left.mas_equalTo(view).offset(-1);
        make.right.mas_equalTo(view).offset(1);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *topMsg_left = [[UILabel alloc]init];
    [topView addSubview:topMsg_left];
    
    topMsg_left.text = @"交纳金额";
    topMsg_left.font = [UIFont HeitiSCWithFontSize:15];
    [topMsg_left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.height.mas_equalTo(topView);
    }];
    
    
    UILabel *topMsg_right = [[UILabel alloc]init];
    [topView addSubview:topMsg_right];
    
    self.pageThreeLabel = topMsg_right;
    topMsg_right.font = [UIFont AvenirWithFontSize:16];
    [topMsg_right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.height.mas_equalTo(topView);
    }];
    
    UILabel *bottomLab = [[UILabel alloc]init];
    [view addSubview:bottomLab];
    
    bottomLab.text = @"支付方式";
    bottomLab.font = topLab.font;
    bottomLab.textColor = topLab.textColor;
    [bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).offset(32);
        make.height.mas_equalTo(topLab);
        make.left.mas_equalTo(8);
    }];
    
    
    UIView *bottomView = [[UIView alloc]init];
    [view addSubview:bottomView];
    
    bottomView.backgroundColor= [UIColor whiteColor];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomLab.mas_bottom).offset(1);
        make.left.mas_equalTo(-1);
        make.right.mas_equalTo(1);
        make.height.mas_equalTo(100);
    }];
    
    NSArray *payArr = @[@"微信支付",@"支付宝支付"];
    NSArray *payImageArr = @[@"ico_pay_wechat",@"ico_pay_zfb"];
    
    for (int i = 0; i < 2; i ++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        [bottomView addSubview:imageView];
        
        imageView.image = [UIImage imageNamed:payImageArr[i]];
//        imageView.backgroundColor = RANDOW_COLOR;
        imageView.contentMode = UIViewContentModeScaleToFill;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            CGFloat Y = i * 50 + 10;
            make.top.mas_equalTo(Y);
            make.width.height.mas_equalTo(30);
        }];
        
        
        UILabel *label = [[UILabel alloc]init];
        [bottomView addSubview:label];
        label.text = payArr[i];
        label.font = [UIFont HeitiSCWithFontSize:15];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageView.mas_right).offset(10);
            make.centerY.mas_equalTo(imageView.mas_centerY);
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [bottomView addSubview:button];
        
        button.tag = 1711031455 + i;
        [button setImage:[UIImage imageNamed:@"btn_recharge_tick_nor"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"btn_recharge_tick_press"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(pageThreeChoosePayType:) forControlEvents:UIControlEventTouchUpInside];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(imageView.mas_centerY);
            make.height.width.mas_equalTo(60);
        }];
        
        if (i == 1) {
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
            [bottomView addSubview:line];
            
            line.backgroundColor = RGB241;
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(50);
                make.left.mas_equalTo(20);
                make.right.mas_equalTo(-20);
                make.height.mas_equalTo(1.3);
            }];
        }
    }
    
//    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [commitBtn setBackgroundImage:[UIImage imageNamed:@"btn_normol_blue"] forState:UIControlStateNormal];
//    [commitBtn setTitle:@"立即支付" forState:UIControlStateNormal];
//    commitBtn.titleLabel.font = [UIFont HelveticaNeueFontSize:17];
//    [commitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [commitBtn addTarget:self action:@selector(pageThreeDone:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:commitBtn];
//
//    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(bottomView.mas_bottom).offset(40);
//        make.centerX.mas_equalTo(view.mas_centerX);
//        if (iphone5s || iphone4s) {
//            make.left.mas_equalTo(26);
//        }
//    }];
    
    UIButton *baseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:baseBtn];
    [baseBtn setImage:IMAGE_NAMED(@"btn_normol_blue") forState:UIControlStateNormal];
    baseBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [baseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        if (iphone5s) {
            make.left.mas_equalTo(26);
            make.top.mas_equalTo(bottomView.mas_bottom).offset(60);
        }else if(iphone4s){
            make.top.mas_equalTo(bottomView.mas_bottom).offset(20);
            make.left.mas_equalTo(26);

        }else{
            make.top.mas_equalTo(bottomView.mas_bottom).offset(90);

        }
    }];
    
    ViewShadow(baseBtn, RGBORANGE, CGSizeMake(0, 3), 3.f, 0.5);
    
    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:customBtn];
    
    [customBtn setTitle:@"交纳押金" forState:UIControlStateNormal];
    [customBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (iphone5s || iphone4s) {
        customBtn.titleLabel.font = [UIFont HelveticaNeueFontSize:16];
    }else{
        customBtn.titleLabel.font = [UIFont HelveticaNeueFontSize:17];
    }
    [customBtn  addTarget:self action:@selector(pageThreeDone:) forControlEvents:UIControlEventTouchUpInside];
    [customBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(baseBtn);
        make.height.width.mas_equalTo(baseBtn);
    }];
    
    
    UILabel *msgLab = [[UILabel alloc]init];
    [view addSubview:msgLab];
    
    msgLab.text = @"* 押金交纳后可随时全额退款";
    msgLab.font = [UIFont AvenirWithFontSize:13];
    msgLab.textColor = RGB100;
    
    [msgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        make.top.mas_equalTo(baseBtn.mas_bottom).offset(10);
    }];
    
    [view layoutIfNeeded];
    ViewShadow(baseBtn, [UIColor grayColor], CGSizeMake(0, 3), 3, 0.4);

}


- (void)setPageFour{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(self.width * 3, 0, self.width, self.height)];
    view.backgroundColor= [UIColor whiteColor];
    [self.scrollView addSubview:view];

    UIImageView *imageView = [[UIImageView alloc]init];
    
    [view addSubview:imageView];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"ico_congratulation"];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(view.mas_centerX);
    }];
    
    UILabel *msgLabel = [[UILabel alloc]init];
    [view addSubview:msgLabel];
    
    msgLabel.text = @"恭喜，您已经完成注册，可以愉快的骑行小松啦!";
    msgLabel.font = [UIFont HeitiSCWithFontSize:15];
    msgLabel.textColor = RGB100;
    msgLabel.adjustsFontSizeToFitWidth = YES;
    [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).offset(-10);
        make.centerX.mas_equalTo(view);
    }];
    

    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:doneBtn];

    [doneBtn setBackgroundImage:[UIImage imageNamed:@"btn_login"] forState:UIControlStateNormal];
    [doneBtn setTitle:@"立即体验" forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont HelveticaNeueFontSize:17];
    [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(pageFourDoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];


    [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        if (iphone4s) {
            make.top.mas_equalTo(msgLabel.mas_bottom).offset(40);
        }else{
            make.top.mas_equalTo(msgLabel.mas_bottom).offset(80);
        }
    }];
//
//    UIButton *reChargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [view addSubview:reChargeBtn];
//
//    [reChargeBtn setTitle:@"充值" forState:UIControlStateNormal];
//    reChargeBtn.titleLabel.font = [UIFont HelveticaNeueFontSize:17];
//    [reChargeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [reChargeBtn addTarget:self action:@selector(pageFourReCharge:) forControlEvents:UIControlEventTouchUpInside];
//
//
//    [reChargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(view.mas_centerX);
//        make.top.mas_equalTo(doneBtn.mas_bottom).offset(20);
//        make.width.height.mas_equalTo(doneBtn);
//    }];
//
//    [view layoutIfNeeded];
//
//    ViewBorderRadius(reChargeBtn,reChargeBtn.height / 2.f, 1.2, RGBORANGE);
//    ViewShadow(doneBtn, [UIColor grayColor], CGSizeMake(0, 3), 3, 0.4);
}

- (void)nextPageWithAnimation:(BOOL)animation{
    _initialPage += 1;
    [self.scrollView setContentOffset:CGPointMake(self.initialPage * self.width, 0) animated:animation];
}


- (void)pageOneVerifyClick:(UIButton *)sender{
    [self.delegate guideMainViewPageOneVerifyWithPhone:self.tf_pageOnePhone.text code:self.tf_pageOneCode.text];
}

- (void)pageTwoCommitClick:(UIButton *)sender{
    //关闭键盘
    [self endEditing:YES];
    
    if (self.tf_pageTwoName.text.length < 1) {
        [SVProgressHUD showErrorWithStatus:@"姓名不能为空"];
        [SVProgressHUD dismissWithDelay:1.5];
        return;
    }
    
    if (self.tf_pageTwoIdCard.text.length < 1 || ![Tool isValidateIdentityCard:self.tf_pageTwoIdCard.text]) {
        [SVProgressHUD showErrorWithStatus:@"身份证号不合法"];
        [SVProgressHUD dismissWithDelay:1.5];
        return;
    }
    
    [self.delegate guideMainViewPageTwoCommitWithName:self.tf_pageTwoName.text IdCard:self.tf_pageTwoIdCard.text];
}



#pragma mark - Method page three

- (void)pageThreeChoosePayType:(UIButton *)sender{
    if (sender.tag == 1711031455) {
        [SVProgressHUD showInfoWithStatus:@"暂不支持微信支付"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    if (sender != self.pageThreeChoosePayTypeBtn) {
        self.pageThreeChoosePayTypeBtn.selected = NO;
        sender.selected = YES;
        self.pageThreeChoosePayTypeBtn = sender;
    }
}

- (void)pageThreeDone:(UIButton *)sender{
    if (self.pageThreeChoosePayTypeBtn == nil) {
        [SVProgressHUD showErrorWithStatus:@"请选择支付方式"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD dismissWithDelay:1.5f];
        
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(guideMainViewPageThreePayType:)]) {
        [self.delegate guideMainViewPageThreePayType:self.tag == 1711031455 ? GuideMainViewPayTypeWeChatPay:GuideMainViewPayTypeAliPay];
    }
    
}

#pragma mark - Method page Four
- (void)pageFourDoneBtnClick:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(guideMainViewPageFourAction:)]) {
        [self.delegate guideMainViewPageFourAction:GuideMainViewActionExperience];
    }
}

- (void)pageFourReCharge:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(guideMainViewPageFourAction:)]) {
        [self.delegate guideMainViewPageFourAction:GuideMainViewActionRecharge];
    }
}

- (void)setDeposit:(NSString *)deposit{
    _deposit = deposit;
    self.pageThreeLabel.text = deposit;
}

#pragma mark - textField
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.tf_pageTwoName) {
        ViewBorderRadius(self.pageTwo_viewName, 6, 1.2, RGBORANGE);
        ViewBorderRadius(self.pageTwo_viewIdCard, 6, 1.2, [UIColor lightGrayColor]);
    }else if (textField == self.tf_pageTwoIdCard){
        ViewBorderRadius(self.pageTwo_viewName, 6, 1.2, [UIColor lightGrayColor]);
        ViewBorderRadius(self.pageTwo_viewIdCard, 6, 1.2,RGBORANGE);
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.tf_pageTwoIdCard) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    return YES;
}

- (void)textFieldChangeValue:(UITextField *)textField{
    if (textField == self.tf_pageTwoIdCard) {
        if (textField.text.length > 18) {
            textField.text = [textField.text substringToIndex:18];
        }
    }
}


- (void)textFiledEditChanged:(id)notification{
    UITextRange *selectedRange = self.tf_pageTwoName.markedTextRange;
    UITextPosition *position = [self.tf_pageTwoName positionFromPosition:selectedRange.start offset:0];
    
    if (!position) {
        self.tf_pageTwoName.text = [self filterCharactor:self.tf_pageTwoName.text withRegex:@"[^\u4e00-\u9fa5]"];
        
        if (self.tf_pageTwoName.text.length >= 15) {
            self.tf_pageTwoName.text = [self.tf_pageTwoName.text substringToIndex:15];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.tf_pageTwoName) {
        [textField resignFirstResponder];
        
        textField.text = [self filterCharactor:textField.text withRegex:@"[^\u4e00-\u9fa5]"];
        
        if (textField.text.length > 15) {
            textField.text = [textField.text substringToIndex:15];
        }
        
        return NO;
    }else{
        
        return YES;
    }
}



- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr{
    NSString *searchText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}
@end
