//
//  AboutMeViewController.m
//  AusoBike
//
//  Created by Chang on 2017/11/14.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "AboutMeViewController.h"

@interface AboutMeViewController ()

@end

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.view.backgroundColor = RGB241;
    [self configViews];
}
- (void)configViews{
    
    UIView *layerView = [[UIView alloc]init];
    [self.view addSubview:layerView];
    
    layerView.backgroundColor = [UIColor whiteColor];
    [layerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(self.view.mas_width).multipliedBy(0.7);
    }];


    UIImageView *icon = [[UIImageView alloc]init];
    [self.view addSubview:icon];

    icon.image = [UIImage imageNamed:@"ico_aboutus_logo"];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(32);
    }];

    UILabel *label = [[UILabel alloc]init];
    [self.view addSubview:label];
    
    label.text = @"营口骜松单车科技有限公司，简称骜松科技，成立于2017年9月，位于辽宁省营口市，是国家重点支持的高新技术企业，经营范围在互联网领域";
    label.numberOfLines = 0;
    label.font = [UIFont HeitiSCWithFontSize:15];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(icon.mas_bottom).offset(32);
    }];
    
    UILabel *copyright = [[UILabel alloc]init];
    [self.view addSubview:copyright];
    
    copyright.text = @"Copyright @营口骜松单车科技有限公司";
    copyright.font = [UIFont AvenirLightWithFontSize:13];
    
    [copyright mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        
    }];
    
    [self.view layoutIfNeeded];
    
    layerView.layer.shadowColor = [UIColor blackColor].CGColor;
    layerView.layer.shadowOffset = CGSizeMake(0, 3);
    layerView.layer.shadowRadius = 4;
    layerView.layer.shadowOpacity = 0.3;
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
