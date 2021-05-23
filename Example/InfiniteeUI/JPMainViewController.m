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
#import "UINavigationBar+JPExtension.h"
#import "CustomNavBgView.h"
#import "SunOrderAreaViewController.h"
#import "JPPhotoViewController.h"
#import "UIImageView+JPExtension.h"

@interface JPMainViewController () <UICollectionViewDataSource>
@property (nonatomic, weak) JPDynamicPage *dp;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<NSString *> *subVcNames;
@end

@implementation JPMainViewController

#pragma mark - 常量

#pragma mark - setter

#pragma mark - getter

#pragma mark - 创建方法

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    [self __setupBase];
    [self __setupNavigationBar];
    [self __setupDynamicPage];
    [self __setupCollectionView];
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.dp stopAnimation];
}

#pragma mark - 初始布局

- (void)__setupBase {
    self.view.backgroundColor = InfiniteeBlue;
    self.subVcNames = @[@" 晒单专区",
                        @" 个人主页",
                        @" 产品详情页",
                        @" 商品详情页",
                        @" 作品详情页",
                        @" 主题活动中心",
                        @" Infinitee相册"];
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

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.subVcNames.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JPMainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPMainCell" forIndexPath:indexPath];
    
    cell.bounceView.alpha = 0.9;
    cell.bounceView.backgroundColor = InfiniteeBlack;
    cell.bounceView.tag = indexPath.item;
    
    [cell.imageView jp_fakeSetPictureCacheMemoryOnlyWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://picsum.photos/400/200?random=%zd", JPRandomNumber(1, 100)]] placeholderImage:nil];
    
    NSString *subVcName = self.subVcNames[indexPath.item];
    NSArray<NSString *> *strs = [subVcName componentsSeparatedByString:@" "];
    cell.iconLabel.text = strs.firstObject;
    cell.titleLabel.text = strs.lastObject;
    
    if (!cell.bounceView.viewTouchUpInside) {
        @jp_weakify(self);
        cell.bounceView.viewTouchUpInside = ^(JPBounceView *kBounceView) {
            @jp_strongify(self);
            if (!self) return;
            [self jumpVC:kBounceView.tag];
        };
    }
    
    return cell;
}

#pragma mark - 跳转

- (void)jumpVC:(NSInteger)index {
    switch (index) {
        case 0:
        {
            SunOrderAreaViewController *soaVC = [[SunOrderAreaViewController alloc] initWithDataSource:nil isFromBeginGuide:NO];
            [self.navigationController pushViewController:soaVC animated:YES];
            break;
        }
        case 6:
        {
            @jp_weakify(self);
            JPPhotoViewController *photoVC =[[JPPhotoViewController alloc] initWithTitle:@"选择照片" maxSelectedCount:5 confirmHandle:^(NSArray<JPPhotoViewModel *> *selectedPhotoVMs) {
                @jp_strongify(self);
                if (!self) return;
                
            }];
            [self.navigationController pushViewController:photoVC animated:YES];
        }
        default:
            [JPProgressHUD showSuccessWithStatus:@"敬请期待~" userInteractionEnabled:YES];
            break;
    }
}

@end
