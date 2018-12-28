//
//  SettingRootViewController.m
//  AusoBike
//
//  Created by Chang on 2017/11/13.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "SettingRootViewController.h"
#import "AboutMeViewController.h"
#import "AgreementViewController.h"
#import "AusoUser.h"
#import "ArchiveUtil.h"

@interface SettingRootViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *dataArr;
@end

@implementation SettingRootViewController

- (NSArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = @[@[@"用户协议",@"使用协议",@"隐私协议"],@[@"关于我们"],@[@"版本号"]];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    [self configViews];
}

- (void)configViews{
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    
    
    
    UIButton *baseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:baseBtn];
    [baseBtn setImage:IMAGE_NAMED(@"btn_normol_blue") forState:UIControlStateNormal];
    baseBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;

    [baseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        if (iphone5s ) {
            make.left.mas_equalTo(20);
            make.bottom.mas_equalTo(self.view).mas_offset(-49);

        }else if (iphone4s){
            make.left.mas_equalTo(20);
            make.bottom.mas_equalTo(self.view).mas_offset(-29);

        }else{
            make.bottom.mas_equalTo(self.view).mas_offset(-49);

        }
    }];
    
    ViewShadow(baseBtn, RGBORANGE, CGSizeMake(0, 3), 3.f, 0.5);

    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:customBtn];
    
    [customBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [customBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    customBtn.titleLabel.font = [UIFont HelveticaNeueFontSize:17];
    if (iphone5s || iphone4s) {
        customBtn.titleLabel.font = [UIFont HelveticaNeueFontSize:16];
    }
    [customBtn  addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [customBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(baseBtn);
        make.height.width.mas_equalTo(baseBtn);
    }];
    
    
//    UIButton *chargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:chargeBtn];
    
//    chargeBtn.titleLabel.font = [UIFont HelveticaNeueFontSize:17];
////    [chargeBtn setBackgroundImage:[UIImage imageNamed:@"btn_normol_blue"] forState:UIControlStateNormal];
////    [chargeBtn setImage:IMAGE_NAMED(@"btn_normol_blue") forState:UIControlStateNormal];
//    [chargeBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
//    [chargeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////    chargeBtn.contentMode = UIViewContentModeScaleAspectFill;
//    [chargeBtn setTitle:@"退出登录" forState:UIControlStateNormal];
//
//    chargeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//
//
//    [chargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//
//    }];
//    [self.view layoutIfNeeded];

//    [chargeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 100)];
// chargeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//
//    [self setButtonContentCenter:chargeBtn];

}

-(void)setButtonContentCenter:(UIButton *) btn{
    
    CGSize imgViewSize,titleSize,btnSize;
//
//    UIEdgeInsets imageViewEdge,titleEdge;
//
//    CGFloat heightSpace = 10.0f;
//
//    //设置按钮内边距
//
//    imgViewSize = btn.imageView.bounds.size;
//
    titleSize = btn.titleLabel.bounds.size;
//
//    btnSize = btn.bounds.size;
//
//
//
//    imageViewEdge = UIEdgeInsetsMake(heightSpace,0.0, btnSize.height -imgViewSize.height - heightSpace, - titleSize.width);
//
//    [btn setImageEdgeInsets:imageViewEdge];
    
//    titleEdge = UIEdgeInsetsMake(imgViewSize.height +heightSpace, - imgViewSize.width, 0.0, 0.0);
    
//    [btn setTitleEdgeInsets:titleEdge];   top left bottom right
//    [btn setTitleEdgeInsets:UIEdgeInsetsMake((btn.height - titleSize.height) / 2, (btn.width - titleSize.width) / 2, 0, 0)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    
}

- (void)logout:(UIButton *)sender{
    
    AusoUser *user = [[AusoUser alloc]init];
    [ArchiveUtil saveUser:user];
    
    [UserDefault removeObjectForKey:KUserLogin];
    [UserDefault removeObjectForKey:KUser_Load_Guide];
    [[NSNotificationCenter defaultCenter]postNotificationName:KUser_Notification_login object:nil];
}

#pragma mark -
#pragma mark - tableView 代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArr[section]count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"settingRootTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataArr[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont AvenirWithFontSize:15];
    cell.textLabel.textColor = RGB100;
    
    if (indexPath.section == 2) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // 当前应用软件版本  比如：1.0.1
        NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSLog(@"当前应用软件版本:%@",appCurVersion);
        // 当前应用版本号码   int类型
        NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
        NSLog(@"当前应用版本号码：%@",appCurVersionNum);
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",appCurVersion];
    }
    
    if (indexPath.section != 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        AgreementViewController *agreementVC = [[AgreementViewController alloc]init];
        if (indexPath.row == 0) {
            agreementVC.type = @"0";
        }else if (indexPath.row == 1){
            agreementVC.type = @"1";
        }else if (indexPath.row == 2){
            agreementVC.type = @"2";
        }
        
        [self.navigationController pushViewController:agreementVC animated:YES];
    }
    
    
    if (indexPath.section == 1) {
        [self.navigationController pushViewController:[[AboutMeViewController alloc]init] animated:YES];
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
