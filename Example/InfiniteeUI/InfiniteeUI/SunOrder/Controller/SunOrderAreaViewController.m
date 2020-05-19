//
//  SunOrderAreaViewController.m
//  Infinitee2.0
//
//  Created by guanning on 2017/7/6.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "SunOrderAreaViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "SunOrderTitleCell.h"
#import "SunOrderListViewController.h"
#import "JPImageView.h"
#import "JPSunOrderDataTool.h"
//#import "UserOrderListMainViewController.h"
#import "NoDataView.h"
#import "FullScreenScrollView.h"
#import "RequestStateTitleView.h"

@interface SunOrderAreaViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>
@property (nonatomic, strong) JPSunOrderDataTool *dataTool;
@property (nonatomic, weak) RequestStateTitleView *navTitleView;
@property (nonatomic, weak) UICollectionView *titleCollectionView;
@property (nonatomic, weak) UIView *couponView;
@property (nonatomic, weak) FullScreenScrollView *scrollView;

@property (nonatomic, weak) UIView *selectedLine;
@property (nonatomic, weak) UIView *line;

@property (nonatomic, weak) UIButton *textImageListBtn;
@property (nonatomic, weak) UIButton *imageListBtn;

@property (nonatomic, weak) NoDataView *noDataView;
@property (nonatomic, weak) UIPageViewController *pageVC;

//@property (nonatomic, assign) NSInteger scrollingIndex;
@end

@implementation SunOrderAreaViewController
{
    BOOL _isFirstDecelerate;
    BOOL _isDecelerate;
    
    CGFloat _startHorOffsetX;
    CGFloat _maxHorOffsetX;
    NSInteger _selectedIndex;
    
    BOOL _isDidClickAnimating;
    
    JPRgba _selRgba;
    JPRgba _norRgba;
    JPRgba _diffRgba;
    UIColor *_selColor;
    UIColor *_norColor;
    
    CGFloat _bottomSoViewH;
    BOOL _isFromBeginGuide;
}

static NSString *const SunOrderTitleCellID = @"SunOrderTitleCell";

#pragma mark - getter

//- (JPInteractiveTransition *)interactiveTransition {
//    if (!_interactiveTransition) {
//        _interactiveTransition = [JPInteractiveTransition interactiveTransitionWithTransitionType:JPTransitionDismiss direction:JPInteractiveTransitionGestureDirectionRight];
//    }
//    return _interactiveTransition;
//}

- (UIView *)selectedLine {
    if (!_selectedLine) {
        UIView *selectedLine = [[UIView alloc] init];
        selectedLine.jp_size = CGSizeMake(30, 2);
        selectedLine.jp_y = 46 - 1;
        selectedLine.layer.cornerRadius = 1;
        selectedLine.backgroundColor = InfiniteeBlue;
        [self.titleCollectionView addSubview:selectedLine];
        _selectedLine = selectedLine;
    }
    return _selectedLine;
}

- (SunOrderListViewController *)currSolVC {
    if (self.childViewControllers.count >= (_selectedIndex + 1)) {
        return self.childViewControllers[_selectedIndex];
    } else {
        return nil;
    }
}

#pragma mark - init

- (instancetype)initWithDataSource:(NSArray<SunOrderCategoryViewModel *> *)dataSource {
    if (self = [super init]) {
        self.dataSource = dataSource;
    }
    return self;
}

- (instancetype)initWithDataSource:(NSArray<SunOrderCategoryViewModel *> *)dataSource isFromBeginGuide:(BOOL)isFromBeginGuide {
    if (self = [super init]) {
        self.dataSource = dataSource;
        _isFromBeginGuide = isFromBeginGuide;
    }
    return self;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBase];
    [self setupNavigationBar];
    [self setupScrollView];
    [self setupTitleCollectionView];
    [self setupCouponView];
    
    if (self.dataSource.count) {
        NSInteger count = self.dataSource.count;
        for (NSInteger i = 0; i < count; i++) {
            SunOrderCategoryViewModel *socVM = self.dataSource[i];
            socVM.isSelected = i == 0;
        }
        [self setupChildVCs];
    } else {
        NoDataView *noDataView = [NoDataView noDataViewWithTitle:@"正在获取产品分类..." onView:self.view center:CGPointMake(JPPortraitScreenWidth * 0.5, JPPortraitScreenHeight * 0.5)];
        [self.view insertSubview:noDataView belowSubview:self.scrollView];
        [noDataView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(requestSunOrderCategoryData)]];
        noDataView.layer.opacity = 1;
        self.noDataView = noDataView;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.dataSource.count == 0) [self requestSunOrderCategoryData];
    if (_isFromBeginGuide) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    if (_interactiveTransition && gestureRecognizer != _interactiveTransition.pan) return NO;
    return YES;
}

- (void)dealloc {
    JPLog(@"晒单专区死了");
}

#pragma mark - setup subviews

- (void)setupBase {
    _bottomSoViewH = 40;
    if (JPis_iphoneX) _bottomSoViewH += 20;
    
    _isFirstDecelerate = YES;
    self.view.backgroundColor = InfiniteeWhite;
    
    _selColor = SOTitleSelectedColor;
    _norColor = SOTitleDeselectColor;
    _selRgba = [_selColor jp_rgba];
    _norRgba = [_norColor jp_rgba];
    _diffRgba = JPDifferRgba(_norRgba, _selRgba);
    
    self.dataTool = [[JPSunOrderDataTool alloc] init];
}

- (void)setupNavigationBar {
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem itemWithTarget:self andAction:@selector(back) andIcon:@"" isLeft:YES]; // 
    UIBarButtonItem *lSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    lSpaceBarButtonItem.width = JPNaviFixedSpace;
    self.navigationItem.leftBarButtonItems = @[lSpaceBarButtonItem, leftBarButtonItem];
    
    UIBarButtonItem *rSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rSpaceBarButtonItem.width = -3;
    UIBarButtonItem *rightBarButtonItem = [UIBarButtonItem itemWithTarget:self andAction:@selector(textImageList) andIcon:@"" isLeft:NO];
    UIBarButtonItem *rightBarButtonItem2 = [UIBarButtonItem itemWithTarget:self andAction:@selector(imageList) andIcon:@"" isLeft:NO];
    self.navigationItem.rightBarButtonItems = @[rSpaceBarButtonItem, rightBarButtonItem, rightBarButtonItem2];
    
    self.textImageListBtn = rightBarButtonItem.customView;
    self.textImageListBtn.jp_width = 25;
    
    self.imageListBtn = rightBarButtonItem2.customView;
    self.imageListBtn.jp_width = 25;
    
    self.textImageListBtn.tintColor = [UIColor clearColor];
    self.imageListBtn.tintColor = [UIColor clearColor];
    
    [self.textImageListBtn setTitleColor:InfiniteeBlackA(0.5) forState:UIControlStateNormal];
    [self.imageListBtn setTitleColor:InfiniteeBlackA(0.5) forState:UIControlStateNormal];
    [self.textImageListBtn setTitleColor:InfiniteeBlack forState:UIControlStateSelected];
    [self.imageListBtn setTitleColor:InfiniteeBlack forState:UIControlStateSelected];
    
    self.textImageListBtn.selected = YES;
    self.imageListBtn.selected = NO;

    RequestStateTitleView *navTitleView = [[RequestStateTitleView alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    [navTitleView setTitle:@"晒单专区" withState:NormalState];
    self.navigationItem.titleView = navTitleView;
    self.navTitleView = navTitleView;
}

- (void)setupScrollView {
    FullScreenScrollView *scrollView = [[FullScreenScrollView alloc] init];
    scrollView.isNotFull = !_isFromBeginGuide;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.frame = CGRectMake(0, JPNavTopMargin + 46, JPPortraitScreenWidth, JPPortraitScreenHeight - JPNavTopMargin - 46);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    [self jp_contentInsetAdjustmentNever:self.scrollView];
}

- (void)setupTitleCollectionView {
    UICollectionViewFlowLayout *titleLayout = [[UICollectionViewFlowLayout alloc] init];
    titleLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    titleLayout.minimumLineSpacing = 0;
    titleLayout.minimumInteritemSpacing = 0;
    titleLayout.sectionInset = UIEdgeInsetsMake(0, CellMargin, 0, CellMargin);
    UICollectionView *titleCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, JPNavTopMargin, JPPortraitScreenWidth, 46) collectionViewLayout:titleLayout];
    titleCollectionView.backgroundColor = InfiniteeWhite;
    titleCollectionView.delegate = self;
    titleCollectionView.dataSource = self;
    titleCollectionView.showsHorizontalScrollIndicator = NO;
    [titleCollectionView registerClass:[SunOrderTitleCell class] forCellWithReuseIdentifier:SunOrderTitleCellID];
    [self.view addSubview:titleCollectionView];
    self.titleCollectionView = titleCollectionView;
    
    CGFloat h = JPSeparateLineThick + 0.01;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, JPNavTopMargin + 46, JPPortraitScreenWidth, h)];
    line.backgroundColor = InfiniteeBlueA(0.5);
    [self.view addSubview:line];
    self.line = line;
}

- (void)setupChildVCs {
    NSInteger count = self.dataSource.count;
    self.scrollView.contentSize = CGSizeMake(JPPortraitScreenWidth * count, 0);
    _maxHorOffsetX = JPPortraitScreenWidth * (count - 1);
    
    @jp_weakify(self);
    for (NSInteger i = 0; i < count; i++) {
        SunOrderCategoryViewModel *socVM = self.dataSource[i];
        SunOrderListViewController *solVC = [[SunOrderListViewController alloc] initWithSocVM:socVM bottomSoViewH:_bottomSoViewH beginDraggingBlock:^(BOOL isDragUp) {
            @jp_strongify(self);
            if (!self) return;
            [self showOrHideCouponView:isDragUp ? NO : YES];
        } viewSize:self.scrollView.jp_size];
        
        [self addChildViewController:solVC];
        solVC.view.frame = CGRectMake(self.scrollView.jp_width * i, 0, self.scrollView.jp_width, self.scrollView.jp_height);
        [self.scrollView addSubview:solVC.view];
        
        if (i == 0) {
            self.selectedLine.jp_width = socVM.titleWidth;
            self.selectedLine.jp_x = -socVM.titleWidth;
        }
    }
    
//    self.scrollingIndex = -1;
//    [self setupSunOrderInfoListView:0];
    
    self.noDataView.layer.opacity = 0;
    [self.noDataView removeFromSuperview];
    
    if (_isFromBeginGuide) {
        self.selectedLine.jp_x = CellMargin + ViewMargin;
        [self scrollViewDidEndDecelerating:self.scrollView];
        return;
    }
    
    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.selectedLine.jp_x = CellMargin + ViewMargin;
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
        [self scrollViewDidEndDecelerating:self.scrollView];
    }];
}

- (void)setupCouponView {
    UIView *couponView = [[UIView alloc] initWithFrame:CGRectMake(0, JPPortraitScreenHeight - _bottomSoViewH, JPPortraitScreenWidth, _bottomSoViewH)];
    couponView.backgroundColor = JPRGBColor(97, 146, 247);
    
    JPImageView *couponImageView = [JPImageView new];
    couponImageView.clipsToBounds = YES;
    couponImageView.contentMode = UIViewContentModeScaleAspectFill;
    couponImageView.frame = CGRectMake(0, 0, JPPortraitScreenWidth, 40);
    couponImageView.image = [UIImage imageNamed:@"prd_coupon_img_large"];
    [couponView addSubview:couponImageView];
    
    [couponView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goOrderList)]];
    [self.view addSubview:couponView];
    self.couponView = couponView;
}

#pragma mark - Api

- (void)showOrHideListView:(BOOL)isShow {
    self.scrollView.alpha = isShow ? 1 : 0;
}

- (void)showOrHideListCouponView:(BOOL)isShow {
    self.couponView.jp_y = isShow ? JPPortraitScreenHeight - _bottomSoViewH : JPPortraitScreenHeight;
}

- (void)willDismissHandle {
    self.view.backgroundColor = [UIColor clearColor];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.clipsToBounds = NO;
}

- (void)dismissHandle {
    self.titleCollectionView.jp_y = -46 - 1;
    self.line.jp_y = 0 - 1;
    self.couponView.jp_y = JPPortraitScreenHeight;
    [self.noDataView hideWithCompletion:nil];
}

#pragma mark - request data

- (void)requestSunOrderCategoryData {
    self.noDataView.userInteractionEnabled = NO;
    self.noDataView.title = @"正在获取产品分类...";
    [self.noDataView show];
    @jp_weakify(self);
    [self.dataTool requestSunOrderCategoryDataWithSuccessBlock:^(NSArray<SunOrderCategoryViewModel *> *socVMs) {
        @jp_strongify(self);
        if (!self) return;
        BOOL isOriginHadData = self.dataSource.count > 0;
        self.dataSource = [socVMs copy];
        if (isOriginHadData) {
            self.isAnimated = NO;
            [self.titleCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        } else {
            self.isAnimated = YES;
            [self.titleCollectionView reloadData];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GettedSunOrderCategoryData" object:[socVMs copy]];
        [self setupChildVCs];
    } failureBlock:^{
        self.noDataView.userInteractionEnabled = YES;
        self.noDataView.title = @"网络异常，点击重新获取";
    }];
}

#pragma mark - observation navigation method

- (void)back {
    if (self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)textImageList {
    JPLog(@"图文");
    if (!self.textImageListBtn.selected) {
        [self switchList];
    }
}

- (void)imageList {
    JPLog(@"纯图");
    if (!self.imageListBtn.selected) {
        [self switchList];
    }
}

#pragma mark - switch imageText or image

- (void)switchList {
    self.textImageListBtn.selected = !self.textImageListBtn.selected;
    self.imageListBtn.selected = !self.imageListBtn.selected;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchImageTextOrAllImageList" object:@(self.textImageListBtn.selected)];
}

#pragma mark - bottom couponImage animate

- (void)showOrHideCouponView:(BOOL)isShow {
    CGFloat y = isShow ? (JPPortraitScreenHeight - _bottomSoViewH) : JPPortraitScreenHeight;
    [UIView animateWithDuration:0.25 animations:^{
        self.couponView.jp_y = y;
    }];
}

#pragma mark - observation couponView tapAction

- (void)goOrderList {
    [JPProgressHUD showSuccessWithStatus:@"订单列表暂未添加，敬请期待" userInteractionEnabled:YES];
//    if (!JPAccount) {
//        __weak typeof(self) weakSelf = self;
//        [LoginOrRegistePopView showLoginOrRegistePopViewWithSuccessHandle:^(UserAccount *account, BOOL needComplete) {
//            [weakSelf goOrderList];
//        }];
//        return;
//    }
//    UserOrderListMainViewController *uolMVC = [[UserOrderListMainViewController alloc] initWithOrderListType:WaitingSunOrderListType];
//    [self.navigationController pushViewController:uolMVC animated:YES];
}

#pragma mark - childVC display

//- (void)setupSunOrderInfoListView:(NSInteger)index {
//    if (self.scrollingIndex == index) return;
//    self.scrollingIndex = index;
//
//    [self addSunOrderInfoListView:index];
//    [self addSunOrderInfoListView:index - 1];
//    [self addSunOrderInfoListView:index + 1];
//
//    for (NSInteger i = 0; i < index - 2; i++) {
//        [self removeSunOrderInfoListView:i];
//    }
//    for (NSInteger i = index + 2; i < self.dataSource.count; i++) {
//        [self removeSunOrderInfoListView:i];
//    }
//}
//
//- (void)addSunOrderInfoListView:(NSInteger)index {
//    if (index >= self.childViewControllers.count || index < 0) return;
//    SunOrderListViewController *solVC = self.childViewControllers[index];
//    if (![self.scrollView.subviews containsObject:solVC.view]) {
//        solVC.view.frame = CGRectMake(JPPortraitScreenWidth * index, 0, self.scrollView.jp_width, self.scrollView.jp_height);
//        [self.scrollView addSubview:solVC.view];
//    }
//}
//
//- (void)removeSunOrderInfoListView:(NSInteger)index {
//    if (index >= self.childViewControllers.count || index < 0) return;
//    SunOrderListViewController *solVC = self.childViewControllers[index];
//    if ([self.scrollView.subviews containsObject:solVC.view]) {
//        [solVC cancelAllRequestHandle];
//        [solVC.view removeFromSuperview];
//    }
//}

#pragma mark - <UIScrollViewDelegate>

- (void)__updateSelectedIndex {
    CGFloat offsetX = self.scrollView.contentOffset.x;
    CGFloat viewWidth = self.scrollView.jp_width;
    _selectedIndex = JPGetCurrentPageNumber(offsetX, viewWidth);
    _startHorOffsetX = viewWidth * (CGFloat)_selectedIndex;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.titleCollectionView) return;
    [self __updateSelectedIndex];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.titleCollectionView) return;
    if (_isDidClickAnimating) {
        return;
    }
    
    NSInteger sourceIndex = 0;
    NSInteger targetIndex = 0;
    CGFloat progress = 0;
    if ([JPSolveTool pageScrollProgressWithPageSizeValue:scrollView.bounds.size.width
                                               pageCount:self.dataSource.count
                                             offsetValue:scrollView.contentOffset.x
                                          maxOffsetValue:_maxHorOffsetX
                                        startOffsetValue:&_startHorOffsetX
                                             currentPage:&_selectedIndex
                                              sourcePage:&sourceIndex
                                              targetPage:&targetIndex
                                                progress:&progress]) {
        
//        [self setupSunOrderInfoListView:_selectedIndex];
        
        SunOrderTitleCell *sourceCell = (SunOrderTitleCell *)[self.titleCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:sourceIndex inSection:0]];
        SunOrderTitleCell *targetCell = (SunOrderTitleCell *)[self.titleCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0]];
        
        CGFloat sProgress = 1 - progress;
        [sourceCell setTitleColor:[UIColor jp_colorWithRgba:JPFromSourceToTargetRgbaByDifferRgba(_norRgba, _diffRgba, sProgress)]];
        
        [targetCell setTitleColor:[UIColor jp_colorWithRgba:JPFromSourceToTargetRgbaByDifferRgba(_norRgba, _diffRgba, progress)]];
        
        CGRect sourceFrame = sourceCell ? sourceCell.frame : [self.dataSource[sourceIndex] cellFrame];
        CGRect targetFrame = targetCell ? targetCell.frame : [self.dataSource[targetIndex] cellFrame];
        
        CGFloat sourceW = sourceFrame.size.width - 20;
        CGFloat sourceX = sourceFrame.origin.x + 10;
        CGFloat sourceMaxX = CGRectGetMaxX(sourceFrame) - 10;
        
        CGFloat targetW = targetFrame.size.width - 20;
        CGFloat targetX = targetFrame.origin.x + 10;
        CGFloat targetMaxX = CGRectGetMaxX(targetFrame) - 10;
        
        CGFloat lineX;
        CGFloat lineW;
        if (sourceIndex < targetIndex) {
            if (progress <= 0.5) {
                CGFloat diffW = targetMaxX - sourceMaxX;
                lineX = sourceX;
                lineW = sourceW + (progress * 2) * diffW;
            } else {
                CGFloat diffW = targetX - sourceX;
                lineX = sourceX + (progress - 0.5) * 2 * diffW;
                lineW = targetMaxX - lineX;
            }
        } else {
            if (progress <= 0.5) {
                CGFloat diffW = sourceX - targetX;
                lineW = sourceW + (progress * 2) * diffW;
                lineX = sourceMaxX - lineW;
            } else {
                CGFloat diffW = sourceMaxX - targetMaxX;
                lineX = targetX;
                lineW = targetW + (1 - progress) * 2 * diffW;
            }
        }
        self.selectedLine.frame = CGRectMake(lineX, self.selectedLine.jp_y, lineW, self.selectedLine.jp_height);
    }
}

// 调用代码滚动动画停止时会调用该方法，手指滑动停止不会来到这里
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.titleCollectionView) return;
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.titleCollectionView) return;
    if (_isFirstDecelerate) {
        _isFirstDecelerate = NO;
        _isDecelerate = decelerate;
    }
    if (!_isDecelerate) [self scrollViewDidEndDecelerating:scrollView];
}

// 手指滑动动画停止时会调用该方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.titleCollectionView) return;
    _isFirstDecelerate = YES;
    _isDidClickAnimating = NO;
    
    [self __updateSelectedIndex];
    SunOrderCategoryViewModel *selSocVM;
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        SunOrderCategoryViewModel *socVM = self.dataSource[i];
        if (i == _selectedIndex) {
            socVM.isSelected = YES;
            selSocVM = socVM;
        } else {
            socVM.isSelected = NO;
        }
    }
    
    [self.titleCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    self.selectedLine.frame = CGRectMake(selSocVM.cellFrame.origin.x + 10, self.selectedLine.jp_y, selSocVM.cellFrame.size.width - 20, self.selectedLine.jp_height);
    
    SunOrderListViewController *solVC = self.childViewControllers[_selectedIndex];
    [solVC beginRequest];
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SunOrderCategoryViewModel *socVM = self.dataSource[indexPath.item];
    
    SunOrderTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SunOrderTitleCellID forIndexPath:indexPath];
    cell.socVM = socVM;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_selectedIndex == indexPath.item) {
        [self.titleCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        return;
    }
    
    _isDidClickAnimating = YES;
    CGFloat targetOffsetX = indexPath.item * self.scrollView.jp_width;
    
    NSIndexPath *lastIdp = [NSIndexPath indexPathForItem:_selectedIndex inSection:0];
    BOOL isMoreThanOne = labs(_selectedIndex - indexPath.item) > 1;
    BOOL isTurnLeft = indexPath.item < _selectedIndex;
    
    _selectedIndex = indexPath.item;
    
    SunOrderCategoryViewModel *selSocVM;
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        SunOrderCategoryViewModel *socVM = self.dataSource[i];
        if (i == _selectedIndex) {
            socVM.isSelected = YES;
            selSocVM = socVM;
        } else {
            socVM.isSelected = NO;
        }
    }
    
    CGRect selectedLineFrame = CGRectMake(selSocVM.cellFrame.origin.x + 10, self.selectedLine.jp_y, selSocVM.cellFrame.size.width - 20, self.selectedLine.jp_height);
    
    void (^titleAnimateBlock)(void) = ^{
        [self.titleCollectionView performBatchUpdates:^{
            [self.titleCollectionView reloadItemsAtIndexPaths:@[lastIdp, indexPath]];
            [self.titleCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        } completion:nil];
        self.selectedLine.frame = selectedLineFrame;
    };
    
    void (^allCompleteBlock)(void) = ^{
        [self scrollViewDidEndDecelerating:self.scrollView];
    };
    
    void (^animateBlock)(void);
    void (^animateCompleteBlock)(void);
    if (isMoreThanOne) {
        UIView *snapshotView = [self.scrollView snapshotViewAfterScreenUpdates:NO];
        snapshotView.frame = self.scrollView.frame;
        [self.view insertSubview:snapshotView aboveSubview:self.scrollView];
        CGFloat snapshotViewX = (isTurnLeft ? 1.0 : -1.0) * snapshotView.jp_width;
        
        self.scrollView.jp_x = (isTurnLeft ? -1.0 : 1.0) * self.scrollView.jp_width;
        self.scrollView.contentOffset = CGPointMake(targetOffsetX, 0);
        
        animateBlock = ^{
            snapshotView.jp_x = snapshotViewX;
            self.scrollView.jp_x = 0;
        };
        
        animateCompleteBlock = ^{
            [snapshotView removeFromSuperview];
        };
    } else {
        animateBlock = ^{
            [self.scrollView setContentOffset:CGPointMake(targetOffsetX, 0)];
        };
    }
    
//    [self setupSunOrderInfoListView:_selectedIndex];
    
    [UIView animateWithDuration:0.3 animations:^{
        titleAnimateBlock();
        animateBlock();
    } completion:^(BOOL finished) {
        !animateCompleteBlock ? : animateCompleteBlock();
        allCompleteBlock();
    }];
}

- (void)setIsAnimated:(BOOL)isAnimated {
    _isAnimated = isAnimated;
    self.titleCollectionView.userInteractionEnabled = !isAnimated;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isAnimated) {
        cell.alpha = 0;
        cell.jp_x += JPPortraitScreenWidth;
        [UIView animateWithDuration:1.2 delay:0.05 * indexPath.item usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:0 animations:^{
            cell.jp_x -= JPPortraitScreenWidth;
            cell.alpha = 1;
        } completion:^(BOOL finished) {
            if (indexPath.item == collectionView.visibleCells.count - 1) {
                self.isAnimated = NO;
            }
        }];
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    SunOrderCategoryViewModel *socVM = self.dataSource[indexPath.item];
    return socVM.cellFrame.size;
}

@end
