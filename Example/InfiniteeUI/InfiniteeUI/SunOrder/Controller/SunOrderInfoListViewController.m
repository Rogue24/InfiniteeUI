//
//  SunOrderInfoListViewController.m
//  Infinitee2.0
//
//  Created by guanning on 2017/7/7.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "SunOrderInfoListViewController.h"
#import "SunOrderImageTextCell.h"
#import "SunOrderImageCell.h"
//#import "DetailMainViewController.h"
//#import "JPUserHomePageViewController.h"
#import "InfiniteeRefreshHeader.h"
#import "InfiniteeRefreshFooter.h"
//#import "ShareOpenView.h"
#import "JPBrowseImagesViewController.h"
#import "JPFadeFlowLayout.h"

@interface SunOrderInfoListViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, JPBrowseImagesDelegate>
@property (nonatomic, assign) BOOL isDragUp;
@end

@implementation SunOrderInfoListViewController
{
    BOOL _isFirstDecelerate;
    BOOL _isDecelerate;
    BOOL _isCanSetSameModel;
    BOOL _isSwitching;
    
    CGFloat _currOffsetY;
    CGFloat _bottomSoViewH;
    CGSize _viewSize;
}

static NSString *const SunOrderImageTextCellID = @"SunOrderImageTextCell";
static NSString *const SunOrderImageCellID = @"SunOrderImageCell";

#pragma mark - setter

- (void)setIsDragUp:(BOOL)isDragUp {
    if (_isDragUp == isDragUp) return;
    _isDragUp = isDragUp;
    if ([self isDisplayOnWindow] && self.beginDraggingBlock) self.beginDraggingBlock(isDragUp);
}

#pragma mark - init

- (instancetype)initWithSocVM:(SunOrderCategoryViewModel *)socVM bottomSoViewH:(CGFloat)bottomSoViewH beginDraggingBlock:(void (^)(BOOL isDragUp))beginDraggingBlock viewSize:(CGSize)viewSize {
    if (self = [super init]) {
        self.socVM = socVM;
        self.beginDraggingBlock = beginDraggingBlock;
        _bottomSoViewH = bottomSoViewH;
        _viewSize = viewSize;
    }
    return self;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBase];
    [self setupCollectionView];
    [self setupTableView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 是否正在窗口显示

- (BOOL)isDisplayOnWindow {
    if (!self.view.superview) return NO;
    if (![self.view.superview isKindOfClass:[UIScrollView class]]) return NO;
    UIScrollView *scrollView = (UIScrollView *)self.view.superview;
    return scrollView.contentOffset.x == self.view.jp_x;
}

#pragma mark - 基本配置

- (void)setupBase {
    _isFirstDecelerate = YES;
    self.isImageText = YES;
    self.view.backgroundColor = InfiniteeWhite;
    self.dataTool = [[JPSunOrderDataTool alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchList:) name:@"SwitchImageTextOrAllImageList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goGoodsDetail:) name:kSOGoodsImageDidClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goUserHomePage:) name:kSOUserInfoDidClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(browseSunOrderImages:) name:kSOListImageDidClickNotification object:nil];
}

#pragma mark - 页面布局

- (void)setupCollectionView {
    CGFloat itemWH = SunOrderImageCell.itemWH;
    JPFadeFlowLayout *layout = [[JPFadeFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(ViewMargin, ViewMargin, ViewMargin, ViewMargin);
    layout.minimumLineSpacing = CellMargin;
    layout.minimumInteritemSpacing = CellMargin;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:(CGRect){CGPointZero, _viewSize} collectionViewLayout:layout];
    [self jp_contentInsetAdjustmentNever:collectionView];
    collectionView.backgroundColor = InfiniteeWhite;
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, JPDiffTabBarH, 0);
    collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, JPDiffTabBarH, 0);
    collectionView.alpha = 0;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    collectionView.mj_header = [InfiniteeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestNewData)];
    collectionView.mj_header.ignoredScrollViewContentInsetTop = -5;
    
    collectionView.mj_footer = [InfiniteeRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData) bottomInset:-5];
    collectionView.mj_footer.hidden = YES;
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[SunOrderImageCell class] forCellWithReuseIdentifier:SunOrderImageCellID];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:(CGRect){CGPointZero, _viewSize} style:UITableViewStylePlain];
    [self jp_contentInsetAdjustmentNever:tableView];
    tableView.backgroundColor = InfiniteeWhite;
    tableView.contentInset = UIEdgeInsetsMake(ViewMargin, 0, JPDiffTabBarH, 0);
    tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, JPDiffTabBarH, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.mj_header = [InfiniteeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestNewData)];
    tableView.mj_header.ignoredScrollViewContentInsetTop = 5;
    
    tableView.mj_footer = [InfiniteeRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData) bottomInset:-5];
    tableView.mj_footer.hidden = YES;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[SunOrderImageTextCell class] forCellReuseIdentifier:SunOrderImageTextCellID];
}

#pragma mark - Api

- (void)cancelAllRequestHandle {
    [self.currTask cancel];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    [self.tableView setContentOffset:self.tableView.contentOffset animated:YES];
    [self.collectionView setContentOffset:self.collectionView.contentOffset animated:YES];
    self.isDragUp = NO;
}

#pragma mark - 子类重写方法

#pragma mark cell出现动画

- (void)tableViewWillDisplayCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {}

#pragma mark 数据请求

- (void)requestNewData {}

- (void)requestMoreData {}

#pragma mark 检查footer状态

- (void)checkFooterState {}

#pragma mark - 切换列表

- (void)switchList:(NSNotification *)noti {
    BOOL isImageText = [noti.object boolValue];
    if (self.isImageText == isImageText) return;
    
    self.isImageText = isImageText;
    
    BOOL isNeedAnimate = [self isDisplayOnWindow];
    
    [self cancelAllRequestHandle];
    
    if (!isNeedAnimate) {
        self.tableView.alpha = isImageText ? 1 : 0;
        self.collectionView.alpha = isImageText ? 0 : 1;
        [self.tableView reloadData];
        [self.collectionView reloadData];
        return;
    }
    
    if (!isImageText) {
        JPLog(@"tableView -> collectionView");
        [self.collectionView reloadData];
        [self tableView2CollectionViewAnimate];
    } else {
        JPLog(@"collectionView -> tableView");
        [self.tableView reloadData];
        [self collectionView2TableViewAnimate];
    }
}

- (void)tableView2CollectionViewAnimate {
    JPKeyWindow.userInteractionEnabled = NO;
    _isSwitching = YES;
    
    CGFloat itemWH = SunOrderImageCell.itemWH;
    NSArray *sortedIndexPaths = [self.tableView.indexPathsForVisibleRows sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSIndexPath *path1 = (NSIndexPath *)obj1;
        NSIndexPath *path2 = (NSIndexPath *)obj2;
        return [path1 compare:path2];
    }];
    
    NSMutableArray *targetFrames = [NSMutableArray array];
    NSMutableArray *snapshotViews = [NSMutableArray array];
    NSMutableArray *imageModels = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in sortedIndexPaths) {
        
        SunOrderImageTextCell *imageTextCell = (SunOrderImageTextCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        NSInteger uCount = imageTextCell.detailVM.userImageModels.count;
        for (NSInteger i = 0; i < uCount; i++) {
            SunOrderImageModel *imageModel = imageTextCell.detailVM.userImageModels[i];
            imageModel.isAnimating = YES;
            [imageModels addObject:imageModel];
            
            UIView *imageView = imageTextCell.userListView.picViews[i];
            UIView *snapshotView = [imageView snapshotViewAfterScreenUpdates:NO];
            [snapshotViews addObject:snapshotView];
            
            CGRect frame = [imageView convertRect:imageView.bounds toView:self.view];
            snapshotView.frame = frame;
            [self.view addSubview:snapshotView];
            
            imageView.hidden = YES;
        }
        
        NSInteger gCount = imageTextCell.detailVM.governImageModels.count;
        for (NSInteger i = 0; i < gCount; i++) {
            SunOrderImageModel *imageModel = imageTextCell.detailVM.governImageModels[i];
            imageModel.isAnimating = YES;
            [imageModels addObject:imageModel];
            
            UIView *imageView = imageTextCell.governListView.picViews[i];
            UIView *snapshotView = [imageView snapshotViewAfterScreenUpdates:NO];
            [snapshotViews addObject:snapshotView];
            
            CGRect frame = [imageView convertRect:imageView.bounds toView:self.view];
            snapshotView.frame = frame;
            [self.view addSubview:snapshotView];
            
            imageView.hidden = YES;
        }
    }
    
    NSIndexPath *startIndexPath = sortedIndexPaths.firstObject;
    
    NSInteger startCount = 0;
    if (startIndexPath.item > 0) {
        for (NSInteger i = 0; i < startIndexPath.item; i++) {
            SunOrderDetailViewModel *sodVM = self.socVM.detailVMs[i];
            startCount += (sodVM.userImageModels.count + sodVM.governImageModels.count);
        }
    }
    NSInteger startRow = startCount / 3;
    NSInteger startCol = startCount % 3;
    CGFloat startOffsetY = startRow * (itemWH + CellMargin);
    
    CGFloat diffY = 0;
    NSInteger maxCount = self.socVM.soImageModels.count;
    
    NSInteger maxRow = maxCount / 3;
    if (maxCount % 3 > 0) maxRow += 1;
    
    CGFloat maxH = ViewMargin + itemWH * maxRow + CellMargin * (maxRow - 1) + ViewMargin;
    
    CGFloat maxOffsetY = maxH - (self.collectionView.jp_height - _bottomSoViewH);
    if (maxOffsetY < 0) maxOffsetY = 0;
    
    if (startOffsetY > maxOffsetY) {
        diffY = startOffsetY - maxOffsetY;
        startOffsetY = maxOffsetY;
    }
    
    NSInteger count = snapshotViews.count;
    for (NSInteger i = 0; i < count; i++) {
        NSInteger index = i + startCol;
        NSInteger col = index % 3;
        NSInteger row = index / 3;
        CGFloat x = ViewMargin + itemWH * col + CellMargin * col;
        CGFloat y = ViewMargin + itemWH * row + CellMargin * row;
        y += diffY;
        CGRect frame = CGRectMake(x, y, itemWH, itemWH);
        [targetFrames addObject:[NSValue valueWithCGRect:frame]];
    }
    
    self.collectionView.contentOffset = CGPointMake(0, startOffsetY);
    _currOffsetY = startOffsetY;
    
    [self switchListAnimateWithIsTableVToCollectionV:YES imageModels:imageModels snapshotViews:snapshotViews targetFrames:targetFrames];
}

- (void)collectionView2TableViewAnimate {
    JPKeyWindow.userInteractionEnabled = NO;
    _isSwitching = YES;
    
    for (SunOrderDetailViewModel *sodVM in self.socVM.detailVMs) {
        sodVM.isShowed = YES;
    }
    
    CGFloat itemWH = SunOrderImageListView.itemWH;
    NSArray *sortedIndexPaths = [self.collectionView.indexPathsForVisibleItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSIndexPath *path1 = (NSIndexPath *)obj1;
        NSIndexPath *path2 = (NSIndexPath *)obj2;
        return [path1 compare:path2];
    }];
    
    NSIndexPath *startIndexPath = sortedIndexPaths.firstObject;
    SunOrderImageModel *startImageModel = self.socVM.soImageModels[startIndexPath.item];
    BOOL isStartUserList = startImageModel.isUserList;
    NSInteger startTableIndex = startImageModel.tableIndex;
    
    CGFloat offsetY = 0;
    for (NSInteger i = 0; i < startTableIndex; i++) {
        SunOrderDetailViewModel *sodVM = self.socVM.detailVMs[i];
        offsetY += sodVM.cellHeight;
    }
    
    SunOrderDetailViewModel *startSodVM = self.socVM.detailVMs[startTableIndex];
    
    CGFloat diffY = isStartUserList ? startSodVM.userImageListY : startSodVM.governImageListY;
    offsetY += diffY;
    CGFloat nextDiffY = startSodVM.cellHeight - diffY;
    
    NSMutableArray *snapshotViews = [NSMutableArray array];
    NSMutableArray *targetFrames = [NSMutableArray array];
    NSMutableArray *imageModels = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in sortedIndexPaths) {
        
        SunOrderImageCell *cell = (SunOrderImageCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        UIView *snapshotView = [cell snapshotViewAfterScreenUpdates:NO];
        CGRect frame = [cell convertRect:cell.bounds toView:self.view];
        snapshotView.frame = frame;
        [self.view addSubview:snapshotView];
        [snapshotViews addObject:snapshotView];
        
        cell.hidden = YES;
        
        SunOrderImageModel *imageModel = cell.imageModel;
        imageModel.isAnimating = YES;
        [imageModels addObject:imageModel];
        
        NSInteger tableIndex = imageModel.tableIndex;
        
        SunOrderDetailViewModel *sodVM = self.socVM.detailVMs[tableIndex];
        
        NSInteger col = imageModel.picListIndex % 5;
        NSInteger row = imageModel.picListIndex / 5;
        CGFloat x = 20 + (col * itemWH + col * CellMargin);
        CGFloat y = 5.5 + (row * itemWH + row * CellMargin);
        
        if (startTableIndex == tableIndex) {
            if (isStartUserList != imageModel.isUserList) {
                CGFloat listDiffY = sodVM.governImageListY - sodVM.userImageListY;
                y += listDiffY;
            }
        } else {
            
            y += nextDiffY;
            
            NSInteger diffIndex = tableIndex - startTableIndex;
            if (diffIndex > 1) {
                for (NSInteger i = startTableIndex + 1; i < tableIndex; i++) {
                    SunOrderDetailViewModel *lastSodVM = self.socVM.detailVMs[i];
                    y += lastSodVM.cellHeight;
                }
            }
            
            y += (imageModel.isUserList ? sodVM.userImageListY : sodVM.governImageListY);
            
        }
        
        [targetFrames addObject:[NSValue valueWithCGRect:CGRectMake(x, y, itemWH, itemWH)]];
    }
    
    self.tableView.contentOffset = CGPointMake(0, offsetY);
    
    [self switchListAnimateWithIsTableVToCollectionV:NO imageModels:imageModels snapshotViews:snapshotViews targetFrames:targetFrames];
}

- (void)switchListAnimateWithIsTableVToCollectionV:(BOOL)isTvToCv imageModels:(NSArray *)imageModels snapshotViews:(NSArray *)snapshotViews targetFrames:(NSArray *)targetFrames {
    
    UIScrollView *targetView = isTvToCv ? self.collectionView : self.tableView;
    
    __block BOOL snapshotDone = NO;
    __block BOOL listViewDone = NO;
    void (^allDone)(BOOL aSnapshotDone, BOOL aListViewDone) = ^(BOOL aSnapshotDone, BOOL aListViewDone){
        if (!aSnapshotDone || !aListViewDone) return;
        
        if (isTvToCv) {
            [self.tableView reloadData];
            for (SunOrderImageCell *cell in self.collectionView.visibleCells) {
                [cell animateDone];
            }
        } else {
            [self.collectionView reloadData];
            for (SunOrderImageTextCell *cell in self.tableView.visibleCells) {
                [cell animateDone];
            }
        }
        
        for (SunOrderImageModel *imageModel in imageModels) {
            imageModel.isAnimating = NO;
        }
        
        for (UIView *snapshotView in snapshotViews) {
            [snapshotView removeFromSuperview];
        }
        
        if (targetView.contentSize.height > (targetView.jp_height - self->_bottomSoViewH)) {
            CGFloat maxOffsetY = targetView.contentSize.height - (targetView.jp_height - self->_bottomSoViewH);
            if (targetView.contentOffset.y > maxOffsetY) {
                [targetView setContentOffset:CGPointMake(0, maxOffsetY) animated:YES];
            }
        }

        self->_isCanSetSameModel = isTvToCv;
        
        !self.switchListTypeFinishBlock ? : self.switchListTypeFinishBlock();
        
        JPKeyWindow.userInteractionEnabled = YES;
        self->_isSwitching = NO;
    };
    
    NSInteger count = snapshotViews.count;
    NSTimeInterval duration = 0.7; // 0.5
    CGPoint contentOffset = targetView.contentOffset;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (count == 0) {
            snapshotDone = YES;
            allDone(snapshotDone, listViewDone);
        } else {
            for (NSInteger i = 0; i < count; i++) {
                UIView *snapshotView = snapshotViews[i];
                CGRect frame = [targetFrames[i] CGRectValue];
                [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.85 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    snapshotView.frame = frame;
                } completion:^(BOOL finished) {
                    if (i == count - 1) {
                        snapshotDone = YES;
                        allDone(snapshotDone, listViewDone);
                    }
                }];
            }
        }
        
        targetView.contentOffset = contentOffset; // 不知道为什么会有所改变，有可能是MJRefresh修改的
        [UIView animateWithDuration:duration * 0.5 delay:0 options:kNilOptions animations:^{
            self.tableView.alpha = isTvToCv ? 0 : 1;
            self.collectionView.alpha = isTvToCv ? 1 : 0;
        } completion:^(BOOL finished) {
            listViewDone = YES;
            allDone(snapshotDone, listViewDone);
        }];
    });
}

#pragma mark - <UIScrollViewDelegate>

// 每次手指开始触碰到scrollview，并有开始滚动时触发（减速时手指再触碰滚动也会触发）
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    if ([self isDisplayOnWindow] && self.isFirstDecelerate) {
//        !self.beginDraggingBlock ? : self.beginDraggingBlock();
//    }
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isSwitching) return;
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGFloat insetTop = scrollView.contentInset.top;
    CGFloat insetBottom = scrollView.contentInset.bottom;
    
    CGFloat minOffsetY = -insetTop;
    CGFloat maxOffsetY = scrollView.contentSize.height + insetBottom;
    if (maxOffsetY > scrollView.jp_height) maxOffsetY -= scrollView.jp_height;
    
//    JPLog(@"minOffsetY %.2lf", minOffsetY);
//    JPLog(@"%.2lf <---> %.2lf", offsetY, self.currOffsetY);
//    JPLog(@"maxOffsetY %.2lf", maxOffsetY);
//    JPLog(@"-=-=-=-=-=-=-=-=-=-")
    
    if (scrollView.panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if (offsetY > minOffsetY && offsetY < maxOffsetY) {
            if (offsetY >= _currOffsetY) {
                self.isDragUp = YES;
            } else {
                self.isDragUp = NO;
            }
        } else if (offsetY <= minOffsetY) {
            self.isDragUp = NO;
        } else {
            self.isDragUp = YES;
        }
    }
    
    _currOffsetY = offsetY;
}

// 当是手指的拖动，开始减速时就会触发
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    // 只拿到第一次减速的decelerate值（是否减速）
    // 当第一次触发该方法时，只要decelerate为yes，并且还没滚动停止就会触发scrollViewDidEndDecelerating
    // 例如第一次decelerate为yes，开始减速时手指再次开始拖动，但这次没有减速，即decelerate为no，也会触发scrollViewDidEndDecelerating
    if (_isFirstDecelerate) {
        _isFirstDecelerate = NO;
        _isDecelerate = decelerate;
    }
    
    // 只有第一次decelerate为no，就不会触发scrollViewDidEndDecelerating
    // 所以拿到第一次的decelerate值，只要为no就手动调用停止方法，执行相关业务逻辑
    // 保证从开始滚动到结束（无论中间多少次手指再次滚动），只会执行一次scrollViewDidEndDecelerating
    if (!_isDecelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _isFirstDecelerate = YES;
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return !self.isImageText ? 0 : self.socVM.detailVMs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SunOrderImageTextCell *cell = [tableView dequeueReusableCellWithIdentifier:SunOrderImageTextCellID forIndexPath:indexPath];
    SunOrderDetailViewModel *sodVM = self.socVM.detailVMs[indexPath.row];
    if (_isCanSetSameModel) {
        cell.detailVM = sodVM;
    } else {
        if (cell.detailVM != sodVM) {
            cell.detailVM = sodVM;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self tableViewWillDisplayCell:cell indexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SunOrderDetailViewModel *detailVM = self.socVM.detailVMs[indexPath.item];
    return detailVM.cellHeight;
}

#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.isImageText ? 0 : self.socVM.soImageModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SunOrderImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SunOrderImageCellID forIndexPath:indexPath];
    cell.hidden = NO;
    SunOrderImageModel *soIM = self.socVM.soImageModels[indexPath.item];
    cell.imageModel = soIM;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self browseImageWithImageIndex:indexPath.item];
}

#pragma mark - Observe notification

#pragma mark 查看商品详情

- (void)goGoodsDetail:(NSNotification *)noti {
    if (self.tableView != noti.object) return;
    [JPProgressHUD showSuccessWithStatus:@"商品详情页暂未添加，敬请期待" userInteractionEnabled:YES];
//    CreativeWorks *works = noti.userInfo[@"works"];
//    CGRect frame = [noti.userInfo[@"goodsPictureFrame"] CGRectValue];
//    UIImage *placeholder = noti.userInfo[@"placeholder"];
//    DetailMainViewController *dmVC = [DetailMainViewController detailFromGoodsWithWorks:works placeHolderImage:placeholder goodsImageFrame:frame];
//    [self.navigationController pushViewController:dmVC animated:YES];
}

#pragma mark 查看用户主页

- (void)goUserHomePage:(NSNotification *)noti {
    if (self.tableView != noti.object) return;
    [JPProgressHUD showSuccessWithStatus:@"用户主页暂未添加，敬请期待" userInteractionEnabled:YES];
//    UserAccount *account = noti.userInfo[@"account"];
//    JPUserHomePageViewController *uhpVC = [JPUserHomePageViewController userHomePageVCWithAccount:account];
//    [self.navigationController pushViewController:uhpVC animated:YES];
}

#pragma mark 浏览大图

- (void)browseSunOrderImages:(NSNotification *)noti {
    if (self.tableView != noti.object) return;
    SunOrderImageModel *soIM = noti.userInfo[@"imageModel"];
    NSInteger imageIndex = soIM.allPicIndex;
    [self browseImageWithImageIndex:imageIndex];
}

#pragma mark - 跳转浏览大图

- (void)browseImageWithImageIndex:(NSInteger)imageIndex {
    JPBrowseImagesViewController *browseVC = [JPBrowseImagesViewController browseImagesViewControllerWithDelegate:self totalCount:self.socVM.soImageModels.count currIndex:imageIndex isShowProgress:YES isShowNavigationBar:YES];
    [self presentViewController:browseVC animated:YES completion:nil];
}

- (JPImageView *)soImageTextImageViewWithImageModel:(SunOrderImageModel *)imageModel {
    JPImageView *imageView;
    SunOrderImageTextCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:imageModel.tableIndex inSection:0]];
    if (cell) {
        if (imageModel.isUserList) {
            imageView = cell.userListView.picViews[imageModel.picListIndex];
        } else {
            imageView = cell.governListView.picViews[imageModel.picListIndex];
        }
    }
    return imageView;
}

#pragma mark - <JPBrowseImagesDelegate>

- (UIImageView *)getOriginImageView:(NSInteger)currIndex {
    JPImageView *imageView;
    SunOrderImageModel *currImageModel = self.socVM.soImageModels[currIndex];
    if (self.isImageText) {
        imageView = [self soImageTextImageViewWithImageModel:currImageModel];
    } else {
        SunOrderImageCell *currCell = (SunOrderImageCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:currImageModel.allPicIndex inSection:0]];
        imageView = currCell.imageView;
    }
    return (UIImageView *)imageView;
}

- (void)flipImageViewWithLastIndex:(NSInteger)lastIndex currIndex:(NSInteger)currIndex {
    SunOrderImageModel *lastImageModel = self.socVM.soImageModels[lastIndex];
    SunOrderImageModel *currImageModel = self.socVM.soImageModels[currIndex];
    if (self.isImageText) {
        JPImageView *lastImageView = [self soImageTextImageViewWithImageModel:lastImageModel];
        JPImageView *currImageView = [self soImageTextImageViewWithImageModel:currImageModel];
        if (lastImageView) lastImageView.hidden = NO;
        if (currImageView) currImageView.hidden = YES;
    } else {
        SunOrderImageCell *lastCell = (SunOrderImageCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:lastImageModel.allPicIndex inSection:0]];
        SunOrderImageCell *currCell = (SunOrderImageCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:currImageModel.allPicIndex inSection:0]];
        if (lastCell) lastCell.hidden = NO;
        if (currCell) currCell.hidden = YES;
    }
}

- (void)dismissComplete:(NSInteger)currIndex {
    SunOrderImageModel *currImageModel = self.socVM.soImageModels[currIndex];
    if (self.isImageText) {
        JPImageView *currImageView = [self soImageTextImageViewWithImageModel:currImageModel];
        currImageView.hidden = NO;
    } else {
        SunOrderImageCell *currCell = (SunOrderImageCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:currImageModel.allPicIndex inSection:0]];
        if (currCell) currCell.hidden = NO;
    }
}

- (void)cellRequestImage:(JPBrowseImageCell *)cell
                   index:(NSInteger)index
           progressBlock:(void (^)(NSInteger, JPBrowseImageModel *, float))progressBlock
           completeBlock:(void (^)(NSInteger, JPBrowseImageModel *, UIImage *))completeBlock {
    SunOrderImageModel *model = self.socVM.soImageModels[index];
    UIImage *placeholderImage = [self getOriginImageView:index].image;
    __weak JPBrowseImageModel *wModel = cell.model;
    @jp_weakify(self);
    [cell.imageView jp_fakeSetPictureWithURL:[NSURL URLWithString:[model.baseURLStr jp_imageFormatURLWithSize:JPPortraitScreenSize]] placeholderImage:placeholderImage progress:^(float percent) {
        @jp_strongify(self);
        if (!self || !wModel) return;
        progressBlock(index, wModel, percent);
    } transform:nil completed:^(UIImage *image, NSError *error, NSURL *imageURL, JPWebImageFromType jp_fromType, JPWebImageStage jp_stage) {
        @jp_strongify(self);
        if (!self || !wModel) return;
        completeBlock(index, wModel, image);
    }];
}

- (void)requestImageFailWithModel:(JPBrowseImageModel *)model index:(NSInteger)index {
    [JPProgressHUD showErrorWithStatus:@"图片获取失败" userInteractionEnabled:YES];
}

- (void)browseImagesVC:(JPBrowseImagesViewController *)browseImagesVC navigationOtherHandleWithModel:(JPBrowseImageModel *)model index:(NSInteger)index {
    [JPProgressHUD showErrorWithStatus:@"Demo无法分享~" userInteractionEnabled:YES];
}

@end
