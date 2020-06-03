//
//  JPPhotoViewController.m
//  Infinitee2.0
//
//  Created by 周健平 on 2018/2/23.
//  Copyright © 2018年 Infinitee. All rights reserved.
//

#import "JPPhotoViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "JPCategoryTitleView.h"
#import "WMPageController.h"
#import "JPPhotoSelectedView.h"
#import "JPAlbumViewModel.h"
//#import "JPImageresizerViewController.h"
#import "JPPhotoCollectionViewController.h"

@interface JPPhotoViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, WMPageControllerDataSource, WMPageControllerDelegate, JPPhotoCollectionViewControllerDelegate>
@property (nonatomic, weak) WMPageController *pageCtr;

@property (nonatomic, copy) void (^replaceHandle)(BOOL isReplaceIcon, UIImage *replaceImage);
@property (nonatomic, copy) void (^procesDoneHandle)(UIImage *procesImage);
@property (nonatomic, assign) BOOL isReplaceIcon;
@property (nonatomic, assign) BOOL isPictureProces;

@property (nonatomic, weak) UILabel *navTitleLabel;

@property (nonatomic, weak) JPCategoryTitleView *titleView;
@property (nonatomic, strong) NSMutableDictionary *pageContentViewFrames;
@property (nonatomic, strong) NSMutableDictionary *photoCollectionVCs;

@property (nonatomic, assign) NSInteger maxSelectedCount;
@property (nonatomic, copy) void (^confirmHandle)(NSArray<JPPhotoViewModel *> *selectedPhotoVMs);
@property (nonatomic, strong) NSMutableArray<JPPhotoViewModel *> *selectedPhotoVMs;
@property (nonatomic, strong) NSMutableArray<JPPhotoCollectionViewController *> *selectedPcVCs;

@property (nonatomic, weak) JPPhotoSelectedView *selectedView;
@end

@implementation JPPhotoViewController
{
    BOOL _isNotFirst;
    BOOL _isDragging;
    CGFloat _startOffsetX;
}

#pragma mark - const

#pragma mark - setter

#pragma mark - getter

- (JPPhotoSelectedView *)selectedView {
    if (!_selectedView) {
        @jp_weakify(self);
        JPPhotoSelectedView *selectedView = [JPPhotoSelectedView photoSelectedViewWithConfirmBlock:^{
            @jp_strongify(self);
            if (!self) return;
            !self.confirmHandle ? : self.confirmHandle(self.selectedPhotoVMs);
            [self back];
        } cancelBlock:^{
            @jp_strongify(self);
            if (!self) return;
            [self removeAllSelectedPhotoVMs];
        }];
        [self.view addSubview:selectedView];
        _selectedView = selectedView;
    }
    return _selectedView;
}

- (NSMutableArray<JPPhotoViewModel *> *)selectedPhotoVMs {
    if (!_selectedPhotoVMs) {
        _selectedPhotoVMs = [NSMutableArray array];
    }
    return _selectedPhotoVMs;
}

- (NSMutableArray<JPPhotoCollectionViewController *> *)selectedPcVCs {
    if (!_selectedPcVCs) {
        _selectedPcVCs = [NSMutableArray array];
    }
    return _selectedPcVCs;
}

- (NSMutableDictionary *)photoCollectionVCs {
    if (!_photoCollectionVCs) {
        _photoCollectionVCs = [NSMutableDictionary dictionary];
    }
    return _photoCollectionVCs;
}

#pragma mark - init

- (instancetype)initWithTitle:(NSString *)title maxSelectedCount:(NSInteger)maxCount confirmHandle:(void(^)(NSArray<JPPhotoViewModel *> *selectedPhotoVMs))confirmHandle {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.title = title;
        self.maxSelectedCount = maxCount;
        self.confirmHandle = confirmHandle;
    }
    return self;
}

+ (instancetype)replaceIconOrBackgroundPicWithIsReplaceIcon:(BOOL)isReplaceIcon title:(NSString *)title replaceHandle:(void(^)(BOOL isReplaceIcon, UIImage *replaceImage))replaceHandle {
    JPPhotoViewController *photoVC = [[self alloc] initWithTitle:title maxSelectedCount:0 confirmHandle:nil];
    photoVC.replaceHandle = replaceHandle;
    photoVC.isPictureProces = YES;
    photoVC.isReplaceIcon = isReplaceIcon;
    return photoVC;
}

+ (instancetype)selectedDesignPictureWithTitle:(NSString *)title procesDoneHandle:(void(^)(UIImage *procesImage))procesDoneHandle {
    JPPhotoViewController *photoVC = [[self alloc] initWithTitle:title maxSelectedCount:0 confirmHandle:nil];
    photoVC.procesDoneHandle = procesDoneHandle;
    photoVC.isPictureProces = YES;
    return photoVC;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBase];
    [self setupNavigationBar];
    [self setupCategoryTitleView];
    [self setupPageController];
    [self setupAlbums];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_isNotFirst) {
        _isNotFirst = YES;
        @jp_weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @jp_strongify(self);
            if (!self) return;
            [UIView transitionWithView:self.navTitleLabel duration:0.35 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                self.navTitleLabel.text = @"长按照片可放大";
            } completion:^(BOOL finished) {
                @jp_weakify(self);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    @jp_strongify(self);
                    if (!self) return;
                    [UIView transitionWithView:self.navTitleLabel duration:0.35 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                        self.navTitleLabel.text = self.title;
                    } completion:nil];
                });
            }];
        });
    }
}

- (void)dealloc {
    [JPPhotoToolSI unRegisterChange];
    JPLog(@"新相册死了");
}

#pragma mark - setup

- (void)setupBase {
    self.view.backgroundColor = UIColor.whiteColor;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.automaticallyAdjustsScrollViewInsets = NO;
#pragma clang diagnostic pop
}

- (void)setupNavigationBar {
    UIBarButtonItem *leftBarButtonItem;
    if (self.navigationController.viewControllers.count == 1) {
        leftBarButtonItem = [UIBarButtonItem itemWithTarget:self andAction:@selector(back) andIcon:@"" isLeft:YES];
    } else {
        leftBarButtonItem = [UIBarButtonItem itemWithTarget:self andAction:@selector(back) andIcon:@"" isLeft:YES];
    }
    UIBarButtonItem *lSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    lSpaceBarButtonItem.width = JPNaviFixedSpace;
    self.navigationItem.leftBarButtonItems = @[lSpaceBarButtonItem, leftBarButtonItem];
    
    UIBarButtonItem *rightBarButtonItem = [UIBarButtonItem itemWithTarget:self andAction:@selector(camcera) andIcon:@"" isLeft:NO];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = self.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.textColor = InfiniteeBlack;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel sizeToFit];
    titleLabel.jp_width = 150;
    self.navigationItem.titleView = titleLabel;
    self.navTitleLabel = titleLabel;
}

- (void)setupCategoryTitleView {
    JPCategoryTitleView *titleView = [JPCategoryTitleView categoryTitleViewWithSideMargin:JPScaleValue(15.0) cellSpace:JPScaleValue(20.0)];
    [self.view addSubview:titleView];
    self.titleView = titleView;
    
    @jp_weakify(self);
    titleView.selectedIndexPathDidChange = ^(NSIndexPath *selectedIndexPath) {
        @jp_strongify(self);
        if (!self) return;
        NSInteger diffIndex = self.pageCtr.selectIndex - selectedIndexPath.item;
        if (diffIndex == 0 || self.pageCtr.scrollView.dragging) {
            return;
        } else if (labs(diffIndex) == 1) {
            [self.pageCtr.scrollView setContentOffset:CGPointMake(self.pageCtr.scrollView.jp_width * selectedIndexPath.item, 0) animated:YES];
        } else {
            UIView *snapshotView = [self.pageCtr.scrollView.superview snapshotViewAfterScreenUpdates:NO];
            [self.pageCtr.scrollView.superview insertSubview:snapshotView aboveSubview:self.pageCtr.scrollView];
            
            BOOL isTurnLeft = diffIndex > 0;
            CGFloat width = self.pageCtr.scrollView.frame.size.width;
            
            self.pageCtr.scrollView.transform = CGAffineTransformMakeTranslation((isTurnLeft ? -1.0 : 1.0) * width, 0);
            [self.pageCtr.scrollView setContentOffset:CGPointMake(width * selectedIndexPath.item, 0)];
            
            [UIView animateWithDuration:0.35 animations:^{
                self.pageCtr.scrollView.transform = CGAffineTransformIdentity;
                snapshotView.transform = CGAffineTransformMakeTranslation((isTurnLeft ? 1.0 : -1.0) * width, 0);
            } completion:^(BOOL finished) {
                [snapshotView removeFromSuperview];
                [self.pageCtr scrollViewDidEndDecelerating:self.pageCtr.scrollView];
            }];
        }
    };
    
    titleView.isNeedAnimatedDidChange = ^(BOOL isNeedAnimated) {
        @jp_strongify(self);
        if (!self) return;
        self.view.userInteractionEnabled = !isNeedAnimated;
    };
}

- (void)setupPageController {
    WMPageController *pageCtr = [[WMPageController alloc] init];
    CGFloat x = 0;
    CGFloat y = self.titleView.jp_maxY;
    CGFloat w = JPPortraitScreenWidth;
    CGFloat h = JPPortraitScreenHeight - y;
    pageCtr.viewFrame = CGRectMake(x, y, w, h);
    pageCtr.dataSource = self;
    pageCtr.delegate = self;
    pageCtr.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:pageCtr.view];
    [self addChildViewController:pageCtr];
    self.pageCtr = pageCtr;
}

#pragma mark - 导航栏按钮响应

- (void)back {
    if (self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)camcera {
    if (self.maxSelectedCount > 0 && self.selectedPhotoVMs.count == self.maxSelectedCount) {
        [JPProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"最多选择%zd张", self.maxSelectedCount] userInteractionEnabled:YES];
        return;
    }
    @jp_weakify(self);
    [JPPhotoToolSI cameraAuthorityWithAllowAccessAuthorityHandler:^{
        @jp_strongify(self);
        if (!self) return;
        [self photograph];
    } refuseAccessAuthorityHandler:^{
        @jp_strongify(self);
        if (!self) return;
        [self photograph];
    } alreadyRefuseAccessAuthorityHandler:^{
        @jp_strongify(self);
        if (!self) return;
        [self photograph];
    } canNotAccessAuthorityHandler:^{
        @jp_strongify(self);
        if (!self) return;
        [self photograph];
    }];
}

#pragma mark - 判断相册权限

- (void)setupAlbums {
    @jp_weakify(self);
    [JPPhotoToolSI albumAccessAuthorityWithAllowAccessAuthorityHandler:^{
        @jp_strongify(self);
        if (!self) return;
        [JPProgressHUD show];
        [self setupDataSource];
    } refuseAccessAuthorityHandler:^{
        @jp_strongify(self);
        if (!self) return;
        [self setupDataSource];
    } alreadyRefuseAccessAuthorityHandler:^{
        @jp_strongify(self);
        if (!self) return;
        [self setupDataSource];
    } canNotAccessAuthorityHandler:nil isRegisterChange:YES];
}

#pragma mark - 配置相册数据源

- (void)setupDataSource {
    self.pageContentViewFrames = [NSMutableDictionary dictionary];
    [JPProgressHUD show];
    @jp_weakify(self);
    [JPPhotoToolSI getAllAssetCollectionWithFastEnumeration:^(PHAssetCollection *collection, NSInteger index, NSInteger totalCount) {
        @jp_strongify(self);
        if (!self) return;
        JPAlbumViewModel *albumVM = [JPAlbumViewModel albumViewModelWithAssetCollection:collection assetTotalCount:totalCount];
        [self.titleView.titleVMs addObject:albumVM];
        
        CGFloat w = self.pageCtr.viewFrame.size.width;
        CGFloat x = index * w;
        CGFloat y = 0;
        CGFloat h = self.pageCtr.viewFrame.size.height;
        CGRect frame = CGRectMake(x, y, w, h);
        self.pageContentViewFrames[@(index)] = @(frame);
    } completion:^{
        [JPProgressHUD dismiss];
        @jp_strongify(self);
        if (!self) return;
        [self.titleView reloadDataWithAnimated:YES];
        [self.pageCtr reloadData];
    }];
}

#pragma mark - 拍照

- (void)photograph {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerController相关逻辑

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (picker.sourceType != UIImagePickerControllerSourceTypeCamera) return;
    
    // 获取选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (!image) {
        if (@available(iOS 13.0, *)) {
            NSURL *url = info[UIImagePickerControllerImageURL];
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        }
    }
    if (!image) {
        [JPProgressHUD showErrorWithStatus:@"照片保存失败" userInteractionEnabled:YES];
        [picker dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    @jp_weakify(self);
    [JPPhotoToolSI savePhotoWithImage:image successHandle:^(NSString *assetID) {
        @jp_strongify(self);
        if (!self) return;
        
        [picker dismissViewControllerAnimated:YES completion:^{
            if (self.isPictureProces) [self imageresizerWithImage:image];
            
            if (self.titleView.titleVMs.count == 0) return;
            
            JPAlbumViewModel *albumVM = (JPAlbumViewModel *)self.titleView.titleVMs.firstObject;
            NSInteger count = albumVM.count.integerValue + 1;
            [self.titleView reloadCount:count inIndex:0];
            
            for (JPPhotoCollectionViewController *pcVC in self.pageCtr.childViewControllers) {
                if (pcVC.albumVM == albumVM) {
                    PHAsset *asset = [JPPhotoToolSI getNewestAsset];
                    JPPhotoViewModel *photoVM = [[JPPhotoViewModel alloc] initWithAsset:asset];
                    if (self.maxSelectedCount > 0) {
                        [self pcVC:pcVC photoDidSelected:photoVM];
                    }
                    [pcVC insertPhotoVM:photoVM atIndex:0];
                    break;
                }
            }
        }];
        
    } failHandle:^{
        [JPProgressHUD showErrorWithStatus:@"图片保存失败" userInteractionEnabled:YES];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - 裁剪图片

- (void)imageresizerWithImage:(UIImage *)image {
//    JPImageresizerType type = JPTheWholePictureResizerType;
//    if (self.replaceHandle) type = self.isReplaceIcon ? JPIconPictureResizerType : JPBackgroundPictureResizerType;
//    @jp_weakify(self);
//    JPImageresizerViewController *imageresizerVC = [[JPImageresizerViewController alloc] initWithResizeImage:image imageresizerType:type imageresizerComplete:^(UIImage *resizeDoneImage) {
//        if (!resizeDoneImage) return;
//        @jp_strongify(self);
//        if (!self) return;
//        [self dismissViewControllerAnimated:YES completion:nil];
//        !self.replaceHandle ? : self.replaceHandle(self.isReplaceIcon, resizeDoneImage);
//        !self.procesDoneHandle ? : self.procesDoneHandle(resizeDoneImage);
//    }];
//    [self.navigationController pushViewController:imageresizerVC animated:YES];
}

#pragma mark - 请求照片

- (void)pcVC:(JPPhotoCollectionViewController *)pcVC requestPhotosWithIndex:(NSInteger)index {
    @jp_weakify(self);
    [pcVC requestPhotosWithComplete:^(NSInteger photoTotal) {
        @jp_strongify(self);
        if (!self) return;
        [self.titleView reloadCount:photoTotal inIndex:index];
    }];
}

#pragma mark - <JPPhotoCollectionViewDelegate>

- (BOOL)pcVC:(JPPhotoCollectionViewController *)pcVC photoDidSelected:(JPPhotoViewModel *)photoVM {
    if (self.maxSelectedCount == 0) {
        JPLog(@"选一张");
        
        if (self.isPictureProces) {
            [JPProgressHUD show];
            @jp_weakify(self); // PHImageManagerMaximumSize
            [JPPhotoToolSI requestOriginalPhotoImageForAsset:photoVM.asset isFastMode:NO isFixOrientation:NO isJustGetFinalPhoto:YES resultHandler:^(PHAsset *requestAsset, UIImage *resultImage, BOOL isFinalImage) {
                [JPProgressHUD dismiss];
                @jp_strongify(self);
                if (!self) return;
                if (!resultImage) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [JPProgressHUD showErrorWithStatus:@"获取照片错误" userInteractionEnabled:YES];
                    });
                    return;
                }
                [self imageresizerWithImage:resultImage];
            }];
        } else {
            !self.confirmHandle ? : self.confirmHandle(@[photoVM]);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        return NO;
    }
    
    BOOL isCanSelected = NO;
    if ([self.selectedPhotoVMs containsObject:photoVM]) {
        photoVM.isSelected = NO;
        
        [self.selectedPhotoVMs removeObject:photoVM];
        
        if ([pcVC.albumVM.selectedPhotoVMs containsObject:photoVM]) {
            [pcVC.albumVM.selectedPhotoVMs removeObject:photoVM];
        }
        
    } else {
        if (self.selectedPhotoVMs.count < self.maxSelectedCount) {
            
            photoVM.isSelected = YES;
            [self.selectedPhotoVMs addObject:photoVM];
            
            [pcVC.albumVM.selectedPhotoVMs addObject:photoVM];
            
            isCanSelected = YES;
        } else {
            [JPProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"最多选择%zd张", self.maxSelectedCount] userInteractionEnabled:YES];
        }
    }
    
    if (self.selectedPhotoVMs.count && !self.selectedView.isShowed) {
        for (JPPhotoCollectionViewController *childVC in self.pageCtr.childViewControllers) {
            UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)childVC.collectionView.collectionViewLayout;
            UIEdgeInsets sectionInset = layout.sectionInset;
            sectionInset.bottom = 8 + self.selectedView.jp_height;
            layout.sectionInset = sectionInset;
            [childVC.collectionView setCollectionViewLayout:layout animated:YES];
        }
    } else if (self.selectedPhotoVMs.count == 0 && self.selectedView.isShowed) {
        for (JPPhotoCollectionViewController *childVC in self.pageCtr.childViewControllers) {
            UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)childVC.collectionView.collectionViewLayout;
            UIEdgeInsets sectionInset = layout.sectionInset;
            sectionInset.bottom = 8;
            layout.sectionInset = sectionInset;
            [childVC.collectionView setCollectionViewLayout:layout animated:YES];
        }
    }
    
    self.selectedView.count = self.selectedPhotoVMs.count;
    
    if (pcVC.albumVM.selectedPhotoVMs.count) {
        if (![self.selectedPcVCs containsObject:pcVC]) {
            [self.selectedPcVCs addObject:pcVC];
        }
    } else {
        if ([self.selectedPcVCs containsObject:pcVC]) {
            [self.selectedPcVCs removeObject:pcVC];
        }
    }
    
    return isCanSelected;
}

- (void)removeAllSelectedPhotoVMs {
    if (self.selectedPhotoVMs.count == 0) return;
    
    for (JPPhotoViewModel *photoVM in self.selectedPhotoVMs) {
        photoVM.isSelected = NO;
    }
    
    for (JPPhotoCollectionViewController *pcVC in self.selectedPcVCs) {
        [pcVC removeSelectedPhotoVMs];
    }
    
    [self.selectedPhotoVMs removeAllObjects];
    [self.selectedPcVCs removeAllObjects];
    
    for (JPPhotoCollectionViewController *childVC in self.pageCtr.childViewControllers) {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)childVC.collectionView.collectionViewLayout;
        UIEdgeInsets sectionInset = layout.sectionInset;
        sectionInset.bottom = 8;
        layout.sectionInset = sectionInset;
        [childVC.collectionView setCollectionViewLayout:layout animated:YES];
    }
    
    self.selectedView.count = 0;
}

#pragma mark - WMPageControllerDataSource, WMPageControllerDelegate

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titleView.titleVMs.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    JPAlbumViewModel *albumVM = (JPAlbumViewModel *)self.titleView.titleVMs[index];
    JPPhotoCollectionViewController *pcVC = [JPPhotoCollectionViewController pcVCWithAlbumVM:albumVM sideMargin:8 cellSpace:2 maxWHSclae:(16.0 / 9.0) maxCol:4 pcVCDelegate:self];
    if (_selectedView && _selectedView.isShowed) {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)pcVC.collectionView.collectionViewLayout;
        UIEdgeInsets sectionInset = layout.sectionInset;
        sectionInset.bottom = 8 + _selectedView.jp_height;
        layout.sectionInset = sectionInset;
        pcVC.collectionView.collectionViewLayout = layout;
    }
    self.photoCollectionVCs[@(index)] = pcVC;
    return pcVC;
}

- (CGRect)pageController:(WMPageController *)pageController viewControllerFrameAtIndex:(NSInteger)index {
    return [self.pageContentViewFrames[@(index)] CGRectValue];
}

- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController index:(NSInteger)index {
    if (self.titleView.selectedIndexPath) {
        if (self.titleView.selectedIndexPath.item == index) {
            [self.titleView resetSelectedLine];
        } else {
            self.titleView.selectedIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
        }
    }
    [self pcVC:(JPPhotoCollectionViewController *)viewController requestPhotosWithIndex:index];
    
    _isDragging = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JPPhotoPageViewScrollDidEnd" object:nil];
    
}

- (void)pageController:(WMPageController *)pageController lazyLoadViewController:(__kindof UIViewController *)viewController index:(NSInteger)index {
    [self pcVC:(JPPhotoCollectionViewController *)viewController requestPhotosWithIndex:index];
}

- (void)pageController:(WMPageController *)pageController scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isDragging = YES;
    
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat scrollViewWidth = pageController.scrollView.bounds.size.width;
    
    NSInteger sourceIndex = (NSInteger)((offsetX + scrollViewWidth * 0.5) / scrollViewWidth);
    _startOffsetX = scrollViewWidth * (CGFloat)sourceIndex;

    JPPhotoCollectionViewController *sourceVC = self.photoCollectionVCs[@(sourceIndex)];
    if (sourceVC) [sourceVC willBeginScorllHandle];

    JPPhotoCollectionViewController *leftVC = self.photoCollectionVCs[@(sourceIndex - 1)];
    if (leftVC) [leftVC willBeginScorllHandle];
    
    JPPhotoCollectionViewController *rightVC = self.photoCollectionVCs[@(sourceIndex + 1)];
    if (rightVC) [rightVC willBeginScorllHandle];
}

- (void)pageController:(WMPageController *)pageController scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_isDragging) return;
    
    NSInteger totalCount = self.titleView.titleVMs.count;
    if (totalCount <= 1) return;
    
    CGFloat viewWidth = scrollView.bounds.size.width;
    
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX < 0) {
        offsetX = 0;
    } else if (offsetX > (scrollView.contentSize.width - viewWidth)) {
        offsetX = (scrollView.contentSize.width - viewWidth);
    }
    
    if (offsetX == _startOffsetX) return;
    
    NSInteger sourceIndex = 0;
    NSInteger targetIndex = 0;
    CGFloat progress = 0;
    
    // 滑动位置与初始位置的距离
    CGFloat offsetDistance = fabs(offsetX - _startOffsetX);
    
    if (offsetX > _startOffsetX) {
        // 左滑动
        sourceIndex = (NSInteger)(offsetX / viewWidth);
        targetIndex = sourceIndex + 1;
        progress = offsetDistance / viewWidth;
        
        // 这里要大于等于1
        // 例如 如果 startOffsetX = 0
        // 若 0 < offsetX < 375，0 < progress < 1，本来 sourceIndex = 0，targetIndex = 1
        // 但 375 <= offsetX，progress >= 1，导致 sourceIndex = 1，targetIndex = 2
        if (progress >= 1) {
            JPLog(@"向左改变");
            if (targetIndex == totalCount) {
                progress = 1;
                targetIndex -= 1;
                sourceIndex -= 1;
            } else {
                progress = 0;
            }
        }
        
        JPPhotoCollectionViewController *sourceVC = self.photoCollectionVCs[@(sourceIndex)];
        if (sourceVC) sourceVC.hideScale = progress;
        
        JPPhotoCollectionViewController *targetVC = self.photoCollectionVCs[@(targetIndex)];
        if (targetVC) targetVC.showScale = progress;
        
    } else {
        // 右滑动
        targetIndex = (NSInteger)(offsetX / viewWidth);
        sourceIndex = targetIndex + 1;
        progress = offsetDistance / viewWidth;
        
        // 这里只能大于1
        // 例如 如果 startOffsetX = 750
        // 若 375 <= offsetX < 750，0 < progress <= 1，本来 targetIndex = 1，sourceIndex = 2
        // 但 375 > offsetX，progress > 1，导致 targetIndex = 0，sourceIndex = 1
        if (progress > 1) {
            JPLog(@"向右改变");
            if (sourceIndex == totalCount) {
                progress = 1;
                targetIndex -= 1;
                sourceIndex -= 1;
            } else {
                progress = 0;
            }
        }
        
        JPPhotoCollectionViewController *sourceVC = self.photoCollectionVCs[@(sourceIndex)];
        if (sourceVC) sourceVC.showScale = 1 - progress;
        
        JPPhotoCollectionViewController *targetVC = self.photoCollectionVCs[@(targetIndex)];
        if (targetVC) targetVC.hideScale = 1 - progress;
    }
    
    if (offsetDistance >= viewWidth) {
        NSInteger index = (NSInteger)((offsetX + viewWidth * 0.5) / viewWidth);
        _startOffsetX = viewWidth * (CGFloat)index;
    }
    
    [self.titleView updateSelectedLineWithSourceIndex:sourceIndex targetIndex:targetIndex progress:progress];
}

@end
