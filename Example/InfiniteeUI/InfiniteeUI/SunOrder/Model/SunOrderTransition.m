//
//  SunOrderTransition.m
//  Infinitee2.0
//
//  Created by guanning on 2017/9/1.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "SunOrderTransition.h"
#import "SunOrderNavigationViewController.h"
#import "SunOrderAreaViewController.h"
#import "SunOrderListViewController.h"
#import "JPInteractiveTransition.h"

@interface SunOrderTransition ()
@property (nonatomic, assign) JPTransitionType type;
@property (nonatomic, copy) NSArray *fromCells;
@end

@implementation SunOrderTransition

+ (instancetype)transitionPresentWithFromCells:(NSArray<UITableViewCell *> *)fromCells {
    SunOrderTransition *transition = [[self alloc] initWithTransitionType:JPTransitionPresent];
    transition.fromCells = fromCells;
    return transition;
}

+ (instancetype)transitionDismiss {
    SunOrderTransition *transition = [[self alloc] initWithTransitionType:JPTransitionDismiss];
    return transition;
}

- (instancetype)initWithTransitionType:(JPTransitionType)type {
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}



- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.75;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    [transitionContext completeTransition:YES];
    
//    //为了将两种动画的逻辑分开，变得更加清晰，我们分开书写逻辑，
//    switch (_type) {
//        case JPTransitionPresent:
//            [self presentAnimation:transitionContext];
//            break;
//
//        case JPTransitionDismiss:
//            [self dismissAnimation:transitionContext];
//            break;
//
//        default:
//            JPLog(@"用错转场方式了");
//            [transitionContext completeTransition:YES];
//            break;
//    }
}


/**
 *  实现present动画
 */
//- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
//
//    JPKeyWindow.userInteractionEnabled = NO;
//
//    UIView *containerView = [transitionContext containerView];
//
//    JPTabBarController *fromVC = (JPTabBarController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    [containerView addSubview:fromVC.view];
//
//    // 5是tabbar突出来的部分
//    UIView *tabbarView = [fromVC.tabBar resizableSnapshotViewFromRect:CGRectMake(0, -5, fromVC.tabBar.jp_width, fromVC.tabBar.jp_height + 5) afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
//    tabbarView.frame = CGRectMake(0, JPPortraitScreenHeight - tabbarView.jp_height, tabbarView.jp_width, tabbarView.jp_height);
//    fromVC.tabBar.hidden = YES;
//
//    CGFloat y = SunOrderListBaseY;
//    CGFloat maxY = JPPortraitScreenHeight - y;
//    NSTimeInterval duration = 0.85;
//    NSInteger cellCount = self.fromCells.count;
//    NSMutableArray *cellViews = [NSMutableArray array];
//    for (NSInteger i = 0; i < cellCount; i++) {
//
//        UITableViewCell *cell = self.fromCells[i];
//
//        if (y > JPPortraitScreenHeight) {
//            cell.hidden = YES;
//            continue;
//        }
//
//        CGRect frame = [cell convertRect:cell.bounds toView:JPKeyWindow];
//        cell.hidden = YES;
//
//        UIView *cellView = [cell snapshotViewAfterScreenUpdates:NO];
//        cellView.frame = frame;
//        [containerView addSubview:cellView];
//        [cellViews addObject:cellView];
//
//        y += frame.size.height;
//        if (i == 0) {
//            duration = fabs(frame.origin.y - y) / maxY;
//            if (duration < 0.85) duration = 0.85;
//        }
//
//    }
//
//    SunOrderNavigationViewController *toVC = (SunOrderNavigationViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    toVC.view.alpha = 0;
//    [containerView addSubview:toVC.view];
//    [containerView addSubview:tabbarView];
//
//    SunOrderAreaViewController *soaVC = toVC.soaVC;
//    [soaVC showOrHideListCouponView:NO];
//    [soaVC showOrHideListView:NO];
//
//    UIView *bgView = [[UIView alloc] initWithFrame:JPPortraitScreenBounds];
//    bgView.backgroundColor = soaVC.view.backgroundColor;
//    bgView.alpha = 0;
//    [containerView insertSubview:bgView aboveSubview:fromVC.view];
//    soaVC.view.backgroundColor = [UIColor clearColor];
//
//    // 0.35
//    [UIView animateWithDuration:0.5 animations:^{
//        bgView.alpha = 1;
//        toVC.view.alpha = 1;
//        tabbarView.jp_y += tabbarView.jp_height;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.25 animations:^{
//            [soaVC showOrHideListCouponView:YES];
//        }];
//    }];
//
//    y = SunOrderListBaseY;
//
//    void (^complated)(void) = ^{
//        soaVC.view.backgroundColor = bgView.backgroundColor;
//        [bgView removeFromSuperview];
//        [tabbarView removeFromSuperview];
//
//        for (UIView *cellView in cellViews) {
//            [cellView removeFromSuperview];
//        }
//
//        for (UITableViewCell *cell in self.fromCells) {
//            cell.hidden = NO;
//        }
//
//        self.fromCells = nil;
//        fromVC.tabBar.hidden = NO;
//        [transitionContext completeTransition:YES];
//        JPKeyWindow.userInteractionEnabled = YES;
//    };
//
//    NSInteger cellViewCount = cellViews.count;
//    if (cellViewCount == 0) {
//        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//            [soaVC showOrHideListView:YES];
//        } completion:^(BOOL finished) {
//            complated();
//        }];
//        return;
//    }
//
//    for (NSInteger i = 0; i < cellViewCount; i++) {
//        UIView *cellView = cellViews[i];
//
//        [UIView animateWithDuration:duration delay:0.07 * i usingSpringWithDamping:0.8 initialSpringVelocity:0.3 options:0 animations:^{
//            cellView.jp_y = y;
//        } completion:^(BOOL finished) {
//            if (i == cellViews.count - 1) {
//                [soaVC showOrHideListView:YES];
//                complated();
//            }
//        }];
//
//        y += cellView.jp_height;
//    }
//}

/**
 *  实现dimiss动画
 */
//- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
//    
//    JPKeyWindow.userInteractionEnabled = NO;
//
//    UIView *containerView = [transitionContext containerView];
//    
//    SunOrderNavigationViewController *fromVC = (SunOrderNavigationViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    SunOrderAreaViewController *soaVC = fromVC.soaVC;
//    
//    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    [containerView addSubview:toVC.view];
//    
//    UIView *bgView = [[UIView alloc] initWithFrame:JPPortraitScreenBounds];
//    bgView.backgroundColor = soaVC.view.backgroundColor;
//    [containerView addSubview:bgView];
//    [containerView addSubview:fromVC.view];
//    
//    [soaVC willDismissHandle];
//    [soaVC.currSolVC dismissAnimated];
//    
//    NSTimeInterval duration = [self transitionDuration:transitionContext];
//    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:0.1 options:0 animations:^{
//        bgView.alpha = 0;
//        fromVC.navigationBar.jp_y = -JPNavTopMargin;
//        [soaVC dismissHandle];
//    } completion:^(BOOL finished) {
//        [bgView removeFromSuperview];
//        [fromVC.view removeFromSuperview];
//        [transitionContext completeTransition:YES];
//        JPKeyWindow.userInteractionEnabled = YES;
//    }];
//    
//}

@end
