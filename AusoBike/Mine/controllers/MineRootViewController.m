//
//  MineRootViewController.m
//  AusoBike
//
//  Created by Chang on 2017/11/13.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "MineRootViewController.h"
#import "ChangeNameViewController.h"
#import "AusoUser.h"
#import "ArchiveUtil.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>
#import "GuideViewController.h"
#import "BaseNavigationController.h"

typedef void (^PFResponseFail)(NSURLSessionDataTask * task, NSError * error);

@interface MineRootViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *dataArr;
@property (nonatomic,strong)NSMutableArray *detaliArr;
@property (nonatomic,strong)UIImageView *iconImageView;
@end

@implementation MineRootViewController

- (NSArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = @[@[@"头像",@"用户名",@"性别"],@[@"我的认证",@"手机号"]];
    }
    return _dataArr;
}

- (NSMutableArray *)detaliArr{
    if (_detaliArr == nil) {
//        NSString *sex = [[Tool GetUserOption:AusoUserOptionSex] isEqualToString:@"0"] ? @"未知" : [Tool GetUserOption:AusoUserOptionSex];
        NSString *sex = @"未知";
        if ([[Tool GetUserOption:AusoUserOptionSex] isEqualToString:@"1"]) {
            sex = @"男";
        }else if ([[Tool GetUserOption:AusoUserOptionSex]isEqualToString:@"2"]){
            sex = @"女";
        }

        NSArray *arr = @[@[@"",[Tool GetUserOption:AusoUserOptionNickName],sex],@[[Tool IsCertification] ? @"已认证":@"未认证",[Tool GetUserOption:AusoUserOptionMobile]]];
        _detaliArr = [NSMutableArray arrayWithArray:arr];
    }
    return _detaliArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    [self getUserInfo];
    [self configViews];
}

- (void)configViews{
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
}

#pragma mark -
#pragma mark - tableView 代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 80;
        }else{
            return 50;
        }
    }else{
        return 50;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArr[section]count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.001;
    }
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"MineRootViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    
    cell.textLabel.text = self.dataArr[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont AvenirWithFontSize:15];
    cell.textLabel.textColor = RGB100;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.font = [UIFont HelveticaNeueBoldFontSize:18];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        [cell.contentView addSubview:imageView];
        
        self.iconImageView = imageView;
        
        NSString *photoUrl = [Tool GetUserOption:AusoUserOptionPhoto];
        if (photoUrl.length < 1) {
            imageView.image = IMAGE_NAMED(@"defaultavatar2");
        }else{
            [imageView sd_setImageWithURL:[NSURL URLWithString:photoUrl]placeholderImage:IMAGE_NAMED(@"defaultavatar2")];
        }
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.top.mas_offset(8);
            make.bottom.mas_equalTo(-8);
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            make.width.mas_equalTo(imageView.mas_height);
        }];
        
        ViewRadius(imageView, 4);
    }
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    if (indexPath.section == 1 && indexPath.row == 0) {
        if ([Tool IsCertification]) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    cell.detailTextLabel.text = self.detaliArr[indexPath.section][indexPath.row];
    cell.detailTextLabel.font =[UIFont HelveticaNeueFontSize:15];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        if (indexPath.row == 1) {
            ChangeNameViewController *changeVC = [[ChangeNameViewController alloc]init];
          
            [changeVC setNickName:^{
                [self refresh];
            }];
            
            [self.navigationController pushViewController:changeVC animated:YES];
        }else if (indexPath.row == 0){
            //选择头像
            [self ChangeUserIcon];
        }
    }else{
        if (indexPath.row == 0) {
            
            if ([[Tool GetUserOption:AusoUserOptionCard]intValue] != 2) {
                GuideViewController *guideVC = [[GuideViewController alloc]init];
                guideVC.initialPage = 1;
                BaseNavigationController *navi = [[BaseNavigationController alloc]initWithRootViewController:guideVC];
                
                [self presentViewController:navi animated:YES completion:nil];
            }
        }
    }
}


- (void)getUserInfo{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"1" forKey:@"type"];
    
    NSMutableDictionary *headerInfo = [NSMutableDictionary dictionary];
    [headerInfo setObject:[Tool GetUserOption:AusoUserOptionUserId] forKey:@"userid"];
    [headerInfo setObject:[Tool GetUserOption:AusoUserOptionToken] forKey:@"token"];
    
    [Tool Get:API_User_Info param:param header:headerInfo isHUD:YES result:^(BOOL status, NSDictionary *result) {
        if (status) {
            if ([self resultVerify:result]) {
                NSLog(@"%@",result);
                
                AusoUser *temp = [ArchiveUtil getUser];
                //从后台拿到 用户信息
                AusoUser *user = [AusoUser mj_objectWithKeyValues:[result objectForKey:@"data"]];
                user.token = temp.token;
                user.user_id = temp.user_id;
                //归档
                [ArchiveUtil saveUser:user];
                
                //刷新数据源
                [self refresh];
            }
        }
    }];
}


- (void)refresh{
    
    NSString *sex = @"";
    if ([[Tool GetUserOption:AusoUserOptionSex] isEqualToString:@"1"]) {
        sex = @"男";
    }else if ([[Tool GetUserOption:AusoUserOptionSex]isEqualToString:@"2"]){
        sex = @"女";
    }

    NSArray *arr = @[@[@"",[Tool GetUserOption:AusoUserOptionNickName],sex],@[[Tool IsCertification] ? @"已认证":@"未认证",[Tool GetUserOption:AusoUserOptionMobile]]];
    self.detaliArr = [NSMutableArray arrayWithArray:arr];
    [self.tableView reloadData];
    

}


-(void)ChangeUserIcon{
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self GetImageFromAlbum];
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self GetImageFromCamera];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 *从相册
 */
-(void)GetImageFromAlbum{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [picker.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self presentViewController:picker animated:YES completion:nil];
}

/**
 *从相机
 */
-(void)GetImageFromCamera{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES; //允许用户编辑
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else {
        //弹出窗口响应点击事件
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告"
                                                        message:@"未检测到摄像头" delegate:nil cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil ,nil];
        [alert show];
    }
}
//选择图片后的代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    //缓存到本地
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileImagepath = [path stringByAppendingPathComponent:@"Headimage"];
    [UIImagePNGRepresentation(newPhoto) writeToFile:fileImagepath atomically:YES];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    

    //上传头像
    [self uploadIconImageWithImage:newPhoto];
    
}

-(void)uploadIconImageWithImage:(UIImage *)image{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"2" forKey:@"type"];
    [param setValue:@"111" forKey:@"headerimage"];
    

    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);//image为要上传的图片(UIImage)
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *headerDictionary = [Tool AusoNetHeader];
    
    for (NSString *httpHeaderField in headerDictionary.allKeys) {
        NSString *value = headerDictionary[httpHeaderField];
        [manager.requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
    }

    [SVProgressHUD show];
    [manager POST:API_User_Info parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat = @"yyyyMMddHHmmss";
//        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[formatter stringFromDate:[NSDate date]]];
//
        
        
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        
        //二进制文件，接口key值，文件路径，图片格式
        [formData appendPartWithFileData:imageData name:@"headerimage" fileName:fileName mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",responseDict);
        NSString *code = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"code"]];
        if ([code isEqualToString:@"0"]) {
           
            [SVProgressHUD showSuccessWithStatus:@"头像上传成功"];
            [SVProgressHUD dismissWithDelay:1.5];
            
            self.iconImageView.image = image;
            
            [self getUserInfo];
            
        }else{
           
            [SVProgressHUD showErrorWithStatus:@"头像上传失败"];
            [SVProgressHUD dismissWithDelay:1.5];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showError:KERROR_CONNECTION_FAILED];
    }];
    
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
