//
//  GuideHeader.m
//  AusoBike
//
//  Created by Chang on 2017/11/20.
//  Copyright © 2017年 Auso Inc. All rights reserved.
//

#import "GuideHeader.h"

@interface GuideHeader()
@property (nonatomic,strong)NSMutableArray *labelArr;
@property (nonatomic,strong)NSMutableArray *buttoncArr;
@property (nonatomic,strong)UIImageView *bgImgView;
@end

@implementation GuideHeader

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView setImage:IMAGE_NAMED(@"bg_pagination1")];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
    }];
    self.bgImgView = imageView;
    
    NSArray *titleArr = @[@"手机验证",@"实名认证",@"交纳押金",@"完成"];
    
    self.buttoncArr= [NSMutableArray array];
    self.labelArr =[NSMutableArray array];
    
    for (int i = 0; i < titleArr.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        
        CGFloat left = i * (self.width / 4.f) + 10;
        
        [button setBackgroundImage:IMAGE_NAMED(@"ico_pagination_finished") forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:10];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(left);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        UILabel *label = [[UILabel alloc]init];
        [self addSubview:label];
        
        label.font = [UIFont HelveticaNeueBoldFontSize:12];
        if (iphone5s || iphone4s) {
            label.font = [UIFont HelveticaNeueBoldFontSize:11];

        }
        label.text = titleArr[i];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(button.mas_right).offset(2);
            make.centerY.mas_equalTo(button);
        }];
        
        [self.buttoncArr addObject:button];
        [self.labelArr addObject:label];
    }
}

- (void)setIndexPage:(NSInteger)indexPage{
    _indexPage = indexPage;
    [self resetStatusWithPage:indexPage];
}
- (void)nextPage{
    self.indexPage += 1;
    [self resetStatusWithPage:self.indexPage];
}

-(void)resetStatusWithPage:(NSInteger)index{
    for (int i = 0; i < self.labelArr.count; i ++) {
        UILabel *label = self.labelArr[i];
        UIButton *btn = self.buttoncArr[i];
        
        if (i < index) {
            label.textColor = [UIColor whiteColor];
            [btn setTitle:@"" forState:UIControlStateNormal];
            [btn setBackgroundImage:IMAGE_NAMED(@"ico_pagination_finished") forState:UIControlStateNormal];
        }else if (i == index){
            label.textColor = RGBORANGE;
            [btn setTitle:[NSString stringWithFormat:@"%d",i + 1] forState:UIControlStateNormal];
            [btn setBackgroundImage:IMAGE_NAMED(@"ico_pagination_going") forState:UIControlStateNormal];

        }else if (i > index){
            label.textColor = [UIColor grayColor];
            [btn setTitle:[NSString stringWithFormat:@"%d",i + 1] forState:UIControlStateNormal];
            [btn setBackgroundImage:IMAGE_NAMED(@"ico_pagination_unfinished") forState:UIControlStateNormal];

        }
        
        if (index == 0) {
            self.bgImgView.image = IMAGE_NAMED(@"bg_pagination1");
        }else if (index == 1){
            self.bgImgView.image = IMAGE_NAMED(@"bg_pagination1");
        }else if (index == 2){
            self.bgImgView.image = IMAGE_NAMED(@"bg_pagination2");
        }else if (index == 3){
            self.bgImgView.image = IMAGE_NAMED(@"bg_pagination3");
        }
    }
}
@end
