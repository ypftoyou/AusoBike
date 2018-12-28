//
//  RefundListViewController.m
//  AusoBike
//
//  Created by Chang on 2017/11/23.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "RefundListViewController.h"
#import <MJRefresh.h>
#import "ChargeRecordCell.h"

@interface RefundListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UILabel        *topLine;
@property (nonatomic,strong) UITableView    *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr1;
@property (nonatomic,strong) NSMutableArray *dataArr2;
@property (nonatomic,assign) NSInteger      page_1;
@property (nonatomic,assign) NSInteger      page_2;
@property (nonatomic,assign) NSInteger      select_will;
@property (nonatomic,strong) UIButton       *selectBtn;

@end

@implementation RefundListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataArr1 = [NSMutableArray array];
    self.dataArr2 = [NSMutableArray array];
    _page_1 = 1;
    _page_2 = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    _select_will = 0;
    self.title = @"押金退款记录";
    [self configViews];
    
    [self getInfoWithPage:self.page_1];
    
}
- (void)configViews{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    self.tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(50);
    }];
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (self.select_will == 0) {
            self.dataArr1 = [NSMutableArray array];
            self.page_1 = 1;
            [self getInfoWithPage:self.page_1];
        }else{
            self.dataArr2 = [NSMutableArray array];
            self.page_2 = 1;
            [self getInfoWithPage:self.page_2];
        }
    
    }];
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (self.select_will == 0) {
            self.page_1 ++;
            [self getInfoWithPage:self.page_1];
        }else{
            self.page_2 ++;
            [self getInfoWithPage:self.page_2];
        }
    }];
    
    
    [self.view layoutIfNeeded];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    NSArray *arr = @[@"退款申请中",@"申请已通过"];
    for (int i = 0; i < 2; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [topView addSubview:btn];
//        btn.backgroundColor= RANDOW_COLOR;
        btn.frame = CGRectMake(i * (KScreenWidth / 2), 0, KScreenWidth / 2, 50);
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:RGBORANGE forState:UIControlStateSelected];
//        btn.userInteractionEnabled = YES;
        [btn addTarget:self action:@selector(clickTopViews:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.titleLabel.font = [UIFont AvenirWithFontSize:16];
        
        if (i == 0) {
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(40, 48, KScreenWidth / 2 - 80, 2)];
            line.backgroundColor = RGBORANGE;
            [topView addSubview:line];
            self.topLine = line;
            btn.selected = YES;
            self.selectBtn = btn;

        }else{
            UILabel *line = [[UILabel alloc]initWithFrame: CGRectMake(btn.left, 8, 1, 50 - 16)];
            line.backgroundColor = [UIColor grayColor];
            [topView addSubview:line];
        }
    }
    
    
    ViewShadow(topView, [UIColor grayColor], CGSizeMake(0, 3), 3, 0.4);

}

#pragma mark -
#pragma mark - tableView 代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.select_will == 0) {
        return self.dataArr1.count;
    }else{
        return self.dataArr2.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"RefundListViewCell";
    ChargeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[ChargeRecordCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    cell.types = @"1";
    
    if (self.select_will == 0) {
        NSDictionary *dict = self.dataArr1[indexPath.row];
        cell.infoDict = dict;
    }else{
        NSDictionary *dict = self.dataArr2[indexPath.row];
        cell.infoDict = dict;
    }
    return cell;
}

- (void)getInfoWithPage:(NSInteger)page{

    //退款中 status = 43 type = 4
    //已退款 status = 44 type = 4
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"4" forKey:@"type"];
    NSString *status;
    if (self.select_will == 0) {
        //退款中
        status = @"43";
    }else{
        status = @"44";
    }

    [param setValue:status forKey:@"status"];
    [param setValue:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    
    NSLog(@"%@",param);
    [Tool Get:API_RouteList param:param header:[Tool AusoNetHeader] isHUD:YES result:^(BOOL status, NSDictionary *result) {
        if (self.select_will == 0) {
            if (self.page_1 == 1) {
                [self.tableView.mj_header endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }else{
            if (self.page_2 == 1) {
                [self.tableView.mj_header endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }
        
        if (status) {
            if ([self resultVerify:result]) {
                //获取退款成功
                NSDictionary *dict = [result objectForKey:@"data"];
                NSArray *infoArr = [dict valueForKey:@"data"];
                
                if (infoArr.count > 0 ) {

                    for (NSDictionary *infoDic in infoArr) {
                        if (self.select_will == 0) {
                            [self.dataArr1 addObject:infoDic];
                        }else{
                            [self.dataArr2 addObject:infoDic];
                        }
                    }
                    self.tableView.tableFooterView = [UIView new];
                    [self.tableView reloadData];
                }else{
                    [self showFootView];
                }
            }else{
                [self showFootView];
            }
        }else{
            [self showFootView];
        }
        
        [self.tableView reloadData];

    }];
}

- (void)clickTopViews:(UIButton *)sender{
    if (sender != self.selectBtn) {
        self.tableView.tableFooterView = [UIView new];
        self.selectBtn.selected = NO;
        sender.selected = YES;
        self.selectBtn = sender;
        
        if ([sender.titleLabel.text isEqualToString:@"退款申请中"]) {
            
//            if (self.dataArr1.count < 1) {
//                UILabel *labe = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenWidth)];
//                labe.font = [UIFont AvenirWithFontSize:18];
//                labe.text = @"您还没有退款中的数据哦！";
//                labe.textAlignment = NSTextAlignmentCenter;
//
//                self.tableView.tableFooterView = labe;
//            }
            self.select_will = 0;
            [UIView animateWithDuration:0.3 animations:^{
                self.topLine.center = CGPointMake(KScreenWidth / 4, self.topLine.center.y);
            }];
            
            self.dataArr1 = [NSMutableArray array];
            self.page_1 = 1;
            [self getInfoWithPage:self.page_1];
        }else{
            
//            if (self.dataArr2.count < 1) {
//                UILabel *labe = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenWidth)];
//                labe.font = [UIFont AvenirWithFontSize:18];
//                labe.text = @"您还没有申请通过的数据哦！";
//                labe.textAlignment = NSTextAlignmentCenter;
//
//                self.tableView.tableFooterView = labe;
//            }
            
            self.select_will = 1;
            [UIView animateWithDuration:0.3 animations:^{
                self.topLine.center = CGPointMake(KScreenWidth / 4 * 3, self.topLine.center.y);
            }];
            
            self.dataArr2 = [NSMutableArray array];
            self.page_2 = 1;
            [self getInfoWithPage:self.page_2];
//            static dispatch_once_t onceToken;
//            dispatch_once(&onceToken, ^{
//                [self.tableView.mj_header beginRefreshing];
//                [self getInfoWithPage:self.page_2];
//            });
        }
    }
}

- (void)showFootView{
    UILabel *labe = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenWidth)];
        labe.font = [UIFont AvenirWithFontSize:18];
        labe.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableFooterView = labe;
    if (self.select_will == 0) {
        if (self.page_1 > 1) {
            self.page_1 --;
        }else{
            if (self.page_1 == 1) {
                    labe.text = @"您还没有退款中的数据哦！";
            }else{
                    labe.text = @"没有更多数据...";
            }
        }
    }else{
        if (self.page_2 > 1) {
            self.page_2 --;
        }else{
            if (self.page_2 == 1) {
                labe.text = @"您还没有申请通过的数据哦！";
            }else{
                labe.text = @"没有更多数据...";
            }
        }
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
