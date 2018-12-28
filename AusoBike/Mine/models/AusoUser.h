//
//  AusoUser.h
//  AusoBike
//
//  Created by Chang on 2017/11/15.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "BaseModel.h"

@interface AusoUser : BaseModel

/** 用户id */
@property (nonatomic,strong) NSString *user_id;
/** 押金 */
@property (nonatomic,strong) NSString *deposit;
/** username = 1 代表已经实名 */
@property (nonatomic,strong) NSString *username;
/** card = 2 代表身份证已经实名 */
@property (nonatomic,strong) NSString *card;
/** 密码 */
@property (nonatomic,strong) NSString *password;
/** 令牌 */
@property (nonatomic,strong) NSString *token;
/** 余额 */
@property (nonatomic,strong) NSString *money;
/** 性别 */
@property (nonatomic,strong) NSString *sex;
/** 手机号 */
@property (nonatomic,strong) NSString *mobile;
/** 昵称 */
@property (nonatomic,strong) NSString *nickname;
/** 生日 */
@property (nonatomic,strong) NSString *birthday;
/** 头像 */
@property (nonatomic,strong) NSString *images;

- (NSArray *)getAllProperties;
- (NSDictionary *)properties_aps;
@end
