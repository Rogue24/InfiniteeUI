//
//  ActivityDetailViewController.m
//  Infinitee2.0
//
//  Created by guanning on 2017/3/15.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "InfiniteeRefreshFooter.h"
#import "InfiniteeRefreshHeader.h"
#import "Theme.h"
#import "ActivityIntroductionView.h"
#import "SwitchListView.h"
#import "UIBarButtonItem+Extension.h"
#import "SmallMenuView.h"
//#import "JPPublicPopView.h"
//#import "ShareOpenView.h"
#import "CreativeWorksCell.h"
//#import "ShopCartViewController.h"
//#import "SelectDesignStyleViewController.h"
#import "RequestStateTitleView.h"
#import "JPThemeListTransition.h"
#import "JPInteractiveTransition.h"
#import "JPScreenBorderButton.h"

@interface ActivityDetailViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIImageView *headerView;
@property (nonatomic, weak) ActivityIntroductionView *aiView;
@property (nonatomic, strong) NSArray *menuModels;
@property (nonatomic, strong) NSMutableArray *dataSouce;

@property (nonatomic, weak) NSURLSessionDataTask *currTask;
@property (nonatomic, assign) NSInteger totalResult;
@property (nonatomic, assign) NSInteger currPage;

@property (nonatomic, assign) BOOL isRequesting;
@property (nonatomic, weak) RequestStateTitleView *navTitleView;

@property (nonatomic, assign) BOOL isCustomNavPush;
@property (nonatomic, copy) void (^startPushBlock)(void);
@property (nonatomic, copy) void (^startPopBlock)(BOOL isInteractivePop, CGFloat diffY);

@property (nonatomic, weak) UIView *bottomView;

@property (nonatomic, strong) JPInteractiveTransition *interactiveTransition;

@property (nonatomic, assign) BOOL isFRAAnimateDone;
@property (nonatomic, weak) id fraDelegate;
@end

@implementation ActivityDetailViewController

static NSString * const CreativeWorksCellID = @"CreativeWorksCell";

- (CGRect)activityDetailHeaderFrame:(BOOL)isOnWindow {
    if (!isOnWindow) {
        CGFloat actualWidth = InfiniteeConst.themeCellSize.width;
        CGFloat actualHeight = InfiniteeConst.themeCellSize.height;
        return CGRectMake(ViewMargin, JPNavTopMargin + ViewMargin, actualWidth, actualHeight);
    } else {
        return [self.headerView convertRect:self.headerView.bounds toView:JPKeyWindow];
    }
}

- (NSArray *)menuModels {
    if (!_menuModels) {
        _menuModels = [SmallMenuModel ActivityDetailModels];
    }
    return _menuModels;
}

- (NSMutableArray *)dataSouce {
    if (!_dataSouce) {
        _dataSouce = [NSMutableArray array];
    }
    return _dataSouce;
}

- (instancetype)initWithTheme:(Theme *)theme {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    if (self = [super initWithCollectionViewLayout:flowLayout]) {
        self.theme = theme;
    }
    return self;
}

- (instancetype)initWithTheme:(Theme *)theme startPushBlock:(void(^)(void))startPushBlock startPopBlock:(void(^)(BOOL isInteractivePop, CGFloat diffY))startPopBlock {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    if (self = [super initWithCollectionViewLayout:flowLayout]) {
        self.theme = theme;
        self.startPushBlock = startPushBlock;
        self.startPopBlock = startPopBlock;
        self.isCustomNavPush = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupHeaderView];
    [self setupActivityIntroductionView];
    [self setupCollectionView];
    [self setupBottomView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(worksZan:) name:WorksZan object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAttention:) name:AddOrDelAttentionFriend object:nil];
    
    if (self.isCustomNavPush) {
        self.interactiveTransition = [JPInteractiveTransition interactiveTransitionWithTransitionType:JPTransitionTypePop direction:JPInteractiveTransitionGestureDirectionRight];
        //给当前控制器的视图添加手势
        [self.interactiveTransition addPanGestureForViewController:self panView:JPKeyWindow referenceView:JPKeyWindow];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.isFromRecomActivity) {
        if (!self.fraDelegate) self.fraDelegate = self.navigationController.delegate;
        self.navigationController.delegate = self.fraDelegate;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    } else {
        if (self.isCustomNavPush) {
            self.navigationController.delegate = self;
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        } else {
            self.navigationController.delegate = nil;
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    if (self.dataSouce.count == 0) [self requestNewData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.isCustomNavPush || self.isFromRecomActivity) {
        UINavigationController *navCtr = [UIWindow jp_topViewControllerFromDelegateWindow].navigationController;
        navCtr.delegate = nil;
        navCtr.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setIsRequesting:(BOOL)isRequesting {
    _isRequesting = isRequesting;
    [self.navTitleView setTitle:self.theme.name withState:isRequesting ? RequestState : NormalState];
}

#pragma mark - 通知回调

- (void)worksZan:(NSNotification *)notification {
    if (notification.object != self.collectionView && self.dataSouce.count) {
        NSString *ID = notification.userInfo[@"productionId"];
        NSString *zan = notification.userInfo[@"zan"];
        
        for (NSInteger i = 0; i < self.dataSouce.count; i++) {
            CreativeWorks *works = self.dataSouce[i];
            if ([works.ID isEqualToString:ID]) {
                
                works.isPraise = zan;
                NSString *praiseCount = notification.userInfo[@"praiseCount"];
                works.praiseCount = praiseCount;
                
                if (works.detailModel) {
                    works.detailModel.isPraise = zan.boolValue;
                    works.detailModel.praiseCount = praiseCount.integerValue;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                    if ([self.collectionView.indexPathsForVisibleItems containsObject:indexPath]) {
                        CreativeWorksCell *cell = (CreativeWorksCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                        if (cell) [cell zanAnimation:works.isPraise];
                    }
                });
                break;
            }
        }
        
    }
}

- (void)updateAttention:(NSNotification *)notification {
    if (notification.object != self.collectionView && self.dataSouce.count) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *followID = userInfo[@"ID"];
        BOOL isAttention = [userInfo[@"isAttention"] boolValue];
        NSString *fansCount = userInfo[@"fansCount"];
        
        for (NSInteger i = 0; i < self.dataSouce.count; i++) {
            CreativeWorks *works = self.dataSouce[i];
            if ([works.cusId isEqualToString:followID]) {
                works.cusFansCount = fansCount;
                if (works.detailModel) {
                    works.detailModel.isAttention = isAttention;
                    works.detailModel.cusFansCount = fansCount;
                }
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([self.collectionView.indexPathsForVisibleItems containsObject:indexPath]) {
                        CreativeWorksCell *cell = (CreativeWorksCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                        if (cell) [cell updateFanAndWorksCount];
                    }
                });
            }
        }
    }
}

#pragma mark - 页面布局

- (void)setupNavigationBar {
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem itemWithTarget:self andAction:@selector(back) andIcon:@"" isLeft:YES];
    UIBarButtonItem *lSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    lSpaceBarButtonItem.width = JPNaviFixedSpace;
    self.navigationItem.leftBarButtonItems = @[lSpaceBarButtonItem, leftBarButtonItem];
    
    UIBarButtonItem *rightBarButtonItem = [UIBarButtonItem itemWithTarget:self andAction:@selector(more) andIcon:@"" isLeft:NO];
    UIBarButtonItem *rSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rSpaceBarButtonItem.width = JPNaviFixedSpace;
    self.navigationItem.rightBarButtonItems = @[rSpaceBarButtonItem, rightBarButtonItem];
    
    RequestStateTitleView *navTitleView = [RequestStateTitleView requestStateTitleViewWithTitle:self.theme.name state:NormalState];
    self.navigationItem.titleView = navTitleView;
    self.navTitleView = navTitleView;
}

- (void)setupHeaderView {
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:[self activityDetailHeaderFrame:NO]];
    headerView.layer.cornerRadius = 2;
    headerView.layer.masksToBounds = YES;
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.contentMode = UIViewContentModeScaleAspectFill;
    [self.collectionView addSubview:headerView];
    self.headerView = headerView;
    
    NSURL *imageURL = [NSURL URLWithString:[self.theme.picture jp_imageFormatURLWithSize:headerView.jp_size]];
    [self.headerView jp_fakeSetPictureWithURL:imageURL placeholderImage:nil];
    
    if (self.isFromRecomActivity) self.headerView.hidden = YES;
}

- (void)setupActivityIntroductionView {
    ActivityIntroductionView *aiView = [ActivityIntroductionView activityIntroductionViewWithRule:self.theme.rule ruleSize:self.theme.ruleSize];
    aiView.jp_x = ViewMargin;
    aiView.jp_y = self.headerView.jp_maxY + ViewMargin;
    [self.collectionView addSubview:aiView];
    self.aiView = aiView;
}

- (void)setupCollectionView {
    self.view.backgroundColor = InfiniteeWhite;
    
    [self jp_contentInsetAdjustmentNever:self.collectionView];
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.itemSize = BaseCellSize;
    flowLayout.minimumLineSpacing = CellMargin;
    flowLayout.minimumInteritemSpacing = CellMargin;
    flowLayout.sectionInset = UIEdgeInsetsMake(self.aiView.jp_maxY + ViewMargin, ViewMargin, JPTabBarH + ViewMargin, ViewMargin);
    
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(JPNavTopMargin, 0, JPTabBarH, 0);
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[CreativeWorksCell class] forCellWithReuseIdentifier:CreativeWorksCellID];
    
    self.collectionView.mj_header = [InfiniteeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestNewData)];
    self.collectionView.mj_footer = [InfiniteeRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData) bottomInset:-(JPTabBarH + 5)];
    self.collectionView.mj_footer.hidden = YES;
    self.collectionView.mj_header.ignoredScrollViewContentInsetTop = -JPNavTopMargin - 5;
}

- (void)setupBottomView {
    UIView *bottomView = [[UIView alloc] init];
    bottomView.frame = CGRectMake(0, JPPortraitScreenHeight - JPTabBarH, JPPortraitScreenWidth, JPTabBarH);
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    
    CALayer *line = [CALayer layer];
    line.backgroundColor = InfiniteeBlueA(0.5).CGColor;
    line.frame = CGRectMake(0, 0, JPPortraitScreenWidth, JPSeparateLineThick);
    [bottomView.layer addSublayer:line];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = @"参与主题将有机会获得现金券奖励";
    contentLabel.textColor = InfiniteeGray;
    contentLabel.font = [UIFont systemFontOfSize:10];
    contentLabel.jp_width = 300;
    contentLabel.jp_height = contentLabel.font.lineHeight;
    contentLabel.jp_x = ViewMargin;
    contentLabel.jp_centerY = JPBaseTabBarH * 0.5;
    [bottomView addSubview:contentLabel];
    
    JPScreenBorderButton *designBtn = [JPScreenBorderButton buttonWithType:UIButtonTypeSystem];
    designBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [designBtn setTitle:@"立即定制" forState:UIControlStateNormal];
    [designBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    designBtn.backgroundColor = InfiniteeBlue;
    designBtn.layer.cornerRadius = 2;
    designBtn.layer.masksToBounds = YES;
    designBtn.jp_size = CGSizeMake(69, 24);
    designBtn.jp_x = JPPortraitScreenWidth - 69 - ViewMargin;
    designBtn.jp_centerY = JPBaseTabBarH * 0.5;
    [designBtn addTarget:self action:@selector(presentSelectDesignStyleView) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:designBtn];
    
    JPScreenBorderButton *shareBtn = [JPScreenBorderButton buttonWithType:UIButtonTypeSystem];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [shareBtn setTitle:@"分享主题" forState:UIControlStateNormal];
    [shareBtn setTitleColor:InfiniteeBlue forState:UIControlStateNormal];
    shareBtn.backgroundColor = [UIColor whiteColor];
    shareBtn.layer.cornerRadius = 2;
    shareBtn.layer.masksToBounds = YES;
    shareBtn.layer.borderWidth = JPSeparateLineThick + 0.01;
    shareBtn.layer.borderColor = InfiniteeBlue.CGColor;
    shareBtn.jp_size = CGSizeMake(69, 24);
    shareBtn.jp_x = JPPortraitScreenWidth - 69 * 2 - ViewMargin * 2;
    if (JPPortraitScreenWidth < iPhone6Width) shareBtn.jp_x += 5;
    shareBtn.jp_centerY = JPBaseTabBarH * 0.5;
    [shareBtn addTarget:self action:@selector(shareTheme) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:shareBtn];
}

#pragma mark - 监听导航栏

- (void)back {
    if (self.isFromRecomActivity) self.navigationController.delegate = self.fraDelegate;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)more {
    __weak typeof(self) weakSelf = self;
    [SmallMenuView smallMenuViewOnView:self.view.window menuModels:self.menuModels itemClick:^(NSInteger selectIndex) {
        [weakSelf smallMenuViewClickHandleWithSelectIndex:selectIndex];
    }];
}

#pragma mark - 小菜单按钮响应

- (void)smallMenuViewClickHandleWithSelectIndex:(NSInteger)selectIndex {
    
    switch (selectIndex) {
        case 0:
            JPLog(@"去购物车");
        {
//            if (JPOdToolInstance.shopCartGoods.count > 0) {
//                ShopCartViewController *shopCartVC = [[ShopCartViewController alloc] init];
//                JPNavigationController *shopCartNav = [[JPNavigationController alloc] initWithRootViewController:shopCartVC];
//                [self presentViewController:shopCartNav animated:YES completion:nil];
//            } else {
                [JPProgressHUD showImage:nil status:ShopCarNoGoodsText];
//            }
            break;
        }
            
        case 1:
        {
            JPLog(@"分享？！");
//            [ShareOpenView shareActivityWithTheme:self.theme];
            break;
        }
            
        case 2:
        {
            JPLog(@"联系客服");
//            [JPPublicPopView showServicePopView];
            break;
        }
            
        default:
            break;
    }
    
}

#pragma mark - 跳转至设计空间款式选择

- (void)presentSelectDesignStyleView {
//    if (![SelectDesignStyleViewController canGoDesign]) return;
//    JPPublicDataTool.isCustomerDesign = YES;
//    SelectDesignStyleViewController *sdsVC = [[SelectDesignStyleViewController alloc] init];
//    sdsVC.activityTag = [NSString stringWithFormat:@"#%@", self.theme.name];
//    [self presentViewController:sdsVC animated:YES completion:nil];
}

#pragma mark - 分享主题

- (void)shareTheme {
//    [ShareOpenView shareActivityWithTheme:self.theme];
}

#pragma mark - 请求数据

- (void)requestNewData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *filePath = JPMainBundleResourcePath(@"productions1", @"plist");
        NSDictionary *resultDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
//        NSInteger totalResult = resultDic[@"totalResult"] ? [resultDic[@"totalResult"] integerValue] : self.totalResult;
        NSMutableArray *dataSouce = [CreativeWorks mj_objectArrayWithKeyValuesArray:resultDic[@"productions"]];
        NSInteger totalResult = dataSouce.count;

        dispatch_async(dispatch_get_main_queue(), ^{
            self.isRequesting = NO;
            [self.collectionView.mj_header endRefreshing];

            self.currPage = 1;
            self.totalResult = totalResult;
            self.dataSouce = dataSouce;

            if (self.isFromRecomActivity && !self.isFRAAnimateDone) return;
            [self.collectionView performBatchUpdates:^{
                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            } completion:^(BOOL finished) {
                [self checkFooterState];
            }];
        });
    });
}

- (void)requestMoreData {}

// 判断footer状态
- (void)checkFooterState {
    
    // 每次刷新数据时，根据是否有数据来控制footer显示或隐藏
    self.collectionView.mj_footer.hidden = [self.collectionView numberOfItemsInSection:0] ? NO : YES;
    
    if ([self.collectionView numberOfItemsInSection:0] == self.totalResult) {
        // 如果已经达到了数据总数（全部加载完）
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    } else {
        // 还没达到数据总数（还没加载完）
        [self.collectionView.mj_footer resetNoMoreData];
        [self.collectionView.mj_footer endRefreshing];
    }
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.isFromRecomActivity && !self.isFRAAnimateDone) return 10;
    NSInteger count = self.dataSouce.count;
    return count > 0 ? count : 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CreativeWorksCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CreativeWorksCellID forIndexPath:indexPath];
    cell.isShowLookSameBtn = YES;
    
    if (self.isFromRecomActivity && !self.isFRAAnimateDone) {
        cell.works = nil;
    } else {
        if (self.dataSouce.count) {
            cell.works = self.dataSouce[indexPath.item];
        } else {
            cell.works = nil;
        }
    }
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= self.headerView.jp_height + 20) {
        self.interactiveTransition.pan.enabled = YES;
    } else {
        self.interactiveTransition.pan.enabled = NO;
    }
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if (!self.startPopBlock) return nil;
    JPThemeListTransition *transition;

    @jp_weakify(self);
    if (operation == UINavigationControllerOperationPush) {
        transition = [JPThemeListTransition themeDetailWithIsPush:YES duration:0.6 startBlock:^{
            @jp_strongify(self);
            if (!self) return;
            self.headerView.hidden = YES;
            !self.startPushBlock ? : self.startPushBlock();
        } finishBlock:^(BOOL isComplete) {
            @jp_strongify(self);
            if (!self) return;
            self.headerView.hidden = NO;
            self.view.userInteractionEnabled = YES;
        }];
    } else {
        if (self.collectionView.contentOffset.y <= self.headerView.jp_height + 20) {
            [UIView animateWithDuration:0.3 animations:^{
                self.bottomView.jp_y = JPPortraitScreenHeight;
            }];
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView setContentOffset:self.collectionView.contentOffset animated:YES];
            transition = [JPThemeListTransition themeDetailWithIsPush:NO duration:0.6 startBlock:^{
                @jp_strongify(self);
                if (!self) return;
                self.headerView.hidden = YES;
                !self.startPopBlock ? : self.startPopBlock(NO, self.collectionView.contentOffset.y);
            } finishBlock:^(BOOL isComplete) {
                @jp_strongify(self);
                if (!self) return;
                if (isComplete) return;
                [UIView animateWithDuration:0.3 animations:^{
                    self.bottomView.jp_y = JPPortraitScreenHeight - self.bottomView.jp_height;
                }];
                self.headerView.hidden = NO;
                self.view.userInteractionEnabled = YES;
            }];
        } else {
            !self.startPopBlock ? : self.startPopBlock(YES, 0);
        }
    }
    
    if (transition) self.view.userInteractionEnabled = NO;
    return transition;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    //手势开始的时候才需要传入手势过渡代理，如果直接点击pop，应该传入空，否者无法通过点击正常pop
    return self.interactiveTransition.interation ? self.interactiveTransition : nil;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    BOOL canNotUseMy = self.collectionView.contentOffset.y > self.headerView.jp_height + 20;
    if (gestureRecognizer != self.navigationController.interactivePopGestureRecognizer) {
        return !canNotUseMy;
    } else {
        if (canNotUseMy && self.startPopBlock) self.startPopBlock(YES, 0);
        return canNotUseMy;
    }
}

#pragma mark - 推荐活动进场动画相关

- (void)fromRecomActivityBeginAnimateWithIsPush:(BOOL)isPush {
    self.headerView.hidden = YES;
}

- (void)fromRecomActivityEndAnimateWithIsPush:(BOOL)isPush isComplete:(BOOL)isComplete {
    self.headerView.hidden = NO;
    if (!isPush) return;
    self.isFRAAnimateDone = YES;
    NSInteger count = self.dataSouce.count;
    if (count) {
        NSMutableArray *indexPaths = [NSMutableArray array];
        for (NSInteger i = 0; i < count; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
        }
        [self.collectionView performBatchUpdates:^{
            [self.collectionView insertItemsAtIndexPaths:indexPaths];
        } completion:^(BOOL finished) {
            [self checkFooterState];
        }];
    } else {
        [self requestNewData];
    }
}

@end
