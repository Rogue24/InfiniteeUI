//
//  JPMainViewController.m
//  InfiniteeUI_Example
//
//  Created by 周健平 on 2021/5/22.
//  Copyright © 2021 zhoujianping24@hotmail.com. All rights reserved.
//

#import "JPMainViewController.h"
#import "JPDynamicPage.h"
#import "JPMainCell.h"
#import "CustomNavBgView.h"
#import "UIImageView+JPExtension.h"
#import "SunOrderAreaViewController.h"
#import "JPPhotoViewController.h"
#import "ThemeListViewController.h"

@interface JPMainViewController () <UICollectionViewDataSource>
@property (nonatomic, weak) JPDynamicPage *dp;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray<JPMainCellModel *> *dataSource;
@end

@implementation JPMainViewController

#pragma mark - 常量

#pragma mark - setter

#pragma mark - getter

- (NSArray<JPMainCellModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = JPMainCellModel.cellModels;
    }
    return  _dataSource;
}

#pragma mark - 创建方法

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    [self __setupBase];
    [self __setupNavigationBar];
    [self __setupDynamicPage];
    [self __setupCollectionView];
    [self __changBgColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
#pragma clang diagnostic pop
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.dp startAnimation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.dp stopAnimation];
}

#pragma mark - 初始布局

- (void)__setupBase {
    self.view.backgroundColor = InfiniteeBlue;
}

- (void)__setupNavigationBar {
    [self.navigationController.navigationBar jp_setupCustomNavigationBgView:[CustomNavBgView customNavBgView]];
    
    UIImage *image = [UIImage imageNamed:@"infiniteeUiLogo.png"];
    UIImageView *logoView = ({
        UIImageView *aImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44 * (image.size.width / image.size.height), 44)];
        aImgView.image = image;
        aImgView.contentMode = UIViewContentModeScaleAspectFit;
        aImgView;
    });
    self.navigationItem.titleView = logoView;
}

- (void)__setupDynamicPage {
    JPDynamicPage *dp = [JPDynamicPage dynamicPage];
    [self.view insertSubview:dp atIndex:0];
    self.dp = dp;
}

- (void)__setupCollectionView {
    CGFloat magin = JPScaleValue(10);
    CGFloat space = JPScaleValue(10);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = space;
    flowLayout.minimumInteritemSpacing = space;
    flowLayout.sectionInset = UIEdgeInsetsMake(JPNavTopMargin + magin, magin, JPDiffTabBarH, magin);
    
    NSInteger colCount = 2;
    CGFloat w = ((JPPortraitScreenWidth - magin - magin) - (colCount - 1) * space) / (CGFloat)colCount;
    CGFloat h = w * (9.0 / 16.0);
    flowLayout.itemSize = CGSizeMake(w, h);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:JPPortraitScreenBounds collectionViewLayout:flowLayout];
    [self jp_contentInsetAdjustmentNever:collectionView];
    collectionView.autoresizingMask = UIViewAutoresizingNone;
    collectionView.backgroundColor = UIColor.clearColor;
    collectionView.alwaysBounceVertical = YES;
    collectionView.delaysContentTouches = NO;
    [collectionView registerClass:JPMainCell.class forCellWithReuseIdentifier:@"JPMainCell"];
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

- (void)__changBgColor {
    @jp_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @jp_strongify(self);
        if (!self) return;
        [self.view jp_addPOPBasicAnimationWithPropertyNamed:kPOPViewBackgroundColor toValue:JPRandomColor duration:2.0 completionBlock:^(POPAnimation *anim, BOOL finished) {
            @jp_strongify(self);
            if (!self) return;
            [self __changBgColor];
        }];
    });
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JPMainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPMainCell" forIndexPath:indexPath];
    if (!cell.didClickCell) {
        @jp_weakify(self);
        cell.didClickCell = ^(JPMainCellModel *kCellModel) {
            @jp_strongify(self);
            if (!self) return;
            [self jumpVC:kCellModel];
        };
    }
    cell.cellModel = self.dataSource[indexPath.item];
    return cell;
}

#pragma mark - 跳转

- (void)jumpVC:(JPMainCellModel *)cellModel {
    switch (cellModel.type) {
        case JPMainCellModelType_SunOrder:
        {
            SunOrderAreaViewController *soaVC = [[SunOrderAreaViewController alloc] initWithDataSource:nil isFromBeginGuide:NO];
            [self.navigationController pushViewController:soaVC animated:YES];
            break;
        }
            
        case JPMainCellModelType_ThemeActivity:
        {
            [JPProgressHUD show];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *filePath = JPMainBundleResourcePath(@"themes", @"plist");
                NSDictionary *resultDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
                NSArray *themes = [Theme mj_objectArrayWithKeyValuesArray:resultDic[@"themes"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [JPProgressHUD dismiss];
                    ThemeListViewController *tlVC = [ThemeListViewController themeListVCWithThemes:themes];
                    self.navigationController.delegate = tlVC;
                    [self.navigationController pushViewController:tlVC animated:YES];
                });
            });
            break;
        }
            
        case JPMainCellModelType_PhotoAlbum:
        {
            @jp_weakify(self);
            JPPhotoViewController *photoVC =[[JPPhotoViewController alloc] initWithTitle:@"选择照片" maxSelectedCount:5 confirmHandle:^(NSArray<JPPhotoViewModel *> *selectedPhotoVMs) {
                @jp_strongify(self);
                if (!self) return;
                
            }];
            [self.navigationController pushViewController:photoVC animated:YES];
            break;
        }
            
        default:
            [JPProgressHUD showSuccessWithStatus:@"敬请期待~" userInteractionEnabled:YES];
            break;
    }
}

@end
