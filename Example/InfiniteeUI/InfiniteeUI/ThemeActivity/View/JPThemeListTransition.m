//
//  JPThemeListTransition.m
//  Infinitee2.0
//
//  Created by guanning on 2017/6/5.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "JPThemeListTransition.h"
#import "Theme.h"

@interface JPThemeListTransition ()
/**
 *  动画过渡代理管理的是push还是pop
 */
@property (nonatomic, assign) BOOL isPush;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, copy) void (^startBlock)(void);
@property (nonatomic, copy) void (^finishBlock)(BOOL isComplete);
@property (nonatomic, assign) BOOL isThemeDetail;
@end

@implementation JPThemeListTransition

+ (instancetype)themeListTransition {
    JPThemeListTransition *transition = [[self alloc] initWithIsPush:YES];
    transition.duration = 0.23;
    return transition;
}

+ (instancetype)themeDetailWithIsPush:(BOOL)isPush duration:(NSTimeInterval)duration startBlock:(void(^)(void))startBlock finishBlock:(void(^)(BOOL isComplete))finishBlock {
    JPThemeListTransition *transition = [[self alloc] initWithIsPush:isPush];
    transition.isThemeDetail = YES;
    transition.duration = duration;
    transition.startBlock = startBlock;
    transition.finishBlock = finishBlock;
    return transition;
}

- (instancetype)initWithIsPush:(BOOL)isPush {
    if (self = [super init]) {
        self.isPush = isPush;
    }
    return self;
}

/**
 *  动画时长
 */
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

/**
 *  如何执行过渡动画
 */
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.isPush) {
        if (self.isThemeDetail) {
            [self doPushDetailAnimation:transitionContext];
        } else {
            [self doPushAnimation:transitionContext];
        }
    } else {
        if (self.isThemeDetail) {
            [self doPopDetailAnimation:transitionContext];
        } else {
            [transitionContext completeTransition:YES];
        }
    }
}

/**
 *  执行push过渡动画
 */
- (void)doPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];
    
    toVC.view.alpha = 0;
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UITabBar *tabBar;
    if (fromVC.tabBarController) tabBar = fromVC.tabBarController.tabBar;
    [tabBar.layer removeAllAnimations];
    
    JPKeyWindow.userInteractionEnabled = NO;
    [UIView animateWithDuration:duration delay:0 options:0 animations:^{
        tabBar.frame = CGRectMake(JPPortraitScreenWidth, JPPortraitScreenHeight + 10, tabBar.jp_width, tabBar.jp_height);
        toVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        [fromVC.view removeFromSuperview];
        [transitionContext completeTransition:YES];
        JPKeyWindow.userInteractionEnabled = YES;
    }];
}

- (void)doPushDetailAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    !self.startBlock ? : self.startBlock();
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    
    UIView *subview = toVC.view.subviews.firstObject;
    subview.alpha = 0;
    [UIView animateWithDuration:self.duration delay:0 options:0 animations:^{
        subview.alpha = 1;
    } completion:^(BOOL finished) {
        !self.finishBlock ? : self.finishBlock(YES);
        [fromVC.view removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
    
}

- (void)doPopDetailAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];
    
    !self.startBlock ? : self.startBlock();
    
    NSTimeInterval delay = 0.0;
    if (transitionContext.interactive) {
        delay = 0.2;
    }
    
    [UIView animateWithDuration:self.duration delay:delay options:0 animations:^{
        fromVC.view.alpha = 0;
    } completion:^(BOOL finished) {
        //由于加入了手势必须判断
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
        JPLog(@"%@", toVC.view);
        
        if ([transitionContext transitionWasCancelled]) {
            //手势取消
            !self.finishBlock ? : self.finishBlock(NO);
        } else {
            !self.finishBlock ? : self.finishBlock(YES);
        }
    }];
    
}

@end
