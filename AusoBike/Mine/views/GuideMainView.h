//
//  GuideMainView.h
//  AusoBike
//
//  Created by Chang on 2017/11/7.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GuideMainViewPayType){
    GuideMainViewPayTypeWeChatPay = 0,     ///< 微信支付
    GuideMainViewPayTypeAliPay,  ///< 阿里支付

};

typedef NS_ENUM(NSUInteger, GuideMainViewAction){
    GuideMainViewActionExperience = 0,  ///< 体验
    GuideMainViewActionRecharge,     ///< 充值
};

@protocol GuideMainViewDelegate<NSObject>
- (void)guideMainViewPageOneSendCodeWithPhont:(NSString *)phone; ///< 手机验证 - 发送短信Action
- (void)guideMainViewPageOneVerifyWithPhone:(NSString *)phone code:(NSString *)code;///< 验证
- (void)guideMainViewPageTwoCommitWithName:(NSString *)name IdCard:(NSString *)idcard;///< 实名认证 - 提交资料
- (void)guideMainViewPageThreePayType:(GuideMainViewPayType)payType;
- (void)guideMainViewPageFourAction:(GuideMainViewAction)action;

@end

@interface GuideMainView : UIView
@property (nonatomic,weak)id<GuideMainViewDelegate> delegate;
@property (nonatomic,strong)NSDictionary *data;///< 数据源
@property (nonatomic,assign)NSInteger initialPage;///< 起始页
@property (nonatomic,strong)NSString *deposit;///< 押金

- (void)nextPageWithAnimation:(BOOL)animation;   ///< 下一页


@end
