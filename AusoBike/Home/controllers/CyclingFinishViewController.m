//
//  CyclingFinishViewController.m
//  AusoBike
//
//  Created by Chang on 2017/11/22.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "CyclingFinishViewController.h"
#import "HomeViewController.h"

@interface CyclingFinishViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *titleArr;
@property (nonatomic,strong)NSArray *detailArr;
@end

@implementation CyclingFinishViewController
- (NSArray *)titleArr{
    if (_titleArr == nil) {
        _titleArr = @[@[@"骑行时长",@"行程消费"]];
    }
    return _titleArr;
}

- (NSArray *)detailArr{
    if (_detailArr == nil) {
        
        //分钟转小时
        NSInteger time = [[self.dict valueForKey:@"time"]integerValue];
        NSString *str = @"";
        if (time < 60) {
            str = [NSString stringWithFormat:@"%ld 分钟",time];
        }else{
            NSInteger m = time % 60;
            NSInteger h = time / 60;
            
            str = [NSString stringWithFormat:@"%ld小时 %ld分钟",h,m];
            
        }
        _detailArr = @[@[[NSString stringWithFormat:@"%@ 分",[self.dict valueForKey:@"time"]],[NSString stringWithFormat:@"%@ 元",[self.dict valueForKey:@"price"]]]];
    }
    return _detailArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self createNaviItemType:NaviItemTypeLeftButton NaviOperType:NaviOperTypeImage NameString:@"navi_btn_cancel"];
    self.title = @"行程结束";
    [self configViews];
}

- (void)configViews{
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [self footView];
    tableView.tableHeaderView = [self headerView];
}

- (UIView *)headerView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenWidth * 0.7)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = IMAGE_NAMED(@"ico_congratulation");
    [view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        make.centerY.mas_equalTo(view.mas_centerY).offset(-30);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    [view addSubview:label];
    
    label.text = @"恭喜，您已成功支付10元";
    label.text = [NSString stringWithFormat:@"恭喜，您已成功支付%@元",[self.dict valueForKey:@"price"]];
    label.textColor = RGB100;
    label.font = [UIFont HelveticaNeueFontSize:20];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom);
        make.centerX.mas_equalTo(0);
    }];
    
    return view;
}

- (UIView *)footView{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 6, KScreenWidth, 20)];
    label.text = @"● 计费标准：按时长计费，每30分钟消费1元";
    label.font = [UIFont HelveticaNeueFontSize:12];
    label.textColor = [UIColor grayColor];
    
    return label;
}

#pragma mark -
#pragma mark - tableView 代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.titleArr[section]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"CyclingFinishCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    
    cell.textLabel.text = self.titleArr[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont AvenirWithFontSize:16];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = RGBACOLOR(50, 50, 50, 1);
    if (indexPath.row == 0) {
//        cell.detailTextLabel.text = @"（4月5日13:10 至 4月6日12:10）";
//        cell.detailTextLabel.font = [UIFont AvenirWithFontSize:12];
//        cell.detailTextLabel.textColor = RGB100;
    }
    
    
    UILabel *subLab = [[UILabel alloc]init];
    subLab.text = self.detailArr[indexPath.section][indexPath.row];
    subLab.font = [UIFont AvenirWithFontSize:16];
    subLab.textAlignment = NSTextAlignmentRight;
    
    [cell.contentView addSubview:subLab];
    [subLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(cell.mas_right).offset(-12);
        make.centerY.mas_equalTo(cell.mas_centerY);
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (void)navigationLeftBtnClick:(UIButton *)sender{
    self.closeBlock();
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
