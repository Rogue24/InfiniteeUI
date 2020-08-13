//
//  SunOrderNavigationViewController.m
//  Infinitee2.0
//
//  Created by guanning on 2017/9/1.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "SunOrderNavigationViewController.h"
#import "SunOrderCategoryViewModel.h"
#import "SunOrderTransition.h"
#import "SunOrderAreaViewController.h"

@interface SunOrderNavigationViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic, copy) NSArray<UITableViewCell *> *fromCells;
@end

@implementation SunOrderNavigationViewController

#pragma mark - init

- (instancetype)initWithDataSource:(NSArray<SunOrderCategoryViewModel *> *)dataSource fromCells:(NSArray<UITableViewCell *> *)fromCells {
    SunOrderAreaViewController *soaVC = [[SunOrderAreaViewController alloc] initWithDataSource:dataSource];
    if (self = [super initWithRootViewController:soaVC]) {
        self.fromCells = fromCells;
        self.soaVC = soaVC;
        self.soaVC.isAnimated = YES;
        self.transitioningDelegate = self;
        
#warning JPWarning: 如果modalPresentationStyle设置了UIModalPresentationCustom模式，那么Present的fromVC就不会从容器中移除，也就是它的viewWillDisappear和viewDidDisappear都不会触发，因为没有移除它的view，它的是在toView的底下
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    NSArray *fromCells = self.fromCells;
    self.fromCells = nil;
    return [SunOrderTransition transitionPresentWithFromCells:fromCells];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SunOrderNavigationViewControllerDismiss" object:nil];
    return [SunOrderTransition transitionDismiss];
}

@end
