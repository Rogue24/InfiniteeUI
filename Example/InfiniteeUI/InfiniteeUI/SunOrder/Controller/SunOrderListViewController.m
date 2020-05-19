//
//  SunOrderListViewController.m
//  Infinitee2.0
//
//  Created by guanning on 2017/7/27.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "SunOrderListViewController.h"
#import "JPSunOrderDataTool.h"
#import "InfiniteeRefreshHeader.h"
#import "InfiniteeRefreshFooter.h"
#import "SunOrderImageTextCell.h"
#import "NoDataView.h"

@interface SunOrderListViewController ()
- (UIScrollView *)currScrollView;
@property (nonatomic, weak) NoDataView *noDataView;
@property (nonatomic, assign) NSTimeInterval delay;
@end

@implementation SunOrderListViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NoDataView *noDataView = [NoDataView noDataViewWithTitle:[NSString stringWithFormat:@"%@的晒单", self.socVM.socModel.name] onView:self.view center:CGPointMake(JPPortraitScreenWidth * 0.5, JPPortraitScreenHeight * 0.5 - 46 - JPNavTopMargin)];
    [noDataView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginRequest)]];
    noDataView.userInteractionEnabled = NO;
    noDataView.layer.opacity = 1;
    self.noDataView = noDataView;
    
    __weak typeof(self) weakSelf = self;
    self.switchListTypeFinishBlock = ^{
        if (weakSelf.socVM.detailVMs.count == 0) {
            [weakSelf beginRequest];
        } else {
            [weakSelf checkFooterState];
        }
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissHandle) name:@"SunOrderNavigationViewControllerDismiss" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Api

- (void)beginRequest {
    if (!self.socVM.isRequestSunOrderDataSuccess) {
        if (self.isImageText && self.socVM.detailVMs.count) {
            [self.tableView.mj_header beginRefreshing];
        } else if (!self.isImageText && self.socVM.soImageModels.count) {
            [self.collectionView.mj_header beginRefreshing];
        } else {
            [self requestNewData];
        }
    } else {
        [self checkFooterState];
    }
}

- (void)dismissAnimated {
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    self.view.clipsToBounds = NO;
    self.tableView.clipsToBounds = NO;
    self.collectionView.clipsToBounds = NO;
    
    if (self.isImageText) {
        [self.tableView setContentOffset:self.tableView.contentOffset animated:YES];
        CGFloat tableVH = self.tableView.jp_height;
        CGFloat offsetY = self.tableView.contentOffset.y;
        for (UITableViewCell *cell in self.tableView.visibleCells) {
            [cell.layer pop_removeAllAnimations];
            CGFloat cellY = cell.jp_y - offsetY;
            CGFloat diffY = tableVH - cellY;
            [UIView animateWithDuration:0.35 animations:^{
                cell.jp_y += diffY;
            }];
        }
    } else {
        [self.collectionView setContentOffset:self.collectionView.contentOffset animated:YES];
        NSMutableArray *visibleCells = [self.collectionView.visibleCells mutableCopy];
        if (visibleCells.count == 0) return;
        
        BOOL change1 = NO;
        BOOL change2 = NO;
        BOOL left = YES;
        CGPoint center = CGPointMake(JPPortraitScreenWidth * 0.5, JPPortraitScreenHeight * 0.5);
        CGFloat distance = JPPortraitScreenHeight * 0.75;
        NSInteger count = visibleCells.count;
        for (NSInteger i = 0; i < count; i++) {
            
            NSInteger index = arc4random() % visibleCells.count;
            UICollectionViewCell *cell = visibleCells[index];
            [visibleCells removeObject:cell];
            [cell.layer removeAllAnimations];
            
            CGPoint oCenter = cell.center;
            CGPoint cCenter = [cell.superview convertPoint:oCenter toView:nil];
            
            if (cCenter.x == center.x || cCenter.y == center.y) {
                if (cCenter.y < center.y) {
                    oCenter.y -= distance;
                    if (change1) {
                        oCenter.x = oCenter.x + (left ? distance * 0.5 : -distance * 0.5);
                        left = !left;
                    } else {
                        change1 = YES;
                    }
                } else {
                    oCenter.y += distance;
                    if (change2) {
                        oCenter.x = oCenter.x + (left ? distance * 0.5 : -distance * 0.5);
                        left = !left;
                    } else {
                        change2 = YES;
                    }
                }
            } else if (cCenter.x < center.x && cCenter.y < center.y) {
                // 第一区间
                oCenter.x -= distance;
                oCenter.y -= distance;
            } else if (cCenter.x > center.x && cCenter.y < center.y) {
                // 第二区间
                oCenter.x += distance;
                oCenter.y -= distance;
            } else if (cCenter.x > center.x && cCenter.y > center.y) {
                // 第三区间
                oCenter.x += distance;
                oCenter.y += distance;
            } else if (cCenter.x < center.x && cCenter.y > center.y) {
                // 第四区间
                oCenter.x -= distance;
                oCenter.y += distance;
            }
            
            [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:0.1 options:0 animations:^{
                cell.center = oCenter;
            } completion:nil];
        }
    }
}

#pragma mark - Observe notification

// 退出处理
- (void)dismissHandle {
    if (!self.view.superview) return;
    [self.noDataView hideWithCompletion:nil];
    self.tableView.mj_header.alpha = 0;
    self.tableView.mj_footer.alpha = 0;
    self.collectionView.mj_header.alpha = 0;
    self.collectionView.mj_footer.alpha = 0;
}

#pragma mark - 私有方法

- (UIScrollView *)currScrollView {
    if (self.isImageText) return self.tableView;
    return self.collectionView;
}

- (void)tableViewWillDisplayCell:(SunOrderImageTextCell *)cell indexPath:(NSIndexPath *)indexPath {
    SunOrderDetailViewModel *sodVM = self.socVM.detailVMs[indexPath.row];
    if (sodVM.cellFrame.size.width == 0) {
        sodVM.cellFrame = cell.frame;
        sodVM.cellPosition = cell.center;
    }
    
    [cell pop_removeAllAnimations];
    
    
    
    if (sodVM.isShowed) {
        cell.alpha = 1;
        cell.center = sodVM.cellPosition;
        cell.userInteractionEnabled = YES;
        return;
    }
    
    sodVM.isShowed = YES;
    
    cell.alpha = 0;
    cell.center = CGPointMake(sodVM.cellPosition.x, sodVM.cellPosition.y + JPScaleValue(100));
    cell.userInteractionEnabled = NO;
    
    CGFloat speed = 8;
    CGFloat bounciness = 8;
    NSTimeInterval beginTime = CACurrentMediaTime() + self.delay;
    
    POPSpringAnimation *anim1 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim1.fromValue = @(cell.alpha);
    anim1.toValue = @1;
    anim1.springSpeed = speed;
    anim1.springBounciness = bounciness;
    anim1.dynamicsTension *= 0.5;
    anim1.dynamicsMass *= 0.85;
    anim1.beginTime = beginTime;
    [cell pop_addAnimation:anim1 forKey:kPOPViewAlpha];
    
    POPSpringAnimation *anim2 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim2.fromValue = @(cell.center);
    anim2.toValue = @(sodVM.cellPosition);
    anim2.springSpeed = speed;
    anim2.springBounciness = bounciness;
    anim2.dynamicsTension *= 0.5;
    anim2.dynamicsMass *= 0.85;
    anim2.beginTime = beginTime;
    anim2.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            cell.userInteractionEnabled = YES;
            self.delay = 0;
        }
    };
    [cell pop_addAnimation:anim2 forKey:kPOPViewCenter];
}

#pragma mark - 数据请求

- (void)requestNewData {
    self.currScrollView.mj_header.alpha = 1;
    if (self.currScrollView.mj_footer.alpha > 0) [self.currScrollView.mj_footer endRefreshing];
    
    self.noDataView.userInteractionEnabled = NO;
    if (self.socVM.detailVMs.count == 0) {
        self.noDataView.title = [NSString stringWithFormat:@"正在获取%@的晒单...", self.socVM.socModel.name];
        [self.noDataView show];
    } else {
        [self.noDataView hideWithCompletion:nil];
    }
    
    NSString *ID = self.socVM.socModel.ID;
    NSInteger page = 1;
    NSInteger imageIndex = 0;
    NSString *lastTime = @"";
    
    [self.currTask cancel];
    @jp_weakify(self);
    self.currTask = [self.dataTool requestSunOrderDataWithCategoryID:ID page:page imageIndex:imageIndex lastTime:lastTime successBlock:^(NSInteger page, NSInteger totalResult, NSString *lastTime, NSArray<SunOrderDetailViewModel *> *sodVMs, NSArray<SunOrderImageModel *> *soIMs) {
        @jp_strongify(self);
        if (!self) return;
        
        [self.noDataView hideWithCompletion:^{
            [self.noDataView removeFromSuperview];
            self.noDataView = nil;
        }];
        
        self.socVM.isRequestSunOrderDataSuccess = YES;
        self.socVM.detailVMs = sodVMs;
        self.socVM.soImageModels = soIMs;
        self.socVM.page = 1;
        self.socVM.lastTime = lastTime;
        self.socVM.total = totalResult;
        
        if (self.socVM.socModel.ID.length == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DiscoverUpdateSunOrderData" object:nil];
        }
        
        if (self.isImageText) {
            [UIView animateWithDuration:0.35 animations:^{
                for (UITableViewCell *cell in self.tableView.visibleCells) {
                    cell.layer.opacity = 0;
                }
            } completion:^(BOOL finished) {
                if (self.currScrollView.mj_header.isRefreshing) {
                    [self.currScrollView.mj_header endRefreshingWithCompletionBlock:^{
                        self.delay = 0.15;
                        [self.tableView reloadData];
                        [self checkFooterState];
                    }];
                } else {
                    self.delay = 0.15;
                    [self.tableView reloadData];
                    [self checkFooterState];
                }
            }];
        } else {
            if (self.currScrollView.mj_header.isRefreshing) {
                [self.currScrollView.mj_header endRefreshingWithCompletionBlock:^{
                    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                    [self checkFooterState];
                }];
            } else {
                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                [self checkFooterState];
            }
        }
        
    } failureBlock:^{
        @jp_strongify(self);
        if (!self) return;
        [self.currScrollView.mj_header setEndRefreshingCompletionBlock:nil];
        [self checkFooterState];
        if (self.socVM.detailVMs.count == 0) {
            self.noDataView.title = @"网络异常，点击重新获取";
            self.noDataView.userInteractionEnabled = YES;
            [self.noDataView show];
        } else {
            [JPProgressHUD showErrorWithStatus:@"网络异常，晒单数据获取失败" userInteractionEnabled:YES];
        }
    }];
}

- (void)requestMoreData {
    [self.currScrollView.mj_header endRefreshing];
    
    NSString *ID = self.socVM.socModel.ID;
    NSInteger page = self.socVM.page + 1;
    NSInteger imageIndex = self.socVM.soImageModels.count;
    NSString *lastTime = self.socVM.lastTime;
    
    [self.currTask cancel];
    @jp_weakify(self);
    self.currTask = [self.dataTool requestSunOrderDataWithCategoryID:ID page:page imageIndex:imageIndex lastTime:lastTime successBlock:^(NSInteger page, NSInteger totalResult, NSString *lastTime, NSArray<SunOrderDetailViewModel *> *sodVMs, NSArray<SunOrderImageModel *> *soIMs) {
        @jp_strongify(self);
        if (!self) return;
        
        self.socVM.page = page;
        [self.currScrollView.mj_footer endRefreshing];
        
        NSMutableArray *currSodVMs = [self.socVM.detailVMs mutableCopy];
        NSMutableArray *currSoIMs = [self.socVM.soImageModels mutableCopy];
        
        NSMutableArray *indexPaths = [NSMutableArray array];
        NSInteger count = self.isImageText ? sodVMs.count : soIMs.count;
        if (count > 0) {
            NSInteger beginIndex = currSodVMs.count;
            if (!self.isImageText) beginIndex = currSoIMs.count;
            
            for (NSInteger i = 0; i < count; i++) {
                NSIndexPath *indexPath;
                if (self.isImageText) {
                    indexPath = [NSIndexPath indexPathForRow:(beginIndex + i) inSection:0];
                } else {
                    indexPath = [NSIndexPath indexPathForItem:(beginIndex + i) inSection:0];
                }
                [indexPaths addObject:indexPath];
            }
            
            [currSodVMs addObjectsFromArray:sodVMs];
            [currSoIMs addObjectsFromArray:soIMs];
        }
        
        self.socVM.detailVMs = currSodVMs;
        self.socVM.soImageModels = currSoIMs;
        
        if (indexPaths.count) {
            if (self.isImageText) {
                [self.tableView reloadData];
            } else {
                [self.collectionView insertItemsAtIndexPaths:indexPaths];
            }
        }
        
        [self checkFooterState];
        
    } failureBlock:^{
        @jp_strongify(self);
        if (!self) return;
        [self checkFooterState];
        [JPProgressHUD showErrorWithStatus:@"网络异常，晒单数据获取失败" userInteractionEnabled:YES];
    }];
}

#pragma mark 检查footer状态

- (void)checkFooterState {
    [self.currScrollView.mj_header endRefreshing];
    [self.currScrollView.mj_footer endRefreshing];
    NSInteger dataCount = self.socVM.detailVMs.count;
    if (dataCount) {
        if (self.currScrollView.mj_footer.hidden) {
            self.currScrollView.mj_footer.hidden = NO;
            self.currScrollView.mj_footer.alpha = 0;
            [self.currScrollView.mj_footer jp_addPOPBasicAnimationWithPropertyNamed:kPOPViewAlpha toValue:@1 duration:0.2];
        }
        if (dataCount == self.socVM.total) {
            [self.currScrollView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.currScrollView.mj_footer resetNoMoreData];
        }
    } else {
        if (!self.currScrollView.mj_footer.hidden) {
            [self.currScrollView.mj_footer jp_addPOPBasicAnimationWithPropertyNamed:kPOPViewAlpha toValue:@0 duration:0.2 completionBlock:^(POPAnimation *anim, BOOL finished) {
                if (finished) self.currScrollView.mj_footer.hidden = YES;
            }];
        }
    }
}

@end
