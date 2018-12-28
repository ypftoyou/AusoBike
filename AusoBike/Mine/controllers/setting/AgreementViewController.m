//
//  AgreementViewController.m
//  AusoBike
//
//  Created by Chang on 2017/11/18.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()
@property (nonatomic,strong)UIWebView *webView;
@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configViews];
}

- (void)configViews{
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.width,self.view.height)];
    self.webView.backgroundColor=[UIColor lightGrayColor];
    [self.view  addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).with.offset(0);
        make.top.mas_equalTo(self.view.mas_top);
    }];
    //    //设置网页的地址  直接的网络请求
    NSString *fileName = @"";
    if ([self.type isEqualToString:@"0"]) {
        fileName = @"用户协议";
    }else if ([self.type isEqualToString:@"1"])
    {
        fileName = @"使用协议";
    }
    else if ([self.type isEqualToString:@"2"])
    {
        fileName = @"隐私协议";
    }else if ([self.type isEqualToString:@"3"])
    {
        fileName = @"服务条款和隐私政策";
    }
    self.title = fileName;
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:fileName
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [self.webView loadHTMLString:htmlCont baseURL:baseURL];
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
