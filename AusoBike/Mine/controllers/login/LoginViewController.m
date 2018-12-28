//
//  LoginViewController.m
//  AusoBike
//
//  Created by Chang on 2017/11/2.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "BaseNavigationController.h"
#import "GuideViewController.h"
#import "ArchiveUtil.h"
#import "AusoUser.h"
#import <MJExtension.h>
#import "UITextField+AusoBackSpace.h"

@interface LoginViewController ()<UITextFieldDelegate,AusoBackSpaceTextFieldDelegate>

@property (nonatomic,strong) UITextField    *tf_account;
@property (nonatomic,strong) UITextField    *tf_password;
@property (nonatomic,strong) UIButton       *loginBtn;
@property (nonatomic,strong) UIButton       *sendCode;
@property (nonatomic,copy  ) NSString       *SMSCODE;


@property (nonatomic,strong) NSMutableArray *textFieldArray;
@property (nonatomic,strong) UIButton       *responseInputBtn;
@property (nonatomic,assign) NSInteger      second;
@property (nonatomic,strong) NSTimer        *secondDownTime;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.SMSCODE = @"";
    self.second = 60;
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNewViews];
    
    UITapGestureRecognizer *singTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBory)];
    [self.view addGestureRecognizer:singTap];
}

- (void)hideKeyBory{
    [self.view endEditing:YES];
}
- (void)configNewViews{
    UIImageView *iconImgView = [[UIImageView alloc]init];
    [iconImgView setImage:[UIImage imageNamed:@"ico_login_logo"]];
    [self.view addSubview:iconImgView];
    
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (iphone5s || iphone4s) {
            make.top.mas_equalTo(50);
        }else{
            make.top.mas_equalTo(60);
        }
        make.centerX.mas_equalTo(self.view);
    }];
    
    //第一条线
    UILabel *line_one = [[UILabel alloc]init];
    [self.view addSubview:line_one];
    
    line_one.backgroundColor = [UIColor lightGrayColor];
    [line_one mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        if (iphone5s || iphone4s) {
            make.top.mas_equalTo(iconImgView.mas_bottom).offset(46);
        }else if(iphone4s){
            make.top.mas_equalTo(iconImgView.mas_bottom).offset(42);
        }else{
            make.top.mas_equalTo(iconImgView.mas_bottom).offset(76);
        }
        make.height.mas_equalTo(1);
    }];
    
    UIImageView *userIcon = [[UIImageView alloc]init];
    [self.view addSubview:userIcon];
    
//    userIcon.backgroundColor = RANDOW_COLOR;
    userIcon.image = IMAGE_NAMED(@"ico_user");
    [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(line_one.mas_top).offset(-6);
        make.left.mas_equalTo(line_one);
        make.width.height.mas_equalTo(24);
    }];
    
    UIButton *sendCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:sendCodeBtn];
    
//    sendCodeBtn.backgroundColor = RANDOW_COLOR;
    [sendCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    sendCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    sendCodeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [sendCodeBtn addTarget:self action:@selector(senderCode:) forControlEvents:UIControlEventTouchUpInside];
    [sendCodeBtn setTitleColor:RGBACOLOR(21, 152, 246, 1) forState:UIControlStateNormal];
    [sendCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    self.sendCode = sendCodeBtn;
    [sendCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(line_one.mas_right);
//        make.width.mas_equalTo(90);
        make.centerY.mas_equalTo(userIcon.mas_centerY);
        
    }];
    
    [self.view layoutIfNeeded];
    UITextField *tf_account = [[UITextField alloc]init];
    [self.view addSubview:tf_account];

    tf_account.placeholder = @"请输入账号";
    tf_account.font = [UIFont AvenirWithFontSize:17];
    tf_account.keyboardType = UIKeyboardTypeNumberPad;
    tf_account.delegate = self;
    tf_account.tag = 1711171435;
    [tf_account addTarget:self action:@selector(textFierldAccountChange:) forControlEvents:UIControlEventEditingChanged];

    [tf_account mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userIcon.mas_right).offset(6);
        make.right.mas_equalTo(sendCodeBtn.mas_left).offset(-8);
        make.centerY.mas_equalTo(userIcon.mas_centerY);
    }];
    
    [tf_account becomeFirstResponder];
    self.tf_account = tf_account;

    [self.view layoutIfNeeded];
    
    CGFloat magin = 10;
    CGFloat Y = line_one.bottom + 70;
    CGFloat width = (KScreenWidth - line_one.left * 2 - magin * 3) / 4;
    
    CGFloat H = 38;
    

    UIButton *hold_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    hold_btn.frame = CGRectMake(line_one.left,Y - H - 6, line_one.width, H);
    [self.view addSubview:hold_btn];
    hold_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [hold_btn setTitle:@"请输入短信验证码" forState:UIControlStateNormal];
    hold_btn.titleLabel.font = [UIFont HeitiSCWithFontSize:18];
    [hold_btn addTarget:self action:@selector(holdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [hold_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.responseInputBtn = hold_btn;
    
    self.textFieldArray = [NSMutableArray array];
    for (int i = 0; i < 4 ; i ++ ) {
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(line_one.left + i * (width + magin), Y, width, 1)];
        [self.view addSubview:line];
        
        line.backgroundColor = [UIColor lightGrayColor];
        
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(line.left, line.bottom - H - 6, line.width, H)];
        textField.textAlignment = NSTextAlignmentCenter;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        textField.userInteractionEnabled = NO;
        textField.font = [UIFont HelveticaNeueBoldFontSize:20];
        textField.tintColor = RGBORANGE;
        textField.delegate = self;
        [self.view addSubview:textField];
        textField.tag = 1711161809 + i;
        [self.textFieldArray addObject:textField];
    }
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:loginBtn];
    
    [loginBtn setBackgroundImage:IMAGE_NAMED(@"btn_login_nor") forState:UIControlStateDisabled];
    [loginBtn setBackgroundImage:IMAGE_NAMED(@"btn_login_press") forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font = [UIFont HelveticaNeueBoldFontSize:17];
    self.loginBtn = loginBtn;
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Y + 32);
        
        if (iphone5s) {
            make.top.mas_equalTo(Y + 20);

        }
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [self.view layoutIfNeeded];
    
    self.loginBtn.enabled = NO;
    self.sendCode.enabled = NO;
}

#pragma mark -
#pragma mark - 获取验证码
- (void)senderCode:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    if (self.tf_account.text.length != 11) {
        [self showInfo:@"请输入完整的手机号"];
        sender.userInteractionEnabled = YES;
        return;
    }
    
    if (![Tool IsPhoneNum:self.tf_account.text]) {
        [self showError:@"手机号格式不正确！"];
        sender.userInteractionEnabled = YES;
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.tf_account.text forKey:@"mobile"];
    [param setValue:@"1" forKey:@"status"];
    NSString *phoneMode = [[UIDevice currentDevice] systemName];
    NSString *phoneType = [Tool deviceVersion];
    NSString *phoneVersion =[[UIDevice currentDevice] systemVersion];
    
    NSString *model = [NSString stringWithFormat:@"%@-%@-%@",phoneMode,phoneType,phoneVersion];
    
    [param setValue:model forKey:@"model"];
    [Tool Get:API_Send_Code param:param header:nil isHUD:YES result:^(BOOL status, NSDictionary *result) {
        if (status) {
            if ([self resultVerify:result]) {
                [self showSuccess:[self resultInfo:result]];
                self.second = 60;
                self.secondDownTime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(trunDonwForWait) userInfo:nil repeats:YES];
                [[NSRunLoop mainRunLoop]addTimer:self.secondDownTime forMode:NSRunLoopCommonModes];
                [self.sendCode setTitle:[NSString stringWithFormat:@"%ld秒后重新获取",(long)self.second] forState:UIControlStateNormal];

                
                [self.tf_account resignFirstResponder];
                self.responseInputBtn.hidden = YES;
                
                self.SMSCODE = @"";
                for (UITextField*textField in self.textFieldArray) {
                    textField.text = @"";
                    textField.userInteractionEnabled = NO;
                }
                UITextField *textField = [self.textFieldArray firstObject];
                textField.userInteractionEnabled = YES;
                [textField becomeFirstResponder];

                
            }else{
                [self showInfo:[self resultInfo:result]];
                sender.userInteractionEnabled = YES;
            }
        }else{
            sender.userInteractionEnabled = YES;

        }
    }];
    
}

- (void)holdBtnClick:(UIButton *)sender{
    
    if (self.tf_account.text.length != 11) {
        [self showInfo:@"请输入手机号"];
        return;
    }
    if (![Tool IsPhoneNum:self.tf_account.text]) {
        [self showInfo:@"请输入正确的手机号"];
        return;
    }
    
    [self.tf_account resignFirstResponder];
    self.responseInputBtn.hidden = YES;
    [self resetTextFieldFirstResponderIndex:0];
}

#pragma mark - 重置验证码框
- (void)resetTextFieldFirstResponderIndex:(NSInteger)index{
    for (int i = 0; i < self.textFieldArray.count; i ++) {
        UITextField *textField = self.textFieldArray[i];
        if (i == index) {
            textField.userInteractionEnabled = YES;
            [textField becomeFirstResponder];
        }else{
            textField.userInteractionEnabled = NO;
        }
    }
}

#pragma mark - 登录 - 短信
- (void)loginAction:(UIButton *)sender{
    NSLog(@"%@",self.SMSCODE);
    sender.userInteractionEnabled = NO;
    if (self.tf_account.text.length < 1) {
        [self showInfo:@"请输入手机号"];
        sender.userInteractionEnabled = YES;

        return;
    }
    
    if (![Tool IsPhoneNum:self.tf_account.text]) {
        [self showError:@"手机号格式不正确！"];
        sender.userInteractionEnabled = YES;

        return;
    }
    
    if (self.SMSCODE.length != 4) {
        [self showInfo:@"请输入验证码"];
        sender.userInteractionEnabled = YES;

        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.tf_account.text forKey:@"mobile"];
    [param setValue:self.SMSCODE forKey:@"code"];

    [Tool Get:API_Login_Code param:param header:nil isHUD:YES result:^(BOOL status, NSDictionary *result) {
        if (status) {
            if ([self resultVerify:result]) {
                AusoUser *user = [AusoUser mj_objectWithKeyValues:[result objectForKey:@"data"]];
                user.mobile = self.tf_account.text;
                [ArchiveUtil saveUser:user];
                [UserDefault setBool:YES forKey:KUserLogin];
                [self getUserInfo];
            }else{
                [self showError:[self resultInfo:result]];
                self.loginBtn.userInteractionEnabled = YES;

            }
        }else{
            self.loginBtn.userInteractionEnabled = YES;
        }
    }];
    
}

#pragma mark - 拉取个人信息
- (void)getUserInfo{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"1" forKey:@"type"];
    
    [Tool Get:API_User_Info param:param header:[Tool AusoNetHeader] isHUD:YES result:^(BOOL status, NSDictionary *result) {
        if (status) {
            if ([self resultVerify:result]) {
                NSLog(@"登录页面 拉取个人信息成功");
                AusoUser *temp = [ArchiveUtil getUser];
                //从后台拿到 用户信息
                AusoUser *user = [AusoUser mj_objectWithKeyValues:[result objectForKey:@"data"]];
                user.token = temp.token;
                user.user_id = temp.user_id;
                //归档
                [ArchiveUtil saveUser:user];
            }
            
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            BaseNavigationController *navi = [[BaseNavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init]];
            window.rootViewController = navi;
        }else{
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            BaseNavigationController *navi = [[BaseNavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init]];
            window.rootViewController = navi;
        }
    }];
}

#pragma mark - 登录 - 密码
- (void)loginActionWidhPasswrod:(UIButton *)sender{
    
//    NSLog(@"%@",self.SMSCODE);
//
//    if (self.tf_account.text.length < 1) {
//        [self showInfo:@"请输入账号"];
//        return;
//    }
//
//    if (self.tf_password.text.length <6) {
//        [self showInfo:@"密码最短为6位"];
//        return;
//    }
//
//    if (self.tf_password.text.length > 16) {
//        [self showInfo:@"密码最长为16位"];
//        return;
//    }
//
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"15210713101" forKey:@"mobile"];
    [param setObject:@"123456" forKey:@"password"];
        
    [Tool Post:API_Login_Account param:param isHud:YES result:^(BOOL status, NSDictionary *result) {
        if (status) {
            NSLog(@"%@",result);
            [SVProgressHUD showSuccessWithStatus:[self resultInfo:result]];

            AusoUser *user = [AusoUser mj_objectWithKeyValues:[result objectForKey:@"data"]];
            user.mobile = self.tf_account.text;
            [ArchiveUtil saveUser:user];
            [UserDefault setBool:YES forKey:KUserLogin];
            if ([self resultVerify:result]) {
//                [SVProgressHUD dismissWithDelay:1.5 completion:^{
//                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//                    BaseNavigationController *navi = [[BaseNavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init]];
//                    window.rootViewController = navi;
//                }];
                [self getUserInfo];
            }
        }
    }];
}




#pragma mark - textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.tf_account) {
        return YES;
    }else{
        
    if ([string isEqualToString:@""]) {
        return YES;
    }else{
        if (textField.text.length < 1) {
            return YES;
        }else{
            //上次退格 响应下一个
            
            NSInteger index = textField.tag - 1711161809;
            if (index != 3) {
                UITextField *nextTextField = self.textFieldArray[index + 1];
                nextTextField.text = string;
                [textField resignFirstResponder];
                textField.userInteractionEnabled = NO;
                nextTextField.userInteractionEnabled = YES;
                [nextTextField becomeFirstResponder];
                self.SMSCODE = [NSString stringWithFormat:@"%@%@",self.SMSCODE,string];
                
            }
            
            if (index + 1 == 3 ) {
                self.loginBtn.enabled = YES;
            }
            
            return NO;
        }
    }
    }
}
- (void)textFieldDidDeleteBackSpace:(UITextField *)textField{
    
    if (textField != self.tf_account) {
        
    NSInteger index = textField.tag - 1711161809;

    if (textField.text.length == 0) {
        //退格
        if (index != 0) {
//            [self.SMSCODE setValue:[self.SMSCODE substringToIndex:index] forKeyPath:@"smscode"];
            self.SMSCODE = [self.SMSCODE substringToIndex:index];

            [self resetTextFieldFirstResponderIndex:index - 1];
        }else{
//            [self.SMSCODE setValue:@"" forKeyPath:@"smscode"];
            self.SMSCODE = @"";
        }
    }
    
    self.loginBtn.enabled = NO;
    }

}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.tf_account) {
        NSLog(@"开始输入账号啦");
        if (self.SMSCODE.length >= 1) {
            self.responseInputBtn.hidden = YES;
        }else{
            self.responseInputBtn.hidden = NO;
        }
    }else{
        //判断下手机号是否正确
        if (![Tool IsPhoneNum:self.tf_account.text]) {
            [self showInfo:@"您的手机号格式不正确哎~\n ~\(≧▽≦)/~啦啦啦"];
        }
        self.responseInputBtn.hidden = YES;
    }
}


- (void)textFieldChange:(UITextField *)textField{
    NSInteger index = textField.tag - 1711161809;
    if (textField.text.length > 0) {
//        [self.SMSCODE setValue:[NSString stringWithFormat:@"%@%@",self.SMSCODE,textField.text] forKeyPath:@"smscode"];
        self.SMSCODE = [NSString stringWithFormat:@"%@%@",self.SMSCODE,textField.text];
        if (index != 3) {
            [textField resignFirstResponder];
            [self resetTextFieldFirstResponderIndex:index + 1];
        }else{
            self.loginBtn.enabled = YES;
        }
    }
}

#pragma mark - 账号改变
- (void)textFierldAccountChange:(UITextField *)textField{
    if (textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }
    
    if (textField.text.length == 11) {
        self.sendCode.enabled = YES;
    }else{
        self.sendCode.enabled = NO;
    }
}

#pragma mark - 倒计时
- (void)trunDonwForWait{
    self.second --;
    if (self.second >= 1) {
        [self.sendCode setTitle:[NSString stringWithFormat:@"%ld秒后重新获取",(long)self.second] forState:UIControlStateNormal];
    }else{
        [self.secondDownTime invalidate];
        self.secondDownTime = nil;
        
        [self.sendCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.sendCode.userInteractionEnabled = YES;
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.view endEditing:YES];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"");
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
