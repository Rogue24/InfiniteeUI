//
//  ThemeListViewController.m
//  Infinitee2.0
//
//  Created by guanning on 2017/6/5.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "ThemeListViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "RecomActivityCell.h"
#import "JPThemeListTransition.h"
#import "ActivityDetailViewController.h"
#import "InfiniteeRefreshFooter.h"

@interface ThemeListViewController ()
@property (nonatomic, strong) NSMutableArray *themes;
@property (nonatomic, assign) BOOL isShowAll;
@property (nonatomic, assign) NSInteger showedCount;
@property (nonatomic, weak) UICollectionViewCell *didSelectedCell;
@property (nonatomic, assign) NSInteger currPage;
@property (nonatomic, weak) UIView *bgView;

@property (nonatomic, assign) BOOL isSpreadOut;
@property (nonatomic, assign) BOOL isEnough;
@end

@implementation ThemeListViewController

- (NSMutableArray *)themes {
    if (!_themes) {
        _themes = [NSMutableArray array];
    }
    return _themes;
}

static NSString * const RecomActivityCellID = @"RecomActivityCell";

+ (instancetype)themeListVCWithThemes:(NSArray<Theme *> *)themes {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat actualWidth = JPPortraitScreenWidth - 2 * ViewMargin;
    CGFloat designWidth = iPhone6Width - 2 * ViewMargin;
    CGFloat actualHeight = actualWidth * (RecCarouselViewHeight / designWidth);
    
    layout.itemSize = CGSizeMake(actualWidth, actualHeight);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(JPNavTopMargin + ViewMargin, 0, ViewMargin + JPDiffTabBarH, 0);
    
    ThemeListViewController *tlVC = [[ThemeListViewController alloc] initWithCollectionViewLayout:layout];
    tlVC.isEnough = themes.count < 15;
    tlVC.themes = [themes mutableCopy];
    
    return tlVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currPage = 1;
    self.view.backgroundColor = [UIColor clearColor];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = JPPortraitScreenBounds;
    bgView.backgroundColor = InfiniteeWhite;
    [self.view insertSubview:bgView atIndex:0];
    self.bgView = bgView;
    
    [self setupCollectionView];
    [self setupNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = nil;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    if (self.didSelectedCell) {
//        self.didSelectedCell = nil;
//        self.bgView.alpha = 1;
//        for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
//            cell.transform = CGAffineTransformIdentity;
//            cell.alpha = 1;
//        }
//        self.collectionView.mj_footer.layer.opacity = 1;
//        [self checkFooterState];
//    }
}

- (void)dealloc {
    for (Theme *theme in self.themes) {
        theme.isShowed = NO;
    }
}

- (void)setupCollectionView {
    [self jp_contentInsetAdjustmentNever:self.collectionView];
    
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:[RecomActivityCell jp_className] bundle:nil] forCellWithReuseIdentifier:RecomActivityCellID];
    
    self.collectionView.mj_footer = [InfiniteeRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData) bottomInset:-5 -JPDiffTabBarH];
    self.collectionView.mj_footer.hidden = YES;
}

- (void)setupNavigationBar {
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem itemWithTarget:self andAction:@selector(back) andIcon:@"" isLeft:YES];
    UIBarButtonItem *lSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    lSpaceBarButtonItem.width = JPNaviFixedSpace;
    self.navigationItem.leftBarButtonItems = @[lSpaceBarButtonItem, leftBarButtonItem];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = InfiniteeBlack;
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.text = @"主题分类";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 请求更多数据

- (void)requestMoreData {}

// 判断footer状态
- (void)checkFooterState {
    
    NSInteger cellCount = self.themes.count;
    
    // 每次刷新数据时，根据是否有数据来控制footer显示或隐藏
    self.collectionView.mj_footer.hidden = cellCount ? NO : YES;
    
    // 判断footer状态
    NSInteger leftCount = [self.collectionView numberOfItemsInSection:0] % 15;
    
    if ((leftCount > 0 && leftCount < 15) || self.isEnough == YES) {
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
    return self.themes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecomActivityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RecomActivityCellID forIndexPath:indexPath];
    
    Theme *theme = self.themes[indexPath.item];
    
    if (cell.theme != theme) {
        cell.theme = theme;
        if (!theme.isShowed) cell.transform = CGAffineTransformTranslate(cell.transform, JPPortraitScreenWidth, 0);
    }
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Theme *theme = self.themes[indexPath.item];
    
    if (theme.isShowed) return;
    
    theme.isShowed = YES;
    
    NSTimeInterval delay = self.isShowAll ? 0 : (0.05 + indexPath.item * 0.04);
    [UIView animateWithDuration:0.7 delay:delay usingSpringWithDamping:0.85 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
        cell.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if (!self.isShowAll) {
            self.showedCount += 1;
            if (self.showedCount == self.collectionView.indexPathsForVisibleItems.count) {
                self.isShowAll = YES;
                self.collectionView.scrollEnabled = YES;
                [self checkFooterState];
            }
        }
    }];
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *selectCell = [collectionView cellForItemAtIndexPath:indexPath];
    self.didSelectedCell = selectCell;
    
    __weak typeof(self) weakSelf = self;
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] initWithTheme:self.themes[indexPath.item] startPushBlock:^{
        [weakSelf spreadOutOrIn:YES diffY:0 isAnimation:YES];
    } startPopBlock:^(BOOL isInteractivePop, CGFloat diffY) {
        [weakSelf spreadOutOrIn:!isInteractivePop diffY:diffY isAnimation:NO];
        if (!isInteractivePop) {
            [weakSelf spreadOutOrIn:NO diffY:0 isAnimation:YES];
        }
    }];
    self.navigationController.delegate = adVC;
    [self.navigationController pushViewController:adVC animated:YES];

}

- (void)spreadOutOrIn:(BOOL)isOut diffY:(CGFloat)diffY isAnimation:(BOOL)isAnimation {
    
//    if (!self.didSelectedCell ||
//        (self.isSpreadOut == isOut && diffY == 0)) return;
    
    if (!self.didSelectedCell) return;
    
    self.isSpreadOut = isOut;
    
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView setContentOffset:self.collectionView.contentOffset animated:YES];
    self.collectionView.mj_footer.layer.opacity = 0;
    
    if (!isOut) {
        if (!isAnimation) {
            for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
                cell.transform = CGAffineTransformIdentity;
                cell.alpha = 1;
            }
            self.bgView.alpha = 1;
            self.collectionView.mj_footer.layer.opacity = 1;
            [self checkFooterState];
        } else {
            [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
                    cell.transform = CGAffineTransformIdentity;
                    cell.alpha = 1;
                }
                self.bgView.alpha = 1;
                self.collectionView.mj_footer.layer.opacity = 1;
            } completion:^(BOOL finished) {
                [self checkFooterState];
            }];
        }
        return;
    }
    
    CGRect frame = [self.didSelectedCell convertRect:self.didSelectedCell.bounds toView:JPKeyWindow];
    
    CGFloat upY = frame.origin.y - (JPNavTopMargin + ViewMargin) + diffY;
    
    NSMutableArray *upCells = [NSMutableArray array];
    NSMutableArray *downCells = [NSMutableArray array];
    
    CGFloat downY = 0;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:self.didSelectedCell];
    for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
        NSInteger cellIndex = [self.collectionView indexPathForCell:cell].item;
        if (cellIndex <= indexPath.item) {
            [upCells addObject:cell];
        } else {
            [downCells addObject:cell];
        }
        
        if (cellIndex == indexPath.item + 1) {
            frame = [cell convertRect:cell.bounds toView:JPKeyWindow];
            downY = JPPortraitScreenHeight - frame.origin.y;
        }
    }
    
    if (!isAnimation) {
        for (UICollectionViewCell *cell in upCells) {
            cell.transform = CGAffineTransformTranslate(cell.transform, 0, -upY);
            if (cell != self.didSelectedCell) {
                cell.alpha = 0;
            }
        }
        for (UICollectionViewCell *cell in downCells) {
            cell.transform = CGAffineTransformTranslate(cell.transform, 0, downY);
            cell.alpha = 0;
        }
        self.collectionView.mj_footer.layer.opacity = 1;
        self.bgView.alpha = 0;
        return;
    }
    
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        for (UICollectionViewCell *cell in upCells) {
            cell.transform = CGAffineTransformTranslate(cell.transform, 0, -upY);
        }
        for (UICollectionViewCell *cell in downCells) {
            cell.transform = CGAffineTransformTranslate(cell.transform, 0, downY);
        }
    } completion:nil];
    
    [UIView animateWithDuration:0.6 animations:^{
        for (UICollectionViewCell *cell in upCells) {
            if (cell != self.didSelectedCell) {
                cell.alpha = 0;
            }
        }
        for (UICollectionViewCell *cell in downCells) {
            cell.alpha = 0;
        }
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        self.collectionView.mj_footer.layer.opacity = 1;
    }];
    
    
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        JPThemeListTransition *transition = [JPThemeListTransition themeListTransition];
        return transition;
    } else {
        return nil;
    }
}

@end
