//
//  CreativeWorksCell.m
//  优化CreativeWorksCell
//
//  Created by guanning on 2017/2/20.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "CreativeWorksCell.h"
//#import "DetailMainViewController.h"
//#import "LoginOrRegistePopView.h"
//#import "UserWorksEditViewController.h"
//#import "JPUserHomePageViewController.h"
//#import "LookMoreProduceViewController.h"
#import "UIView+Extension.h"

@interface CreativeWorksCell () <UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGSize pictureSize;
@property (nonatomic, assign) CGFloat bottomViewHeight;
@property (nonatomic, assign) CGFloat iconWH;
@property (nonatomic, assign) CGFloat iconMargin;
@property (nonatomic, strong) UIFont *nameFont;
@property (nonatomic, strong) UIFont *detailIconFont;
@property (nonatomic, strong) UIFont *detailFont;
@property (nonatomic, assign) CGFloat btnWH;
@property (nonatomic, assign) CGFloat fansCountLabelW;

@property (nonatomic, weak) UIImageView *pictureView;
@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *fansIcon;
@property (nonatomic, weak) UILabel *fansCountLabel;
@property (nonatomic, weak) UILabel *worksIcon;
@property (nonatomic, weak) UILabel *worksCountLabel;
@property (nonatomic, weak) UIButton *zanBtn;
@property (nonatomic, weak) UIButton *editBtn;
@property (nonatomic, weak) UIButton *lookSameBtn;
@end

@implementation CreativeWorksCell

#pragma mark - Setter

- (void)setIsShowLookSameBtn:(BOOL)isShowLookSameBtn {
    _isShowLookSameBtn = isShowLookSameBtn;
    
    if (isShowLookSameBtn && !self.lookSameBtn) {
        
        UILabel *tempL = ({
            UILabel *aLabel = [UILabel new];
            aLabel.font = [UIFont systemFontOfSize:JPScaleValue(8.0)];
            aLabel.text = @"看同款";
            [aLabel sizeToFit];
            aLabel;
        });
        
        UIButton *lookSameBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.titleLabel.font = tempL.font;
            [btn setTitle:tempL.text forState:UIControlStateNormal];
            [btn setTitleColor:InfiniteeBlue forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn addTarget:self action:@selector(lookSameGoods) forControlEvents:UIControlEventTouchUpInside];
            CGFloat width = tempL.jp_width + 2 * 5;
            CGFloat height = tempL.font.pointSize + 2 * 3;
            btn.frame = (CGRect) {
                .size = {
                    .width = width,
                    .height = height,
                },
                .origin = {
                    .x = self.bottomView.jp_width - width - ViewMargin,
                    .y = (self.bottomView.jp_height - height) * 0.5,
                }
            };
            [btn jp_drawBorderLayerWithBounds:btn.bounds borderWidth:JPSeparateLineThick borderColor:InfiniteeBlue cornerRadius:2];
            btn;
        });
        
        [self.bottomView addSubview:lookSameBtn];
        self.lookSameBtn = lookSameBtn;
    }
    
}

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setupBase];
        [self setupPictureView];
        [self setupBottomView];
        [self setupIconView];
        [self setupNameLabel];
        [self setupDetailViews];
        [self setupBtn];
        
        CALayer *line = [CALayer layer];
        line.backgroundColor = InfiniteeGrayA(0.3).CGColor;
        line.frame = CGRectMake(0, self.bottomView.jp_y, BaseCellW, JPSeparateLineThick);
        [self.contentView.layer addSublayer:line];
        
        [self.contentView jp_drawBorderLayerWithBounds:self.bounds borderWidth:JPSeparateLineThick borderColor:InfiniteeGrayA(0.3) cornerRadius:0];
    }
    
    return self;
}

#pragma mark - 页面布局

- (void)setupBase {
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.pictureSize = CGSizeMake(BaseCellW, BaseCellW);
    self.bottomViewHeight = BaseCellH - BaseCellW;
    self.iconWH = self.bottomViewHeight - 2 * ViewMargin;
    self.iconMargin = ViewMargin;
    self.nameFont = [UIFont systemFontOfSize:12];
    self.detailIconFont = [UIFont infiniteeFontWithSize:10];
    self.detailFont = [UIFont systemFontOfSize:10];
    self.btnWH = 44;
    self.fansCountLabelW = InfiniteeConst.fontSize10MaxWidth;
    
    if (JPPortraitScreenWidth == iPhone6Width) {
        self.iconMargin = 8;
        self.iconWH = self.bottomViewHeight - 2 * self.iconMargin;
        self.btnWH = 40;
    } else if (JPPortraitScreenWidth < iPhone6Width) {
        self.iconWH = 25;
        self.iconMargin = (self.bottomViewHeight - 25) * 0.5;
        self.btnWH = 38;
        self.nameFont = [UIFont systemFontOfSize:10];
        self.detailFont = [UIFont systemFontOfSize:8];
        self.detailIconFont = [UIFont infiniteeFontWithSize:8];
        self.fansCountLabelW = InfiniteeConst.fontSize8MaxWidth;
    }
    
    self.isShowBtn = YES;
}

- (void)setupPictureView {
    UIImageView *pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BaseCellW, BaseCellW)];
    pictureView.backgroundColor = InfiniteeWhite;
    pictureView.contentMode = UIViewContentModeScaleAspectFit;
    pictureView.image = [UIImage defaultWorksPicture];
    [self.contentView addSubview:pictureView];
    self.pictureView = pictureView;
    
    UITapGestureRecognizer *pictureViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushWorksDetailView)];
    pictureView.userInteractionEnabled = YES;
    [pictureView addGestureRecognizer:pictureViewTap];
}

- (void)setupBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, BaseCellW, BaseCellW, self.bottomViewHeight)];
    [self.contentView addSubview:bottomView];
    self.bottomView = bottomView;
    
    UITapGestureRecognizer *bottomTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserDetailView)];
    bottomTap.delegate = self;
    [bottomView addGestureRecognizer:bottomTap];
}

- (void)setupIconView {
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(self.iconMargin, self.iconMargin, self.iconWH, self.iconWH)];
    iconView.image = [UIImage defaultIcon];
    [iconView jp_addRoundedCornerWithSize:CGSizeMake(self.iconWH, self.iconWH) radius:(self.iconWH * 0.5) maskColor:[UIColor whiteColor]];
    [self.bottomView addSubview:iconView];
    self.iconView = iconView;
}

- (void)setupNameLabel {
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = self.nameFont;
    nameLabel.textColor = InfiniteeBlack;
    nameLabel.text = @"  ";
    [nameLabel sizeToFit];
    nameLabel.jp_x = self.iconWH + 2 * self.iconMargin;
    nameLabel.jp_y = self.iconMargin;
    nameLabel.jp_width = BaseCellW - nameLabel.jp_x - self.btnWH - ViewMargin;
    [self.bottomView addSubview:nameLabel];
    self.nameLabel = nameLabel;
}

- (void)setupDetailViews {
    UILabel *fansIcon = [[UILabel alloc] init];
    fansIcon.font = self.detailIconFont;
    fansIcon.textColor = InfiniteeGray;
    fansIcon.text = @"";
    [fansIcon sizeToFit];
    fansIcon.jp_x = self.nameLabel.jp_x;
    fansIcon.jp_y = self.bottomView.jp_height - self.iconMargin - fansIcon.jp_height;
    [self.bottomView addSubview:fansIcon];
    self.fansIcon = fansIcon;
    
    UILabel *fansCountLabel = [[UILabel alloc] init];
    fansCountLabel.font = self.detailFont;
    fansCountLabel.textColor = InfiniteeGray;
    fansCountLabel.text = @"  ";
    [fansCountLabel sizeToFit];
    fansCountLabel.jp_width = self.fansCountLabelW;
    fansCountLabel.jp_x = CGRectGetMaxX(fansIcon.frame) + 5;
    fansCountLabel.jp_centerY = fansIcon.jp_centerY;
    [self.bottomView addSubview:fansCountLabel];
    self.fansCountLabel = fansCountLabel;
    
    UILabel *worksIcon = [[UILabel alloc] init];
    worksIcon.font = self.detailIconFont;
    worksIcon.textColor = InfiniteeGray;
    worksIcon.text = @"";
    [worksIcon sizeToFit];
    worksIcon.jp_x = CGRectGetMaxX(fansCountLabel.frame) + 5;
    worksIcon.jp_centerY = fansIcon.jp_centerY;
    [self.bottomView addSubview:worksIcon];
    self.worksIcon = worksIcon;
    
    UILabel *worksCountLabel = [[UILabel alloc] init];
    worksCountLabel.font = self.detailFont;
    worksCountLabel.textColor = InfiniteeGray;
    worksCountLabel.text = @"  ";
    [worksCountLabel sizeToFit];
    worksCountLabel.jp_width = self.fansCountLabelW;
    worksCountLabel.jp_x = CGRectGetMaxX(worksIcon.frame) + 5;
    worksCountLabel.jp_centerY = fansIcon.jp_centerY;
    [self.bottomView addSubview:worksCountLabel];
    self.worksCountLabel = worksCountLabel;
}

- (void)setupBtn {
    UIButton *zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zanBtn.titleLabel.font = [UIFont infiniteeFontWithSize:21];
    [zanBtn setTitle:@"" forState:UIControlStateNormal];
    [zanBtn setTitleColor:InfiniteeGray forState:UIControlStateNormal];
    [zanBtn setTitleColor:JPRGBColor(227, 140, 125) forState:UIControlStateSelected];
    [zanBtn addTarget:self action:@selector(zan:) forControlEvents:UIControlEventTouchUpInside];
    zanBtn.jp_size = CGSizeMake(self.btnWH, self.btnWH);
    zanBtn.jp_x = self.bottomView.jp_width - zanBtn.jp_width;
    zanBtn.jp_centerY = self.bottomView.jp_height * 0.5;
    [self.bottomView addSubview:zanBtn];
    self.zanBtn = zanBtn;
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.titleLabel.font = [UIFont infiniteeFontWithSize:21];
    [editBtn setTitle:@"" forState:UIControlStateNormal];
    [editBtn setTitleColor:InfiniteeGray forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editWorks:) forControlEvents:UIControlEventTouchUpInside];
    editBtn.jp_size = zanBtn.jp_size;
    editBtn.jp_x = zanBtn.jp_x;
    editBtn.jp_centerY = zanBtn.jp_centerY;
    editBtn.hidden = YES;
    [self.bottomView addSubview:editBtn];
    self.editBtn = editBtn;
}

- (void)setIsCollection:(BOOL)isCollection {
    if (_isCollection == isCollection) return;
    _isCollection = isCollection;
    if (isCollection) {
        [self.zanBtn setTitle:@"" forState:UIControlStateNormal];
    } else {
        [self.zanBtn setTitle:@"" forState:UIControlStateNormal];
    }
}

#pragma mark - 设置模型

- (void)setWorks:(CreativeWorks *)works {
    
//    BOOL isFirst = _works == nil;
    
    _works = works;
    
    if (!works) {
        self.pictureView.backgroundColor = InfiniteeWhite;
        self.pictureView.image = [UIImage defaultWorksPicture];
        self.iconView.image = [UIImage defaultIcon];
        self.nameLabel.text = @"  ";
        self.fansCountLabel.text = @" ";
        self.worksCountLabel.text = @" ";
        
        if (self.isShowLookSameBtn) {
            self.editBtn.hidden = YES;
            self.zanBtn.hidden = YES;
            self.lookSameBtn.hidden = NO;
        } else {
            self.editBtn.hidden = YES;
            self.zanBtn.hidden = NO;
            self.zanBtn.selected = NO;
            self.lookSameBtn.hidden = YES;
        }
        return;
    }
    
    // 作品图
    NSURL *pictureUrl = [NSURL URLWithString:[works.picture jp_imageFormatURLWithSize:self.pictureSize]];
    [self.pictureView jp_fakeSetPictureWithURL:pictureUrl placeholderImage:[UIImage defaultWorksPicture]];
    
    // 头像
    NSURL *iconUrl = [NSURL URLWithString:[works.cusIcon jp_imageFormatURLWithSize:CGSizeMake(self.iconWH, self.iconWH)]];
    [self.iconView jp_fakeSetPictureWithURL:iconUrl placeholderImage:[UIImage defaultIcon]];
    
    // 昵称
    self.nameLabel.text = works.cusNickname.length ? works.cusNickname : @" ";
    
    // 粉丝作品数
    self.fansCountLabel.text = [works.cusFansCount fansOrWorksCountText];
    self.worksCountLabel.text = [works.cusWorkCount fansOrWorksCountText];
    
    if (self.isShowLookSameBtn) {
        self.editBtn.hidden = YES;
        self.zanBtn.hidden = YES;
        self.lookSameBtn.hidden = NO;
        return;
    }
    
    self.lookSameBtn.hidden = YES;
    
    // 作品背景色
    UIColor *worksColor = [works.color worksBgColor];
    self.pictureView.backgroundColor = worksColor;
    
    if (self.isShowBtn) {
        BOOL editHidden = NO;
        BOOL zanHidden = NO;
        BOOL zanSelected = NO;
        BOOL zanEnabled = YES;
        if (self.isCollection) {
            editHidden = YES;
            zanEnabled = !works.isCollectioning;
            zanSelected = works.isCollection;
        } else {
//            if (!JPAccount) {
//                editHidden = YES;
//                zanSelected = works.isPraise.boolValue;
//            } else {
//                if ([works.cusId isEqualToString:JPAccount.useId]) {
//                    zanHidden = YES;
//                } else {
                    editHidden = YES;
                    zanSelected = works.isPraise.boolValue;
                    zanEnabled = !works.isZaning;
//                }
//            }
        }
        self.editBtn.hidden = editHidden;
        self.zanBtn.hidden = zanHidden;
        self.zanBtn.selected = zanSelected;
        self.zanBtn.userInteractionEnabled = zanEnabled;
    } else {
        self.editBtn.hidden = YES;
        self.zanBtn.hidden = YES;
    }
    
}

#pragma mark - 编辑作品

- (void)editWorks:(id)sender {
    JPLog(@"编辑作品");
    
//    UserWorksEditViewController *uweVC = [UserWorksEditViewController editWorksControllerWithPlaceHolderImage:self.pictureView.image works:self.works presentingNavigationController:self.jp_topNavigationController];
//    JPNavigationController *naVC = [[JPNavigationController alloc] initWithRootViewController:uweVC];
//    [self.jp_topViewController presentViewController:naVC animated:YES completion:nil];
}

#pragma mark - 点赞

- (void)zan:(UIButton *)sender {
    if (!self.works) return;
    
//    if (!JPAccount) {
//
//        [LoginOrRegistePopView showLoginOrRegistePopViewWithSuccessHandle:nil];
//
//    } else {
        
        self.zanBtn.userInteractionEnabled = NO;
        self.zanBtn.selected = !self.zanBtn.selected;
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        anim.springSpeed = 5;
        anim.springBounciness = 10;
        anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.8, 0.8)];
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
        [self.zanBtn.layer pop_addAnimation:anim forKey:nil];
        
        if (self.isCollection) {
            [self collection];
        } else {
            [self zan];
        }
        
//    }
    
}
    
- (void)zan {
//    NSDictionary *body = @{@"cusId": JPAccount.useId,
//                           @"followCusId": self.works.cusId,
//                           @"productionId": self.works.ID};
//
//#warning jp：需要额外处理的接口！！！AddProductionPraise
//    NSString *port = self.zanBtn.selected ? @"AddProductionPraise" : @"DelProductionPraise";
//
//    __weak CreativeWorks *works = self.works;
//    works.isZaning = YES;
//
//    @jp_weakify(self);
//    [JPSessionManager requestDataWithMethod:port parameter:body successHandler:^(NSURLSessionDataTask *task, NSDictionary *responseDic) {
//        @jp_strongify(self);
//        if (!self || !works) return;
//
//        works.isZaning = NO;
//        BOOL isPraise = [port isEqualToString:@"AddProductionPraise"];
//        NSInteger praiseCount = works.praiseCount.integerValue;
//        if (works.detailModel) {
//            praiseCount = works.detailModel.praiseCount;
//        }
//        if (isPraise) {
//            praiseCount += 1;
//        } else {
//            praiseCount -= 1;
//        }
//        works.isPraise = isPraise ? @"1" : @"0";
//        works.praiseCount = [NSString stringWithFormat:@"%zd", praiseCount];
//        if (works.detailModel) {
//            works.detailModel.praiseCount = praiseCount;
//            works.detailModel.isPraise = isPraise;
//        }
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (self.works == works) {
//                self.zanBtn.selected = works.isPraise.boolValue;
//                self.zanBtn.userInteractionEnabled = YES;
//            }
//            [self postZanNotifitionWithProductionId:works.ID zan:works.isPraise praiseCount:works.praiseCount];
//        });
//
//    } failureHandler:^(NSURLSessionDataTask *task, NSError *error, NSString *failedMsg, BOOL isServerError, BOOL isCancelMyself) {
//        @jp_strongify(self);
//        if (!self || isCancelMyself || !works) return;
//        works.isZaning = NO;
//        BOOL selected = NO;
//        if (isServerError) {
//            // 已经赞过
//            [JPProgressHUD showImage:nil status:failedMsg userInteractionEnabled:YES];
//            selected = YES;
//            works.isPraise = @"1";
//            [self postZanNotifitionWithProductionId:works.ID zan:works.isPraise praiseCount:works.praiseCount];
//        } else {
//            [JPProgressHUD showErrorWithStatus:@"网络异常" userInteractionEnabled:YES];
//            selected = works.isPraise.boolValue;
//        }
//        if (self.works == works) {
//            self.zanBtn.selected = selected;
//            self.zanBtn.userInteractionEnabled = YES;
//        }
//    }];
}

// 点赞成功的通知
- (void)postZanNotifitionWithProductionId:(NSString *)productionId zan:(NSString *)zan praiseCount:(NSString *)praiseCount {
    [[NSNotificationCenter defaultCenter] postNotificationName:WorksZan object:self.superview userInfo:@{@"productionId": productionId, @"zan": zan, @"praiseCount": praiseCount}];
}


- (void)collection {
//    NSDictionary *body = @{@"cusId": JPAccount.useId,
//                           @"followCusId": self.works.cusId,
//                           @"productionId": self.works.ID};
//    
//    NSString *port = self.zanBtn.selected ? @"AddCollectProduction" : @"DelCollectProduction";
//    
//    __weak CreativeWorks *works = self.works;
//    works.isCollectioning = YES;
//    
//    @jp_weakify(self);
//    [JPSessionManager requestDataWithMethod:port parameter:body successHandler:^(NSURLSessionDataTask *task, NSDictionary *responseDic) {
//        @jp_strongify(self);
//        if (!self || !works) return;
//        
//        works.isCollectioning = NO;
//        BOOL isCollection = [port isEqualToString:@"AddCollectProduction"];
//        works.isCollection = isCollection;
//        NSInteger collectCount = works.collectCount.integerValue;
//        if (works.detailModel) {
//            collectCount = works.detailModel.collectCount;
//        }
//        if (isCollection) {
//            collectCount += 1;
//        } else {
//            collectCount -= 1;
//        }
//        works.collectCount = [NSString stringWithFormat:@"%zd", collectCount];
//        if (works.detailModel) {
//            works.detailModel.isCollection = isCollection;
//            works.detailModel.collectCount = collectCount;
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (self.works == works) {
//                self.zanBtn.selected = isCollection;
//                self.zanBtn.userInteractionEnabled = YES;
//            }
//            NSString *isCollectionStr = isCollection ? @"1" : @"0";
//            CreativeWorks *aWorks = isCollection ? works : nil;
//            [self postCollectionNotifitionWithUserID:works.cusId productionId:works.ID collection:isCollectionStr collectCount:[NSString stringWithFormat:@"%zd", collectCount] works:aWorks];
//        });
//    } failureHandler:^(NSURLSessionDataTask *task, NSError *error, NSString *failedMsg, BOOL isServerError, BOOL isCancelMyself) {
//        @jp_strongify(self);
//        if (!self || isCancelMyself || !works) return;
//        [JPProgressHUD showErrorWithStatus:(failedMsg ? failedMsg : @"网络异常，操作失败") userInteractionEnabled:YES];
//        works.isCollectioning = NO;
//        if (self.works == works) {
//            self.zanBtn.selected = works.isCollection;
//            self.zanBtn.userInteractionEnabled = YES;
//        }
//    }];
}

// 收藏成功的通知
- (void)postCollectionNotifitionWithUserID:(NSString *)userID productionId:(NSString *)productionId collection:(NSString *)collection collectCount:(NSString *)collectCount works:(CreativeWorks *)works {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo.dictionary = @{@"userID": userID,
                            @"productionId": productionId,
                            @"collection": collection,
                            @"collectCount": collectCount};
    if (works) userInfo[@"works"] = works;
    [[NSNotificationCenter defaultCenter] postNotificationName:WorksCollection object:self.superview userInfo:userInfo];
}



// 点赞动画
- (void)zanAnimation:(NSString *)isZan {
    self.zanBtn.selected = isZan.boolValue;
    self.works.isPraise = isZan;
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    anim.springSpeed = 5;
    anim.springBounciness = 5;
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.8, 0.8)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    [self.zanBtn.layer pop_addAnimation:anim forKey:nil];
}

#pragma mark - 刷新粉丝作品数

- (void)updateFanAndWorksCount {
    self.fansCountLabel.text = [self.works.cusFansCount fansOrWorksCountText];
    self.worksCountLabel.text = [self.works.cusWorkCount fansOrWorksCountText];
}

#pragma mark - 推出作品\商品详情页

- (void)pushWorksDetailView {
    [self pushWorksDetailView:YES];
}

- (void)pushWorksDetailView:(BOOL)isAnimated {
    if (!self.works) return;
    
//    CGRect frame = [self.pictureView convertRect:self.pictureView.bounds toView:self.window];
//
//    DetailMainViewController *dmVC;
//    if (self.isShowLookSameBtn) {
//        dmVC = [DetailMainViewController detailFromGoodsWithWorks:self.works placeHolderImage:self.pictureView.image goodsImageFrame:frame];
//        if (!isAnimated) [dmVC goodDetailVCShowBottomView];
//    } else {
//        dmVC = [DetailMainViewController detailFromWorksWithWorks:self.works pictureBgColor:self.pictureView.backgroundColor placeHolderImage:self.pictureView.image worksImageFrame:frame];
//    }
//
//    UINavigationController *nav = self.jp_topNavigationController;
//    [nav pushViewController:dmVC animated:isAnimated];
}

#pragma mark - 推出用户主页

- (void)pushUserDetailView {
    if (!self.works) return;
    
//    UserAccount *account = [[UserAccount alloc] init];
//    account.useId = self.works.cusId;
//    account.icon = self.works.cusIcon;
//    account.nickname = self.works.cusNickname;
//    account.workCount = self.works.cusWorkCount;
//    account.fansCount = self.works.cusFansCount;
//
//    JPUserHomePageViewController *uhpVC = [JPUserHomePageViewController userHomePageVCWithAccount:account];
//
//    UINavigationController *nav = self.jp_topNavigationController;
//    nav.delegate = nil;
//    [nav pushViewController:uhpVC animated:YES];
}

#pragma mark - 去看同款商品

- (void)lookSameGoods {
    if (!self.works) return;
    
//    LookMoreProduceViewController *lmpVC = [[UIStoryboard storyboardWithName:@"Discover" bundle:nil] instantiateViewControllerWithIdentifier:@"LookMoreProduceViewController"];
//    lmpVC.title = @"相关商品";
//    lmpVC.cusID = self.works.cusId;
//    lmpVC.worksID = self.works.componentId;
//    lmpVC.type = LookMoreCorresGoods;
//    lmpVC.works = self.works;
//    UINavigationController *nav = self.jp_topNavigationController;
//    nav.delegate = nil;
//    [nav pushViewController:lmpVC animated:YES];
}

#pragma mark - UIGestureRecognizerDelegate（点击按钮不要响应tap事件）

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]){
        return NO;
    }
    return YES;
}

#pragma mark - 获取作品图片

- (UIImage *)image {
    return self.pictureView.image;
}

@end
