//
//  ChangeNameViewController.m
//  AusoBike
//
//  Created by Chang on 2017/11/16.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "ChangeNameViewController.h"
#import "AusoUser.h"
#import "ArchiveUtil.h"

@interface ChangeNameViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *textField;
@end

@implementation ChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改昵称";
    [self createNaviItemType:NaviItemTypeRightButton NaviOperType:NaviOperTypeTitle NameString:@"保存"];
    self.view.backgroundColor = RGB241;
    [self configViews];
}

- (void)configViews{
    UIView *bgView = [[UIView alloc]init];
    [self.view addSubview:bgView];
    
    bgView.backgroundColor = [UIColor whiteColor];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.right.mas_equalTo(-14);
        make.top.mas_equalTo(16);
        make.height.mas_equalTo(50);
    }];
    
    UITextField *textField = [[UITextField alloc]init];
    [self.view addSubview:textField];
    
    self.textField = textField;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.placeholder = @"请输入您的新昵称";
    textField.font = [UIFont HeitiSCWithFontSize:16];
    textField.delegate = self;
    [textField addTarget:self action:@selector(textViewDidChange:) forControlEvents:UIControlEventEditingChanged];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView).offset(10);
        make.right.mas_equalTo(bgView).offset(-10);
        make.centerY.mas_equalTo(bgView.mas_centerY);
    }];
    
    
    [self.view layoutIfNeeded];
    
    ViewBorderRadius(bgView, 4, 0.2, [UIColor lightGrayColor]);
    
    UILabel *msgLab = [[UILabel alloc]init];
    [self.view addSubview:msgLab];
    
    msgLab.text = @"4-12字符，仅支持中文，英文大小写，数字、“_”、减号及其组合";
    msgLab.textColor = [UIColor lightGrayColor];
    msgLab.font = [UIFont HeitiSCWithFontSize:14];
    msgLab.numberOfLines = 0;
    [msgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(bgView);
        make.top.mas_equalTo(bgView.mas_bottom).offset(15);
    }];
}

#pragma mark 限制提交字数
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger number = [textView.text length];
    if (number > 12) {
        textView.text = [textView.text substringToIndex:16];
    }
}

- (void)navigationRightBtnClick:(UIButton *)sende{
    if (self.textField.text.length < 1 || self.textField.text.length > 12) {
        [self showError:@"格式错误"];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"3" forKey:@"type"];

    [param setObject:self.textField.text forKey:@"nickname"];
    
    NSMutableDictionary *header = [NSMutableDictionary dictionary];
    [header setObject:[Tool GetUserOption:AusoUserOptionToken] forKey:@"token"];
    [header setObject:[Tool GetUserOption:AusoUserOptionUserId] forKey:@"userid"];
    
    [Tool Post:API_User_Info param:param header:header isHUD:YES result:^(BOOL status, NSDictionary *result) {
        if (status) {
            [self showInfo:[self resultInfo:result]];
            if ([self resultVerify:result]) {
                
                AusoUser *user = [ArchiveUtil getUser];
                user.nickname = self.textField.text;
                [ArchiveUtil saveUser:user];
                self.nickName();

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    return YES;
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
